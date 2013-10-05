package pl.lwitkowski.as3lib.display {
	import pl.lwitkowski.as3lib.math.ExtMath;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.filters.ColorMatrixFilter;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class GraphicUtils 
	{
		public static const GRAYSCALE_MATRIX:Array = [
			.3086, 	.6094, 	.0820, 	0, 	0,
			.3086, 	.6094, 	.0820, 	0, 	0,
			.3086, 	.6094, 	.0820, 	0, 	0,
			0,   	0,   	0, 		1, 	0 
		];
		
		public static const SEPIA_MTX:Array = [
	        0.393, 0.349, 0.272, 0, 0,
	        0.769, 0.686, 0.534, 0, 0,
	        0.189, 0.168, 0.131, 0, 0,
	        0,      0,      0, 1, 0,
	        0,      0,      0, 0, 1
	    ];
		
		// makes display object grey
		public static function makeGrayscale(target:DisplayObject):void {
			target.filters = [new ColorMatrixFilter(GRAYSCALE_MATRIX)];
		}
		public static function makeSepia(target:DisplayObject):void {
			target.filters = [new ColorMatrixFilter(SEPIA_MTX)];
		}
		
		public static function getDisplayObjectTree(target:DisplayObject):String {
			var str:String = target.name;
			var doContainer:DisplayObjectContainer = target.parent;
			while(doContainer) {
				if(doContainer is Stage) {
					str = "stage/" + str;
				} else {
					str = doContainer.name + "/" + str;
				}
				doContainer = doContainer.parent;
			}
			return str;
		}
		
		/*private var _lastOffset:Number = 0;
		public static function drawNextDashedLine(graphics:Graphics, fromX:Number, fromY:Number, 
					toX:Number, toY:Number, dashSize:Number = 3, spaceSize:Number = 3, 
					firstDashOffset:Number = 0):Number 
		{
			drawDashedLine(graphics, fromX, fromY, toX, toY, dashSize, spaceSize, firstDashOffset || _lastOffset;
		}*/
		
		public static function drawDashedLine(graphics:Graphics, fromX:Number, fromY:Number, 
					toX:Number, toY:Number, dashSize:Number = 3, spaceSize:Number = 3, 
					firstDashOffset:Number = 0):Number 
		{
			var angle:Number = Math.atan2(toY - fromY, toX - fromX);
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			
			var t:Number = -(firstDashOffset  % (dashSize + spaceSize));
		 	var realLineLength:Number = Math.sqrt(Math.pow(toX - fromX, 2) + Math.pow(toY - fromY, 2));
		 	var lineLength:Number = realLineLength - t;
		 	
		 	graphics.moveTo(fromX, fromY);
		 	while (t < lineLength) {
			 	t += dashSize;
			 	if(t > lineLength) {
			 		graphics.lineTo(toX, toY);
			 	} else {
			 		graphics.lineTo(fromX + t * cos, fromY + t * sin);
				 	t += spaceSize;
			 		graphics.moveTo(fromX + t * cos, fromY + t * sin);
		 	 	}
			}
		 	return (t - realLineLength) % (dashSize + spaceSize);
		}
		
		public static function drawWedgeRadians(target:Graphics, x:Number, y:Number, radius:Number, 
					fromAngleRadians:Number, toAngleRadians:Number):void 
		{
			drawWedge(target, x, y, radius, fromAngleRadians * ExtMath._PI_DIV_180, toAngleRadians * ExtMath._PI_DIV_180);
		}
		
		public static function drawWedge(target:Graphics, x:Number, y:Number, radius:Number, 
					fromAngleDegrees:Number, toAngleDegrees:Number):void 
		{
			if(toAngleDegrees < fromAngleDegrees) toAngleDegrees += 360;
			
			var degToRad:Number = Math.PI/180;
			var n:Number = Math.ceil((toAngleDegrees-fromAngleDegrees)/45);
			
			var theta:Number = ((toAngleDegrees-fromAngleDegrees)/n)*degToRad;
			var cr:Number = radius/Math.cos(theta/2);
			var angle:Number = fromAngleDegrees*degToRad;
			var cangle:Number = angle-theta/2;
			target.moveTo(x, y);
			target.lineTo(x + radius*Math.cos(angle), y + radius*Math.sin(angle));
			for (var i:int = 0; i < n; ++i) {
				angle += theta;
				cangle += theta;
				target.curveTo(x + cr * Math.cos(cangle), y + cr * Math.sin(cangle), 
						x + radius * Math.cos(angle), y + radius * Math.sin(angle));
			}
			
			target.lineTo(x, y);
		}
	}
}
