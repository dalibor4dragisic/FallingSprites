package model
{
   import flash.display.Bitmap;
   
   public class DoubleGun extends Gun
   {
      
      private static const DoubleGunBitmap:Class = DoubleGun_DoubleGunBitmap;
      
      public function DoubleGun()
      {
         super();
         var _loc1_:Bitmap = new DoubleGunBitmap();
         _loc1_.rotation = 90;
         addChild(_loc1_);
      }
   }
}

