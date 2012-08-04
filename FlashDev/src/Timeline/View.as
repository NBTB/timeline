package Timeline 
{
	/**
	 * The View class is a collection of variables relating to how the timeline is currently presented.
	 * It communicates the center of focus, zoom level, and more.
	 * It should be treated as a struct, bearing in mind that it is still a reference type.
	 * @author Robert Cigna
	 */
	public class View 
	{
		public var center:Number;      //The current focus of the timeline, measured as a fraction of the whole width.
		public var width:Number;       //The current zoom of the timeline, measured in years per screen width.
		
		public function View(center:Number = .6, width:Number = 10) 
		{
			this.center = center;
			this.width = width;
		}
		
	}

}