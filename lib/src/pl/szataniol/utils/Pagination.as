package pl.szataniol.utils {

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class Pagination extends EventDispatcher {

		private var _start : int = 0;
		private var _perPage : int;
		private var _limit : int;

		public function Pagination(perPage : int, limit : int) {

			_limit = limit;
			_perPage = perPage;
			_start = 0;
		}

		public function get nextPageAvaible() : Boolean {
			
			return _start + _perPage < _limit;
		}

		public function get prevPageAvaible() : Boolean {
			return _start  > 0;
		}

		public function get nextItemAvaible() : Boolean {

			return nextPageAvaible;
		}

		public function get prevItemAvaible() : Boolean {
			return _start > 0;
		}
		
		public function get firstPageAvaible():Boolean {
			
			return prevItemAvaible;
		}
		public function get lastPageAvaible():Boolean {
			
			return nextPageAvaible;
		}

		public function nextPage() : void {

			if (nextPageAvaible) {

				_start += _perPage;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function prevPage() : void {

			if (prevPageAvaible) {

				_start -= _perPage;
				_start = Math.max(_start, 0);
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function nextItem() : void {

			if (nextItemAvaible) {

				_start++;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function prevItem() : void {

			if (prevItemAvaible) {

				_start--;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		public function firstPage() : void {

			if (firstPageAvaible) {

				_start = 0;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function lastPage() : void {

			if (lastPageAvaible) {

				_start = _limit - _perPage;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function set limit(limit : int) : void {

			_limit = limit;

			if (_start + _perPage > _limit) {

				_start = Math.max(0, _limit - _perPage);
			}
		}

		public function set start(start : int) : void {

			_start = start;
		}

		public function getItems(itemsList : Vector.<*>) : Vector.<*> {
			
			if (itemsList.length != _limit) {

				throw new IllegalOperationError("list size doesn't match pagination limit");
			}
			
			return itemsList.slice(_start, _start + _perPage);
		}

		public function get perPage() : int {
			
			return _perPage;
		}
		
		public function get currentPage():int {
			
			return Math.ceil(_start / _perPage)+1;
		}
	
		public function get totalPages():int {
			
			return Math.ceil(_limit / _perPage);
		}

		public function get start() : int {
			
			return _start;
		}
		
		public function set percentValue(value:Number):void {
			
			value = Math.max(0, Math.min(1, value));
			_start = _limit * value;
			dispatchEvent(new Event(Event.CHANGE));
		}
    }
}
