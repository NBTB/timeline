package Timeline 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	
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
			//desShape.graphics.lineStyle(1, 0x000000,1);
			desShape.graphics.beginFill(0xFFFFFF,1);
			desShape.graphics.drawRect(0, 0, width, height);
			desShape.graphics.endFill();
			
			var popupTextFormat = Main.serif_tf;
			
			var titleText:TextField = new TextField();
			titleText.text = item.title;
			titleText.x = 25;
			titleText.y = 5;
			titleText.width = width - 100;
			titleText.multiline = true;
			titleText.autoSize = "left";
			titleText.wordWrap = true;
			if (titleText.text.length > 40) {
				popupTextFormat.size = 30;
			}
			else {
				popupTextFormat.size = 40;
			}
			popupTextFormat.color = 0x777777;
			titleText.setTextFormat(popupTextFormat);
			
			var dateText:TextField = new TextField();
			dateText.text = item.month + "/" + item.day + "/" + item.year;
			dateText.x = 25;
			dateText.y = titleText.y + titleText.height - 5;
			dateText.width = width - 100;
			dateText.autoSize = "left";
			popupTextFormat.size = 25;
			popupTextFormat.color = 0xbbbbbb;
			dateText.setTextFormat(popupTextFormat);
			
			var bodyText:TextField = new TextField();
			bodyText.text = item.fullDes;
			bodyText.x = 50;
			bodyText.y = dateText.y + dateText.height + 15;
			bodyText.width = width - 100;
			bodyText.multiline = true;
			bodyText.autoSize = "left";
			bodyText.wordWrap = true;
			popupTextFormat.size = 20;
			popupTextFormat.color = 0x777777;
			bodyText.setTextFormat(popupTextFormat);
			
			addChild(desShape);
			addChild(titleText);
			addChild(dateText);
			addChild(bodyText);
			
			//Use the letter X in a textfield as a button to close the popup
			var closeBtnText:TextField = new TextField();
			closeBtnText.text = "X";
			closeBtnText.selectable = false;
			closeBtnText.mouseEnabled = false;
			closeBtnText.x = width - 50;
			closeBtnText.y = 0;
			popupTextFormat.size = 40;
			popupTextFormat.color = 0xbbbbbb;
			closeBtnText.setTextFormat(popupTextFormat);
			
			//AS3 doesn't support using the hand cursor on a textfield...brilliant
			//We overlay an invisible sprite on top of the textfield to get around this
			var closeBtn = new Sprite();
			closeBtn.x = closeBtnText.x;
			closeBtn.y = closeBtnText.y;
			closeBtn.graphics.beginFill(0x000000, 0);
			closeBtn.graphics.drawRect(0 - 20, 0, closeBtnText.width - 30, closeBtnText.height - 30);
			closeBtn.graphics.endFill();
			closeBtn.buttonMode = true;
			closeBtn.useHandCursor = true;
			closeBtn.addEventListener(MouseEvent.MOUSE_OVER, function() {
				popupTextFormat.color = 0xc15c5c;
				closeBtnText.setTextFormat(popupTextFormat);
			});
			closeBtn.addEventListener(MouseEvent.MOUSE_OUT, function() {
				popupTextFormat.color = 0xbbbbbb;
				closeBtnText.setTextFormat(popupTextFormat);
			});
			closeBtn.addEventListener(MouseEvent.CLICK, hide);
			
			addChild(closeBtn);
			addChild(closeBtnText);
		}
		
		public function hide(e:Event):void {
			if (parent != null) parent.removeChild(this);
		}
	}

}