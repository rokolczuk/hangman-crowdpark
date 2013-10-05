package pl.szataniol.utils.math {

	import flash.geom.Point;

	/**
	 * @author maciek
	 */
	public class MathUtil {

		public static function transformPointByCartesianCoordinates(point : Point, rotation : Number, tx : Number = 0, ty : Number = 0) : Point {

			var px : Number = point.x;
			var py : Number = point.y;

			point.x = tx + px * Math.cos(rotation) - py * Math.sin(rotation);
			point.y = ty + px * Math.sin(rotation) + py * Math.cos(rotation);

			return point;
		}

		public static function curveThroughPoint(from : Point, through : Point, to : Point) : Point {

			return new Point(2 * through.x - 0.5 * (from.x + to.x), 2 * through.y - 0.5 * (from.y + to.y));
		}

		public static function pointInConvexPolygon(point : Point, polygon : Vector.<Point>) : Boolean {

			var j : int = polygon.length - 1;
			
			var oddNodes : Boolean = false;
			
			for (var i : int = 0; i < polygon.length; i++) {

				if (polygon[i].y < point.y && polygon[j].y >= point.y || polygon[j].y < point.y && polygon[i].y >= point.y) {


					if (polygon[i].x + (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) {
						oddNodes = !oddNodes;
					}
				}
				
				j = i;
			}
			return  oddNodes;
		}
	}
}
