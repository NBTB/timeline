package Timeline 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * A graphic representation of the entire timeline all at once.
	 * The intended use is to have one inside a Timeline object which in turn masks the TimelineField,
	 * scrolling handled by simply moving the field left or right, changes in zoom handled by shifting elements around in the field.
	 * @author Robert Cigna
	 */
	public class TimelineField extends MovieClip
	{
		private var ticks:Array;
		
		public function TimelineField(view:Timeline.View, width:int, height:int, items:Vector.<Timeline.TimelineItem>, icons:Vector.<Bitmap>) 
		{
			ticks = new Array();
			
			//TODO fix this hardcoding
			//hardcoded stuff follows
			
			var totalwidth:Number = width * 100 / view.width;
			
			var line:Shape;
			line = new Shape();
			line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0x002772,0.5);
			line.graphics.drawRect(0, height - 4, totalwidth, 8);
			line.graphics.endFill();
			addChild(line);
			
			for (var i:int = 0; i <= 100; i++)
			{
				var tick:TimelineTick = new Timeline.TimelineTick(height, (i + 1800).toString());
				tick.y = height;
				tick.x = totalwidth / 100 * i;// 
				addChild(tick);
			}
			
			graphics.beginFill(0xDCDCDC, 1);
			graphics.drawRect(0, 0, totalwidth, height);
			
			this.x = - totalwidth * view.center + width / 2;
			//this.cacheAsBitmap = true;
			
			for ( var j:int = 0; j < items.length; j++)
			{
				items[j].setUp(icons);
				items[j].x = totalwidth - (1900 - items[j].year) * totalwidth / 100 - (12 - items[j].month) * totalwidth / 1200;
				if(items[j].type == "Political") {
					items[j].y = 80;
				}
				else if(items[j].type == "Battle") {
					items[j].y = 160;
				}
				else if(items[j].type == "Artist") {
					items[j].y = 240;
				}
				addChild(items[j]);
			}
		}
		
	}

}