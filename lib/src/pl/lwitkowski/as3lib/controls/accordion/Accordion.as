package pl.lwitkowski.as3lib.controls.accordion {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Accordion extends EventDispatcher 
	{
		private var _items:Vector.<AccordionItem>;
		private var _itemsRefPoint:Point;
		
		private var _allowMultiExpand:Boolean = false;
		private var _expandedItem : AccordionItem;
		private var _margin : int = 3;
		
		// trzeba przyznac, ze jestes bardzo fotogeniczna
		public function Accordion(margin:int = 3) {
			_margin = margin;
			_items = new Vector.<AccordionItem>();
			_itemsRefPoint = new Point(0, 0);
		}
		
		public function addItem(item:AccordionItem):void {
			item.addEventListener(AccordionItem.EXPAND, handleItemExpand);
			item.addEventListener(Event.RESIZE, handleItemResize);
			_items.push(item);
			updateItemsPositions();
		}
		
		public function removeAll():void {
			while(_items.length > 0) {
				var item:AccordionItem = _items.pop() as AccordionItem; 
				item.removeEventListener(AccordionItem.EXPAND, handleItemExpand);
				item.removeEventListener(Event.RESIZE, handleItemResize);
			}
			
			_expandedItem = null;
			dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function expandItemByIndex(index:int):void {
			try {
				AccordionItem(_items[index]).expand();
			} catch(e:Error) {}
		}
		
		public function collapseAll(immediate:Boolean = false):void {
			for each(var item:AccordionItem in _items) {
				item.collapse(immediate);
			}
		}
		
		protected function set refPoint(value:Point):void {
			_itemsRefPoint = value;
			updateItemsPositions();
		}

		// item listeners
		private function handleItemExpand(e:Event):void {
			if(!_allowMultiExpand) {
				var item:AccordionItem = e.currentTarget as AccordionItem;
				if(item != _expandedItem) {
					if(_expandedItem) _expandedItem.collapse();
					_expandedItem = item;
				}
			}
		}
		
		private function handleItemResize(e:Event):void {
			updateItemsPositions();
		}
		
		private function updateItemsPositions():void {
			var currentY:Number = _itemsRefPoint.y;
			for each(var item:AccordionItem in _items) {
				item.x = int(_itemsRefPoint.x);
				item.y = int(currentY); 
				currentY += item.accordionHeight;
				currentY += _margin;
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get items():Vector.<AccordionItem> {
			return _items.concat();
		}

		public function set allowMultiExpand(value:Boolean) : void {
			_allowMultiExpand = value;
		}
	}
}
