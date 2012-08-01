package Timeline
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * A TimelineItem is an interactive icon that appears on the timeline. 
	 */
	public class TimelineItem extends MovieClip
	{
		public var type:String; //type of event it is (political, war, etc.) for icons and sorting purposes
		public var victor:String;
		
		//date values
		public var year:int;
		public var month:int;
		public var day:int;
		
		public var shortDes:String;
		public var fullDes:String;
		
		public var importance:int;
		
		public function TimelineItem()
		{
		}
		
		//on hover
		
		//on click
	}
}