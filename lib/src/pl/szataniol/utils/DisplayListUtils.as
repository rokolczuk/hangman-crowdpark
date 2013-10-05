package pl.szataniol.utils {
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class DisplayListUtils {
		
		private static const _zero:Point = new Point();
		
		public static function moveToContainer(displayObject:DisplayObject, container:DisplayObjectContainer):void {
			
			if(!displayObject.stage) {
				
				container.addChild(displayObject);
				return;
			}
			
			var containerPoint:Point = container.localToGlobal(_zero);
			var displayObjectPoint:Point = displayObject.localToGlobal(_zero);
			var position:Point = displayObjectPoint.subtract(containerPoint);
			
			container.addChild(displayObject);
			
			displayObject.x = position.x;
			displayObject.y = position.y;
		}
		
		public static function removeAllChildren(displayObjectContainer:DisplayObjectContainer):void {
			
			while(displayObjectContainer.numChildren > 0)
				displayObjectContainer.removeChildAt(0);
		}
		
		public static function removeChildrenByType(displayObjectContainer:DisplayObjectContainer, typeClass:Class):void {
			
			for (var i : int = 0; i < displayObjectContainer.numChildren; i++) {
				
				if(displayObjectContainer.getChildAt(i) is typeClass) {
					
					displayObjectContainer.removeChildAt(i);
					i--;
				}
			}
		}
		
		public static function getRealDistanceBetween(displayObjectA:DisplayObject, displayObjectB:DisplayObject):Number {
			
			var pointA:Point = displayObjectA.localToGlobal(_zero);
			var pointB:Point = displayObjectB.localToGlobal(_zero);
			
			return Point.distance(pointA, pointB);
		}

		public static function transformPointToParentCoordinates(point : Point, displayObject : DisplayObject, displayObjectParent : DisplayObjectContainer) : Point {
		
			var global:Point = displayObject.localToGlobal(point);
			var parentGlobal:Point = displayObjectParent.localToGlobal(_zero);
			
			return global.subtract(parentGlobal);
		}

		static public function get zero() : Point {
			
			return _zero;
		}
	}
}
