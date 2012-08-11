package Timeline 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * The View class is a collection of variables relating to how the timeline is currently presented.
	 * It communicates the center of focus, zoom level, and more.
	 * 
	 * @author Robert Cigna
	 */
	public class View extends Sprite
	{
		public var center:Number;      //The current focus of the timeline, measured as a fraction of the whole width.
		public var viewwidth:Number;       //The current zoom of the timeline, measured in years per screen width.
		
		//{ region Constants
		
		public static const SCROLL_CHANGE:String = "ScrollChange"; //An event that is fired when the center of view changes.
		public static const ZOOM_CHANGE:String = "ZoomChange";     //An event that is fired when the zoom level changes.
		
		public static const ZOOM_RATE:Number = .4;                 //The fraction that the difference in desired and actual zoom is reduced by each frame.
		public static const SCROLL_RATE:Number = .2;               //The fraction that the difference in desired and actual focus is reduced by each frame.
		
		public static const ZOOM_TOLERANCE:Number = .001;          //Controls when the app stops sending ZOOM_CHANGE events. Less is more (events).
		public static const SCROLL_TOLERANCE:Number = .2;          //Controls when the app stops sending SCROLL_CHANGE events. Less is more (events).
		
		public static const MIN_ZOOM:Number = 100;
		public static const MAX_ZOOM:Number = .5;
		
		//} endregion
		
		//{ region Properties
		
		private var focus:Number; 
		private var zoom:Number;  
		
		public function get Focus():Number { return focus; } //the center of focus in years
		public function get Zoom():Number { return zoom; } //the width in years
		
		public function set Focus(value:Number):void 
		{
			value = Math.max(Math.min(endDate - zoom / 2, value), startDate + zoom / 2);
			
			if (focus != value) { 
				dispatchEvent(new Event(SCROLL_CHANGE));
			}
			
			focus = value;
		}
		public function set Zoom(value:Number):void 
		{
			if (zoom != value) {
				dispatchEvent(new Event(ZOOM_CHANGE));
			}
			
			zoom = value;
		}
		
		private var startDate:Number; 
		private var endDate:Number; 
		
		public function get StartDate():Number { return startDate; }//the start date of the timeline in years
		public function get EndDate():Number { return endDate; }// the end date of the timeline in years
		
		private var targetCenter:Number; 
		private var targetZoom:Number;
		
		public function get TargetCenter():Number { return targetCenter; }
		public function get TargetZoom():Number { return targetZoom; }
		
		public function set TargetCenter(value:Number):void 
		{
			targetCenter = Math.max(Math.min(endDate - targetZoom / 2, value), startDate + targetZoom / 2);
		}
		public function set TargetZoom(value:Number):void 
		{
			targetZoom = Math.max(Math.min(MAX_ZOOM, value), MIN_ZOOM);
			targetCenter = Math.max(Math.min(endDate - targetZoom / 2, targetCenter), startDate + targetZoom / 2);
		}
		
		//} endregion
		
		public function View(width:Number, height:Number, startDate:Number = 1800, endDate:Number = 1900, center:Number = .625, zoom:Number = 5 ) 
		{
			this.center = center;
			this.viewwidth = zoom;
			
			targetCenter = 1862.5;
			focus = 1862.5;
			targetZoom = zoom;
			this.zoom = zoom;
			
			this.startDate = startDate;
			this.endDate = endDate;
			
			//Draw the shape of the view area. The View object can therefore be used as a mask and its size and position properties are meaningful.
			graphics.beginFill(0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			cacheAsBitmap = true;
			visible = false; 
			mouseEnabled = false;
			
			//Having change over time necessitates an enter frame listener.
			//addEventListener(Event.ENTER_FRAME, OnFrame);
		}
		
		public function OnFrame(e:Event):void {
			//Zooming
			var ratio:Number = 1 - targetZoom / zoom;
			if (Math.abs(ratio) < ZOOM_TOLERANCE) {
				zoom = targetZoom;
			}
			else {
				Zoom = (1 - ratio * (1 - ZOOM_RATE)) * this.Zoom;
			}
			
			//Scrolling
			var difference:Number = targetCenter - focus;
			if (Math.abs(difference) < SCROLL_TOLERANCE) {
				focus = targetCenter;
			}
			else {
				Focus = targetCenter - difference * (1 - SCROLL_RATE);
			}
		}
		
		public function jumpCenter(value:Number):void {
			TargetCenter = value;
			Focus = value;
		}
		
		public function jumpZoom(value:Number):void {
			TargetZoom = value;
			Zoom = value;
		}
	}

}