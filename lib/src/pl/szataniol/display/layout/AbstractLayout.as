package pl.szataniol.display.layout {

	import flash.display.DisplayObject;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class AbstractLayout {

		public function setItemsPositions(items : Vector.<DisplayObject>) : void {

			for (var i : int = 0; i < items.length; i++) {
				setItemPosition(items[i], i);
			}
		}

		public function setItemPosition(item : DisplayObject, index : int) : void {

		}
	}
}
