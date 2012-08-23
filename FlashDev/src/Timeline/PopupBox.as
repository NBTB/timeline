package Timeline 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.Event;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class PopupBox extends Sprite
	{
		
		public function PopupBox(x:int, y:int, width:int, height:int, item:Timeline.TimelineItem) 
		{
			this.x = x;
			this.y = y;
			
			var desShape:Shape = new Shape();
			desShape.graphics.lineStyle(1, 0x000000,1);
			desShape.graphics.beginFill(0xFFFFFF,1);
			desShape.graphics.drawRoundRect(0, 0, width, height, 50);
			desShape.graphics.endFill();
			
			var format1:TextFormat = new TextFormat();
			format1.size = 25;
			
			var titleText:TextField = new TextField();
			titleText.text = item.shortDes;
			titleText.x = 50;
			titleText.y = 50;
			titleText.width = width - 100;
			titleText.multiline = true;
			titleText.autoSize = "left";
			titleText.wordWrap = true;
			titleText.setTextFormat(format1);
			
			var dateText:TextField = new TextField();
			dateText.text = item.month + "/" + item.day + "/" + item.year;
			dateText.x = 50;
			dateText.y = 100;
			dateText.width = width - 100;
			dateText.autoSize = "left";
			dateText.setTextFormat(format1);
			
			var bodyText:TextField = new TextField();
			bodyText.text = item.fullDes;
			bodyText.x = 50;
			bodyText.y = 150;
			bodyText.width = width - 100;
			bodyText.multiline = true;
			bodyText.autoSize = "left";
			bodyText.wordWrap = true;
			bodyText.setTextFormat(format1);
			
			addChild(desShape);
			addChild(titleText);
			addChild(dateText);
			addChild(bodyText);
			
			
			var btnShape:Sprite = new Sprite();
			btnShape.graphics.lineStyle(1, 0x000000,1);
			btnShape.graphics.beginFill(0xFF4444,0.5);
			btnShape.graphics.drawRoundRect(0, 0, 30, 30, 10);
			btnShape.graphics.endFill();
			btnShape.x = width - 50;
			btnShape.y = 30;
			
			btnShape.addEventListener(MouseEvent.CLICK, hide);		
			addChild(btnShape);
		}
		
		public function hide(e:Event):void {
			if (parent != null) parent.removeChild(this);
		}
	}

}