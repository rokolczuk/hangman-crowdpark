package pl.szataniol.display.layout.lists {

	import flash.errors.IllegalOperationError;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class AbstractLayoutList extends EventDispatcher {

		protected var _width : int;
		protected var _items : Vector.<DisplayObject> = new Vector.<DisplayObject>();

		public function AbstractLayoutList(width : int) {

			_width = width;
			super();
		}

		public function addItem(displayObject : DisplayObject) : void {

			displayObject.addEventListener(Event.RESIZE, itemResizedHandler);
			_items.push(displayObject);
			resize();
		}

		public function removeItem(displayObject : DisplayObject) : void {

			for (var i : int = 0; i < _items.length; i++) {

				if (_items[i] == displayObject) {
					_items.splice(i, 1);
					break;
				}
			}

			resize();
		}

		public function removeAll() : void {

			for (var i : int = 0; i < _items.length; i++) {
				_items[i].removeEventListener(Event.RESIZE, itemResizedHandler);
				
			}
			
			_items.splice(0, _items.length);
		}

		public function resize() : void {

			throw new IllegalOperationError("AbstractLayoutList.resize is abstract");
		}

		private function itemResizedHandler(event : Event) : void {

			resize();
		}

		protected function get totalItemsWidth() : int {

			var width : int = 0;

			for (var i : int = 0; i < _items.length; i++) {
				width += _items[i].width;
			}
			
			return width;
		}

        public function get numItems():uint {

            return _items.length;
        }
	}
}
