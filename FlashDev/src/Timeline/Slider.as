//Draggable slider class
//Refined from code at http://zanuzawa.blogspot.com/2012/01/slider-bar-with-actionscript-3.html
package Timeline {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Slider extends Sprite {
		
		private var SliderTrack:Class;
		private var SliderDragger:Class;
		public var sliderValue:Number = 0; // Default sliderValue
		private var sliderTrack:Sprite = new Sprite();
		private var sliderDragger:Sprite = new Sprite();
		private var bounds:Rectangle = new Rectangle();
		
		public function Slider(initialValue:Number) {
			
			sliderValue = initialValue;
			
			sliderTrack.x = 0;
			sliderTrack.y = 0;
			sliderTrack.graphics.lineStyle(1, 0x000000,1);
			sliderTrack.graphics.beginFill(0xFFFFFF,1);
			sliderTrack.graphics.drawRect(0, 0, 150, 20);
			sliderTrack.graphics.endFill();

			sliderDragger.x = (sliderTrack.width - 15) * (sliderValue / 10);
			sliderDragger.y = 0;
			sliderDragger.graphics.lineStyle(1, 0x000000,1);
			sliderDragger.graphics.beginFill(0xFFFFFF,1);
			sliderDragger.graphics.drawRect(0, -15, 15, 50);
			sliderDragger.graphics.endFill();
			sliderDragger.buttonMode = true;
			addChild(sliderTrack);
			addChild(sliderDragger);

			bounds = new Rectangle(sliderTrack.x,sliderTrack.y,sliderTrack.width - sliderDragger.width,0);
			sliderDragger.addEventListener(MouseEvent.MOUSE_DOWN, SliderDown);
			sliderDragger.addEventListener(MouseEvent.MOUSE_UP, SliderUp);
			
		}

		public function SliderUp(e:MouseEvent):void {
			sliderDragger.stopDrag();
			sliderDragger.removeEventListener(Event.ENTER_FRAME, Dragger);
		}

		protected function SliderDown(e:MouseEvent):void {
			sliderDragger.startDrag(false, bounds);
			sliderDragger.addEventListener(Event.ENTER_FRAME, Dragger);
		}

		protected function Dragger(e:Event):void {
			sliderValue = int(sliderDragger.x * 10 / (sliderTrack.width - sliderDragger.width)); // Normalized to range 0-10
			Main(root).timeline.TargetZoom = sliderValue;
		}
	}
}