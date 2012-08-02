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
		private var viewWidth:int;
		private var viewHeight:int;
		
		private var ticks:Array;
		private var items:Array;
		private var line:Shape;
		private var fill:Shape;
		private var totalwidth:Number;
		public function get TotalWidth():Number { return totalwidth; }
		
		public function TimelineField(view:Timeline.View, width:int, height:int, items:Vector.<Timeline.TimelineItem>, icons:Vector.<Bitmap>) 
		{
			viewWidth = width;
			viewHeight = height;
			ticks = new Array();
			this.items = new Array();
			
			//TODO fix this hardcoding
			//hardcoded stuff follows
			
			totalwidth = viewWidth * 100 / view.width;
			
			
			fill = new Shape();
			fill.graphics.beginFill(0xDCDCDC, 1);
			fill.graphics.drawRect(0, 0, totalwidth, viewHeight);
			addChild(fill);
			
			line = new Shape();
			line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0x002772,0.5);
			line.graphics.drawRect(0, viewHeight - 4, totalwidth, 8);
			line.graphics.endFill();
			addChild(line);
			
			for (var i:int = 0; i <= 100; i++)
			{
				var tick:TimelineTick = new Timeline.TimelineTick(viewHeight, (i + 1800).toString());
				tick.y = viewHeight;
				tick.x = totalwidth / 100 * i;// 
				ticks.push(tick);
				addChild(tick);
			}
			
			
			this.x = - totalwidth * view.center + viewWidth / 2;
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
				this.items.push(items[j]);
			}
		}
		
		public function update(view:Timeline.View):void {
			
			totalwidth = viewWidth * 100 / view.width;
			
			line.graphics.clear();
			line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0x002772,0.5);
			line.graphics.drawRect(0, viewHeight - 4, totalwidth, 8);
			line.graphics.endFill();
			
			fill.graphics.clear();
			fill.graphics.beginFill(0xDCDCDC, 1);
			fill.graphics.drawRect(0, 0, totalwidth, viewHeight);
			fill.graphics.endFill();
			
			
			for (var i:int = 0; i <= 100; i++)
			{
				ticks[i].x = totalwidth / 100 * i;
			}
			
			for ( var j:int = 0; j < items.length; j++)
			{
				items[j].x = totalwidth - (1900 - items[j].year) * totalwidth / 100 - (12 - items[j].month) * totalwidth / 1200;
			}
			
			this.x = - totalwidth * view.center + viewWidth / 2;
		}
	}

}