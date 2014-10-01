package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * FilterButton is a toggleable button used for the filtering buttons that turn on/off categories of items.
	 * @author Robert Cigna
	 */
	public class FilterButton extends Sprite
	{
		private var tag:String;
		public function get Tag():String { return tag; }
		private var selected:Boolean;
		public function get Selected():Boolean { return selected; }
		public function set Selected(value:Boolean):void 
		{
			if (value) alpha = 1;
			else alpha = .5;
			
			selected = value;
		}
		
		public function FilterButton(tag:String, text:String, color:Number, selected:Boolean = true) 
		{
			this.tag = tag;
			
			Selected = selected;
			
			addEventListener(MouseEvent.CLICK, toggle);
			
			var labelTextFormat:TextFormat = Main.serif_tf;
			
			var square:Sprite = new Sprite();
			square.graphics.lineStyle(1, 0x1a1b1f, 1);
			square.graphics.beginFill(color,1);
			square.graphics.drawRect(0, 0, 24, 24);
			square.graphics.endFill();
			square.buttonMode = true;
			square.mouseEnabled = true;
			square.useHandCursor = true;
			addChild(square);
			
			var label:TextField = new TextField();
			label.text = text;
			label.width = 245;
			label.x = square.width + 15;
			label.y = square.y - 3;
			label.multiline = true;
			label.autoSize = "left";
			label.wordWrap = true;
			labelTextFormat.size = 16;
			label.setTextFormat(labelTextFormat);
			label.selectable = false;
			label.mouseEnabled = false;
			
			var btn:Sprite = new Sprite();
			btn.graphics.beginFill(0x000000, 0);
			btn.graphics.drawRect(0 - 20, 0, label.width, label.height);
			btn.graphics.endFill();
			btn.buttonMode = true;
			btn.useHandCursor = true;
			
			addChild(label);
			addChild(btn);
		}
		
		public function toggle(e:Event = null):void {
			Selected = !Selected;
		}
	}

}