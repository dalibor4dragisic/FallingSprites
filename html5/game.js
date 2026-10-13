// The Nose Picker (FallingSprites) - HTML5/Canvas port of the original Flex/AS3 game.
// Gameplay constants, speeds and positions are taken 1:1 from the decompiled ActionScript.
'use strict';

(() => {
  // ---- Constants (from FallingSprites.as) ----------------------------------------------
  const W = 976;               // main play field width
  const H = 720;               // main play field height
  const INFO_H = 80;           // info bar height
  const MAIN_Y = 85;           // main play field offset
  const STAGE_W = W;
  const STAGE_H = MAIN_Y + H;
  const FPS = 24;              // original SWF frame rate - all movement is per frame
  const STEP = 1000 / FPS;

  const MAX_LIVES = 3;
  const LEVEL_COUNTER = 5;
  const GAME_ENDED = 0, GAME_STARTED = 1, GAME_PAUSED = 2, GAME_DEFAULT = 5;
  const MIN_INTERVAL = 300, MAX_INTERVAL = 600;

  const LOGO_SIZE = 60;
  const PICKER_W = 69, PICKER_H = 114;
  const GUN_W = 100, GUN_H = 75;           // bitmap size, rotated 90 degrees inside the Gun sprite
  const HEART_SIZE = 48;
  const GAME_OVER_W = 510, GAME_OVER_H = 40;

  const COLOR_TITLE = '#06FC3E';
  const COLOR_INFO = '#C8C026';
  const COLOR_BUTTON_BG = '#34C927';
  const COLOR_BUTTON_TEXT = '#E0FCFB';
  const FONT = 'Verdana, Geneva, sans-serif';

  // GeometricShape.getRndNumber - integer in [min, max]
  const rnd = (min, max) => Math.floor(Math.random() * (1 + max - min)) + min;

  // ---- Assets ---------------------------------------------------------------------------
  const IMG = {};
  const IMAGE_FILES = {
    picker: 'nosePicker.png', gameOver: 'gameOver.png', heart: 'heart.png',
    singleGun: 'singleGun.png', doubleGun: 'doubleGun.png', tripleGun: 'tripleGun.png',
    s2games: 's2games.png', eurocom: 'eurocom.png', disney: 'disney.png', nbc: 'nbc.png',
    playboy: 'playboy.png', ea: 'ea.png', atari: 'atari.png'
  };

  function loadImages() {
    return Promise.all(Object.entries(IMAGE_FILES).map(([key, file]) => new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => { IMG[key] = img; resolve(); };
      img.onerror = () => reject(new Error('Cannot load ' + file));
      img.src = 'assets/img/' + file;
    })));
  }

  // Small pool of <audio> elements so overlapping shots/explosions work (and file:// works too)
  function makeSound(src, voices) {
    const pool = [];
    for (let i = 0; i < voices; i++) {
      const a = new Audio(src);
      a.preload = 'auto';
      pool.push(a);
    }
    let next = 0;
    return {
      play() {
        const a = pool[next];
        next = (next + 1) % voices;
        try {
          a.currentTime = 0;
          const p = a.play();
          if (p) p.catch(() => {});
        } catch (e) { /* ignore */ }
      }
    };
  }

  const sndExplosion = makeSound('assets/sound/explosion.mp3', 6);
  const sndAmmo = makeSound('assets/sound/shot.mp3', 6);

  // ---- Flash-like Timer (driven by the fixed game step) ---------------------------------
  class Timer {
    constructor(delay, callback) {
      this.delay = delay;
      this.callback = callback;
      this.running = false;
      this.elapsed = 0;
    }
    start() { this.running = true; }
    stop() { this.running = false; this.elapsed = 0; }
    setDelay(delay) { this.delay = delay; this.elapsed = 0; }
    tick(ms) {
      if (!this.running) return;
      this.elapsed += ms;
      if (this.elapsed >= this.delay) {
        this.elapsed = 0;
        this.callback();
      }
    }
  }

  // ---- Display list of the main sprite --------------------------------------------------
  // Each entity: { kind, x, y, rotation (degrees, clockwise, around the local origin), lb: local bounds }
  const main = [];

  function addChild(e) {
    const i = main.indexOf(e);
    if (i >= 0) main.splice(i, 1);
    main.push(e);
    e.onStage = true;
    savePrevious(e);
  }

  // Position at the start of the current logic step, used to interpolate rendering between steps
  function savePrevious(e) {
    e.prevX = e.x;
    e.prevY = e.y;
    e.prevRotation = e.rotation || 0;
  }

  function removeChild(e) {
    const i = main.indexOf(e);
    if (i >= 0) main.splice(i, 1);
    e.onStage = false;
  }

  // Axis-aligned bounds in main-sprite coordinates (same as Flash getBounds)
  function bounds(e) {
    const lb = e.lb;
    if (!e.rotation) return { x: e.x + lb.x, y: e.y + lb.y, w: lb.w, h: lb.h };
    const r = e.rotation * Math.PI / 180, c = Math.cos(r), s = Math.sin(r);
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    const corners = [[lb.x, lb.y], [lb.x + lb.w, lb.y], [lb.x, lb.y + lb.h], [lb.x + lb.w, lb.y + lb.h]];
    for (const [px, py] of corners) {
      const X = px * c - py * s, Y = px * s + py * c;
      if (X < minX) minX = X;
      if (X > maxX) maxX = X;
      if (Y < minY) minY = Y;
      if (Y > maxY) maxY = Y;
    }
    return { x: e.x + minX, y: e.y + minY, w: maxX - minX, h: maxY - minY };
  }

  // DisplayObject.hitTestObject - bounding box intersection
  function hitTestObject(a, b) {
    const A = bounds(a), B = bounds(b);
    return A.x < B.x + B.w && B.x < A.x + A.w && A.y < B.y + B.h && B.y < A.y + A.h;
  }

  function containsPoint(e, px, py) {
    const r = (e.rotation || 0) * Math.PI / 180, c = Math.cos(r), s = Math.sin(r);
    const dx = px - e.x, dy = py - e.y;
    const lx = dx * c + dy * s, ly = -dx * s + dy * c;
    return lx >= e.lb.x && lx <= e.lb.x + e.lb.w && ly >= e.lb.y && ly <= e.lb.y + e.lb.h;
  }

  // ---- Game state -----------------------------------------------------------------------
  let gameState = GAME_DEFAULT;
  let collisionCount = MAX_LIVES;   // lives (info bar shows "Lives: 3" before the first game)
  let killsCount = 0;
  let frameNo = 0;
  let currentGun = 1;
  let startValue = 1;
  let endValue = 5;
  let keysActive = false;
  let touchMode = false;           // switched on by the first touch, off again by the keyboard
  const touchCapable = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
  const RESTART_DELAY_MS = 1000;   // ignore taps right after game over, so a tap meant for the game does not restart it
  let gameOverAt = -Infinity;

  let leftPressed = false, rightPressed = false, spacePressed = false, shieldPressed = false;

  let logos = [];
  let gameOverEntity = null;

  const picker = { kind: 'picker', x: 0, y: 0, lb: { x: 0, y: 0, w: PICKER_W, h: PICKER_H } };
  // Shield: two quadratic curves 100x50, 4px stroke
  const shield = { kind: 'shield', x: 0, y: 0, lb: { x: -2, y: -2, w: 104, h: 54 } };
  const heart = { kind: 'heart', x: 0, y: 0, addedToGame: false, lb: { x: 0, y: 0, w: HEART_SIZE, h: HEART_SIZE } };
  let guns = [];

  // Touch HUD (main sprite coordinates): hold-to-shield button and weapon selection buttons
  const HUD_SHIELD = { x: 75, y: H - 75, r: 55 };
  const HUD_WEAPON_SIZE = 56, HUD_WEAPON_GAP = 10;
  const hudWeapons = [1, 2, 3, 4].map((gun, i) => ({
    gun,
    x: W - (4 - i) * (HUD_WEAPON_SIZE + HUD_WEAPON_GAP),
    y: H - HUD_WEAPON_SIZE - HUD_WEAPON_GAP,
    w: HUD_WEAPON_SIZE, h: HUD_WEAPON_SIZE
  }));
  const PICKER_MIN_X = -48, PICKER_MAX_X = W - PICKER_W;
  let shieldPointer = null;        // pointerId holding the shield button
  let dragPointer = null;          // { id, startX, pickerX } for drag-to-move
  let dragTargetX = null;          // picker x requested by the drag, applied in the game step

  // Info bar buttons (ButtonSprite stretched to width 130)
  const BUTTON_H = 26;
  const buttonStart = { label: 'Start game', x: W - 400, y: 10, w: 130, h: BUTTON_H, action: () => onStartGame() };
  const buttonPause = { label: 'Pause game', x: W - 400, y: 50, w: 130, h: BUTTON_H, action: () => onPauseGame() };
  const buttons = [buttonStart, buttonPause];

  const minuteTimer = new Timer(1000, onTick);
  const gunTimer = new Timer(1000, onGunTimerTick);
  const heartTimer = new Timer(1000, onHeartTimerTick);

  // ---- Spawning -------------------------------------------------------------------------
  function generateShape() {
    const img = logos[rnd(0, logos.length - 1)];
    // Rectangle/Ellipse are created with drawGraphics=false, so only the logo is visible
    const shape = {
      kind: 'shape', img,
      x: rnd(0, W - LOGO_SIZE), y: 0, rotation: 0,
      lb: { x: 0, y: 0, w: LOGO_SIZE, h: LOGO_SIZE },
      speed: rnd(startValue, endValue)
    };
    if (killsCount % LEVEL_COUNTER === 0) {
      startValue = killsCount / LEVEL_COUNTER;
      endValue = startValue + LEVEL_COUNTER;
    }
    return shape;
  }

  function makeEnemyAmmo(x, y) {
    return { kind: 'enemyAmmo', x, y, lb: { x: 0, y: 0, w: 4, h: 10 } };
  }

  function makeAmmo(type, color, x, y, rotation) {
    const big = type === 'laser';
    return {
      kind: 'ammo', type, color: big ? '#D092FC' : color, x, y, rotation: rotation || 0,
      lb: big ? { x: 0, y: 0, w: 20, h: 40 } : { x: 0, y: 0, w: 5, h: 20 }
    };
  }

  function onTick() {
    const shape = generateShape();
    addChild(shape);
    addChild(makeEnemyAmmo(shape.x, shape.y + LOGO_SIZE));
    addChild(makeEnemyAmmo(shape.x, shape.y + LOGO_SIZE - 55));
    minuteTimer.setDelay(rnd(MIN_INTERVAL, MAX_INTERVAL));
  }

  function onGunTimerTick() {
    const gun = guns[rnd(0, guns.length - 1)];
    gun.y = 0;
    gun.x = rnd(0, W - GUN_H);
    addChild(gun);
    gunTimer.setDelay(rnd(5000, 10000));
  }

  function onHeartTimerTick() {
    if (!heart.addedToGame) {
      heart.x = rnd(0, W - HEART_SIZE);
      addChild(heart);
      heart.addedToGame = true;
      heartTimer.setDelay(rnd(20000, 40000));
    }
  }

  // ---- Game flow ------------------------------------------------------------------------
  function addTouchEvents() {
    if (touchMode) spacePressed = true;     // auto-fire on touch devices
  }

  function setTouchMode(on) {
    if (touchMode === on) return;
    touchMode = on;
    if (keysActive) spacePressed = on;      // auto-fire follows the input mode during a game
    if (!on) {
      dragPointer = null;
      dragTargetX = null;
      if (shieldPointer !== null) {
        shieldPointer = null;
        setShield(false);
      }
    }
  }

  function setShield(on) {
    if (on) {
      if (!keysActive) return;
      shieldPressed = true;
      // Place it on the picker right away, so it does not slide in from its last position
      shield.x = picker.x - 10;
      shield.y = picker.y - 5;
      addChild(shield);
    } else {
      shieldPressed = false;
      removeChild(shield);
    }
  }

  function onStartGame() {
    if (gameState === GAME_DEFAULT || gameState === GAME_ENDED) {
      addTouchEvents();
      gameState = GAME_STARTED;
      collisionCount = MAX_LIVES;
      removeGameOver();
      setPickerGunOnMainSprite();
      minuteTimer.setDelay(rnd(MIN_INTERVAL, MAX_INTERVAL));
      minuteTimer.start();
      gunTimer.setDelay(rnd(5000, 10000));
      gunTimer.start();
      heartTimer.start();
    } else if (gameState === GAME_PAUSED) {
      gameState = GAME_STARTED;
      minuteTimer.setDelay(rnd(MIN_INTERVAL, MAX_INTERVAL));
      minuteTimer.start();
      gunTimer.start();
      heartTimer.start();
    }
  }

  function onPauseGame() {
    if (gameState === GAME_STARTED) {
      gameState = GAME_PAUSED;
      minuteTimer.stop();
      gunTimer.stop();
    }
  }

  function gameOver() {
    gameOverAt = performance.now();
    gameState = GAME_ENDED;
    killsCount = 0;
    currentGun = 1;
    collisionCount = 0;
    resetKeysThatPressed();
    keysActive = false;
    removeChild(picker);
    minuteTimer.stop();
    gunTimer.stop();
    heartTimer.stop();
    removeAllSprites();
    gameOverEntity = {
      kind: 'gameOver', x: W / 2 - GAME_OVER_W / 2, y: H / 2 - GAME_OVER_H / 2,
      lb: { x: 0, y: 0, w: GAME_OVER_W, h: GAME_OVER_H }
    };
    addChild(gameOverEntity);
    frameNo = 0;
  }

  function setPickerGunOnMainSprite() {
    picker.x = W / 2 - PICKER_W / 2;
    picker.y = H - PICKER_H;
    addChild(picker);
    keysActive = true;
  }

  function removeGameOver() {
    if (gameOverEntity) removeChild(gameOverEntity);
  }

  function removeAllSprites() {
    effects.length = 0;
    for (const e of main.slice()) {
      if (e === heart) heart.addedToGame = false;
      removeChild(e);
    }
  }

  function resetKeysThatPressed() {
    leftPressed = rightPressed = spacePressed = shieldPressed = false;
    currentGun = 1;
    dragPointer = null;
    dragTargetX = null;
    shieldPointer = null;
  }

  function changeLivesBy(delta) {
    collisionCount += delta;
  }

  function changeScore(delta) {
    killsCount += delta;
  }

  function fireAmmo() {
    const px = picker.x, py = picker.y;
    sndAmmo.play();
    if (currentGun === 1) {
      addChild(makeAmmo('normal', '#F2FF00', px + 58, py));
    } else if (currentGun === 2) {
      addChild(makeAmmo('normal', '#00FA15', px + 9, py));
      addChild(makeAmmo('normal', '#00FA15', px + 69, py));
    } else if (currentGun === 3) {
      addChild(makeAmmo('left', '#04E6FF', px + 9, py, 160));
      addChild(makeAmmo('right', '#04E6FF', px + 69, py, 20));
      addChild(makeAmmo('normal', '#04E6FF', px + 39, py));
    } else if (currentGun === 4) {
      addChild(makeAmmo('laser', null, px + 58, py));
    }
  }

  // ---- Per-frame updates (ENTER_FRAME handlers) -----------------------------------------
  function updatePicker() {
    if (gameState === GAME_PAUSED) return;
    frameNo++;
    if (shieldPressed) {
      shield.x = picker.x - 10;
      shield.y = picker.y - 5;
    }
    if (dragTargetX !== null) {
      // Touch drag: picker follows the finger (the original had unfinished touchMove code for this)
      const dx = dragTargetX - picker.x;
      picker.x += dx;
      shield.x += dx;
      if (!dragPointer) dragTargetX = null;   // finger lifted - last position applied
    } else if (leftPressed) {
      if (PICKER_MIN_X < picker.x) {
        picker.x -= 15;
        shield.x -= 15;
      }
    } else if (rightPressed) {
      if (picker.x + PICKER_W < W) {
        picker.x += 15;
        shield.x += 15;
      }
    }
    if (spacePressed && frameNo % 10 === 0) fireAmmo();
  }

  function updateShape(s) {
    if (gameState === GAME_PAUSED || gameState === GAME_ENDED) return;
    if (s.y + bounds(s).h < H) {
      s.rotation += 6;
      s.y += s.speed;
      if (shieldPressed && hitTestObject(s, shield)) {
        removeChild(s);
        return;
      }
      if (hitTestObject(s, picker)) {
        removeChild(s);
        changeLivesBy(-1);
        if (collisionCount === 0) gameOver();
      }
    } else {
      removeChild(s);
    }
  }

  function updateEnemyAmmo(a) {
    if (gameState === GAME_PAUSED) return;
    if (a.y < H) {
      a.y += 30;
      if (shieldPressed && hitTestObject(shield, a)) {
        removeChild(a);
      } else if (hitTestObject(picker, a)) {
        removeChild(a);
        changeLivesBy(-1);
        if (collisionCount === 0) gameOver();
      }
    } else {
      removeChild(a);
    }
  }

  function updateAmmo(a) {
    if (gameState === GAME_PAUSED) return;
    if (0 < a.y && a.x > 0 && a.x < W) {
      if (a.type === 'left') {
        a.y -= 30;
        a.x -= 10;
      } else if (a.type === 'right') {
        a.y -= 30;
        a.x += 10;
      } else {
        a.y -= 30;
      }
      for (let i = 0; i < main.length; i++) {
        const target = main[i];
        if (target.kind !== 'shape' || !hitTestObject(target, a)) continue;
        sndExplosion.play();
        spawnExplosion(target);
        removeChild(target);
        i--;
        changeScore(1);
        // The big laser goes through everything, normal ammo stops at the first hit
        if (a.type !== 'laser') {
          removeChild(a);
          break;
        }
      }
    } else {
      removeChild(a);
    }
  }

  function updateGun(g) {
    if (gameState === GAME_PAUSED) return;
    if (g.y + GUN_W < H) {
      g.y += 25;
      if (hitTestObject(g, picker)) currentGun = g.index + 1;
    } else {
      removeChild(g);
    }
  }

  function updateHeart(h) {
    if (gameState === GAME_PAUSED) return;
    if (h.y + HEART_SIZE < H) {
      h.y += 15;
      if (hitTestObject(h, picker)) {
        removeChild(h);
        h.addedToGame = false;
        h.y = 0;
        changeLivesBy(1);
      }
    } else {
      removeChild(h);
      h.addedToGame = false;
      h.y = 0;
    }
  }

  const UPDATERS = {
    picker: updatePicker,
    shape: updateShape,
    enemyAmmo: updateEnemyAmmo,
    ammo: updateAmmo,
    gun: updateGun,
    heart: updateHeart
  };

  function step() {
    minuteTimer.tick(STEP);
    gunTimer.tick(STEP);
    heartTimer.tick(STEP);
    main.forEach(savePrevious);
    for (const e of main.slice()) {
      if (!e.onStage) continue;
      const update = UPDATERS[e.kind];
      if (update) update(e);
    }
  }

  // ---- Input ----------------------------------------------------------------------------
  const GAME_KEYS = ['ArrowLeft', 'ArrowRight', 'Space', 'Digit1', 'Digit2', 'Digit3', 'Digit4',
    'Numpad1', 'Numpad2', 'Numpad3', 'Numpad4', 'ControlLeft', 'ControlRight'];

  window.addEventListener('keydown', (ev) => {
    if (['Space', 'ArrowLeft', 'ArrowRight'].includes(ev.code) || ev.ctrlKey) ev.preventDefault();
    if (GAME_KEYS.includes(ev.code)) setTouchMode(false);

    // Always active (onKeyDownStartPause)
    if (ev.code === 'KeyS') onStartGame();
    else if (ev.code === 'KeyP') onPauseGame();

    if (!keysActive) return;
    if (ev.code === 'ArrowLeft') leftPressed = true;
    else if (ev.code === 'ArrowRight') rightPressed = true;
    else if (ev.code === 'Space') spacePressed = true;
    else if (ev.key === 'Control' && !ev.repeat) setShield(true);
  });

  window.addEventListener('keyup', (ev) => {
    if (!keysActive) return;
    if (ev.code === 'ArrowLeft') leftPressed = false;
    else if (ev.code === 'ArrowRight') rightPressed = false;
    else if (ev.code === 'Space') {
      spacePressed = false;
      fireAmmo();
    } else if (ev.code === 'Digit1' || ev.code === 'Numpad1') currentGun = 1;
    else if (ev.code === 'Digit2' || ev.code === 'Numpad2') currentGun = 2;
    else if (ev.code === 'Digit3' || ev.code === 'Numpad3') currentGun = 3;
    else if (ev.code === 'Digit4' || ev.code === 'Numpad4') currentGun = 4;
    else if (ev.key === 'Control') setShield(false);
  });

  // Release held keys / fingers when the window loses focus, otherwise they stay "stuck"
  window.addEventListener('blur', () => {
    leftPressed = rightPressed = false;
    if (!touchMode) spacePressed = false;
    dragPointer = null;
    shieldPointer = null;
    if (shieldPressed) setShield(false);
  });

  // ---- Canvas, scaling, pointer ---------------------------------------------------------
  const canvas = document.getElementById('game');
  const ctx = canvas.getContext('2d');
  let scale = 1;
  let dpr = 1;

  function resize() {
    dpr = window.devicePixelRatio || 1;
    scale = Math.min(window.innerWidth / STAGE_W, window.innerHeight / STAGE_H);
    const cssW = Math.floor(STAGE_W * scale), cssH = Math.floor(STAGE_H * scale);
    canvas.style.width = cssW + 'px';
    canvas.style.height = cssH + 'px';
    canvas.width = Math.round(cssW * dpr);
    canvas.height = Math.round(cssH * dpr);
  }
  window.addEventListener('resize', resize);
  resize();

  function toStage(ev) {
    const r = canvas.getBoundingClientRect();
    return { x: (ev.clientX - r.left) / scale, y: (ev.clientY - r.top) / scale };
  }

  function buttonAt(p) {
    return buttons.find(b => p.x >= b.x && p.x <= b.x + b.w && p.y >= b.y && p.y <= b.y + b.h);
  }

  const clamp = (v, min, max) => Math.max(min, Math.min(max, v));
  const hudVisible = () => touchMode && keysActive;

  function onShieldButton(mx, my) {
    return Math.hypot(mx - HUD_SHIELD.x, my - HUD_SHIELD.y) <= HUD_SHIELD.r;
  }

  function weaponButtonAt(mx, my) {
    return hudWeapons.find(b => mx >= b.x && mx <= b.x + b.w && my >= b.y && my <= b.y + b.h);
  }

  // Topmost shape under the point; other sprites on top block the click like in Flash
  // (GameOver bitmap and the shield outline are not clickable)
  function shapeAt(mx, my) {
    for (let i = main.length - 1; i >= 0; i--) {
      const e = main[i];
      if (e.kind === 'gameOver' || e.kind === 'shield') continue;
      if (containsPoint(e, mx, my)) return e.kind === 'shape' ? e : null;
    }
    return null;
  }

  // Keep receiving move/up events even when the finger leaves the canvas
  function capturePointer(id) {
    try { canvas.setPointerCapture(id); } catch (e) { /* pointer already gone */ }
  }

  canvas.addEventListener('pointerdown', (ev) => {
    const isTouch = ev.pointerType === 'touch' || ev.pointerType === 'pen';
    if (isTouch) setTouchMode(true);

    const p = toStage(ev);
    const button = buttonAt(p);
    if (button) {
      button.action();
      return;
    }
    if (p.y < INFO_H) return;

    // Tap/click anywhere on the playfield starts the game (or resumes it after pause)
    if (gameState !== GAME_STARTED) {
      if (performance.now() - gameOverAt >= RESTART_DELAY_MS) onStartGame();
      return;
    }
    const mx = p.x, my = p.y - MAIN_Y;

    if (hudVisible()) {
      if (shieldPointer === null && onShieldButton(mx, my)) {
        shieldPointer = ev.pointerId;
        setShield(true);
        capturePointer(ev.pointerId);
        return;
      }
      const weapon = weaponButtonAt(mx, my);
      if (weapon) {
        currentGun = weapon.gun;
        return;
      }
    }

    const shape = shapeAt(mx, my);
    if (shape) {
      removeChild(shape);   // onMouseClick - shape simply disappears, no score
      return;
    }

    if (isTouch && keysActive && dragPointer === null) {
      dragPointer = { id: ev.pointerId, startX: p.x, pickerX: picker.x };
      capturePointer(ev.pointerId);
    }
  });

  canvas.addEventListener('pointermove', (ev) => {
    const p = toStage(ev);
    if (dragPointer && ev.pointerId === dragPointer.id) {
      dragTargetX = clamp(dragPointer.pickerX + p.x - dragPointer.startX, PICKER_MIN_X, PICKER_MAX_X);
    }
    if (ev.pointerType === 'mouse') canvas.style.cursor = buttonAt(p) ? 'pointer' : 'default';
  });

  function releasePointer(ev) {
    if (dragPointer && ev.pointerId === dragPointer.id) dragPointer = null;
    if (ev.pointerId === shieldPointer) {
      shieldPointer = null;
      setShield(false);
    }
  }
  canvas.addEventListener('pointerup', releasePointer);
  canvas.addEventListener('pointercancel', releasePointer);

  canvas.addEventListener('contextmenu', (ev) => ev.preventDefault());

  // ---- Explosion effect (visual only, does not affect gameplay) -------------------------
  const EXPLOSION_MS = 650;
  const EXPLOSION_PARTICLES = 28;
  const EXPLOSION_COLORS = ['#FFF6C2', '#FFD23F', '#FF9F1C', '#FF5A1F', '#E63946'];
  const effects = [];

  function spawnExplosion(target) {
    const b = bounds(target);
    const particles = [];
    for (let i = 0; i < EXPLOSION_PARTICLES; i++) {
      const angle = Math.random() * Math.PI * 2;
      const speed = 120 + Math.random() * 320;          // px per second
      particles.push({
        x: 0, y: 0,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        size: 2 + Math.random() * 4,
        color: EXPLOSION_COLORS[i % EXPLOSION_COLORS.length]
      });
    }
    effects.push({
      x: b.x + b.w / 2, y: b.y + b.h / 2, age: 0, particles,
      img: target.img, rotation: target.rotation || 0
    });
  }

  function updateEffects(dt) {
    const s = dt / 1000;
    for (let i = effects.length - 1; i >= 0; i--) {
      const fx = effects[i];
      fx.age += dt;
      if (fx.age >= EXPLOSION_MS) {
        effects.splice(i, 1);
        continue;
      }
      const drag = Math.pow(0.04, s);                   // sparks slow down quickly
      for (const p of fx.particles) {
        p.x += p.vx * s;
        p.y += p.vy * s;
        p.vx *= drag;
        p.vy = p.vy * drag + 500 * s;                   // and fall a little
      }
    }
  }

  function drawExplosion(fx) {
    const t = fx.age / EXPLOSION_MS;                    // 0..1
    ctx.save();
    ctx.translate(fx.x, fx.y);

    // Logo "pops" - grows and fades out
    if (t < 0.25) {
      const k = t / 0.25;
      ctx.save();
      ctx.globalAlpha = 1 - k;
      ctx.rotate(fx.rotation * Math.PI / 180);
      const size = LOGO_SIZE * (1 + k * 0.8);
      ctx.drawImage(fx.img, -size / 2, -size / 2, size, size);
      ctx.restore();
    }

    ctx.globalCompositeOperation = 'lighter';

    // Flash
    if (t < 0.45) {
      const k = t / 0.45;
      const r = 15 + 55 * k;
      const g = ctx.createRadialGradient(0, 0, 0, 0, 0, r);
      g.addColorStop(0, `rgba(255, 250, 220, ${0.9 * (1 - k)})`);
      g.addColorStop(0.4, `rgba(255, 170, 40, ${0.7 * (1 - k)})`);
      g.addColorStop(1, 'rgba(255, 60, 0, 0)');
      ctx.fillStyle = g;
      ctx.beginPath();
      ctx.arc(0, 0, r, 0, Math.PI * 2);
      ctx.fill();
    }

    // Shock wave
    ctx.beginPath();
    ctx.arc(0, 0, 20 + 75 * Math.sqrt(t), 0, Math.PI * 2);
    ctx.lineWidth = 5 * (1 - t);
    ctx.strokeStyle = `rgba(255, 200, 90, ${0.8 * (1 - t)})`;
    ctx.stroke();

    // Sparks
    ctx.globalAlpha = 1 - t * t;
    for (const p of fx.particles) {
      const size = p.size * (1 - t * 0.6);
      ctx.fillStyle = p.color;
      ctx.fillRect(p.x - size / 2, p.y - size / 2, size, size);
    }

    ctx.restore();
  }

  // ---- Rendering ------------------------------------------------------------------------
  // alpha: 0..1 position between the previous and the current logic step
  function drawEntity(e, alpha) {
    const lerp = (from, to) => from + (to - from) * alpha;
    const rotation = lerp(e.prevRotation, e.rotation || 0);
    ctx.save();
    ctx.translate(lerp(e.prevX, e.x), lerp(e.prevY, e.y));
    if (rotation) ctx.rotate(rotation * Math.PI / 180);
    switch (e.kind) {
      case 'shape':
        ctx.drawImage(e.img, 0, 0, LOGO_SIZE, LOGO_SIZE);
        break;
      case 'enemyAmmo':
        ctx.fillStyle = '#FEBFEF';
        ctx.fillRect(0, 0, 4, 10);
        break;
      case 'ammo':
        ctx.fillStyle = e.color;
        ctx.fillRect(e.lb.x, e.lb.y, e.lb.w, e.lb.h);
        break;
      case 'picker':
        ctx.drawImage(IMG.picker, 0, 0);
        break;
      case 'gun':
        ctx.rotate(Math.PI / 2);
        ctx.drawImage(e.img, 0, 0);
        break;
      case 'heart':
        ctx.drawImage(IMG.heart, 0, 0);
        break;
      case 'shield':
        ctx.strokeStyle = '#0072FD';
        ctx.lineWidth = 4;
        ctx.lineCap = 'round';
        ctx.beginPath();
        ctx.moveTo(50, 0);
        ctx.quadraticCurveTo(100, 0, 100, 50);
        ctx.moveTo(50, 0);
        ctx.quadraticCurveTo(0, 0, 0, 50);
        ctx.stroke();
        break;
      case 'gameOver':
        ctx.drawImage(IMG.gameOver, 0, 0);
        break;
    }
    ctx.restore();
  }

  function drawText(text, x, y, size, color) {
    ctx.font = `bold ${size}px ${FONT}`;
    ctx.fillStyle = color;
    ctx.fillText(text, x + 2, y + 2);   // Flash TextField has a 2px gutter
  }

  function drawButton(b) {
    ctx.font = `bold 18px ${FONT}`;
    const natural = ctx.measureText(b.label).width + 4;
    ctx.save();
    ctx.translate(b.x, b.y);
    ctx.scale(b.w / natural, 1);
    ctx.fillStyle = COLOR_BUTTON_BG;
    ctx.fillRect(0, 0, natural, b.h);
    ctx.fillStyle = COLOR_BUTTON_TEXT;
    ctx.fillText(b.label, 2, 2);
    ctx.restore();
  }

  const AMMO_COLORS = { 1: '#F2FF00', 2: '#00FA15', 3: '#04E6FF', 4: '#D092FC' };

  function drawTouchHud() {
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';

    ctx.beginPath();
    ctx.arc(HUD_SHIELD.x, HUD_SHIELD.y, HUD_SHIELD.r, 0, Math.PI * 2);
    ctx.fillStyle = shieldPressed ? 'rgba(0, 114, 253, 0.45)' : 'rgba(0, 114, 253, 0.18)';
    ctx.fill();
    ctx.lineWidth = 3;
    ctx.strokeStyle = 'rgba(0, 114, 253, 0.8)';
    ctx.stroke();
    ctx.font = `bold 14px ${FONT}`;
    ctx.fillStyle = 'rgba(255, 255, 255, 0.85)';
    ctx.fillText('SHIELD', HUD_SHIELD.x, HUD_SHIELD.y);

    for (const b of hudWeapons) {
      const active = b.gun === currentGun;
      ctx.fillStyle = active ? 'rgba(255, 255, 255, 0.3)' : 'rgba(255, 255, 255, 0.1)';
      ctx.fillRect(b.x, b.y, b.w, b.h);
      ctx.lineWidth = active ? 3 : 1.5;
      ctx.strokeStyle = AMMO_COLORS[b.gun];
      ctx.strokeRect(b.x, b.y, b.w, b.h);
      ctx.font = `bold 24px ${FONT}`;
      ctx.fillStyle = AMMO_COLORS[b.gun];
      ctx.fillText(String(b.gun), b.x + b.w / 2, b.y + b.h / 2);
    }

    ctx.textAlign = 'left';
    ctx.textBaseline = 'top';
  }

  function drawStartPrompt() {
    if (gameState === GAME_ENDED && performance.now() - gameOverAt < RESTART_DELAY_MS) return;
    const tap = touchMode || touchCapable;
    let text;
    if (gameState === GAME_PAUSED) text = tap ? 'PAUSED - TAP TO RESUME' : 'PAUSED - PRESS S OR CLICK TO RESUME';
    else text = tap ? 'TAP TO START' : 'PRESS S OR CLICK TO START';
    // Below the GAME OVER image, centered otherwise
    const y = gameState === GAME_ENDED ? H / 2 + 70 : H / 2;
    ctx.save();
    ctx.globalAlpha = 0.55 + 0.45 * Math.sin(performance.now() / 250);   // blink
    ctx.font = `bold 30px ${FONT}`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillStyle = COLOR_TITLE;
    ctx.fillText(text, W / 2, y);
    ctx.restore();
  }

  function render(alpha) {
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.setTransform(scale * dpr, 0, 0, scale * dpr, 0, 0);
    ctx.textBaseline = 'top';
    ctx.imageSmoothingEnabled = true;

    // Main sprite
    ctx.save();
    ctx.translate(0, MAIN_Y);
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, W, H);
    for (const e of main) drawEntity(e, alpha);
    effects.forEach(drawExplosion);
    if (gameState !== GAME_STARTED) drawStartPrompt();
    if (hudVisible()) drawTouchHud();
    ctx.restore();

    // Info sprite (drawn on top of the main sprite, like in the original)
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, W, INFO_H);
    drawText('THE NOSE PICKER', 30, 18, 30, COLOR_TITLE);
    drawText('Lives: ' + collisionCount, 30, 50, 20, COLOR_INFO);
    drawText('Killed: ' + killsCount, W - 200, 30, 20, COLOR_INFO);
    const manual = touchMode
      ? ['tap Start game', 'drag : move', '1-4 : weapons', 'SHIELD : hold', 'auto fire']
      : ['S : start game', 'P : pause game', '1-4 : weapons', 'ctrl : shield', 'space : fire'];
    manual.forEach((line, i) => drawText(line, 400, 5 + i * 15, 12, COLOR_TITLE));
    buttons.forEach(drawButton);
  }

  // ---- Main loop --------------------------------------------------------------------------
  // Game logic runs at a fixed 24 steps/s exactly like the SWF (speeds, timers and collisions
  // stay identical), rendering runs at the display refresh rate and interpolates between steps.
  let last = 0;
  let accumulator = 0;

  function frame() {
    const now = performance.now();
    const dt = Math.max(0, Math.min(now - last, 250));
    accumulator += dt;
    last = now;
    if (gameState !== GAME_PAUSED) updateEffects(dt);
    while (accumulator >= STEP) {
      step();
      accumulator -= STEP;
    }
    render(accumulator / STEP);
    requestAnimationFrame(frame);
  }

  loadImages().then(() => {
    logos = [IMG.s2games, IMG.eurocom, IMG.disney, IMG.nbc, IMG.playboy, IMG.ea, IMG.atari];
    guns = [IMG.singleGun, IMG.doubleGun, IMG.tripleGun].map((img, index) => ({
      kind: 'gun', img, index, x: 0, y: 0,
      // bitmap rotated 90 degrees around the sprite origin -> occupies [-75, 0] x [0, 100]
      lb: { x: -GUN_H, y: 0, w: GUN_H, h: GUN_W }
    }));
    last = performance.now();
    requestAnimationFrame(frame);
  }).catch((err) => {
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    ctx.fillStyle = '#000';
    ctx.font = '16px sans-serif';
    ctx.fillText(err.message, 10, 30);
  });
})();
