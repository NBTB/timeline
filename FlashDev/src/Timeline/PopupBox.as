package Timeline 
{
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
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
			var isArt:Boolean = false;
			
			if (item.type === "Art") {
				isArt = true;
			}
			
			var popupTextFormat:TextFormat = Main.serif_tf;
			
			var titleText:TextField = new TextField();
			titleText.text = item.title;
			titleText.x = 25;
			titleText.y = 5;
			titleText.width = width - 100;
			titleText.multiline = true;
			titleText.autoSize = "left";
			titleText.wordWrap = true;
			if (titleText.text.length >= 35) {
				popupTextFormat.size = 30;
			}
			else {
				popupTextFormat.size = 40;
			}
			popupTextFormat.color = 0x594d3a;
			titleText.setTextFormat(popupTextFormat);
			
			var dateText:TextField = new TextField();
			dateText.text = item.month + "/" + item.day + "/" + item.year;
			dateText.x = 25;
			dateText.y = titleText.y + titleText.height - 5;
			dateText.width = width - 100;
			dateText.autoSize = "left";
			dateText.setTextFormat(Main.subtle_tf);
			
			var bodyText:TextField = new TextField();
			bodyText.text = item.fullDes;
			bodyText.x = 25;
			bodyText.y = dateText.y + dateText.height + 15;
			bodyText.width = width - 100;
			bodyText.multiline = true;
			bodyText.autoSize = "left";
			bodyText.wordWrap = true;
			popupTextFormat.size = 16;
			popupTextFormat.color = 0x8c795b;
			bodyText.setTextFormat(popupTextFormat);

			addChild(titleText);
			addChild(dateText);
			addChild(bodyText);
			
			if (isArt) {
				
				var thumbSize:Number = 220;
				var loader:Loader = new Loader();
				var location:String = "data/pictures/" + item.imageLoc + ".png";
				var picContainer:Sprite = new Sprite();
				var linkText:TextField = new TextField();

				bodyText.x = 450;

				picContainer.x = 500;
				picContainer.y = 30;
				picContainer.buttonMode = true;
				picContainer.useHandCursor = true;
				addChild(picContainer);

				titleText.width = 400;
				dateText.y = titleText.y + titleText.height;
				bodyText.visible = false;

				linkText.text = "Enlarge in a new tab";
				linkText.x = picContainer.x;
				linkText.y = picContainer.y + thumbSize + 5;
				linkText.width = 400;
				linkText.multiline = true;
				linkText.autoSize = "left";
				linkText.wordWrap = true;
				popupTextFormat.size = 16;
				popupTextFormat.color = 0x5f8aa9;
				linkText.setTextFormat(popupTextFormat);
				linkText.selectable = false;
				linkText.mouseEnabled = false;
				
				//AS3 doesn't support using the hand cursor on a textfield...brilliant
				//We overlay an invisible sprite on top of the textfield to get around this
				var linkBtn:Sprite = new Sprite();
				linkBtn.x = linkText.x;
				linkBtn.y = linkText.y;
				linkBtn.graphics.beginFill(0x000000, 0);
				linkBtn.graphics.drawRect(0 - 20, 0, linkText.width, linkText.height);
				linkBtn.graphics.endFill();
				linkBtn.buttonMode = true;
				linkBtn.useHandCursor = true;
				
				addChild(linkBtn);
				addChild(linkText);
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					var shape:Shape = new Shape();
					var g:Graphics = shape.graphics;
					var scaleWidth:Number = thumbSize / loader.width;
					var scaleHeight:Number = thumbSize / loader.height;
					if (scaleWidth > scaleHeight) {
						loader.scaleX = loader.scaleY = scaleWidth;
					}
					else {
						loader.scaleX = loader.scaleY = scaleHeight;
					}
					g.beginFill(0x00FF00);
					g.drawRect(0, 0, thumbSize, thumbSize);
					g.endFill();
					loader.mask = shape;
					picContainer.addChild(loader);
					picContainer.addChild(shape);
				});
				
				loader.load(new URLRequest(location));
				
				linkBtn.addEventListener(MouseEvent.CLICK, openLink(location));
				picContainer.addEventListener(MouseEvent.CLICK, openLink(location));
			}

		}
		
		//Uber-sweet generator pattern lets us pass variables to event handlers
		public function openLink(location:String):Function {
			return function(e:Event):void { 
				var request:URLRequest = new URLRequest(location);
				navigateToURL(request, "_blank");
			}
		}
		
		public function hide(e:Event):void {
			if (parent != null) parent.removeChild(this);
		}
	}

}