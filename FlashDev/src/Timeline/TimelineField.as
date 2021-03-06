package Timeline 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
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
		public static const MONTH_TICK_FADE_RATE:Number = 1;         //The rate at which monthly ticks fade out, in alpha-per-year-of-view-width. (The reciprocal is the number of years-of-view-width until fully transparent).
		
		public static const QUARTER_TICK_THRESHOLD:Number = 3;       //The threshold at which the quarterly tick marks begin to fade in years-of-view-width.
		public static const QUARTER_TICK_FADE_RATE:Number =.333;     //The rate at which quarterly ticks fade out, in alpha-per-year-of-view-width.
		
		public static const YEAR_TICK_THRESHOLD:Number = 15;         //The threshold at which the yearly tick marks begin to fade in years-of-view-width.
		public static const YEAR_TICK_FADE_RATE:Number = .1;         //The rate at which yearly ticks fade out, in alpha-per-year-of-view-width.
		
		public static const FIVE_TICK_THRESHOLD:Number = 50;         //The threshold at which the five-year tick marks begin to fade in years-of-view-width.
		public static const FIVE_TICK_FADE_RATE:Number = .02;        //The rate at which five-year ticks fade out, in alpha-per-year-of-view-width.
		
		public static const DECADE_TICK_THRESHOLD:Number = 150;      //The threshold at which the decade tick marks begin to fade in years-of-view-width.
		public static const DECADE_TICK_FADE_RATE:Number = .01;      //The rate at which decade ticks fade out, in alpha-per-year-of-view-width.
		
		public static const ITEM_THRESHOLD_RATE:Number = 10;          //The rate at which the threshold for items disappearing increases (linearly with importance).
		//} endregion
		
		private var viewWidth:int;
		private var viewHeight:int;
		
		private var ticks:Array;
		private var monthlyTicks:Array;
		private var yearAssuranceTicks:Array;
		public var items:Array;
		public var visiblePopups:Array;
		private var line:Shape;
		private var fill:Shape;
		private var totalwidth:Number;
		private var currentAlpha:Number;
		public function get TotalWidth():Number { return totalwidth; }
			
		public function TimelineField(width:int, height:int, items:Vector.<Timeline.TimelineItem>, center:Number, zoom:Number, start:Number, end:Number) 
		{
			viewWidth = width;
			viewHeight = height;
			ticks = new Array();
			monthlyTicks = new Array();
			yearAssuranceTicks = new Array();
			this.items = new Array();
			visiblePopups = new Array();
			currentAlpha = 1;
			
			//TODO fix this hardcoding (mostly overall length of timeline)
			//hardcoded stuff follows
			
			totalwidth = viewWidth * (end-start) / zoom;
			
			line = new Shape();
			//line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0xa9997f,1);
			line.graphics.drawRect(0, viewHeight - 4, totalwidth, 8);
			line.graphics.endFill();
			addChild(line);
			
			//TODO tick labels
			
			//set up ticks
			var years:Number = end - start;
			var yearRepeat:TimelineTick;
			for (var i:int = 0; i <= years; i++)
			{
				var curYear:String = (i + 1801).toString();
				var tick:TimelineTick = new Timeline.TimelineTick(viewHeight, curYear, 20);
				tick.y = viewHeight;
				tick.x = totalwidth / years * i;// 
				ticks.push(tick);
				tick.mouseEnabled = false;
				addChild(tick);
				
				//TODO ticks for individual months in a year
				var jan:TimelineTick = new Timeline.TimelineTick(viewHeight, "January");
				jan.y = viewHeight;
				jan.x = totalwidth / years * (i + 0 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(jan);
				jan.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(jan);
				
				var feb:TimelineTick = new Timeline.TimelineTick(viewHeight, "February");
				feb.y = viewHeight;
				feb.x = totalwidth / years * (i + 1 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(feb);
				feb.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(feb);
				
				var mar:TimelineTick = new Timeline.TimelineTick(viewHeight, "March");
				mar.y = viewHeight;
				mar.x = totalwidth / years * (i + 2 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(mar);
				mar.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(mar);
				
				var apr:TimelineTick = new Timeline.TimelineTick(viewHeight, "April");
				apr.y = viewHeight;
				apr.x = totalwidth / years * (i + 3 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(apr);
				apr.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(apr);
				
				var may:TimelineTick = new Timeline.TimelineTick(viewHeight, "May");
				may.y = viewHeight;
				may.x = totalwidth / years * (i + 4 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(may);
				may.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(may);
				
				var jun:TimelineTick = new Timeline.TimelineTick(viewHeight, "June");
				jun.y = viewHeight;
				jun.x = totalwidth / years * (i + 5 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(jun);
				jun.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(jun);
				
				var jul:TimelineTick = new Timeline.TimelineTick(viewHeight, "July");
				jul.y = viewHeight;
				jul.x = totalwidth / years * (i + 6 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(jul);
				jul.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(jul);
				
				var aug:TimelineTick = new Timeline.TimelineTick(viewHeight, "August");
				aug.y = viewHeight;
				aug.x = totalwidth / years * (i + 7 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(aug);
				aug.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(aug);
				
				var sep:TimelineTick = new Timeline.TimelineTick(viewHeight, "September");
				sep.y = viewHeight;
				sep.x = totalwidth / years * (i + 8 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(sep);
				sep.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(sep);
				
				var oct:TimelineTick = new Timeline.TimelineTick(viewHeight, "October");
				oct.y = viewHeight;
				oct.x = totalwidth / years * (i + 9 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(oct);
				oct.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(oct);
				
				var nov:TimelineTick = new Timeline.TimelineTick(viewHeight, "November");
				nov.y = viewHeight;
				nov.x = totalwidth / years * (i + 10 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(nov);
				nov.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(nov);
				
				var dec:TimelineTick = new Timeline.TimelineTick(viewHeight, "December");
				dec.y = viewHeight;
				dec.x = totalwidth / years * (i + 11 / 12);
				yearRepeat = new Timeline.TimelineTick(viewHeight, curYear, 295, false, true);
				yearAssuranceTicks.push(yearRepeat);
				monthlyTicks.push(dec);
				dec.mouseEnabled = false;
				yearRepeat.mouseEnabled = false;
				yearRepeat.cacheAsBitmap = true;
				addChild(yearRepeat);
				addChild(dec);
			}
			
			this.x = - totalwidth * center + viewWidth / 2;
			
			for ( var j:int = 0; j < items.length; j++)
			{
				items[j].x = totalwidth - (end - items[j].year) * totalwidth / years - (12 - items[j].month) * totalwidth / (12 * years)- (30 - items[j].day) * totalwidth / (years * 12 * 30);
				if(items[j].type == "Political") {
					items[j].y = 60+ (j % 5) * 13;
				}
				else if(items[j].type == "Battle") {
					items[j].y = 160 +(j % 5) * 13;
				}
				else if(items[j].type == "Artist") {
					items[j].y = 260 +(j % 5) * 13;
				}
				else if(items[j].type == "Art") {
					items[j].y = 360 +(j % 5) * 13;
				}
				items[j].doubleClickEnabled = true;
				items[j].cacheAsBitmap = true;
				addChild(items[j]);
				this.items.push(items[j]);
				items[j].addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
				items[j].addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
				items[j].addEventListener(MouseEvent.CLICK, showPopup);
			}
			
			update(center, zoom, start, end, zoom);
		}
		
		private function mouseOver(e:Event):void {
			e.stopPropagation();
			currentAlpha = e.currentTarget.labelBackground.alpha;
			this.setChildIndex(Sprite(e.currentTarget), (this.numChildren-1));
			if(!e.currentTarget.isSelected) {
				Sprite(e.currentTarget.labelBackground).transform.colorTransform = new ColorTransform(1, 1, 1, 1, 15, 15, 15);
			}
			//show index in array
			//trace("Index: " + items.indexOf(e.currentTarget) + " desiredHeight: " + e.currentTarget.desiredHeight);
		}
		
		private function mouseOut(e:Event):void {
			e.stopPropagation();
			if(!e.currentTarget.isSelected) {
				Sprite(e.currentTarget.labelBackground).transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0);
			}
		}
		
		private function showPopup(e:Event):void {
			currentAlpha = e.currentTarget.labelBackground.alpha;

			if (visiblePopups.length > 0) {
				for each (var p:Timeline.PopupBox in visiblePopups) {
					p.hide(e);
					visiblePopups.pop();
				}			

			}
			for each (var item:Timeline.TimelineItem in items) {
				if (item === e.currentTarget) {
					item.isSelected = true;
					Sprite(item.labelBackground).transform.colorTransform = new ColorTransform(1, 1, 1, 1, -45, -45, -45);
				}
				else {
					item.isSelected = false;
					Sprite(item.labelBackground).transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0);
				}
			}

			var popup:Timeline.PopupBox = e.currentTarget.popup;
			popup.x = 450;
			popup.y = 20;
			parent.parent.addChild(popup);
			visiblePopups.push(popup);
		}
		
		public function update(center:Number, zoom:Number, start:Number, end:Number, targetzoom:Number):void {
			
			totalwidth = viewWidth * (end - start) / zoom;
			
			line.graphics.clear();
			//line.graphics.lineStyle(1, 0x000000,1);
			line.graphics.beginFill(0xa9997f,1);
			line.graphics.drawRect(0, viewHeight - 7, totalwidth, 14);
			line.graphics.endFill();
			
			var monthA:Number = 1 - MONTH_TICK_FADE_RATE * (zoom - MONTH_TICK_THRESHOLD);
			monthA = monthA > 1 ? 1 : monthA;
			var quarterA:Number = 1 - QUARTER_TICK_FADE_RATE * (zoom - QUARTER_TICK_THRESHOLD);
			quarterA = quarterA > 1 ? 1 : quarterA;
			var yearA:Number = 1 - YEAR_TICK_FADE_RATE * (zoom - YEAR_TICK_THRESHOLD);
			yearA = yearA > 1 ? 1 : yearA;
			var fiveA:Number = 1 - FIVE_TICK_FADE_RATE * (zoom - FIVE_TICK_THRESHOLD);
			fiveA = fiveA > 1 ? 1 : fiveA;
			var decadeA:Number = 1 - DECADE_TICK_FADE_RATE * (zoom - DECADE_TICK_THRESHOLD);
			decadeA = decadeA > 1 ? 1 : decadeA;
			
			for (var i:int = 0; i <= 100; i++)
			{
				//If this is a decade
				if (i % 10 == 0) {
					ticks[i].x = totalwidth / (end-start) * i;
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
					ticks[i].x = totalwidth / (end-start) * i;
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
					ticks[i].x = totalwidth / (end-start) * i;
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
					monthlyTicks[k].x = totalwidth / (12*(end-start)) * k;
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
					monthlyTicks[k].x = totalwidth / (12*(end-start)) * k;
					monthlyTicks[k].alpha = monthA;
					if (monthA < 0) {
						monthlyTicks[k].visible = false;
					}
					else {
						monthlyTicks[k].visible = true;
					}
				}
				yearAssuranceTicks[k].x = 1 == targetzoom ? monthlyTicks[k].x + 35 : monthlyTicks[k].x + 95;
				yearAssuranceTicks[k].alpha = monthA;
				if (monthA < 0) {
					yearAssuranceTicks[k].visible = false;
				}
				else {
					yearAssuranceTicks[k].visible = true;
				}
			}
			
			
			//Items
			for ( var j:int = 0; j < items.length; j++)
			{
				//Item fading by importance
				var itemA:Number = 1 - (targetzoom - ITEM_THRESHOLD_RATE * (items[j].importance+1));
				items[j].isVanished = itemA < 1;
				
				items[j].x = totalwidth - (end - items[j].year) * totalwidth / (end - start)
							- (12 - items[j].month) * totalwidth / (12 * (end - start)) 
							- (30 - items[j].day) * totalwidth / (12 * (end - start) * 30);
			}
			
			this.x = - totalwidth * (center - start) / (end - start) + viewWidth / 2;
			
			stagger(start, end, targetzoom);
		}
		
		/**
		 * A function that filters timeline items by matching to the given array.
		 * @param	types An array containing the String tags to match. If an item matches one of these tags, it is "turned on", otherwise it becomes invisible.
		 */
		public function filter(types:Array):void {
			for (var i:int = 0 ; i < items.length; i++ ) {
				items[i].isFiltered = true;
				for (var j:int = 0; j < types.length; j++) {
					if (items[i].type == types[j]) {
						items[i].isFiltered = false;
					}
				}
			}
		}
		
		/**
		 * A helper function that moves items around on the screen to stagger them and reduce collisions.
		 * It's not perfect, but more often than not, it's good enough.
		 */
		public function stagger(start:Number, end:Number, targetZoom:Number):void {
			var factor:Number = 0;
			for (var j:int = 0; j < items.length; j++) {
				items[j].desiredHeight = 0;
				if (items[j].type == "Political") items[j].desiredHeight = 100;
				if (items[j].type == "Art") items[j].desiredHeight = 225;
				items[j].desiredHeight += (factor * 25);
				//The following spreads the items out when zoomed in
				//But it doesn't work well enough
				/*
				if (targetZoom < 1) {
					items[j].desiredHeight *= (1 / targetZoom * 0.8);
				}
				*/
				factor++;
				if (factor > 3) {
					factor = 0;
				}
				if (items[j].type == "Artist") items[j].desiredHeight = 200; //Always put these at the same height
			}
		}
		
		public function clamp(val:Number, min:Number, max:Number):Number {
			return Math.max(min, Math.min(max, val))
		}
	}

}