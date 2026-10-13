package model
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ButtonSprite extends Sprite
   {
      
      private var textField:TextField = new TextField();
      
      private var textFormat:TextFormat = new TextFormat();
      
      public function ButtonSprite(param1:uint, param2:uint, param3:String)
      {
         super();
         this.buttonMode = true;
         this.textField.text = param3;
         this.textFormat.font = "Verdana";
         this.textFormat.bold = true;
         this.textFormat.size = 18;
         this.textFormat.color = param2;
         this.textField.autoSize = TextFieldAutoSize.LEFT;
         this.textField.setTextFormat(this.textFormat);
         this.textField.mouseEnabled = false;
         this.graphics.beginFill(param1);
         this.graphics.drawRect(0,0,this.textField.width,this.textField.height);
         addChild(this.textField);
      }
   }
}

