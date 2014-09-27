package Timeline 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * A type representing the Timeline itself as a user interface element.
	 * @author Robert Cigna
	 */
	public class Timeline extends MovieClip
	{
		//{ region Constants
		
		/**
		 * Essentially, the rate at which the scrolling momentum decays. Larger ratios mean slower / larger scrolling animations.
		 */
		public static const SCROLL_RATE:Number = .8;
		/**
		 * Essentially, the rate at which the zooming momentum decays. Larger ratios mean slower animations.
		 */
		public static const ZOOM_RATE:Number = .6;
        /**
         * Controls when the app stops attempting to adjust the current zoom to match the desired.
         */
		public static const ZOOM_TOLERANCE:Number = .001;
		/**
		 * Controls when the app stops attempting to adjust the current center to match the desired.
		 */
		public static const SCROLL_TOLERANCE:Number = 1;
		
		/**
		 * The ratio between two levels of zoom. Clicking the zoom buttons changes the zoom by one level. 
		 * Double clicking the field changes the zoom by two levels.
		 */
		public static const ZOOM_STEP:Number = Math.SQRT2;
		
		/**
		 * The maximum size of the view, in years.
		 */
		public static const MAX_ZOOM:Number = 100;
		/**
		 * //The minimum size of the view, in years.
		 */
		public static const MIN_ZOOM:Number = .5;            
		
		//} endregion
		
		//{ region View Members
		
		private var center:Number;   //The current center of focus, in absolute years.
		private var zoom:Number;     //The current zoom, in years.
		private var fieldWidth:Number; //Cache the width of the field object
		
		public var descriptionBox:MovieClip;
		public var exitBtn:MovieClip;
		
		/**
		 * Gets the current center of focus, in abolute years.
		 */
		public function get Center():Number { return center; } 
		/**
		 * Gets the current zoom, in years.
		 */
		public function get Zoom():Number { return zoom; }
		
		/**
		 * Sets the current center of focus. Automatically clamps to a valid range and updates the display to reflect new position.
		 */
		public function set Center(value:Number):void {
			value = Math.max(Math.min(endDate - zoom / 2, value), startDate + zoom / 2);
			center = value;
			field.x = - (center - startDate) * field.TotalWidth / (endDate - startDate) + fieldWidth/2;
		}
		/**
		 * Sets the current level of zoom. Automatically triggers a redraw of the onscreen elements to reflect the new zoom.
		 */
		public function set Zoom(value:Number):void {
			zoom = value;
			field.update(center, zoom, startDate, endDate, targetZoom);
		}
		
		private var startDate:Number; //The earliest visible date. This should allow some padding around the earliest event.
		private var endDate:Number;   //The latest visible date. This should allow some padding around the latest event.
		
		/**
		 * Gets the start date of the timeline, in years.
		 */
		public function get StartDate():Number { return startDate; }
		/**
		 * Gets the end date of the timeline, in years.
		 */
		public function get EndDate():Number { return endDate; }
		
		private var targetCenter:Number; //The center of focus the app is moving towards, in absolute years.
		private var targetZoom:Number;   //The zoom level the app is changing to, in years.
		
		/**
		 * Gets the desired center of focus, in absolute years.
		 */
		public function get TargetCenter():Number { return targetCenter; }
		/**
		 * Gets the desired zoom level, in years.
		 */
		public function get TargetZoom():Number { return targetZoom; } 
		
		/**
		 * Sets the desired center of focus, in absolute years. Automatically clamps to valid range.
		 */
		public function set TargetCenter(value:Number):void {
			targetCenter = Math.max(Math.min(endDate - targetZoom / 2, value), startDate + targetZoom / 2);
		}
		/**
		 * Sets the desired zoom level, in years. Automatically clamps to valid range.
		 */
		public function set TargetZoom(value:Number):void {
			targetZoom = Math.max(Math.min(MAX_ZOOM, value), MIN_ZOOM);
			targetCenter = Math.max(Math.min(endDate - targetZoom / 2, targetCenter), startDate + targetZoom / 2);
		}
		
		private var isDragging:Boolean = false; //A flag signalling when the user is dragging the timeline.
		private var lastmouseX:Number;          //A cache of the last mouseX, used to find mouse deltas.
		//} endregion
		
		//{ region UI Elements
		
		private var leftArrow:Sprite;    //A temporary arrow icon on the left side of the timeline for fast scrolling.
		private var rightArrow:Sprite;   //A temporary arrow icon on the right side of the timeline for fast scrolling.
		
		private var field:TimelineField; //The entire timeline.
		private var fieldView:Sprite;    //A mask that ensures only the right portion of the timeline is visible.
		private var fieldHitArea:Sprite; //A sprite used to define the hit area of the timeline.
		
		/**
		 * Gets a reference to the TimelineField.
		 */
		public function get Field():Timeline.TimelineField { return field; }
		
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
		public function Timeline(x:int, y:int, width:int, height:int, items:Vector.<Timeline.TimelineItem>, icons:Vector.<Bitmap>) {
			
			this.x = x;
			this.y = y;
			
			targetCenter = 1863;
			center = 1863;
			targetZoom = 7;
			zoom = 20;
			startDate = 1800;
			endDate = 1900;
			
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
			leftArrow.graphics.beginFill(0x444444, 1);
			leftArrow.graphics.drawTriangles(Vector.<Number>([-20, 0, 0, -10, 0, 10]));
			leftArrow.graphics.endFill();
			leftArrow.x = 0;
			leftArrow.y = height;
			leftArrow.addEventListener(MouseEvent.CLICK, flipLeft);
			addChild(leftArrow);
			
			rightArrow = new Sprite();
			rightArrow.graphics.beginFill(0x444444, 1);
			rightArrow.graphics.drawTriangles(Vector.<Number>([0, -10, 20, 0, 0, 10]));
			rightArrow.graphics.endFill();
			rightArrow.x = width;
			rightArrow.y = height;
			rightArrow.addEventListener(MouseEvent.CLICK, flipRight);
			addChild(rightArrow);
			
			addEventListener(Event.ADDED_TO_STAGE, setListeners);
		}
		
		/**
		 * Sets the appropriate listeners for the Timeline to function
		 * @param	e The ADDED_TO_STAGE event
		 */
		private function setListeners(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, setListeners);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, endDrag);
			field.addEventListener(MouseEvent.MOUSE_DOWN, beginDrag);
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
			field.doubleClickEnabled = true;
			field.addEventListener(MouseEvent.DOUBLE_CLICK, quickZoom);
		}
		
		/**
		 * An event listener for ENTER_FRAME that performs zooming and scrolling animation.
		 * @param	e The ENTER_FRAME event.
		 */
		private function onFrame(e:Event):void {
			e.stopPropagation();
			//Zooming -- basically, this code takes the ratio of desired to current zoom and moves it towards 1, or equal.
			var curMouseX = mouseX;
			if(Zoom != targetZoom) {
				var ratio:Number = 1 - zoom / targetZoom;
				if (Math.abs(ratio) < ZOOM_TOLERANCE) {
					zoom = targetZoom;
				}
				else {
					Zoom = (1 - ratio * ZOOM_RATE) * targetZoom;
				}		
			}
			fieldWidth = fieldView.width;
			//Scrolling -- basically, this code takes the difference of desired and current center and moves it toward 0, or equal.

			if (isDragging) {
				if(lastmouseX != curMouseX) {
					jumpCenter(center - (curMouseX - lastmouseX) * zoom / fieldWidth);
				}
			}
			else {
				var difference:Number = targetCenter - center;
				if (Math.abs(difference * fieldWidth / zoom) < SCROLL_TOLERANCE) {
					center = targetCenter;
				}
				else {
					Center = targetCenter - difference * SCROLL_RATE;
				}
			}
			lastmouseX = curMouseX;
		}
		
		/**
		 * An event listener for MOUSE_DOWN.
		 * @param	e The MOUSE_DOWN event.
		 */
		private function beginDrag(e:MouseEvent):void {
			e.stopPropagation();
			isDragging = true;
			stage.addEventListener(MouseEvent.MOUSE_OVER,suppressBubbling,true,9999,true);
			stage.addEventListener(MouseEvent.MOUSE_OUT,suppressBubbling,true,9999,true);
		}

		//Prevent events from bubbling while dragging
		//Improves performance, especially when dragging rapidly
		function suppressBubbling(e:MouseEvent):void {
			e.stopPropagation();
		}
		
		/**
		 * An event listener for MOUSE_UP. Must be added to the stage to catch all mouse up events.
		 * @param	e The MOUSE_UP event.
		 */
		private function endDrag(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_OVER,suppressBubbling,true);
			stage.removeEventListener(MouseEvent.MOUSE_OUT,suppressBubbling,true);
			if(isDragging) {
				isDragging = false;
				TargetCenter = Center - (mouseX - lastmouseX) / (1 - SCROLL_RATE) * zoom / fieldView.width;
			}
		}
		
		/**
		 * Begins an animated zoom. Decreases the number of years visible on screen by one level.
		 * @param	e
		 */
		public function zoomIn(e:Event = null):void {
			TargetZoom = targetZoom / ZOOM_STEP;
		}
		/**
		 * Begins an animated zoom. Increases the number of years visible on screen by one level.
		 * @param	e
		 */
		public function zoomOut(e:Event = null):void {
			TargetZoom = targetZoom * ZOOM_STEP;
		}
		
		/**
		 * Begins an animated zoom and recenter. Zooms in by two levels and puts the click location in the center of the timeline.
		 * @param	e
		 */
		public function quickZoom(e:MouseEvent):void {
			TargetZoom = TargetZoom / ZOOM_STEP / ZOOM_STEP;
			TargetCenter = center + (e.stageX - x - fieldWidth / 2) / fieldWidth * zoom;
		}
		
		/**
		 * Begins an animated scroll to the left by one whole screen width.
		 * @param	e
		 */
		public function flipLeft(e:Event = null):void {
			TargetCenter = targetCenter - zoom;
		}
		
		/**
		 * Begins an animated scroll to the right by one whole screen width.
		 * @param	e
		 */
		public function flipRight(e:Event = null):void {
			TargetCenter = targetCenter + zoom;
		}
		
		/**
		 * Forces the center of focus to immediately jump to the given location.
		 * @param	value The value to assign, in absolute years.
		 */
		public function jumpCenter(value:Number):void {
			TargetCenter = value;
			Center = value;
		}
		
		/**
		 * Forces the zoom to immediately jump to the given amount.
		 * @param	value The value to assign, in years per screen.
		 */
		public function jumpZoom(value:Number):void {
			TargetZoom = value;
			Zoom = value;
		}
		
		
	}

}