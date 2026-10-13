package model
{
   import flash.display.Sprite;
   
   public class ShieldSprite extends Sprite
   {
      
      public function ShieldSprite()
      {
         super();
         this.graphics.lineStyle(4,29437,1);
         this.graphics.moveTo(50,0);
         this.graphics.curveTo(100,0,100,50);
         this.graphics.moveTo(50,0);
         this.graphics.curveTo(0,0,0,50);
         this.graphics.endFill();
      }
   }
}

