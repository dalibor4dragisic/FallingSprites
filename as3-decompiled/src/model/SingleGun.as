package model
{
   import flash.display.Bitmap;
   
   public class SingleGun extends Gun
   {
      
      private static const SingleGunBitmap:Class = SingleGun_SingleGunBitmap;
      
      public function SingleGun()
      {
         super();
         var _loc1_:Bitmap = new SingleGunBitmap();
         _loc1_.rotation = 90;
         addChild(_loc1_);
      }
   }
}

