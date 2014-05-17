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
		
		public var desiredHeight:Number = 150;
		
		//date values
		public var year:int;
		public var month:int;
		public var day:int;
		
		public var title:String;
		public var shortDes:String;
		public var fullDes:String;
		
		//artist name
		public var artist:String;
		//image filename (.png)
		public var imageLoc:String;
		
		//Battle Stuff
		public var importance:int;
		public var radius:int = 15;
		public var uStrength:String;
		public var cStrength:String;
		public var uCasualties:String;
		public var cCasualties:String;
		public var backgroundCircle:Sprite;
		public var popup:PopupBox;
		public function TimelineItem() {
			
		}
		
		public function setUp(iconArray:Vector.<Bitmap>):void {
			while (numChildren > 0) { removeChildAt(0); }
			
			backgroundCircle = new Sprite();
			backgroundCircle.graphics.lineStyle(1, 0x555555, 1);
			
			//the transparancy of the circles 0-1
			var visiblity = 1;
			if(type == "Battle")
			{
				var magnitude:int = importance * 5;
				//radius = magnitude;
				/*
				if(victor == "Union")
				{
					backgroundCircle.graphics.beginFill(0x002772,visiblity);
					//bitImage = new Bitmap((iconArray[1]).bitmapData.clone());
				}
				else if(victor == "Confederate")
				{
					backgroundCircle.graphics.beginFill(0x777777,visiblity);
					//bitImage = new Bitmap((iconArray[2]).bitmapData.clone());
				}
				else
				{
					backgroundCircle.graphics.beginFill(0x722700,visiblity);
					//bitImage = new Bitmap((iconArray[3]).bitmapData.clone());
				}
				*/
				backgroundCircle.graphics.beginFill(0xa66249,visiblity);
				backgroundCircle.graphics.drawRect( 0, 0, 185, 30);
				/*
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
				*/
			}
			else if (type == "Political")
			{
				backgroundCircle.graphics.beginFill(0x4971a6,visiblity);				
				backgroundCircle.graphics.drawRect( 0, 0, 185, 30);
				/*
				bitImage = new Bitmap((iconArray[0]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 3;
				bitImage.y = -bitImage.height / 3 * 2;
				*/
			}
			else if (type == "Artist")
			{
				backgroundCircle.graphics.beginFill(0x8e8b32,visiblity);
				importance = 5;
				backgroundCircle.graphics.drawRect(0, 0, 185, 30);
				/*
				bitImage = new Bitmap((iconArray[4]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
				*/
			}
			else //Painting
			{
				backgroundCircle.graphics.beginFill(0x5f7936,visiblity);
				backgroundCircle.graphics.drawRect(0,0, 185, 30);
				
				/*
				bitImage = new Bitmap((iconArray[4]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
				*/
			}
			backgroundCircle.graphics.endFill();
			backgroundCircle.buttonMode = true;
			backgroundCircle.mouseEnabled = true;
			backgroundCircle.useHandCursor = true;
			addChild(backgroundCircle);

			var hoverText:TextField = new TextField();
			var itemTextFormat = Main.serif_tf;
			hoverText.text = title.length > 25 ? title.substring(0, 25) + "..." : title;
			itemTextFormat.size = 12;
			itemTextFormat.color = 0xbbbbbb;
			hoverText.setTextFormat(itemTextFormat);
			hoverText.x = 10;
			hoverText.y = 3;
			hoverText.width = 200;
			hoverText.height = 25;
			hoverText.mouseEnabled = false;
			backgroundCircle.addChild(hoverText);
			addEventListener(Event.ENTER_FRAME, onFrame);
			
			popup = new Timeline.PopupBox(0, 0, 850, 380, this);
		}
	
		private function onFrame(e:Event):void {
			//Fading
			if (!isFiltered && !isVanished) {
				visible = true;
				alpha = Math.min(1, alpha * ALPHA_STEP);
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