package model
{
   public class Rectangle extends GeometricShape
   {
      
      public function Rectangle(param1:Number, param2:Number, param3:Number, param4:uint, param5:uint, param6:Boolean, param7:Number)
      {
         super(param4,param5,param6,param7);
         super._parentWidth = param1;
         var _loc8_:Number = getRndNumber(0,param1 - param7);
         this.x = _loc8_;
         if(param6)
         {
            this.generateRectangle(param2,param3);
         }
      }
      
      private function generateRectangle(param1:Number, param2:Number) : void
      {
         this.graphics.lineStyle(1,16777215);
         this.graphics.beginFill(bodyColor,1);
         this.graphics.lineStyle(borderSize,borderColor);
         this.graphics.drawRect(0,0,param1,param2);
         this.graphics.endFill();
      }
   }
}

