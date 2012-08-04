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
		//{ region Constants
		
		public static const MONTH_TICK_THRESHOLD:Number = 1;         //The threshold at which the monthly tick marks begin to fade in years-of-view-width.
		public static const MONTH_TICK_FADE_RATE:Number = 1;         //The rate at which monthly ticks fade out, in alpha-per-year-of-view-width.
		
		public static const QUARTER_TICK_THRESHOLD:Number = 3;       //The threshold at which the quarterly tick marks begin to fade in years-of-view-width.
		public static const QUARTER_TICK_FADE_RATE:Number = .33;     //The rate at which quarterly ticks fade out, in alpha-per-year-of-view-width.
		
		public static const YEAR_TICK_THRESHOLD:Number = 15;         //The threshold at which the yearly tick marks begin to fade in years-of-view-width.
		public static const YEAR_TICK_FADE_RATE:Number = .1;         //The rate at which yearly ticks fade out, in alpha-per-year-of-view-width.
		
		public static const FIVE_TICK_THRESHOLD:Number = 50;         //The threshold at which the five-year tick marks begin to fade in years-of-view-width.
		public static const FIVE_TICK_FADE_RATE:Number = .02;        //The rate at which five-year ticks fade out, in alpha-per-year-of-view-width.
		
		public static const DECADE_TICK_THRESHOLD:Number = 150;      //The threshold at which the decade tick marks begin to fade in years-of-view-width.
		public static const DECADE_TICK_FADE_RATE:Number = .01;      //The rate at which decade ticks fade out, in alpha-per-year-of-view-width.
		
		//} endregion
		
		private var viewWidth:int;
		private var viewHeight:int;
		
		private var ticks:Array;
		private var monthlyTicks:Array;
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
			monthlyTicks = new Array();
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
			
			//set up ticks
			for (var i:int = 0; i <= 100; i++)
			{
				var tick:TimelineTick = new Timeline.TimelineTick(viewHeight, (i + 1800).toString());
				tick.y = viewHeight;
				tick.x = totalwidth / 100 * i;// 
				ticks.push(tick);
				tick.doubleClickEnabled = true;
				addChild(tick);
				
				//TODO ticks for individual months in a year
				var jan:TimelineTick = new Timeline.TimelineTick(viewHeight, "January");
				jan.y = viewHeight;
				jan.x = totalwidth / 100 * (i + 0 / 12);
				monthlyTicks.push(jan);
				jan.doubleClickEnabled = true;
				addChild(jan);
				
				var feb:TimelineTick = new Timeline.TimelineTick(viewHeight, "February");
				feb.y = viewHeight;
				feb.x = totalwidth / 100 * (i + 1 / 12);
				monthlyTicks.push(feb);
				feb.doubleClickEnabled = true;
				addChild(feb);
				
				var mar:TimelineTick = new Timeline.TimelineTick(viewHeight, "March");
				mar.y = viewHeight;
				mar.x = totalwidth / 100 * (i + 2 / 12);
				monthlyTicks.push(mar);
				mar.doubleClickEnabled = true;
				addChild(mar);
				
				var apr:TimelineTick = new Timeline.TimelineTick(viewHeight, "April");
				apr.y = viewHeight;
				apr.x = totalwidth / 100 * (i + 3 / 12);
				monthlyTicks.push(apr);
				apr.doubleClickEnabled = true;
				addChild(apr);
				
				var may:TimelineTick = new Timeline.TimelineTick(viewHeight, "May");
				may.y = viewHeight;
				may.x = totalwidth / 100 * (i + 4 / 12);
				monthlyTicks.push(may);
				may.doubleClickEnabled = true;
				addChild(may);
				
				var jun:TimelineTick = new Timeline.TimelineTick(viewHeight, "June");
				jun.y = viewHeight;
				jun.x = totalwidth / 100 * (i + 5 / 12);
				monthlyTicks.push(jun);
				jun.doubleClickEnabled = true;
				addChild(jun);
				
				var jul:TimelineTick = new Timeline.TimelineTick(viewHeight, "July");
				jul.y = viewHeight;
				jul.x = totalwidth / 100 * (i + 6 / 12);
				monthlyTicks.push(jul);
				jul.doubleClickEnabled = true;
				addChild(jul);
				
				var aug:TimelineTick = new Timeline.TimelineTick(viewHeight, "August");
				aug.y = viewHeight;
				aug.x = totalwidth / 100 * (i + 7 / 12);
				monthlyTicks.push(aug);
				aug.doubleClickEnabled = true;
				addChild(aug);
				
				var sep:TimelineTick = new Timeline.TimelineTick(viewHeight, "September");
				sep.y = viewHeight;
				sep.x = totalwidth / 100 * (i + 8 / 12);
				monthlyTicks.push(sep);
				sep.doubleClickEnabled = true;
				addChild(sep);
				
				var oct:TimelineTick = new Timeline.TimelineTick(viewHeight, "October");
				oct.y = viewHeight;
				oct.x = totalwidth / 100 * (i + 9 / 12);
				monthlyTicks.push(oct);
				oct.doubleClickEnabled = true;
				addChild(oct);
				
				var nov:TimelineTick = new Timeline.TimelineTick(viewHeight, "November");
				nov.y = viewHeight;
				nov.x = totalwidth / 100 * (i + 10 / 12);
				monthlyTicks.push(nov);
				nov.doubleClickEnabled = true;
				addChild(nov);
				
				var dec:TimelineTick = new Timeline.TimelineTick(viewHeight, "December");
				dec.y = viewHeight;
				dec.x = totalwidth / 100 * (i + 11 / 12);
				monthlyTicks.push(dec);
				dec.doubleClickEnabled = true;
				addChild(dec);
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
				items[j].doubleClickEnabled = true;
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
			
			//TODO actively fading ticks to control density on screen
			var monthA:Number = 1 - MONTH_TICK_FADE_RATE * (view.width - MONTH_TICK_THRESHOLD);
			var quarterA:Number = 1 - QUARTER_TICK_FADE_RATE * (view.width - QUARTER_TICK_THRESHOLD);
			var yearA:Number = 1 - YEAR_TICK_FADE_RATE * (view.width - YEAR_TICK_THRESHOLD);
			var fiveA:Number = 1 - FIVE_TICK_FADE_RATE * (view.width - FIVE_TICK_THRESHOLD);
			var decadeA:Number = 1 - DECADE_TICK_FADE_RATE * (view.width - DECADE_TICK_THRESHOLD);
			
			for (var i:int = 0; i <= 100; i++)
			{
				//If this is a decade
				if (i % 10 == 0) {
					ticks[i].x = totalwidth / 100 * i;
					ticks[i].alpha = decadeA;
					if (decadeA < 0) {
						ticks[i].visible = false;
					}
					else {
						ticks[i].visible = true;
					}
				}
				//Else if this is a fifth year
				else if (i % 5 == 0) {
					ticks[i].x = totalwidth / 100 * i;
					ticks[i].alpha = fiveA;
					if (fiveA < 0) {
						ticks[i].visible = false;
					}
					else {
						ticks[i].visible = true;
					}
				}
				//Otherwise this is just a normal year
				else {
					ticks[i].x = totalwidth / 100 * i;
					ticks[i].alpha = yearA;
					if (yearA < 0) {
						ticks[i].visible = false;
					}
					else {
						ticks[i].visible = true;
					}
				}
			}
			
			for (var k:int = 0; k < monthlyTicks.length; k++) 
			{
				//If this is a quarter
				if (k % 3 == 0) {
					monthlyTicks[k].x = totalwidth / 1200 * k;
					monthlyTicks[k].alpha = quarterA;
					if (quarterA < 0) {
						monthlyTicks[k].visible = false;
					}
					else {
						monthlyTicks[k].visible = true;
					}
				}
				//Otherwise just a month
				else {
					monthlyTicks[k].x = totalwidth / 1200 * k;
					monthlyTicks[k].alpha = monthA;
					if (monthA < 0) {
						monthlyTicks[k].visible = false;
					}
					else {
						monthlyTicks[k].visible = true;
					}
				}
			}
			
			for ( var j:int = 0; j < items.length; j++)
			{
				items[j].x = totalwidth - (1900 - items[j].year) * totalwidth / 100 - (12 - items[j].month) * totalwidth / 1200;
			}
			
			this.x = - totalwidth * view.center + viewWidth / 2;
		}
	}

}