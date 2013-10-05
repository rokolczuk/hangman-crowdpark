package pl.szataniol.display.layout.concrete {

import flash.display.DisplayObject;

import pl.szataniol.display.layout.AbstractLayout;

/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class GridLayout extends AbstractLayout {

		protected var _x : int;
		protected var _y : int;
		protected var _cols : int;

		public function GridLayout(x : int, y : int, cols : int) {

			_x = x;
			_y = y;
			_cols = cols;
		}

		override public function setItemPosition(item : DisplayObject, index : int) : void {

			var col : int = index % _cols;
			var row : int = Math.floor(index / _cols);

			item.x = col * _x;
			item.y = row * _y;
		}
	}
}
