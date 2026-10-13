package model
{
   import interfaces.GeometricInterface;
   
   public class Ellipse extends GeometricShape implements GeometricInterface
   {
      
      public function Ellipse(param1:Number, param2:Number, param3:Number, param4:uint, param5:uint, param6:Boolean, param7:Number)
      {
         super(param4,param5,param6,param7);
         super._parentWidth = param1;
         var _loc8_:Number = getRndNumber(0,param1 - param7);
         this.x = _loc8_;
         if(param6)
         {
            this.generateEllipse(param2,param3);
         }
      }
      
      private function generateEllipse(param1:Number, param2:Number) : void
      {
         this.graphics.beginFill(bodyColor,1);
         this.graphics.lineStyle(borderSize,borderColor);
         this.graphics.drawEllipse(0,0,param1,param2);
         this.graphics.endFill();
      }
   }
}

