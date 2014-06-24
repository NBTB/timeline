package Timeline 
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	/**
	 * ...
	 * @author Robert Cigna
	 */
	public class ProgressBar extends Sprite
	{
		private var barWidth:Number;
		private var barHeight:Number;
		
		private var barMask:Sprite;
		private var bar:Sprite;
		private var outline:Sprite;
		
		public function ProgressBar(width:Number, height:Number) 
		{
			barHeight = height;
			barWidth = width;
			
			bar = new Sprite();
			addChild(bar);
			barMask = new Sprite();
			barMask.graphics.moveTo(3, 0);
			barMask.graphics.beginFill(0);
			barMask.graphics.lineTo(width - 3, 0);
			barMask.graphics.curveTo(width, 0, width, 3);
			barMask.graphics.lineTo(width, height - 3);
			barMask.graphics.curveTo(width, height, width - 3, height);
			barMask.graphics.lineTo(3, height);
			barMask.graphics.curveTo(0, height, 0, height - 3);
			barMask.graphics.lineTo(0, 3);
			barMask.graphics.curveTo(0, 0, 3, 0);
			barMask.graphics.endFill();
			bar.addChild(barMask);
			bar.mask = barMask;
			
			outline = new Sprite();
			addChild(outline);
			outline.graphics.moveTo(3, 0);
			outline.graphics.lineStyle(1, 0xE5E5E5, 1, true);
			outline.graphics.lineTo(barWidth - 3, 0);
			outline.graphics.curveTo(barWidth, 0, barWidth, 3);
			outline.graphics.lineTo(barWidth, barHeight - 3);
			outline.graphics.curveTo(barWidth, barHeight, barWidth - 3, barHeight);
			outline.graphics.lineTo(3, barHeight);
			outline.graphics.curveTo(0, barHeight, 0, barHeight - 3);
			outline.graphics.lineTo(0, 3);
			outline.graphics.curveTo(0, 0, 3, 0);
		}
		
		public function draw(progress:Number):void {
			bar.graphics.clear();
			
			bar.graphics.beginFill(0, 1);
			bar.graphics.drawRect(barWidth * progress, 0, barWidth - barWidth * progress, barHeight);
			bar.graphics.endFill();
			
			var mat:Matrix = new Matrix();
			mat.createGradientBox(barWidth, barHeight, Math.PI, 0, 0);
			bar.graphics.beginGradientFill(GradientType.LINEAR, [0x0A1433, 0x0F1F4C, 0x293786], [1, 1, 1], [0, 10 * 255 / width, 255], mat);
			bar.graphics.lineStyle(0, 0, 0);
			bar.graphics.drawRect(0, 0, barWidth * progress, barHeight);
			bar.graphics.endFill();
		}
	}

}