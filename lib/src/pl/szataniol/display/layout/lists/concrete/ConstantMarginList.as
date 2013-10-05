package pl.szataniol.display.layout.lists.concrete {

	import flashx.textLayout.edit.Mark;

	import pl.szataniol.display.layout.lists.AbstractLayoutList;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class ConstantMarginList extends AbstractLayoutList {

		public static const ALIGN_LEFT : String = "left";
		public static const ALIGN_CENTER : String = "center";
		public static const ALIGN_RIGHT : String = "right";

		private var _align : String;

		private var _margin : int;
        private var _sideMargin:int;

		public function ConstantMarginList(width : int, margin : int, align : String = ALIGN_CENTER, sideMargin:int = 0) {

			_margin = margin;
			_align = align;
			super(width);
            _sideMargin = sideMargin;
        }

		override public function resize() : void {

			var currentWidth : int = _sideMargin;

			var i : int;

			for (i = 0; i < _items.length; i++) {
				_items[i].x = currentWidth;
				currentWidth += _items[i].width + _margin;
			}

			if (_align == ALIGN_LEFT) {

				return;
			}

			var shift : int;
			var _totalItemsWidth : int = totalItemsWidth;

			if (_align == ALIGN_CENTER) {
				
				shift = (_width - _totalItemsWidth) / 2 ;
			
			} else if (_align == ALIGN_RIGHT) {

				shift = _width - _totalItemsWidth - _sideMargin * 2;
                trace(_width, _totalItemsWidth, _sideMargin);
			}

			for (i = 0; i < _items.length; i++) {
				
				_items[i].x += shift;
			}
		}


        override protected function get totalItemsWidth():int {
            return super.totalItemsWidth + _margin * (_items.length-1);
        }

        public function set align(value:String):void {

            _align = value;
            resize();
        }
    }
}
