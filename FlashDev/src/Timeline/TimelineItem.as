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
		public var type:String; //type of event it is (political, war, etc.) for icons and sorting purposes
		public var victor:String;
		
		private var shouldBeVisible:Boolean = true;
		public function set ShouldBeVisible(value:Boolean):void 
		{
			if (value) {
				alpha = Math.max(0.015625, alpha);
			}
			shouldBeVisible = value;
		}
		
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
		public var uStrength:String;
		public var cStrength:String;
		public var uCasualties:String;
		public var cCasualties:String;
		
		public var backgroundCircle:Shape;
		//public var bitImage:Bitmap;
		
		public var hoverBoxContainer:Sprite;
		
		public function TimelineItem()
		{
		}
		
		public function setUp(iconArray:Vector.<Bitmap>):void {
			while (numChildren > 0) { removeChildAt(0); }
			
			backgroundCircle = new Shape();
			backgroundCircle.graphics.lineStyle(2, 0x777777, 1);
			
			//the transparancy of the circles 0-1
			var visiblity = 0.7;
			
			if(type == "Battle")
			{
				var magnitude:int = importance * 5 + 7;
				
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
				
				backgroundCircle.graphics.drawCircle(0,0,magnitude);
				/*
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
				*/
			}
			else if (type == "Political")
			{
				backgroundCircle.graphics.beginFill(0xFFCC11,visiblity);				
				backgroundCircle.graphics.drawCircle(0,0,20);
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
				backgroundCircle.graphics.beginFill(0x55FF22,visiblity);
				backgroundCircle.graphics.drawCircle(0,0,20);
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
				backgroundCircle.graphics.beginFill(0x5522FF,visiblity);
				backgroundCircle.graphics.drawCircle(0,0,20);
				
				/*
				bitImage = new Bitmap((iconArray[4]).bitmapData.clone());
				bitImage.scaleX = 1;
				bitImage.scaleY = 1;
				bitImage.x = -bitImage.width / 2;
				bitImage.y = -bitImage.height / 2;
				*/
			}
			backgroundCircle.graphics.endFill();
			addChild(backgroundCircle);
			//addChild(bitImage);
			
			hoverBoxContainer = new Sprite();
			
			var hoverBox:Shape = new Shape();
			hoverBox.graphics.lineStyle(2, 0x777777, 1);
			hoverBox.graphics.beginFill(0xFFFFFF, 0.7);
			hoverBox.graphics.drawRect( -50, 20, 100, 100);
			hoverBox.visible = false;
			hoverBoxContainer.addChild(hoverBox);
			
			var hoverText:TextField = new TextField();
			hoverText.text = month.toString() + "/" + day.toString() + "/" + year.toString() + "\n" + title + "\n" + shortDes;
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
		}
	
		private function onFrame(e:Event):void {
			if (shouldBeVisible) {
				visible = true;
				alpha = Math.min(1, alpha * Math.SQRT2);
			}
			else
			{
				if (visible) {
					alpha /= Math.SQRT2;
					if (alpha < .0001) visible = false;
				}
			}
		}
	}
}