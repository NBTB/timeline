package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public function FilterButton(tag:String, image:Bitmap, selected:Boolean = true) 
		{
			this.tag = tag;
			
			addChild(image);
			
			Selected = selected;
			
			addEventListener(MouseEvent.CLICK, toggle);
		}
		
		public function toggle(e:Event = null):void {
			Selected = !Selected;
		}
	}

}