package Timeline 
{
	import flash.display.MovieClip;
	/**
	 * A graphic representation of the entire timeline all at once.
	 * The intended use is to have one inside a Timeline object which in turn masks the TimelineField,
	 * changes in zoom handled by shifting elements around in the field.
	 * @author Robert Cigna
	 */
	public class TimelineField extends MovieClip
	{
		private var ticks:Array;
		
		public function TimelineField(view:Timeline.View, width:int, height:int) 
		{
			ticks = new Array();
			
			//TODO fix this hardcoding
			//hardcoded stuff follows
			
			var totalwidth:Number = width * 100 / view.width;
			
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
		}
		
	}

}