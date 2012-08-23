package Timeline
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	
	/**
	 * A TimelineItem is an interactive icon that appears on the timeline. 
	 */
	public class TimelineItem extends MovieClip
	{
		public static const MIN_ALPHA:Number = 0.015625;
		
		public static const ALPHA_STEP:Number = Math.SQRT2;
		
		public static const HEIGHT_TOLERANCE:Number = 1;
		public static const MOVE_RATE:Number = .8;
		
		
		public var type:String; //type of event it is (political, war, etc.) for icons and sorting purposes
		public var victor:String;
		
		public var isFiltered:Boolean = false;
		public var isVanished:Boolean = false;
		
		private var desiredHeight:Number = 200;
		public function set DesiredHeight(value:Number):void {
			desiredHeight = value;
		}
		public function get DesiredHeight():Number { return desiredHeight; }
		
		//date values
		public var year:int;
		public var month:int;
		public var day:int;
		
		public var shortDes:String;
		public var fullDes:String;
		
		public var importance:int;
		public var radius:int = 20;
		
		public var backgroundCircle:Shape;
		public var bitImage:Bitmap;
		
		public var hoverBoxContainer:Sprite;
		
		public var popup:PopupBox;
		
		public function TimelineItem() {
			
		}
		
		public function setUp(iconArray:Vector.<Bitmap>):void {
			while (numChildren > 0) { removeChildAt(0); }
			
			backgroundCircle = new Shape();
			backgroundCircle.graphics.lineStyle(2, 0x777777, 1);
			
			trace(importance);
			
			if(type == "Battle")
			{
				var magnitude:int = importance * 5 + 7;
				radius = magnitude;
				
				if(victor == "Union")
				{
					backgroundCircle.graphics.beginFill(0x002772,0.5);
					bitImage = new Bitmap((iconArray[1]).bitmapData.clone());
				}
				else if(victor == "Confederate")
				{
					backgroundCircle.graphics.beginFill(0x777777,0.5);
					bitImage = new Bitmap((iconArray[2]).bitmapData.clone());
				}
				else
				{
					backgroundCircle.graphics.beginFill(0x722700,0.5);
					bitImage = new Bitmap((iconArray[3]).bitmapData.clone());
				}
				
				//if(xPos - lastBattle < safeZone)
				//{
				//	if(byPos == by1) byPos = by2;
				//	else if(byPos == by2) byPos = by3;
				//	else byPos = by1;
				//}
				//else
				//{
				//	byPos = by1;
				//}
				
				//backgroundCircle.x = xPos;
				//backgroundCircle.y = byPos;
				backgroundCircle.graphics.drawCircle(0,0,magnitude);
				//lastBattle = xPos;
				
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
			}
			else if (type == "Artist")
			{
				//trace("artist");
				backgroundCircle.graphics.beginFill(0x55FF22,0.5);
				importance = 5;
				//if(xPos - lastArtist < safeZone)
				//{
				//	if(ayPos == ay1) ayPos = ay2;
				//	else ayPos = ay1;
				//}
				//else
				//{
				//	ayPos = ay1;
				//}
				//backgroundCircle.x = xPos;
				//backgroundCircle.y = ayPos;
				backgroundCircle.graphics.drawCircle(0,0,radius);
				//lastArtist = xPos;
				
				bitImage = new Bitmap((iconArray[4]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
			}
			else
			{
				backgroundCircle.graphics.beginFill(0xFFCC11,0.5);
				
				//if(xPos - lastPolitical < safeZone)
				//{
				//	if(pyPos == py1) pyPos = py2;
				//	else if(pyPos == py2) pyPos = py3;
				//	else pyPos = py1;
				//}
				//else
				//{
				//	pyPos = py1;
				//}
				//backgroundCircle.x = xPos;
				//backgroundCircle.y = pyPos;
				backgroundCircle.graphics.drawCircle(0,0,radius);
				//lastPolitical = xPos;
				
				bitImage = new Bitmap((iconArray[0]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 3;
				bitImage.y = -bitImage.height / 3 * 2;
			}
			backgroundCircle.graphics.endFill();
			addChild(backgroundCircle);
			addChild(bitImage);
			
			hoverBoxContainer = new Sprite();
			
			var hoverBox:Shape = new Shape();
			hoverBox.graphics.lineStyle(2, 0x777777, 1);
			hoverBox.graphics.beginFill(0xFFFFFF, 0.7);
			hoverBox.graphics.drawRect( -50, 20, 100, 100);
			hoverBox.visible = false;
			hoverBoxContainer.addChild(hoverBox);
			
			var hoverText:TextField = new TextField();
			hoverText.text = month.toString() + "/" + day.toString() + "/" + year.toString() + "\n" + shortDes;
			hoverText.x = -50;
			hoverText.y = 20;
			hoverText.width = 100;
			hoverText.multiline = true;
			hoverText.autoSize = "left";
			hoverText.wordWrap = true;
			hoverText.border = true;
			hoverText.background = true;
			
			hoverBoxContainer.addChild(hoverText);
			hoverBoxContainer.visible = false;
			addChild(hoverBoxContainer);
			
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			popup = new Timeline.PopupBox(207, 50, 850, 500, this);
		}
	
		private function onFrame(e:Event):void {
			//Fading
			if (!isFiltered && !isVanished) {
				//if (desiredAlpha > 0) {
					visible = true;
					alpha = Math.min(1, alpha * ALPHA_STEP);
				//}
				//else {
				//}
			}
			else
			{
				if (visible) {
					alpha /= ALPHA_STEP;
					if (alpha < MIN_ALPHA) {
						visible = false;
						alpha = MIN_ALPHA;
					}
				}
			}
			
			//Position
			var difference:Number = desiredHeight - y;
			if (Math.abs(difference) < HEIGHT_TOLERANCE) {
				y = desiredHeight;
			}
			else {
				y = desiredHeight - difference * MOVE_RATE;
			}
		}
		
		public function jumpHeight(value:Number):void {
			y = value;
			desiredHeight = value;
		}
		
		public static function sortItems(a:Timeline.TimelineItem, b:Timeline.TimelineItem):int {
			if (a.year != b.year) {
				return a.year > b.year ? 1 : -1;
			}
			if (a.month != b.month) {
				return a.month > b.month ? 1 : -1;
			}
			if (a.day != b.day) {
				return a.day > b.day ? 1: -1;
			}
			return 0;
		}
	}
}