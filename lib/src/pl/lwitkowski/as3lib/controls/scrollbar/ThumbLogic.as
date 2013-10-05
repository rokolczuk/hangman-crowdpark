package pl.lwitkowski.as3lib.controls.scrollbar {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	internal class ThumbLogic extends EventDispatcher
	{
		public static const CHANGE:String = "change";
		public static const DROP:String = "drop";
		
		protected var _dragging:Boolean;
		protected var _view:Sprite;
		protected var _dragBounds:Rectangle;
		
		public function ThumbLogic(view:Sprite, dragBounds:Rectangle = null) {
			_view = view;
			_view.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			_view.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			if(_view is Sprite) {
				Sprite(_view).buttonMode = true;
			}
			
			if(dragBounds) {
				this.dragBounds = dragBounds;
			}
			
			enabled = false;
		}
		
		public function set dragBounds(value:Rectangle):void {
			_dragBounds = value;
			
			var bounds:Rectangle = _view.getBounds(_view);
			_dragBounds.height = _dragBounds.height - (bounds.y + bounds.height) - 1;
			
			_view.x = Math.max(_dragBounds.x, Math.min(_dragBounds.x + _dragBounds.width, _view.x));
			_view.y = Math.max(_dragBounds.y, Math.min(_dragBounds.y + _dragBounds.height, _view.y));
		}

		public final function set scroll(value:Number):void {
			if(isNaN(value)) {
				value = 0;
			} else {
				if(value < 0) value = 0;
				if(value > 1) value = 1; 
			}
			
			
			if(_dragBounds) {
				_view.y = _dragBounds.y + value * _dragBounds.height;
			}
		}
		
		public function get scroll():Number {
			var value:Number = (_view.y - _dragBounds.y) / _dragBounds.height;
			return Math.round(value * 100)/100;
		}
		
		public function set enabled(value:Boolean):void {
			_view.mouseEnabled = value;
		}
		
		public function get enabled():Boolean {
			return _view.mouseEnabled;
		}
		
		protected function handleMouseDown(e:MouseEvent):void {
			_view.startDrag(false, _dragBounds);
			_dragging = true;
			
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			_view.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
		}
		
		
		protected function handleMouseUp(e:MouseEvent):void {
			if (_dragging) {
				_view.stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false);
				_view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false);
				
				_dragging = false;
				_view.stopDrag();
				
				handleMouseMove();
				dispatchEvent(new Event(DROP));
			}
		}
		
		protected function handleMouseMove(e:MouseEvent = null):void {
			if(_dragging) {
				dispatchEvent(new Event(CHANGE));
			}
		}
	}
}