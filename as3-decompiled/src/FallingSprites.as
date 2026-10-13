package
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import model.Ammo;
   import model.AmmoBigLaser;
   import model.AmmoEnemy;
   import model.AmmoLeftAngle;
   import model.AmmoRightAngle;
   import model.ButtonSprite;
   import model.DoubleGun;
   import model.Ellipse;
   import model.GeometricShape;
   import model.Gun;
   import model.Live;
   import model.Rectangle;
   import model.ShieldSprite;
   import model.SingleGun;
   import model.TripleGun;
   import mx.binding.*;
   import mx.collections.ArrayCollection;
   import mx.core.IFlexModuleFactory;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.filters.*;
   import mx.styles.*;
   import spark.components.Application;
   import spark.components.Label;
   import spark.layouts.VerticalLayout;
   import utility.LoanShark;
   
   use namespace mx_internal;
   
   public class FallingSprites extends Application
   {
      
      private static const EmbeddedPictureNosePicker:Class = FallingSprites_EmbeddedPictureNosePicker;
      
      private static const S2Games:Class = FallingSprites_S2Games;
      
      private static const Eurocom:Class = FallingSprites_Eurocom;
      
      private static const Disney:Class = FallingSprites_Disney;
      
      private static const Abc:Class = FallingSprites_Abc;
      
      private static const Nbc:Class = FallingSprites_Nbc;
      
      private static const Playboy:Class = FallingSprites_Playboy;
      
      private static const Ea:Class = FallingSprites_Ea;
      
      private static const Atari:Class = FallingSprites_Atari;
      
      private static const GameOver:Class = FallingSprites_GameOver;
      
      private static var _skinParts:Object = {
         "contentGroup":false,
         "controlBarGroup":false
      };
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private const MAX_LIVES:int = 3;
      
      private const LEVEL_COUNTER:int = 5;
      
      private const GAME_STARTED:uint = 1;
      
      private const GAME_ENDED:uint = 0;
      
      private const GAME_PAUSED:uint = 2;
      
      private const GAME_DEFAULT:uint = 5;
      
      private const enemiesKilled:String = "Killed: ";
      
      private const lives:String = "Lives: ";
      
      private var gameState:uint = 5;
      
      private var gameStarted:Boolean = false;
      
      private const MINIMUM_INTERVAL_VALUE:Number = 300;
      
      private const MAXIMUM_INTERVAL_VALUE:Number = 600;
      
      private var WIDTH:Number = 976;
      
      private var HEIGHT:Number = 720;
      
      private var containerSprite:Sprite = new Sprite();
      
      private var mainSprite:Sprite = new Sprite();
      
      private var infoSprite:Sprite = new Sprite();
      
      private var minuteTimer:Timer = new Timer(1000);
      
      private var textFld:TextField = new TextField();
      
      private var tfStyle:TextFormat = new TextFormat();
      
      private var textFldScore:TextField = new TextField();
      
      private var tfStyleScore:TextFormat = new TextFormat();
      
      private var textGameTitle:TextField = new TextField();
      
      private var tfStyleGameTitle:TextFormat = new TextFormat();
      
      private var manual:TextField = new TextField();
      
      private var tfManual:TextFormat = new TextFormat();
      
      private var label:Label = new Label();
      
      private var collisionCount:int = 0;
      
      private var killsCont:int = 0;
      
      private var pickerGun:Sprite = new Sprite();
      
      private var keyLeftRightPressed:uint;
      
      private var leftPressed:Boolean = false;
      
      private var rightPressed:Boolean = false;
      
      private var spacePressed:Boolean = false;
      
      private var shieldPressed:Boolean = false;
      
      private var touchEventLeftButtonSprite:Sprite = new Sprite();
      
      private var touchEventRightButtonSprite:Sprite = new Sprite();
      
      private var sndExplosion:Sound;
      
      private var sndAmmo:Sound;
      
      private var frameNo:int = 0;
      
      private var logosArray:ArrayCollection = new ArrayCollection();
      
      private var buttonStartGame:ButtonSprite;
      
      private var buttonPauseGame:ButtonSprite;
      
      private var gameOverBitmap:Bitmap;
      
      private var counter:uint = 0;
      
      private var currentGun:int = 1;
      
      private var gunsPool:ArrayCollection = new ArrayCollection(new Array(new SingleGun(),new DoubleGun(),new TripleGun()));
      
      private var gunTimer:Timer = new Timer(1000);
      
      private var heartTimer:Timer = new Timer(1000);
      
      private var heartSprite:Live = new Live();
      
      private var shieldSprite:ShieldSprite = new ShieldSprite();
      
      private var ammoPool:LoanShark = new LoanShark(Ammo,false,50);
      
      private var ammoLeftPool:LoanShark = new LoanShark(AmmoLeftAngle,false,50);
      
      private var ammoRightPool:LoanShark = new LoanShark(AmmoRightAngle,false,50);
      
      private var ammoBigLaserPool:LoanShark = new LoanShark(AmmoBigLaser,false,50);
      
      private var startValue:Number = 1;
      
      private var endValue:Number = 5;
      
      private var touchMoveID:int = 0;
      
      mx_internal var _FallingSprites_StylesInit_done:Boolean = false;
      
      public function FallingSprites()
      {
         super();
         mx_internal::_document = this;
         this.layout = this._FallingSprites_VerticalLayout1_c();
         this.addEventListener("applicationComplete",this.___FallingSprites_Application1_applicationComplete);
         this.addEventListener("creationComplete",this.___FallingSprites_Application1_creationComplete);
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         mx_internal::_FallingSprites_StylesInit();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      protected function application1_creationCompleteHandler(param1:FlexEvent) : void
      {
         var _loc2_:Bitmap = new S2Games();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Eurocom();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Disney();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Nbc();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Playboy();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Ea();
         this.logosArray.addItem(_loc2_);
         _loc2_ = new Atari();
         this.logosArray.addItem(_loc2_);
         Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
      }
      
      private function generateShape() : Sprite
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = int(GeometricShape.getRndNumber(0,this.logosArray.length - 1));
         var _loc3_:Bitmap = new Bitmap(Bitmap(this.logosArray[_loc2_]).bitmapData);
         _loc3_.width = 60;
         _loc3_.height = 60;
         if(this.counter == 0)
         {
            _loc1_ = new model.Rectangle(this.WIDTH,20,80,1267010,517115,false,_loc3_.width);
            (_loc1_ as model.Rectangle).speed = GeometricShape.getRndNumber(this.startValue,this.endValue);
            if(this.killsCont % this.LEVEL_COUNTER == 0)
            {
               this.startValue = this.killsCont / this.LEVEL_COUNTER;
               this.endValue = this.startValue + this.LEVEL_COUNTER;
            }
            this.counter = 1;
         }
         else
         {
            _loc1_ = new Ellipse(this.WIDTH,40,80,653283,4893656,false,_loc3_.width);
            (_loc1_ as Ellipse).speed = GeometricShape.getRndNumber(this.startValue,this.endValue);
            if(this.killsCont % this.LEVEL_COUNTER == 0)
            {
               this.startValue = this.killsCont / this.LEVEL_COUNTER;
               this.endValue = this.startValue + this.LEVEL_COUNTER;
            }
            this.counter = 0;
         }
         _loc1_.addChild(_loc3_);
         return _loc1_;
      }
      
      protected function application1_applicationCompleteHandler(param1:FlexEvent) : void
      {
         this.sndExplosion = new Sound(new URLRequest("sounds/explosion1.mp"));
         this.sndAmmo = new Sound(new URLRequest("sounds/sound46bullet2.mp"));
         this.mainSprite.graphics.beginFill(0,1);
         this.mainSprite.graphics.drawRect(0,0,this.WIDTH,this.HEIGHT);
         this.mainSprite.x = 0;
         this.mainSprite.y = 85;
         this.containerSprite.addChild(this.mainSprite);
         this.infoSprite.graphics.beginFill(0,1);
         this.infoSprite.graphics.drawRect(0,0,this.WIDTH,80);
         this.infoSprite.x = 0;
         this.tfStyle.font = "Verdana";
         this.tfStyle.bold = true;
         this.tfStyle.size = 20;
         this.textFld.height = 25;
         this.textFld.text = this.lives + this.MAX_LIVES.toString();
         this.textFld.setTextFormat(this.tfStyle);
         this.textFld.textColor = 13156390;
         this.textFld.x = 30;
         this.textFld.y = 50;
         this.tfStyleScore.font = "Verdana";
         this.tfStyleScore.bold = true;
         this.tfStyleScore.size = 20;
         this.tfStyleScore.color = 13156390;
         this.textFldScore.width = 150;
         this.textFldScore.height = 25;
         this.textFldScore.text = this.enemiesKilled + "0";
         this.textFldScore.setTextFormat(this.tfStyleScore);
         this.textFldScore.x = this.WIDTH - 200;
         this.textFldScore.y = 30;
         this.tfStyleGameTitle.font = "Verdana";
         this.tfStyleGameTitle.bold = true;
         this.tfStyleGameTitle.size = 30;
         this.tfStyleGameTitle.color = 457790;
         this.textGameTitle.width = 350;
         this.textGameTitle.text = "THE NOSE PICKER";
         this.textGameTitle.x = 30;
         this.textGameTitle.y = 18;
         this.textGameTitle.setTextFormat(this.tfStyleGameTitle);
         this.tfManual.font = "Verdana";
         this.tfManual.bold = true;
         this.tfManual.size = 12;
         this.tfManual.color = 457790;
         this.manual.width = 250;
         this.manual.text = "S : start game\nP : pause game\n1-4 : weapons\nctrl : shield\nspace : fire";
         this.manual.x = 400;
         this.manual.y = 5;
         this.manual.setTextFormat(this.tfManual);
         this.infoSprite.addChild(this.textFld);
         this.infoSprite.addChild(this.textFldScore);
         this.infoSprite.addChild(this.textGameTitle);
         this.infoSprite.addChild(this.manual);
         this.containerSprite.addChild(this.infoSprite);
         this.buttonStartGame = new ButtonSprite(3459367,14744827,"Start game");
         this.buttonStartGame.width = 130;
         this.buttonStartGame.x = this.WIDTH - 400;
         this.buttonStartGame.y = 10;
         this.buttonStartGame.addEventListener(MouseEvent.CLICK,this.onStartGame);
         this.infoSprite.addChild(this.buttonStartGame);
         this.buttonPauseGame = new ButtonSprite(3459367,14744827,"Pause game");
         this.buttonPauseGame.width = 130;
         this.buttonPauseGame.x = this.WIDTH - 400;
         this.buttonPauseGame.y = 50;
         this.buttonPauseGame.addEventListener(MouseEvent.CLICK,this.onPauseGame);
         this.infoSprite.addChild(this.buttonPauseGame);
         stage.addChild(this.containerSprite);
         this.minuteTimer.addEventListener(TimerEvent.TIMER,this.onTick);
         this.gunTimer.addEventListener(TimerEvent.TIMER,this.onGunTimerTick);
         this.heartTimer.addEventListener(TimerEvent.TIMER,this.onHeartTimerTick);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownStartPause);
         stage.addEventListener(Event.RESIZE,this.resizeListener);
         stage.quality = StageQuality.BEST;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         this.resizeListener(null);
      }
      
      private function addTouchEvents() : void
      {
         if(Multitouch.supportsTouchEvents)
         {
            this.touchEventLeftButtonSprite.graphics.beginFill(16763175,0.2);
            this.touchEventLeftButtonSprite.graphics.drawRect(0,0,70,70);
            this.touchEventLeftButtonSprite.x = 100;
            this.touchEventLeftButtonSprite.y = this.HEIGHT - 70;
            this.touchEventLeftButtonSprite.addEventListener(TouchEvent.TOUCH_BEGIN,this.taphandlerLeftBegin);
            this.touchEventLeftButtonSprite.addEventListener(TouchEvent.TOUCH_END,this.taphandlerLeftEnd);
            this.mainSprite.addChild(this.touchEventLeftButtonSprite);
            this.touchEventRightButtonSprite.graphics.beginFill(16763175,0.2);
            this.touchEventRightButtonSprite.graphics.drawRect(0,0,70,70);
            this.touchEventRightButtonSprite.x = this.WIDTH - 70 - 100;
            this.touchEventRightButtonSprite.y = this.HEIGHT - 70;
            this.touchEventRightButtonSprite.addEventListener(TouchEvent.TOUCH_BEGIN,this.taphandlerRightBegin);
            this.touchEventRightButtonSprite.addEventListener(TouchEvent.TOUCH_END,this.taphandlerRightEnd);
            this.mainSprite.addChild(this.touchEventRightButtonSprite);
            this.spacePressed = true;
         }
      }
      
      private function touchBegin(param1:TouchEvent) : void
      {
         if(this.touchMoveID != 0)
         {
            return;
         }
         this.touchMoveID = param1.touchPointID;
         this.pickerGun.x = param1.stageX;
         stage.addEventListener(TouchEvent.TOUCH_MOVE,this.touchMove);
         stage.addEventListener(TouchEvent.TOUCH_END,this.touchEnd);
      }
      
      private function touchMove(param1:TouchEvent) : void
      {
         if(param1.touchPointID != this.touchMoveID)
         {
            return;
         }
         this.pickerGun.x = param1.stageX;
      }
      
      private function touchEnd(param1:TouchEvent) : void
      {
         if(param1.touchPointID != this.touchMoveID)
         {
            return;
         }
         this.touchMoveID = 0;
         stage.removeEventListener(TouchEvent.TOUCH_MOVE,this.touchMove);
         stage.removeEventListener(TouchEvent.TOUCH_END,this.touchEnd);
         this.pickerGun.x = param1.stageX;
      }
      
      private function taphandlerLeftBegin(param1:TouchEvent) : void
      {
         this.rightPressed = false;
         this.leftPressed = true;
      }
      
      private function taphandlerLeftEnd(param1:TouchEvent) : void
      {
         this.leftPressed = false;
         this.rightPressed = false;
      }
      
      private function taphandlerRightBegin(param1:TouchEvent) : void
      {
         this.leftPressed = false;
         this.rightPressed = true;
      }
      
      private function taphandlerRightEnd(param1:TouchEvent) : void
      {
         this.leftPressed = false;
         this.rightPressed = false;
      }
      
      protected function doTouchBegin(param1:TouchEvent) : void
      {
         stage.addEventListener(TouchEvent.TOUCH_END,this.doTouchEnd);
         stage.addEventListener(TouchEvent.TOUCH_MOVE,this.doTouchMove);
      }
      
      protected function doTouchEnd(param1:TouchEvent) : void
      {
         this.spacePressed = false;
         stage.removeEventListener(TouchEvent.TOUCH_END,this.doTouchEnd);
         stage.removeEventListener(TouchEvent.TOUCH_MOVE,this.doTouchMove);
      }
      
      protected function doTouchMove(param1:TouchEvent) : void
      {
         this.spacePressed = true;
         this.pickerGun.x = param1.stageX;
      }
      
      private function updateTF(param1:TouchEvent) : void
      {
      }
      
      private function onSwipe(param1:TransformGestureEvent) : void
      {
         if(param1.offsetX == 1)
         {
            this.leftPressed = false;
            this.rightPressed = true;
            this.spacePressed = true;
         }
         else
         {
            this.leftPressed = true;
            this.rightPressed = false;
            this.spacePressed = true;
         }
      }
      
      private function resizeListener(param1:Event) : void
      {
         var _loc2_:Number = Number(stage.stageWidth) / stage.stageHeight;
         var _loc3_:Number = this.containerSprite.width / this.containerSprite.height;
         if(_loc2_ > _loc3_)
         {
            this.containerSprite.width *= stage.stageHeight / this.containerSprite.height;
            this.containerSprite.height = stage.stageHeight;
         }
         else
         {
            this.containerSprite.height *= stage.stageWidth / this.containerSprite.width;
            this.containerSprite.width = stage.stageWidth;
         }
      }
      
      private function onGunTimerTick(param1:Event) : void
      {
         var _loc2_:int = GeometricShape.getRndNumber(0,this.gunsPool.length - 1);
         var _loc3_:Gun = this.gunsPool[_loc2_];
         _loc3_.y = 0;
         _loc3_.x = GeometricShape.getRndNumber(0,this.WIDTH - _loc3_.width);
         this.mainSprite.addChild(_loc3_);
         _loc3_.addEventListener(Event.ENTER_FRAME,this.onGunEnterFrame);
         this.gunTimer.delay = GeometricShape.getRndNumber(5000,10000);
      }
      
      private function onHeartTimerTick(param1:Event) : void
      {
         if(!this.heartSprite.addedToGame)
         {
            this.heartSprite.x = GeometricShape.getRndNumber(0,this.WIDTH - this.heartSprite.width);
            this.mainSprite.addChild(this.heartSprite);
            this.heartSprite.addedToGame = true;
            this.heartSprite.addEventListener(Event.ENTER_FRAME,this.onHeartEnterFrame);
            this.heartTimer.delay = GeometricShape.getRndNumber(20000,40000);
         }
      }
      
      private function onStartGame(param1:Event) : void
      {
         if(this.gameState == this.GAME_DEFAULT || this.gameState == this.GAME_ENDED)
         {
            this.addTouchEvents();
            this.gameState = this.GAME_STARTED;
            this.collisionCount = this.MAX_LIVES;
            this.textFld.text = this.lives + this.MAX_LIVES.toString();
            this.textFld.setTextFormat(this.tfStyle);
            this.removeGameOver();
            this.setPickerGunOnMainSprite();
            this.minuteTimer.delay = GeometricShape.getRndNumber(this.MINIMUM_INTERVAL_VALUE,this.MAXIMUM_INTERVAL_VALUE);
            this.minuteTimer.start();
            this.gunTimer.delay = GeometricShape.getRndNumber(5000,10000);
            this.gunTimer.start();
            this.heartTimer.start();
         }
         else if(this.gameState == this.GAME_PAUSED)
         {
            this.gameState = this.GAME_STARTED;
            this.minuteTimer.delay = GeometricShape.getRndNumber(this.MINIMUM_INTERVAL_VALUE,this.MAXIMUM_INTERVAL_VALUE);
            this.minuteTimer.start();
            this.gunTimer.start();
            this.heartTimer.start();
         }
      }
      
      private function onPauseGame(param1:Event) : void
      {
         if(this.gameState == this.GAME_STARTED)
         {
            this.gameState = this.GAME_PAUSED;
            this.minuteTimer.stop();
            this.gunTimer.stop();
         }
      }
      
      private function gameOver() : void
      {
         this.gameState = this.GAME_ENDED;
         this.killsCont = 0;
         this.currentGun = 1;
         this.textFldScore.text = this.enemiesKilled + this.killsCont.toString();
         this.textFldScore.setTextFormat(this.tfStyleScore);
         this.collisionCount = 0;
         this.textFld.text = this.lives + this.collisionCount.toString();
         this.textFld.setTextFormat(this.tfStyle);
         this.resetKeysThatPressed();
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.removeEventPickerGun(this.pickerGun);
         this.mainSprite.removeChild(this.pickerGun);
         this.minuteTimer.stop();
         this.gunTimer.stop();
         this.heartTimer.stop();
         this.removeAllSprites();
         this.gameOverBitmap = new GameOver();
         this.gameOverBitmap.x = this.WIDTH / 2 - this.gameOverBitmap.width / 2;
         this.gameOverBitmap.y = this.HEIGHT / 2 - this.gameOverBitmap.height / 2;
         this.mainSprite.addChild(this.gameOverBitmap);
         this.frameNo = 0;
      }
      
      private function onTick(param1:TimerEvent) : void
      {
         var _loc2_:Sprite = this.generateShape();
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         _loc2_.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         var _loc3_:AmmoEnemy = new AmmoEnemy();
         _loc3_.x = _loc2_.x;
         _loc3_.y = _loc2_.y + _loc2_.height;
         this.mainSprite.addChild(_loc2_);
         _loc3_.addEventListener(Event.ENTER_FRAME,this.onAmmoEnemyEnterFrame);
         this.mainSprite.addChild(_loc3_);
         var _loc4_:AmmoEnemy = new AmmoEnemy();
         _loc4_.x = _loc2_.x;
         _loc4_.y = _loc2_.y + _loc2_.height - 55;
         _loc4_.addEventListener(Event.ENTER_FRAME,this.onAmmoEnemyEnterFrame);
         this.mainSprite.addChild(_loc4_);
         this.minuteTimer.delay = GeometricShape.getRndNumber(this.MINIMUM_INTERVAL_VALUE,this.MAXIMUM_INTERVAL_VALUE);
      }
      
      private function onAmmoEnemyEnterFrame(param1:Event) : void
      {
         var _loc2_:AmmoEnemy = param1.target as AmmoEnemy;
         if(_loc2_.y < this.HEIGHT)
         {
            _loc2_.y += 30;
            if(this.shieldPressed && this.shieldSprite.hitTestObject(_loc2_))
            {
               this.removeEventAmmoEnemy(_loc2_);
               if(this.mainSprite.contains(_loc2_))
               {
                  this.mainSprite.removeChild(_loc2_);
               }
            }
            else if(this.pickerGun.hitTestObject(_loc2_))
            {
               this.removeEventAmmoEnemy(_loc2_);
               if(this.mainSprite.contains(_loc2_))
               {
                  this.mainSprite.removeChild(_loc2_);
               }
               this.changeLivesBy(-1);
               if(this.collisionCount == 0)
               {
                  this.gameOver();
               }
            }
         }
         else
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onAmmoEnemyEnterFrame);
            if(this.mainSprite.contains(_loc2_))
            {
               this.mainSprite.removeChild(_loc2_);
            }
         }
      }
      
      private function onMouseClick(param1:Event) : void
      {
         var _loc2_:GeometricShape = param1.target as GeometricShape;
         this.removeEventGeometricShape(_loc2_);
         this.mainSprite.removeChild(_loc2_);
      }
      
      private function setPickerGunOnMainSprite() : void
      {
         var _loc1_:Bitmap = new EmbeddedPictureNosePicker();
         this.pickerGun.addChild(_loc1_);
         this.pickerGun.x = this.WIDTH / 2 - this.pickerGun.width / 2;
         this.pickerGun.y = this.HEIGHT - this.pickerGun.height;
         this.mainSprite.addChild(this.pickerGun);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.pickerGun.addEventListener(Event.ENTER_FRAME,this.onPickerGunEnterFrame);
      }
      
      private function fireAmmo() : void
      {
         var _loc1_:Vector.<Ammo> = null;
         var _loc2_:Ammo = null;
         var _loc3_:Vector.<Ammo> = null;
         var _loc4_:Ammo = null;
         if(1 == this.currentGun)
         {
            this.sndAmmo.play(0);
            this.mainSprite.addChild(this.generateAmmo());
         }
         else if(2 == this.currentGun)
         {
            this.sndAmmo.play(0);
            _loc1_ = this.generateDoubleAmmo();
            for each(_loc2_ in _loc1_)
            {
               this.mainSprite.addChild(_loc2_);
            }
         }
         else if(3 == this.currentGun)
         {
            this.sndAmmo.play(0);
            _loc3_ = this.generateTripleAmmo();
            for each(_loc4_ in _loc3_)
            {
               this.mainSprite.addChild(_loc4_);
            }
         }
         else if(4 == this.currentGun)
         {
            this.sndAmmo.play(0);
            this.mainSprite.addChild(this.generateBigLaser());
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            this.leftPressed = true;
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.rightPressed = true;
         }
         else if(param1.keyCode == Keyboard.SPACE)
         {
            this.spacePressed = true;
         }
         else if(param1.keyCode == Keyboard.CONTROL)
         {
            this.shieldPressed = true;
            this.mainSprite.addChild(this.shieldSprite);
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.LEFT)
         {
            this.leftPressed = false;
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            this.rightPressed = false;
         }
         else if(param1.keyCode == Keyboard.SPACE)
         {
            this.spacePressed = false;
            this.fireAmmo();
         }
         else if(param1.keyCode == Keyboard.NUMBER_1)
         {
            this.currentGun = 1;
         }
         else if(param1.keyCode == Keyboard.NUMBER_2)
         {
            this.currentGun = 2;
         }
         else if(param1.keyCode == Keyboard.NUMBER_3)
         {
            this.currentGun = 3;
         }
         else if(param1.keyCode == Keyboard.NUMBER_4)
         {
            this.currentGun = 4;
         }
         else if(param1.keyCode == Keyboard.CONTROL)
         {
            this.shieldPressed = false;
            if(this.mainSprite.contains(this.shieldSprite))
            {
               this.mainSprite.removeChild(this.shieldSprite);
            }
         }
      }
      
      private function onKeyDownStartPause(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.S)
         {
            this.onStartGame(null);
         }
         else if(param1.keyCode == Keyboard.P)
         {
            this.onPauseGame(null);
         }
      }
      
      private function resetKeysThatPressed() : void
      {
         this.leftPressed = false;
         this.rightPressed = false;
         this.spacePressed = false;
         this.shieldPressed = false;
         this.leftPressed = false;
         this.rightPressed = false;
         this.spacePressed = false;
         this.currentGun = 1;
         this.shieldPressed = false;
      }
      
      private function generateAmmo() : Ammo
      {
         var _loc1_:Ammo = this.ammoPool.borrowObject();
         _loc1_.graphics.beginFill(15924992,1);
         _loc1_.graphics.drawRect(0,0,5,20);
         _loc1_.graphics.endFill();
         _loc1_.x = this.pickerGun.x + 58;
         _loc1_.y = this.pickerGun.y;
         _loc1_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         return _loc1_;
      }
      
      private function generateDoubleAmmo() : Vector.<Ammo>
      {
         var _loc1_:Vector.<Ammo> = new Vector.<Ammo>();
         var _loc2_:Ammo = this.ammoPool.borrowObject();
         _loc2_.graphics.beginFill(64021,1);
         _loc2_.graphics.drawRect(0,0,5,20);
         _loc2_.graphics.endFill();
         _loc2_.x = this.pickerGun.x + 9;
         _loc2_.y = this.pickerGun.y;
         _loc2_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         _loc1_.push(_loc2_);
         var _loc3_:Ammo = this.ammoPool.borrowObject();
         _loc3_.graphics.beginFill(64021,1);
         _loc3_.graphics.drawRect(0,0,5,20);
         _loc3_.graphics.endFill();
         _loc3_.x = this.pickerGun.x + 69;
         _loc3_.y = this.pickerGun.y;
         _loc3_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         _loc1_.push(_loc3_);
         return _loc1_;
      }
      
      private function generateTripleAmmo() : Vector.<Ammo>
      {
         var _loc1_:Vector.<Ammo> = new Vector.<Ammo>();
         var _loc2_:AmmoLeftAngle = this.ammoLeftPool.borrowObject();
         _loc2_.graphics.beginFill(321279,1);
         _loc2_.graphics.drawRect(0,0,5,20);
         _loc2_.graphics.endFill();
         _loc2_.x = this.pickerGun.x + 9;
         _loc2_.y = this.pickerGun.y;
         _loc2_.rotation = 160;
         _loc2_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         _loc1_.push(_loc2_);
         var _loc3_:AmmoRightAngle = this.ammoRightPool.borrowObject();
         _loc3_.graphics.beginFill(321279,1);
         _loc3_.graphics.drawRect(0,0,5,20);
         _loc3_.graphics.endFill();
         _loc3_.x = this.pickerGun.x + 69;
         _loc3_.y = this.pickerGun.y;
         _loc3_.rotation = 20;
         _loc3_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         _loc1_.push(_loc3_);
         var _loc4_:Ammo = this.ammoPool.borrowObject();
         _loc4_.graphics.beginFill(321279,1);
         _loc4_.graphics.drawRect(0,0,5,20);
         _loc4_.graphics.endFill();
         _loc4_.x = this.pickerGun.x + 39;
         _loc4_.y = this.pickerGun.y;
         _loc4_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         _loc1_.push(_loc4_);
         return _loc1_;
      }
      
      private function generateBigLaser() : Ammo
      {
         var _loc1_:AmmoBigLaser = this.ammoBigLaserPool.borrowObject();
         _loc1_.x = this.pickerGun.x + 58;
         _loc1_.y = this.pickerGun.y;
         _loc1_.addEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
         return _loc1_;
      }
      
      private function changeLivesBy(param1:int) : void
      {
         this.collisionCount += param1;
         this.textFld.text = this.lives + this.collisionCount.toString();
         this.textFld.setTextFormat(this.tfStyle);
      }
      
      private function changeScore(param1:int) : void
      {
         this.killsCont += param1;
         this.textFldScore.text = this.enemiesKilled + this.killsCont.toString();
         this.textFldScore.setTextFormat(this.tfStyleScore);
      }
      
      private function onPickerGunEnterFrame(param1:Event) : void
      {
         if(this.gameState == this.GAME_PAUSED)
         {
            return;
         }
         ++this.frameNo;
         if(this.shieldPressed)
         {
            this.shieldSprite.x = this.pickerGun.x - 10;
            this.shieldSprite.y = this.pickerGun.y - 5;
         }
         if(this.leftPressed)
         {
            if(-48 < this.pickerGun.x)
            {
               this.pickerGun.x -= 15;
               this.shieldSprite.x -= 15;
            }
         }
         else if(this.rightPressed)
         {
            if(this.pickerGun.x + this.pickerGun.width < this.WIDTH)
            {
               this.pickerGun.x += 15;
               this.shieldSprite.x += 15;
            }
         }
         if(this.spacePressed)
         {
            if(this.frameNo % 10 == 0)
            {
               this.fireAmmo();
            }
         }
      }
      
      private function ammoOnEnterFrame(param1:Event) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Sprite = null;
         if(this.gameState == this.GAME_PAUSED)
         {
            return;
         }
         var _loc2_:Sprite = param1.target as Sprite;
         if(0 < _loc2_.y && _loc2_.x > 0 && _loc2_.x < this.WIDTH)
         {
            if(_loc2_ is AmmoLeftAngle)
            {
               _loc2_.y -= 30;
               _loc2_.x -= 10;
            }
            else if(_loc2_ is AmmoRightAngle)
            {
               _loc2_.y -= 30;
               _loc2_.x += 10;
            }
            else if(_loc2_ is Ammo)
            {
               _loc2_.y -= 30;
            }
            _loc3_ = 0;
            while(_loc3_ < this.mainSprite.numChildren)
            {
               _loc4_ = this.mainSprite.getChildAt(_loc3_) as Sprite;
               if(_loc4_ is GeometricShape)
               {
                  if(_loc4_.hitTestObject(_loc2_))
                  {
                     if(null != _loc2_)
                     {
                        if(!(_loc2_ is AmmoBigLaser))
                        {
                           this.removeEventAmmo(_loc2_);
                           if(this.containsInChild(_loc2_))
                           {
                              this.mainSprite.removeChild(_loc2_);
                              this.returnAmmoToPool(_loc2_);
                           }
                        }
                     }
                     this.sndExplosion.play(0);
                     this.removeEventGeometricShape(_loc4_);
                     this.mainSprite.removeChild(_loc4_);
                     this.changeScore(1);
                  }
               }
               _loc3_++;
            }
         }
         else
         {
            this.removeEventAmmo(_loc2_);
            this.mainSprite.removeChild(_loc2_);
            this.returnAmmoToPool(_loc2_);
         }
      }
      
      private function returnAmmoToPool(param1:Sprite) : void
      {
         if(param1 is AmmoLeftAngle)
         {
            this.ammoLeftPool.returnObject(param1);
         }
         else if(param1 is AmmoRightAngle)
         {
            this.ammoRightPool.returnObject(param1);
         }
         else if(param1 is AmmoBigLaser)
         {
            this.ammoBigLaserPool.returnObject(param1);
         }
         else if(param1 is Ammo)
         {
            this.ammoPool.returnObject(param1);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.gameState == this.GAME_PAUSED || this.gameState == this.GAME_ENDED)
         {
            return;
         }
         var _loc2_:GeometricShape = param1.target as GeometricShape;
         if(_loc2_.y + _loc2_.height < this.HEIGHT)
         {
            _loc2_.rotate();
            _loc2_.y += _loc2_.speed;
            if(this.shieldPressed && _loc2_.hitTestObject(this.shieldSprite))
            {
               this.removeEventGeometricShape(_loc2_);
               _loc2_.parent.removeChild(_loc2_);
            }
            if(_loc2_.hitTestObject(this.pickerGun))
            {
               this.removeEventGeometricShape(_loc2_);
               if(_loc2_.parent.contains(_loc2_))
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               this.changeLivesBy(-1);
               if(this.collisionCount == 0)
               {
                  this.gameOver();
               }
            }
         }
         else
         {
            this.removeEventGeometricShape(_loc2_);
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      private function onGunEnterFrame(param1:Event) : void
      {
         if(this.gameState == this.GAME_PAUSED)
         {
            return;
         }
         var _loc2_:Gun = param1.target as Gun;
         if(null != _loc2_)
         {
            if(_loc2_.y + _loc2_.height < this.HEIGHT)
            {
               _loc2_.y += 25;
               if(_loc2_.hitTestObject(this.pickerGun))
               {
                  this.currentGun = this.gunsPool.getItemIndex(_loc2_) + 1;
               }
            }
            else
            {
               this.removeEventGun(_loc2_);
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      private function onHeartEnterFrame(param1:Event) : void
      {
         if(this.gameState == this.GAME_PAUSED)
         {
            return;
         }
         var _loc2_:Live = param1.target as Live;
         if(null != _loc2_)
         {
            if(_loc2_.y + _loc2_.height < this.HEIGHT)
            {
               _loc2_.y += 15;
               if(_loc2_.hitTestObject(this.pickerGun))
               {
                  this.removeEventHeart(_loc2_);
                  _loc2_.addedToGame = false;
                  _loc2_.parent.removeChild(_loc2_);
                  _loc2_.y = 0;
                  this.changeLivesBy(1);
               }
            }
            else
            {
               this.removeEventHeart(_loc2_);
               _loc2_.addedToGame = false;
               _loc2_.parent.removeChild(_loc2_);
               _loc2_.y = 0;
            }
         }
      }
      
      private function containsInChild(param1:Sprite) : Boolean
      {
         var _loc4_:Sprite = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.mainSprite.numChildren)
         {
            _loc4_ = this.mainSprite.getChildAt(_loc3_) as Sprite;
            if(_loc4_ is Ammo)
            {
               if(_loc4_ == param1)
               {
                  _loc2_ = true;
                  break;
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function removeGameOver() : void
      {
         if(null != this.gameOverBitmap)
         {
            this.mainSprite.removeChild(this.gameOverBitmap);
         }
      }
      
      private function removeAllSprites() : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         var _loc2_:int = 0;
         while(_loc2_ < this.mainSprite.numChildren)
         {
            _loc4_ = this.mainSprite.getChildAt(_loc2_) as Sprite;
            _loc1_.addItem(_loc4_);
            _loc2_++;
         }
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ is GeometricShape)
            {
               this.removeEventGeometricShape(_loc3_);
            }
            else if(_loc3_ is Ammo)
            {
               this.removeEventAmmo(_loc3_);
               this.returnAmmoToPool(_loc3_);
            }
            else if(_loc3_ is Gun)
            {
               this.removeEventGun(_loc3_);
            }
            else if(_loc3_ is Live)
            {
               this.removeEventHeart(_loc3_);
               (_loc3_ as Live).addedToGame = false;
            }
            this.mainSprite.removeChild(_loc3_);
         }
         _loc1_.removeAll();
      }
      
      private function removeEventGeometricShape(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         param1.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function removeEventAmmo(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.ammoOnEnterFrame);
      }
      
      private function removeEventPickerGun(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.onPickerGunEnterFrame);
      }
      
      private function removeEventGun(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.onGunEnterFrame);
      }
      
      private function removeEventHeart(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.onHeartEnterFrame);
      }
      
      private function removeEventAmmoEnemy(param1:Sprite) : void
      {
         param1.removeEventListener(Event.ENTER_FRAME,this.onAmmoEnemyEnterFrame);
      }
      
      private function _FallingSprites_VerticalLayout1_c() : VerticalLayout
      {
         return new VerticalLayout();
      }
      
      public function ___FallingSprites_Application1_applicationComplete(param1:FlexEvent) : void
      {
         this.application1_applicationCompleteHandler(param1);
      }
      
      public function ___FallingSprites_Application1_creationComplete(param1:FlexEvent) : void
      {
         this.application1_creationCompleteHandler(param1);
      }
      
      mx_internal function _FallingSprites_StylesInit() : void
      {
         var _loc1_:CSSStyleDeclaration = null;
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:CSSCondition = null;
         var _loc5_:CSSSelector = null;
         if(mx_internal::_FallingSprites_StylesInit_done)
         {
            return;
         }
         mx_internal::_FallingSprites_StylesInit_done = true;
         styleManager.initProtoChainRoots();
      }
   }
}

