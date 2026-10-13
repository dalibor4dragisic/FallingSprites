package model
{
   import flash.display.Bitmap;
   
   public class TripleGun extends Gun
   {
      
      private static const TripleGunBitmap:Class = TripleGun_TripleGunBitmap;
      
      public function TripleGun()
      {
         super();
         var _loc1_:Bitmap = new TripleGunBitmap();
         _loc1_.rotation = 90;
         addChild(_loc1_);
      }
   }
}

