package Timeline 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * A type representing the Timeline itself as a user interface element.
	 * @author Robert Cigna
	 */
	public class Timeline extends MovieClip
	{
		public static const MAX_WIDTH:Number = 100;  //The maximum width of the view in years. Ideally, this should be set to the actual width of the entire timeline, but should never be more.
		public static const MIN_WIDTH:Number = .5;   //The minimum width of the view in years.
		
		public static const SCROLL_DECAY_FRAC:Number = .8;
		public static const ZOOM_DECAY_FRAC:Number = .6;
		
		public var view:Timeline.View;
		
		private var viewWidth:Number;
		private var viewHeight:Number;
		
		private var leftArrow:Sprite;
		private var rightArrow:Sprite;
		
		private var field:TimelineField;
		private var fieldMask:Sprite;
		private var fieldHitArea:Sprite;
		
		private var isDragging:Boolean = false;
		private var lastmouseX:Number;
		private var momentum:Number = 0;
		
		public var descriptionBox:MovieClip;
		public var exitBtn:MovieClip;
		
		//private var isZooming:Boolean = false;
		public var zoomMomentum:Number = 0;
		
		public function Timeline(x:int, y:int, width:int, height:int, items:Vector.<Timeline.TimelineItem>, icons:Vector.<Bitmap>) 
		{
			view = new Timeline.View();
			viewWidth = width;
			
			field = new TimelineField(view, width, height, items, icons);
			addChild(field);
			
			fieldMask = new Sprite();
			fieldMask.graphics.beginFill(0);
			fieldMask.graphics.drawRect(0, 0, width, height + 50);
			fieldMask.graphics.endFill();
			fieldMask.cacheAsBitmap = true;
			fieldMask.visible = false; //I think setting this sprite as a mask automatically sets this property, but just to be safe.
			addChild(fieldMask); //I think doing this means the mask will move with the Timeline object. Don't know for sure though.
			field.mask = fieldMask;
			
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
			leftArrow.addEventListener(MouseEvent.CLICK, function (e:Event):void {
				momentum = 100;
			});
			addChild(leftArrow);
			
			rightArrow = new Sprite();
			rightArrow.graphics.beginFill(0);
			rightArrow.graphics.drawTriangles(Vector.<Number>([0, -10, 20, 0, 0, 10]));
			rightArrow.graphics.endFill();
			rightArrow.x = width;
			rightArrow.y = height;
			rightArrow.addEventListener(MouseEvent.CLICK, function (e:Event):void {
				momentum = -100;
			});
			addChild(rightArrow);
			
			this.x = x;
			this.y = y;
			
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
			//Calculate left/right movement first
			if (isDragging) {
				field.x += mouseX - lastmouseX;
			}
			else {
				field.x += momentum;
				momentum *= SCROLL_DECAY_FRAC;
				if (Math.abs(momentum) < 1) {
					momentum = 0;
				}
			}
			field.x = field.x > 0 ? 0 : field.x;
			field.x = field.x < viewWidth - field.TotalWidth ? viewWidth - field.TotalWidth : field.x;
			view.center = -(field.x - viewWidth / 2) / field.TotalWidth;
			
			//Then zoom
			//TODO decide if zoom momentum is worth it
			//*
			view.width *= (1 + zoomMomentum);
			
			//Clamp to acceptable limits
			view.width = MAX_WIDTH < view.width ? MAX_WIDTH : view.width;
			view.width = MIN_WIDTH > view.width ? MIN_WIDTH : view.width;
			
			field.update(view);
			zoomMomentum *= ZOOM_DECAY_FRAC;
			if (Math.abs(zoomMomentum) < .001) {
				zoomMomentum = 0;
			}
			//*/
			
			field.x = field.x > 0 ? 0 : field.x;
			field.x = field.x < viewWidth - field.TotalWidth ? viewWidth - field.TotalWidth : field.x;
			view.center = -(field.x - viewWidth / 2) / field.TotalWidth;
			lastmouseX = mouseX;
		}
		
		private function beginDrag(e:MouseEvent):void {
			isDragging = true;
			lastmouseX = mouseX;
		}
		
		private function endDrag(e:MouseEvent):void {
			isDragging = false;
			momentum = mouseX - lastmouseX;
		}
		
		public function quickZoom(e:MouseEvent):void {
			//Okay, so I did some maths, and then I tinkered, and now I don't now how, but this sorta works.
			
			//Add scroll momentum to recenter on the click location.
			momentum = (e.stageX - x - viewWidth / 2) * Math.log(SCROLL_DECAY_FRAC) / Math.pow(SCROLL_DECAY_FRAC, 2.47);
			
			//Add a large amount of zoom momentum.
			zoomMomentum = -.4;
		}
		
		public function changeView(view:Timeline.View):void {
			this.view = view;
			field.update(view);
		}
		
		public function showDesBox(item:TimelineItem):void
		{			
			var desShape:Shape = new Shape();
			desShape.graphics.lineStyle(1, 0x000000,1);
			desShape.graphics.beginFill(0xFFFFFF,1);
			desShape.graphics.drawRoundRect(0, 0, 650, 500, 50);
			desShape.graphics.endFill();
			
			var format1:TextFormat = new TextFormat();
			format1.size = 25;
			
			var titleText:TextField = new TextField();
			titleText.text = item.shortDes;
			titleText.x = 50;
			titleText.y = 50;
			titleText.width = 550;
			titleText.multiline = true;
			titleText.autoSize = "left";
			titleText.wordWrap = true;
			titleText.setTextFormat(format1);
			
			var dateText:TextField = new TextField();
			dateText.text = item.month + "/" + item.day + "/" + item.year;
			dateText.x = 50;
			dateText.y = 100;
			dateText.width = 550;
			dateText.autoSize = "left";
			dateText.setTextFormat(format1);
			
			var bodyText:TextField = new TextField();
			bodyText.text = item.fullDes;
			bodyText.x = 50;
			bodyText.y = 150;
			bodyText.width = 550;
			bodyText.multiline = true;
			bodyText.autoSize = "left";
			bodyText.wordWrap = true;
			bodyText.setTextFormat(format1);
			
			descriptionBox = new MovieClip();
			descriptionBox.x = 50;
			descriptionBox.y = 50;
			descriptionBox.addChild(desShape);
			descriptionBox.addChild(titleText);
			descriptionBox.addChild(dateText);
			descriptionBox.addChild(bodyText);
			this.parent.addChild(descriptionBox);
			
			var btnShape:Shape = new Shape();
			btnShape.graphics.lineStyle(1, 0x000000,1);
			btnShape.graphics.beginFill(0xFF4444,0.5);
			btnShape.graphics.drawRoundRect(0, 0, 30, 30, 10);
			btnShape.graphics.endFill();
			
			exitBtn = new MovieClip();
			exitBtn.x = 650;
			exitBtn.y = 70;
			exitBtn.addEventListener(MouseEvent.CLICK, hideDesBox);		
			exitBtn.addChild(btnShape);
			this.parent.addChild(exitBtn);
			
			this.parent.setChildIndex(descriptionBox, this.parent.numChildren-1);
			this.parent.setChildIndex(exitBtn, this.parent.numChildren-1);
		}
		
		public function hideDesBox(e:Event):void
		{
			this.parent.removeChild(descriptionBox);
			this.parent.removeChild(exitBtn);
		}
		
	}

}