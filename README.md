# The Nose Picker (FallingSprites)

*[Srpska verzija / Serbian version](README_RS.md)*

A simple arcade shooter, originally built with Adobe Flex 4.5 / ActionScript 3 (December 2013) and now ported to HTML5/JavaScript.

Company logos fall from the top of the screen and spin as they fall. The player moves a hand (the "nose picker") left and right, shoots the logos and dodges their bullets. There are four weapons and a shield, and hearts that drop from time to time give an extra life.

## Folder contents

| Path | Description |
|---|---|
| `html5/` | **HTML5/JS version of the game**, runs in any modern browser |
| `as3-decompiled/` | ActionScript 3 code decompiled from `FallingSprites.swf` |
| `FallingSprites.swf`, `FallingSprites.html`, `*.swz`, `swfobject.js`, `history/`, `playerProductInstall.swf` | Original Flash version (requires Flash Player) |
| `sounds/` | Original sounds (the `.mp` files are MP3s) |
| `logos/`, `pictures/` | Original images |

## Running the HTML5 version

Open `html5/index.html` in a browser. No server is needed, and the game also works over `file://`.

To host the game, upload the whole `html5/` folder to any static web server.

```
html5/
├── index.html          # page with the <canvas> element
├── game.js             # the whole game (plain JavaScript, no libraries)
└── assets/
    ├── img/            # images extracted from the SWF
    └── sound/          # explosion.mp3, shot.mp3
```

## Controls

### Keyboard

| Key | Action |
|---|---|
| `S` | Start the game / resume after pause |
| `P` | Pause |
| `←` / `→` | Move left/right |
| `Space` | Fire (hold = burst, release = single shot) |
| `1`–`4` | Select weapon |
| `Ctrl` (hold) | Shield |

The **Start game** and **Pause game** buttons can also be clicked with the mouse. Clicking a logo with the mouse removes it but does not score a point, as in the original.

### Touch (phone/tablet)

Touch mode turns on automatically with the first touch on the screen, and pressing any game key switches back to the keyboard.

- **Drag with a finger**: move the hand
- **SHIELD** (bottom left, hold): shield
- **1–4** (bottom right): select weapon
- Firing is automatic

## Game rules

- The player starts with **3 lives** and loses one when hit by a logo or an enemy bullet. The game ends when lives reach 0.
- Every logo fires two bullets downward when it appears.
- The range of falling speeds increases with every **5 logos destroyed**.
- **Weapons:**
  1. single bullet (yellow)
  2. two parallel bullets (green)
  3. three bullets, two of them fired at an angle (blue)
  4. big laser that pierces every target in its path (purple)
- Falling guns (every 5–10 s) switch your weapon when you touch them.
- A heart (every 20–40 s) gives +1 life.
- The shield blocks both logos and bullets.

## Technical notes on the port

- **Faithful logic**: the code is a 1:1 rewrite of the decompiled AS3. Speeds, timers, positions, difficulty levels and collisions (bounding box intersection, like Flash `hitTestObject`) match the original.
- **Fixed 24 Hz step**: the SWF ran at 24 fps and all movement is per frame, so the logic still runs at 24 steps per second.
- **Smooth rendering**: drawing runs at the display refresh rate (60/120/144 Hz), and positions and rotations are interpolated between logic steps.
- **Scaling**: the logical stage is 976×805 (80 px info bar + 5 px gap + 976×720 playfield). It scales to the window size and stays sharp on HiDPI screens.
- **Sound**: a pool of `<audio>` elements, so sounds can overlap and work over `file://`.

### Differences from the original

1. Enemy bullets now stop during pause. In the original they kept flying and could cost you a life.
2. A normal bullet disappears on its first hit. The laser still pierces everything.
3. Held keys are released when the window loses focus.
4. The browser shortcuts `Ctrl+S` and `Ctrl+P` are blocked, because the game uses `S`, `P` and `Ctrl`.
5. New touch controls: drag, a shield button and weapon buttons, instead of two left/right buttons.
6. The game is centered in the window.
7. Hitting a logo with a bullet shows an explosion: the logo pops and disappears, followed by a flash, an expanding shock wave and sparks. The effect is purely visual, does not affect collisions and freezes during pause.

Some quirks of the original were kept on purpose: a logo occasionally gets speed 0 and stays at the top of the screen, and a gun keeps falling after you touch it.

## Decompiled ActionScript (`as3-decompiled/`)

Extracted from `FallingSprites.swf` with [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler).

| Path | Description |
|---|---|
| `src/FallingSprites.as` | Main class containing all of the game logic |
| `src/model/` | Shapes (`GeometricShape`, `Rectangle`, `Ellipse`), guns, ammo, heart (`Live`), shield, buttons |
| `src/utility/LoanShark.as` | Object pool for ammo |
| `src/interfaces/GeometricInterface.as` | Interface for shapes |
| `flex-generated/` | Classes generated by the Flex compiler (styles, SystemManager, resource bundles) |
| `embedded-images/` | Images that were embedded in the SWF |

Limitations of the decompiled code:

- Local variables and parameters have generic names (`_loc2_`, `param1`).
- There are no comments.
- The original MXML has been converted to AS3.
- The `[Embed]` metadata has been replaced by `*_Bitmap` / `FallingSprites_*` classes.

The code is complete and readable, but it can't be compiled again without manual cleanup.
