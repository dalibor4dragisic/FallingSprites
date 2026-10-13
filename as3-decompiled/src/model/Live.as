package model
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class Live extends Sprite
   {
      
      private static const HeartBitmap:Class = Live_HeartBitmap;
      
      public var addedToGame:Boolean = false;
      
      public function Live()
      {
         super();
         var _loc1_:Bitmap = new HeartBitmap();
         addChild(_loc1_);
      }
   }
}

