package model
{
   public class AmmoBigLaser extends Ammo
   {
      
      public function AmmoBigLaser()
      {
         super();
         this.graphics.beginFill(13669116,1);
         this.graphics.drawRect(0,0,20,40);
         this.graphics.endFill();
         this.cacheAsBitmap = true;
      }
   }
}

