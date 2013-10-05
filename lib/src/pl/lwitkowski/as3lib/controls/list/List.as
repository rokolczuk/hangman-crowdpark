package pl.lwitkowski.as3lib.controls.list {
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class List extends EventDispatcher implements IListLayout
	{
		private var _items:Vector.<DisplayObject>; // lista elementów, kolejnosc elementów w tej tablicy odpowiada wyswietlanej kolejnosci elementów
		private var _itemsContainer:Sprite;
		
		private var _locked:Boolean;
		
		private var _layout:IListLayout;
		
		public function List(container:DisplayObjectContainer, layout:IListLayout = null) {
			_itemsContainer = new Sprite();
			container.addChild(_itemsContainer);

			_items = new Vector.<DisplayObject>();

			this.layout = layout || this;
		}
		
		/**
		* Dodaje element na koniec listy
		* @param	p_item
		*/
		public function pushItem(item:DisplayObject):int {
			return addItemAt(item, _items.length);
		}
		public function unshiftItem(item:DisplayObject):int {
			return addItemAt(item, 0);
		}
		public function addItemAt(item:DisplayObject, position:int):int {
			_items.splice(position, 0, item);
			var itemsNum:int = _items.length;
			_itemsContainer.addChildAt(item, position);
			item.addEventListener(Event.RESIZE, handleItemResize);
			_layout.updateListLayout(_items);
			dispatchEvent(new Event(Event.RESIZE));
			return itemsNum;
		}
		private function handleItemResize(e:Event):void {
			_layout.updateListLayout(_items);
			dispatchEvent(new Event(Event.RESIZE));
		}

	
		/**
		* Zwraca element znajdujący się na liście w danym miejscu(w kolejnosci) - 
		* @param	p_position	Pozycja szukanego elementu w liscie
		* @return	Szukany element
		*/
		public function getItemAt(position:int):DisplayObject {
			return DisplayObject(_items[position]);
		}
		
		public function getItemPosition(item:DisplayObject):int {
			for(var i:int = 0; i < _items.length; ++i) {
				if(_items[i] == item) return i;
			}
			return -1;
		}
		
		
		public function get numItems():uint {
			return _items.length;
		}
		
		/**
		* Usuwa pojedynczy element z listy
		* @param	p_itemId
		* @return	True, jesli element znaleziono i usunięto
		*/
		public function removeItem(item:DisplayObject):Boolean {
			for(var i:int = 0; i < _items.length; ++i) {
				if(_items[i] == item) {
					_itemsContainer.removeChild(item);
					item.removeEventListener(Event.RESIZE, handleItemResize);
					_items.splice(i, 1);
					_layout.updateListLayout(_items);
					dispatchEvent(new Event(Event.RESIZE));
					return true;
				}
			}
			return false;
		}
		
		/**
		* Usuwa wszystkie elementy z listy
		*/	
		public function removeAll():void {
			while(_items.length > 0) {
				var item:DisplayObject = _itemsContainer.removeChild(_items.pop() as DisplayObject);
				item.removeEventListener(Event.RESIZE, handleItemResize);
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		/**
		* @param	p_cmpFunction
		*/
		public function sort(compare:Function):void {
			_items.sort(compare);
			_layout.updateListLayout(_items);
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function lock():void {
			_locked = true;
		}

		public function unlock():void {
			_locked = false;
			_layout.updateListLayout(_items);
		}

		public function get itemsContainer() : Sprite {
			return _itemsContainer;
		}

		public function set layout(value:IListLayout) : void {
			if(_layout) {
				_layout.removeEventListener("layoutChange", handleLayoutChange);
			}
			if(value) {
				_layout = value;
				_layout.addEventListener("layoutChange", handleLayoutChange);
				_layout.updateListLayout(_items);
			}
		}
		private function handleLayoutChange(e:Event):void {
			_layout.updateListLayout(_items);
		}
		
		
		
		// IListLayout
		private var _itemsInRow:int = 1;
		public function set itemsInRow(value:int):void {
			if(value > 0) {
				_itemsInRow = value;
				dispatchEvent(new Event("layoutChange"));
			} else {
				throw new ArgumentError("value cannot be negative");
			}
		}
		

		private var _hMargin:int = 0;
		private var _vMargin:int = 0;
		public function set hMargin(hMargin : int) : void {
			_hMargin = hMargin;
		}

		public function set vMargin(vMargin : int) : void {
			_vMargin = vMargin;
		}

		public function get itemsInRow() : int {
			return _itemsInRow;
		}

		public function get vMargin() : int {
			return _vMargin;
		}

		public function get hMargin() : int {
			return _hMargin;
		}

		public function updateListLayout(items : Vector.<DisplayObject>) : void {
			if(!_locked) {
				var currentY:Number = 0;
				var rows:int = Math.ceil(_items.length / _itemsInRow);
				
				var i:int = 0;				
				for(var row:int = 0; row < rows; ++row) {
					var rowHeight:Number = 0;
					var currentX:Number = 0;
					for(var col:int = 0; col<_itemsInRow; ++col) {
						if(i < _items.length) {
							var item:DisplayObject = DisplayObject(_items[i]);
							item.x = currentX;
							item.y = currentY;
							
							if(_itemSize) {
								currentX += _itemSize.x + _hMargin;
								rowHeight = Math.max(rowHeight, _itemSize.y +_vMargin);
							} else {
								currentX += item.width + _hMargin;
								rowHeight = Math.max(rowHeight, item.height +_vMargin);
							}
							
							++i;
						} else {
							break;
						}
					}
					currentY += rowHeight;					
				}
				//dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		private var _itemSize:Point;
		public function setItemSize(value:Point):void {
			_itemSize = value;
		}

		public function getSize() : Point {
			return _itemSize 
					? 
					new Point(Math.ceil(numItems % itemsInRow) * _itemSize.x, Math.ceil(numItems / itemsInRow) * _itemSize.y) 
					: 
					new Point(itemsContainer.width, itemsContainer.height);
		}
	}
}