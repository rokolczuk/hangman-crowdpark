package pl.lwitkowski.as3lib.selection {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class MultiSelectionManager extends EventDispatcher 
	{
		public static const SELECTION_CHANGE:String = "selectionChange";
		
		protected var _items:Array;
		protected var _selectEventType:String = null;
		protected var _deselectEventType:String = null;
		
		private var _locked:Boolean = false;

		public function MultiSelectionManager(selectEventType:String = Event.SELECT, deselectEventType:String = null) {
			_selectEventType = selectEventType;
			_deselectEventType = deselectEventType;
			
			_items = [];
		}

		public function add(item:ISelectable):void {
			if(item == null) throw new ArgumentError("item cannot be null");
			
			_items.push(item);
			setUpListeners(item);
		}
		
		public function remove(item:ISelectable):void {
			if(item == null) return;
			
			var removed:Boolean = false;
			for(var i:int = 0; i < _items.length; ++i) {
				var currentItem:ISelectable = ISelectable(_items[i]);
				if(item == currentItem) {
					if(_selectEventType) {
						currentItem.removeEventListener(_selectEventType, handleItemSelect);
					}
					if(_deselectEventType) {
						currentItem.removeEventListener(_deselectEventType, handleItemDeselect);
					}
					_items.splice(i, 1);
					--i;
					removed = true;
				}
			}	
			
			if(!_locked && removed && item.selected) {
				dispatchEvent(new Event(SELECTION_CHANGE));
			}
		}
		
		public function removeAll():void {
			var dispatchSelectionChange:Boolean = selectedItems.length > 0;
			if(_items) {
				while(_items.length > 0) {
					var item:ISelectable = ISelectable(_items.pop());
					if(_selectEventType) {
						item.removeEventListener(_selectEventType, handleItemSelect);
					}
					if(_deselectEventType) {
						item.removeEventListener(_deselectEventType, handleItemDeselect);
					}
				}
			}
			if(!_locked && dispatchSelectionChange) {
				dispatchEvent(new Event(SELECTION_CHANGE));
			}
		}
		
		public function get items():Array {
			return _items.concat();
		}

		public function get selectedItems():Array {
			return _items.filter(filterOnlySelected);
		}
		
		private function filterOnlySelected(element:*, index:int, arr:Array):Boolean {
			return ISelectable(element).selected;
		}
		
		public function selectAll():void {
			internalSelectAll();
			dispatchEvent(new Event(SELECTION_CHANGE));
		}

		protected function internalSelectAll():void {
			_locked = true;
			for each(var item:ISelectable in _items) {
				select(item);
			}
			_locked = false;
		}

		public function deselectAll():void {
			internalDeselectAll();
			dispatchEvent(new Event(SELECTION_CHANGE));
		}

		protected function internalDeselectAll():void {
			_locked = true;
			for each(var item:ISelectable in _items) {
				if(item.selected) {
					deselect(item);
				}
			}
			_locked = false;
		}

		public function select(value:ISelectable):void {
			if(value == null) return;
			value.selected = true;
			if(!_locked) dispatchEvent(new Event(SELECTION_CHANGE));
		}
		
		public function deselect(value:ISelectable):void {
			if(value == null) return;
			value.selected = false;
			if(!_locked) dispatchEvent(new Event(SELECTION_CHANGE));
		}
		
		protected function setUpListeners(target:ISelectable):void {
			if(_selectEventType) target.addEventListener(_selectEventType, handleItemSelect);
			if(_deselectEventType) target.addEventListener(_deselectEventType, handleItemDeselect);
		}
		
		protected function handleItemSelect(e:Event):void {
			select(ISelectable(e.currentTarget));
		}
		protected function handleItemDeselect(e:Event):void {
			deselect(ISelectable(e.currentTarget));
		}
	}
}
