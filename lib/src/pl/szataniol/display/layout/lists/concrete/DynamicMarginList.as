package pl.szataniol.display.layout.lists.concrete {

	import pl.szataniol.display.layout.lists.AbstractLayoutList;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class DynamicMarginList extends AbstractLayoutList {


		private var _sideMargin : int;

		public function DynamicMarginList(width : int, sideMargin : int = 0) {
			
			_sideMargin = sideMargin;
			super(width);
		}


		override public function resize() : void {

			var _totalItemsWidth : int = 2 * _sideMargin + totalItemsWidth;

			var totalMargin : int = _width - _totalItemsWidth;
			var itemMargin : int = totalMargin / (_items.length - 1);
			var currentWidth : int = 0;

			for (var i : int = 0; i < _items.length; i++) {

				_items[i].x = _sideMargin + currentWidth;
				currentWidth += _items[i].width + itemMargin;
			}
		}
	}
}
