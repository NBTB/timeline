package Timeline
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * A TimelineItem is an interactive icon that appears on the timeline.
	 */
	public class TimelineItem extends MovieClip {

		public static const MIN_ALPHA:Number = 0.015625;

		public static const ALPHA_STEP:Number = Math.SQRT2;

		public static const HEIGHT_TOLERANCE:Number = 1;
		public static const MOVE_RATE:Number = .8;


		public var type:String; //type of event it is (political, war, etc.) for icons and sorting purposes
		public var victor:String;

		public var isFiltered:Boolean = false;
		public var isVanished:Boolean = false;
		public var isSelected:Boolean = false;

		public var desiredHeight:Number = 150;

		//date values
		public var year:int;
		public var month:int;
		public var day:int;

		public var title:String;
		public var url:String; //"Art" objects contain a URL to corresponding webpage to open on the MAG site
		public var description:String;

		//artist name
		public var artist:String;
		//image filename (.png)
		public var imageLoc:String;

		//Battle Stuff
		public var importance:int;
		public var radius:int = 15;
		public var uStrength:String;
		public var cStrength:String;
		public var uCasualties:String;
		public var cCasualties:String;
		public var labelBackground:Sprite;
		public var dot:Sprite;
		public var popup:PopupBox;
		public function TimelineItem() {

		}

		public function setUp():void {
			while (numChildren > 0) { removeChildAt(0); }

			labelBackground = new Sprite();
			dot = new Sprite();
			dot.graphics.lineStyle(1, 0x1a1b1f, 1);
			labelBackground.graphics.lineStyle(1, 0x1a1b1f, 1);

			//the transparancy of the circles 0-1
			var visiblity:Number = 1;
			if(type == "Battle") {
				var magnitude:int = importance * 5;
				labelBackground.graphics.beginFill(0xa66249,visiblity);
				labelBackground.graphics.drawRect(0, 0, 185, 30);
			}
			else if (type == "Political") {
				labelBackground.graphics.beginFill(0x4971a6,visiblity);
				labelBackground.graphics.drawRect(0, 0, 185, 30);
			}
			else if (type == "Artist") {
				labelBackground.graphics.beginFill(0x8e8b32,visiblity);
				importance = 5;
				labelBackground.graphics.drawRect(0, 0, 185, 30);
			}
			else { //Painting
				labelBackground.graphics.beginFill(0x5f7936,visiblity);
				labelBackground.graphics.drawRect(0,0, 185, 30);
			}

			labelBackground.graphics.endFill();
			labelBackground.buttonMode = true;
			labelBackground.mouseEnabled = true;
			labelBackground.useHandCursor = true;
			dot.graphics.beginFill(0x1a1b1f, 1);
			dot.graphics.drawCircle(0,labelBackground.height,5);
			dot.graphics.endFill();
			addChild(labelBackground);
			addChild(dot);


			var hoverText:TextField = new TextField();
			var itemTextFormat:TextFormat = Main.serif_tf;
			hoverText.text = title.length > 25 ? title.substring(0, 25) + "..." : title;
			itemTextFormat.size = 12;
			itemTextFormat.color = 0xe5e5e5;
			hoverText.setTextFormat(itemTextFormat);
			hoverText.x = 10;
			hoverText.y = 3;
			hoverText.width = 200;
			hoverText.height = 25;
			hoverText.mouseEnabled = false;
			labelBackground.addChild(hoverText);
			addEventListener(Event.ENTER_FRAME, onFrame);

			popup = new Timeline.PopupBox(0, 0, 800, 500, this);
		}

		private function onFrame(e:Event):void {
			//Fading
			if (!isFiltered && !isVanished) {
				visible = true;
				alpha = Math.min(1, alpha * ALPHA_STEP);
			}
			else {
				if (visible) {
					alpha /= ALPHA_STEP;
					if (alpha < MIN_ALPHA) {
						visible = false;
						alpha = MIN_ALPHA;
					}
				}
			}

			//Position
			var difference:Number = desiredHeight - y;
			if (Math.abs(difference) < HEIGHT_TOLERANCE) {
				y = desiredHeight;
			}
			else {
				y = desiredHeight - difference * MOVE_RATE;
			}
		}

		public function jumpHeight(value:Number):void {
			y = value;
			desiredHeight = value;
		}

		public static function sortItems(a:Timeline.TimelineItem, b:Timeline.TimelineItem):int {
			if (a.year != b.year) {
				return a.year > b.year ? 1 : -1;
			}
			if (a.month != b.month) {
				return a.month > b.month ? 1 : -1;
			}
			if (a.day != b.day) {
				return a.day > b.day ? 1: -1;
			}
			return 0;
		}
	}
}
