package Timeline 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class TimelineTick extends Sprite 
	{
		
		public function TimelineTick(height:int, date:String, dateHeight:int = 30) 
		{
			//solid lines on datebar/timeline
			var dLine:Shape = new Shape();
			dLine.graphics.moveTo(0, -15);
			dLine.graphics.lineStyle(2, 0x000000,1);
			dLine.graphics.lineTo(0, 15);
			this.addChild(dLine);
			
			//dates
			var dLineText:TextField = new TextField();
			dLineText.text = date;
			dLineText.x =  - 15;
			dLineText.y = dateHeight;
			this.addChild(dLineText);
			
			//faint lines
			var faintLine:Shape;
			faintLine = new Shape();
			faintLine.graphics.moveTo(0, -height);
			faintLine.graphics.lineStyle(2, 0x111188, 0.1);
			faintLine.graphics.lineTo(0, -15);
			this.addChild(faintLine);
		}
		
	}

}