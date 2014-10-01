package Timeline 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class TimelineTick extends Sprite 
	{
		
		public function TimelineTick(height:int, date:String, dateHeight:int = 30, showLine:Boolean = true, subtle:Boolean = false) 
		{
			//solid lines on datebar/timeline
			if(showLine) {
				var dLine:Shape = new Shape();
				dLine.graphics.moveTo(0, -15);
				dLine.graphics.lineStyle(2, 0x444444,1);
				dLine.graphics.lineTo(0, 15);
				this.addChild(dLine);
			}
			
			
			//dates
			var dLineText:TextField = new TextField();
			var dLinkTextFormat:TextFormat = subtle ? Main.subtler_tf : Main.timeline_date_tf;
			dLineText.selectable = false;
			dLineText.mouseEnabled = false;
			dLineText.text = date;
			dLineText.setTextFormat(dLinkTextFormat);
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