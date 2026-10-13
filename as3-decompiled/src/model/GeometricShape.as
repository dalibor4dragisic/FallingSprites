package model
{
   import flash.display.Sprite;
   import interfaces.GeometricInterface;
   
   public class GeometricShape extends Sprite implements GeometricInterface
   {
      
      private var _bodyColor:uint;
      
      private var _borderColor:uint;
      
      private var _borderSize:Number = getRndNumber(0,10);
      
      private var _speed:Number = getRndNumber(1,5);
      
      private var _drawGraphics:Boolean = false;
      
      protected var _parentWidth:Number;
      
      private var _bitMapWidth:Number;
      
      private var rotationAngle:Number = 6;
      
      public function GeometricShape(param1:uint, param2:uint, param3:Boolean, param4:Number)
      {
         this._bodyColor = param1;
         this._borderColor = param2;
         this.drawGraphics = param3;
         this._bitMapWidth = param4;
         super();
         this.cacheAsBitmap = true;
      }
      
      public static function getRndNumber(param1:Number, param2:Number) : Number
      {
         return Math.floor(Math.random() * (1 + param2 - param1)) + param1;
      }
      
      public function rotate() : void
      {
         this.rotation += this.rotationAngle;
      }
      
      public function getArea() : Number
      {
         return this.width * this.height;
      }
      
      public function set bodyColor(param1:uint) : void
      {
         this._bodyColor = param1;
      }
      
      public function get bodyColor() : uint
      {
         return this._bodyColor;
      }
      
      public function set borderColor(param1:uint) : void
      {
         this._borderColor = param1;
      }
      
      public function get borderColor() : uint
      {
         return this._borderColor;
      }
      
      public function set borderSize(param1:Number) : void
      {
         this._borderSize = param1;
      }
      
      public function get borderSize() : Number
      {
         return this._borderSize;
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set drawGraphics(param1:Boolean) : void
      {
         this._drawGraphics = param1;
      }
      
      public function get drawGraphics() : Boolean
      {
         return this._drawGraphics;
      }
      
      public function set bitmapWidth(param1:Number) : void
      {
         this._bitMapWidth = param1;
      }
      
      public function get bitmapWidth() : Number
      {
         return this._bitMapWidth;
      }
   }
}

