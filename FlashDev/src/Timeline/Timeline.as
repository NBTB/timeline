package Timeline 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.AccelerometerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * A type representing the Timeline as a user interface element.
	 * @author Robert Cigna
	 */
	public class Timeline extends MovieClip
	{
		public var view:Timeline.View;
		
		private var leftArrow:Sprite;
		private var rightArrow:Sprite;
		
		private var field:TimelineField;
		private var fieldMask:Sprite;
		private var fieldHitArea:Sprite;
		
		private var isDragging:Boolean = false;
		private var lastmouseX:Number;
		
		public function Timeline(x:int, y:int, width:int, height:int) 
		{
			view = new Timeline.View();
			
			field = new TimelineField(view, width, height);
			addChild(field);
			
			fieldMask = new Sprite();
			fieldMask.x = x;
			fieldMask.y = y;
			fieldMask.graphics.beginFill(0);
			fieldMask.graphics.drawRect(0, 0, width, height + 50);
			fieldMask.graphics.endFill();
			fieldMask.cacheAsBitmap = true;
			field.mask = fieldMask;
			
			fieldHitArea = new Sprite();
			fieldHitArea.x = x;
			fieldHitArea.y = y;
			fieldHitArea.graphics.beginFill(0);
			fieldHitArea.graphics.drawRect(0, 0, width, height + 50);
			fieldHitArea.graphics.endFill();
			fieldHitArea.mouseEnabled = false;
			fieldHitArea.visible = false;
			addChild(fieldHitArea);
			field.hitArea = fieldHitArea;
			
			leftArrow = new Sprite();
			leftArrow.graphics.beginFill(0);
			leftArrow.graphics.drawTriangles(Vector.<Number>([-20, 0, 0, -10, 0, 10]));
			leftArrow.graphics.endFill();
			leftArrow.x = 0;
			leftArrow.y = height;
			addChild(leftArrow);
			
			rightArrow = new Sprite();
			rightArrow.graphics.beginFill(0);
			rightArrow.graphics.drawTriangles(Vector.<Number>([0, -10, 20, 0, 0, 10]));
			rightArrow.graphics.endFill();
			rightArrow.x = width;
			rightArrow.y = height;
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
		}
		
		private function onFrame(e:Event):void {
			if (isDragging) {
				field.x += mouseX - lastmouseX;
				lastmouseX = mouseX;
			}
		}
		
		private function beginDrag(e:MouseEvent):void {
				isDragging = true;
				lastmouseX = mouseX;
		}
		
		private function endDrag(e:MouseEvent):void {
			isDragging = false;
		}
	}

}