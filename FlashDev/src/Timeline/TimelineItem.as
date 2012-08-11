package Timeline
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * A TimelineItem is an interactive icon that appears on the timeline. 
	 */
	public class TimelineItem extends MovieClip
	{
		public var type:String; //type of event it is (political, war, etc.) for icons and sorting purposes
		public var victor:String;
		
		//date values
		public var year:int;
		public var month:int;
		public var day:int;
		
		public var shortDes:String;
		public var fullDes:String;
		
		public var importance:int;
		
		public function TimelineItem()
		{
		}
		
		public function setUp(iconArray:Vector.<Bitmap>):void {
			while (numChildren > 0) { removeChildAt(0); }
			
			var circle:Shape;
			circle = new Shape();
			circle.graphics.lineStyle(2, 0x777777, 1);
			var bit:Bitmap;
			
			trace(importance);
			
			if(type == "Battle")
			{
				var magnitude:int = importance * 5 + 7;
				
				if(victor == "Union")
				{
					circle.graphics.beginFill(0x002772,0.5);
					bit = new Bitmap((iconArray[1]).bitmapData.clone());
				}
				else if(victor == "Confederate")
				{
					circle.graphics.beginFill(0x777777,0.5);
					bit = new Bitmap((iconArray[2]).bitmapData.clone());
				}
				else
				{
					circle.graphics.beginFill(0x722700,0.5);
					bit = new Bitmap((iconArray[3]).bitmapData.clone());
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
				
				//circle.x = xPos;
				//circle.y = byPos;
				circle.graphics.drawCircle(0,0,magnitude);
				//lastBattle = xPos;
				
				bit.scaleX = 0.01*(magnitude/2);
				bit.scaleY = 0.01*(magnitude/2);
				bit.x = -bit.width / 2;
				bit.y = -bit.height / 2;
			}
			else if (type == "Artist")
			{
				//trace("artist");
				circle.graphics.beginFill(0x55FF22,0.5);
				
				//if(xPos - lastArtist < safeZone)
				//{
				//	if(ayPos == ay1) ayPos = ay2;
				//	else ayPos = ay1;
				//}
				//else
				//{
				//	ayPos = ay1;
				//}
				//circle.x = xPos;
				//circle.y = ayPos;
				circle.graphics.drawCircle(0,0,20);
				//lastArtist = xPos;
				
				bit = new Bitmap((iconArray[4]).bitmapData.clone());
				bit.scaleX = 0.15;
				bit.scaleY = 0.15;
				bit.x = -bit.width / 2;
				bit.y = -bit.height / 2;
			}
			else
			{
				circle.graphics.beginFill(0xFFCC11,0.5);
				
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
				//circle.x = xPos;
				//circle.y = pyPos;
				circle.graphics.drawCircle(0,0,20);
				//lastPolitical = xPos;
				
				bit = new Bitmap((iconArray[0]).bitmapData.clone());
				bit.scaleX = 0.15;
				bit.scaleY = 0.15;
				bit.x = -bit.width / 3;
				bit.y = -bit.height / 3 * 2;
			}
			circle.graphics.endFill();
			addChild(circle);
			addChild(bit);
		}
		
		//on hover
		
		//on click
	}
}