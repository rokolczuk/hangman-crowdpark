package pl.szataniol.display.layout {
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class Fitter {
		
		public static function fit(object:DisplayObject, rectangle:Rectangle):void {
			
			var ratioW:Number = object.width / rectangle.width;
			var ratioH:Number = object.height/ rectangle.height;
			
			if(ratioW < ratioH) {
				
				object.width = rectangle.width;
				object.scaleY = object.scaleX;
			} else {
				object.height = rectangle.height;
				object.scaleX = object.scaleY;
			}
		}
		
		public static function centralize(object:DisplayObject):void {
			
			object.x = -object.width/2;
			object.y = -object.height/2;
		}
	}
}
