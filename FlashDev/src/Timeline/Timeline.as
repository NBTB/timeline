package Timeline 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * A type representing the Timeline itself as a user interface element.
	 * @author Robert Cigna
	 */
	public class Timeline extends MovieClip
	{
		//{ region Constants
		
		public static const SCROLL_RATE:Number = .8;         //Essentially, the rate at which the scrolling momentum decays. Larger ratios mean slower / larger scrolling animations.
		public static const ZOOM_RATE:Number = .6;           //Essentially, the rate at which the zooming momentum decays. Larger ratios mean slower animations.
		
		public static const ZOOM_TOLERANCE:Number = .001;    //Controls when the app stops attempting to adjust the current zoom to match the desired.
		public static const SCROLL_TOLERANCE:Number = 1;     //Controls when the app stops attempting to adjust the current center to match the desired.
		
		public static const MAX_ZOOM:Number = 100;           //The maximum size of the view, in years.
		public static const MIN_ZOOM:Number = .5;            //The minimum size of the view, in years.
		
		//} endregion
		
		//{ region View Members
		
		private var center:Number;   //The current center of focus, in absolute years.
		private var zoom:Number;     //The current zoom, in years.
		
		
		public function get Focus():Number { return center; } //Gets the current center of focus, in abolute years.
		public function get Zoom():Number { return zoom; }    //Gets the current zoom, in years.
		
		/**
		 * Sets the current center of focus. Automatically clamps to a valid range and updates the display to reflect new position.
		 */
		public function set Focus(value:Number):void {
			value = Math.max(Math.min(endDate - zoom / 2, value), startDate + zoom / 2);
			center = value;
			field.x = - (center - startDate) * field.TotalWidth / (endDate - startDate) + fieldView.width/2;
		}
		/**
		 * Sets the current level of zoom. Automatically triggers a redraw of the onscreen elements to reflect the new zoom.
		 */
		public function set Zoom(value:Number):void {
			zoom = value;
			field.update(center, zoom, startDate, endDate);
		}
		
		private var startDate:Number; //The earliest visible date. This should allow some padding around the earliest event.
		private var endDate:Number;   //The latest visible date. This should allow some padding around the latest event.
		
		public function get StartDate():Number { return startDate; } //Gets the start date of the timeline, in years.
		public function get EndDate():Number { return endDate; }     //Gets the end date of the timeline, in years.
		
		private var desiredCenter:Number; //The center of focus the app is moving towards, in absolute years.
		private var desiredZoom:Number;   //The zoom level the app is changing to, in years.
		
		public function get TargetCenter():Number { return desiredCenter; } //Gets the desired center of focus, in absolute years.
		public function get TargetZoom():Number { return desiredZoom; }     //Gets the desired zoom level, in years.
		
		//Sets the desired center of focus, in absolute years. Automatically clamps to valid range.
		public function set TargetCenter(value:Number):void {
			desiredCenter = Math.max(Math.min(endDate - desiredZoom / 2, value), startDate + desiredZoom / 2);
		}
		//Sets the desired zoom level, in years. Automatically clamps to valid range.
		public function set TargetZoom(value:Number):void {
			desiredZoom = Math.max(Math.min(MAX_ZOOM, value), MIN_ZOOM);
			desiredCenter = Math.max(Math.min(endDate - desiredZoom / 2, desiredCenter), startDate + desiredZoom / 2);
		}
		
		private var isDragging:Boolean = false; //A flag signalling when the user is dragging the timeline.
		private var lastmouseX:Number;          //A cache of the last mouseX, used to find mouse deltas.
		
		//public var view:Timeline.View;
		//private var momentum:Number = 0;
		//public var zoomMomentum:Number = 0;
		
		//} endregion
		
		//{ region UI Elements
		
		private var leftArrow:Sprite;    //A temporary arrow icon on the left side of the timeline for fast scrolling.
		private var rightArrow:Sprite;   //A temporary arrow icon on the right side of the timeline for fast scrolling.
		
		private var field:TimelineField; //The entire timeline.
		private var fieldView:Sprite;    //A mask that ensures only the right portion of the timeline is visible.
		private var fieldHitArea:Sprite; //A sprite used to define the hit area of the timeline.
		
		//} endregion
		
		/**
		 * Constructs a new Timeline object. 
		 * @param	x The x coordinate of the Timeline.
		 * @param	y The y coordinate of the Timeline.
		 * @param	width The width of the viewable area of the Timeline.
		 * @param	height The height of the viewable area of the Timeline.
		 * @param	items A Vector of TimelineItems, sorted by date.
		 * @param	icons A Vector of Bitmaps containing the icons the TimelineItems will use.
		 */
		public function Timeline(x:int, y:int, width:int, height:int, items:Vector.<Timeline.TimelineItem>, icons:Vector.<Bitmap>) 
		{
			this.x = x;
			this.y = y;
			
			desiredCenter = 1862.5;
			center = 1862.5;
			desiredZoom = 10;
			zoom = 10;
			startDate = 1800;
			endDate = 1900;
			
			//view = new Timeline.View(width,height+50);
			//addChild(view);
			
			field = new TimelineField(width, height, items, icons, center, zoom, startDate, endDate);
			addChild(field);
			
			fieldView = new Sprite();
			fieldView.graphics.beginFill(0);
			fieldView.graphics.drawRect(0, 0, width, height + 50);
			fieldView.graphics.endFill();
			fieldView.cacheAsBitmap = true;
			fieldView.visible = false; //I think setting this sprite as a mask automatically sets this property, but just to be safe.
			addChild(fieldView); //I think doing this means the mask will move with the Timeline object. Don't know for sure though.
			field.mask = fieldView;
			
			//Considering this is an identical shape, it might be possible to use one Sprite as both mask and hitArea... not sure about 
			//caching / mouse enabling, though.
			fieldHitArea = new Sprite();
			fieldHitArea.graphics.beginFill(0);
			fieldHitArea.graphics.drawRect(0, 0, width, height + 50);
			fieldHitArea.graphics.endFill();
			fieldHitArea.mouseEnabled = false;
			fieldHitArea.visible = false; //For hitAreas, this does have to be manually set, because...
			addChild(fieldHitArea); //The hit area has to be part of the display list! who knew!?
			field.hitArea = fieldHitArea;
			
			leftArrow = new Sprite();
			leftArrow.graphics.beginFill(0);
			leftArrow.graphics.drawTriangles(Vector.<Number>([-20, 0, 0, -10, 0, 10]));
			leftArrow.graphics.endFill();
			leftArrow.x = 0;
			leftArrow.y = height;
			leftArrow.addEventListener(MouseEvent.CLICK, flipLeft);
			addChild(leftArrow);
			
			rightArrow = new Sprite();
			rightArrow.graphics.beginFill(0);
			rightArrow.graphics.drawTriangles(Vector.<Number>([0, -10, 20, 0, 0, 10]));
			rightArrow.graphics.endFill();
			rightArrow.x = width;
			rightArrow.y = height;
			rightArrow.addEventListener(MouseEvent.CLICK, flipRight);
			addChild(rightArrow);
			
			addEventListener(Event.ADDED_TO_STAGE, setListeners);
		}
		
		private function setListeners(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, setListeners);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			field.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			field.addEventListener(Event.ENTER_FRAME, onFrame);
			field.doubleClickEnabled = true;
			field.addEventListener(MouseEvent.DOUBLE_CLICK, quickZoom);
		}
		
		private function onFrame(e:Event):void {
			//Zooming
			var ratio:Number = 1 - desiredZoom / zoom;
			if (Math.abs(ratio) < ZOOM_TOLERANCE) {
				zoom = desiredZoom;
			}
			else {
				Zoom = (1 - ratio * (1 - ZOOM_RATE)) * zoom;
			}
			
			//Scrolling
			if (isDragging) {
				jumpCenter(center - (mouseX - lastmouseX) * zoom / fieldView.width);
			}
			else {
				var difference:Number = desiredCenter - center;
				if (Math.abs(difference * fieldView.width / zoom) < SCROLL_TOLERANCE) {
					center = desiredCenter;
				}
				else {
					Focus = desiredCenter - difference * SCROLL_RATE;
				}
			}
			lastmouseX = mouseX;
			
			//Zooming
			/*
			//if (zoomMomentum != 0) {
				view.viewwidth *= (1 + zoomMomentum);
				
				//Clamp to acceptable limits
				view.viewwidth = MIN_ZOOM < view.viewwidth ? MIN_ZOOM : view.viewwidth;
				view.viewwidth = MAX_ZOOM > view.viewwidth ? MAX_ZOOM : view.viewwidth;
				
				field.update(view);
				zoomMomentum *= ZOOM_RATE;
				if (Math.abs(zoomMomentum) < .001) {
					zoomMomentum = 0;
				}
			//}
			//*/

			
			//Scrolling
			//if (isDragging) {
			//	field.x += mouseX - lastmouseX;
			//	
			//	//field.x = - (view.Focus - view.StartDate) * view.width / view.Zoom + view.width / 2;
			//	//((mouseX - lastmouseX) - view.width / 2)/view.width * view.Zoom
			//	//view.jumpCenter(view.Focus - (mouseX - lastmouseX) * view.Zoom / view.width);
			//}
			//else {
			//	field.x += momentum;
			//	momentum *= SCROLL_RATE;
			//	if (Math.abs(momentum) < 1) {
			//		momentum = 0;
			//	}
			//}
			
			//field.x = field.x > 0 ? 0 : field.x;
			//field.x = field.x < fieldView.width - field.TotalWidth ? fieldView.width - field.TotalWidth : field.x;
			//view.center = -(field.x - fieldView.width/ 2) / field.TotalWidth;
			//lastmouseX = mouseX;
		}
		
		private function beginDrag(e:MouseEvent):void {
			isDragging = true;
		}
		
		private function endDrag(e:MouseEvent):void {
			isDragging = false;
			TargetCenter = Focus - (mouseX - lastmouseX) / (1 - SCROLL_RATE) * zoom / fieldView.width;
			//momentum = mouseX - lastmouseX;
		}
		
		public function zoomIn(e:Event = null):void {
			TargetZoom = desiredZoom / Math.SQRT2;
		}
		
		public function zoomOut(e:Event = null):void {
			TargetZoom = desiredZoom * Math.SQRT2;
		}
		
		public function quickZoom(e:MouseEvent):void {
			//Okay, so I did some maths, and then I tinkered, and now I don't now how, but this sorta works.
			
			//Add scroll momentum to recenter on the click location.
			//momentum = (e.stageX - x - fieldView.width / 2) * Math.log(SCROLL_RATE) / Math.pow(SCROLL_RATE, 2.47);
			
			//Add a large amount of zoom momentum.
			//zoomMomentum = -.4;
			
			TargetZoom = TargetZoom / 2;
			TargetCenter = center + (e.stageX - x - fieldView.width / 2) / fieldView.width * zoom;
		}
		
		public function flipLeft(e:Event = null):void {
			TargetCenter = desiredCenter - zoom;
		}
		
		public function flipRight(e:Event = null):void {
			TargetCenter = desiredCenter + zoom;
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