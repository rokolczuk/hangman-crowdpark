package pl.szataniol.display.layout.concrete {

	import flash.display.DisplayObject;

	import pl.szataniol.display.layout.AbstractLayout;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class ListLayout extends AbstractLayout {

		private var _x : int;
		private var _y : int;

		public function ListLayout(x : int, y : int) {

			_y = y;
			_x = x;
		}

		override public function setItemPosition(item : DisplayObject, index : int) : void {

			item.x = index * _x;
			item.y = index * _y;
		}
	}
}
