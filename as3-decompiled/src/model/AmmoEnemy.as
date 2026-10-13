package model
{
   import flash.display.Sprite;
   
   public class AmmoEnemy extends Sprite
   {
      
      public function AmmoEnemy()
      {
         super();
         this.cacheAsBitmap = true;
         this.graphics.beginFill(16695279,1);
         this.graphics.drawRect(0,0,4,10);
         this.graphics.endFill();
      }
   }
}

