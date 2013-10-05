package pl.lwitkowski.as3lib.controls.scrollbar {
	import pl.lwitkowski.as3lib.controls.scrollbar.scrollers.AbstractScroller;
	import pl.lwitkowski.as3lib.controls.scrollbar.scrollers.TextFieldScroller;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class ScrollBar extends EventDispatcher
	{
		// display members
		protected var _up:InteractiveObject; // left/up
		protected var _down:InteractiveObject; // rigth/down
		protected var _thumb:Sprite;
		protected var _track:Sprite;
		protected var _margins:Dictionary;
		
		// variables
		protected var _enabled:Boolean;
		protected var _hideIdleSlider:Boolean = true;
		protected var _hideIdleButtons:Boolean = false;
		
		protected var _scroll:Number;
		protected var _scrollSpeed:Number; // predkosc przewijania
		
		protected var _thumbLogic:ThumbLogic;
		protected var _scroller:AbstractScroller;
		
		protected var _scrollStep:Number = 0;
		protected var _snapping:Boolean = false;
		
		public function ScrollBar(up:InteractiveObject, down:InteractiveObject, 
				thumb:Sprite = null, track:Sprite = null, hideIdleSlider:Boolean = true, hideIdleButtons:Boolean = false) 
		{
			_up = up;
			_down = down;
			_thumb = thumb;
			_track = track;
			_hideIdleSlider = hideIdleSlider;
			_hideIdleButtons = hideIdleButtons;
			
			if(_thumb) {
				_thumbLogic = new ThumbLogic(_thumb);
				_thumbLogic.addEventListener(ThumbLogic.CHANGE, onSliderMove);
				_thumbLogic.addEventListener(ThumbLogic.DROP, onSliderDrop);
				
				_thumb.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				
				if(_track) {
					_track.addEventListener(MouseEvent.CLICK, handleTrackClick);
					_track.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
					_thumbLogic.dragBounds = new Rectangle(_thumb.x, _track.y, 0, _track.height);
				} else {
					_thumbLogic.dragBounds = new Rectangle(_thumb.x, _thumb.y, 0, 0);
				}
			}			
			if(_up) {
				_up.addEventListener(MouseEvent.MOUSE_DOWN, handleUpArrowMouseDown);
				_up.addEventListener(MouseEvent.MOUSE_UP, handleUpArrowMouseUp);
				//up.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);	
				if(_up is Sprite) {
					Sprite(_up).buttonMode = true;
				}
			}
			if(_down) {
				_down.addEventListener(MouseEvent.MOUSE_DOWN, handleDownArrowMouseDown);
				_down.addEventListener(MouseEvent.MOUSE_UP, handleDownArrowMouseUp);
				//down.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				if(_down is Sprite) {
					Sprite(down).buttonMode = true;
				}
			}
			
			enabled = false;
			
			_margins = new Dictionary();
			initMargin(_up, 0, height);
			initMargin(_down, 0, height);
			initMargin(_thumb, 0, height);
			initMargin(_track, 0, height);
		}

		private function handleTrackClick(e:MouseEvent):void {
			var clickedScroll:Number = _track.mouseY/_track.height;
			if(clickedScroll > scroll) {
				_scroller.scrollDown(3);
			} else {
				_scroller.scrollUp(3);
			}
		}

		public function set target(value:Object):void {
			if (value is AbstractScroller) {
				scroller = value as AbstractScroller;
			} else if (value is TextField) {
				scroller = new TextFieldScroller(value as TextField);
			} else {
				throw new ArgumentError('Passed object has unsupported type');
			}
		}
		
		public function get scroll():Number {
			return _scroll;
		}
		public function set scroll(value:Number):void {
			internalSetScroll(value);
		}
		
		public function set scrollStep(value:int):void {
			_scrollStep = value;
			if(_scroller) {
				_scroller.scrollStep = value;
			} 
		}
		public function set snapping(value:Boolean):void {
			_snapping = value;
			if(_scroller) {
				_scroller.snapping = value;
			}
		}
		
		protected var _mouseWheelMultiplier:int = 1;
		public function set mouseWheelMultiplier(value:int):void {
			_mouseWheelMultiplier = value;
		}		
		
		protected var _mouseWheelTarget:InteractiveObject;
		public function set mouseWheelTarget(value:InteractiveObject):void {
			if(_mouseWheelTarget) {
				_mouseWheelTarget.removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			}
			_mouseWheelTarget = value;
			if(_mouseWheelTarget) {
				_mouseWheelTarget.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);	
			}
		}

		protected function handleMouseWheel(e:MouseEvent):void {
			if (e.delta > 0) _scroller.scrollUp(_mouseWheelMultiplier);
			else _scroller.scrollDown(_mouseWheelMultiplier);
		}
		
		public function get height():int {
			if(_down) {
				return _down.y + _down.height - _up.y;
			} else if(_track) {
				return _track.height;
			} else {
				return 0;
			}
		}
		public function set height(value:int):void {
			if(_down) {
				_down.y = value - _margins[_down].y;
			}
			if(_track) {
				_track.height = value - _margins[_track].height;
				_thumbLogic.dragBounds = new Rectangle(_thumb.x, _track.y, 0, _track.height);
			}	
		}
		
		public function isNeeded():Boolean {
			return _thumbLogic ? _thumbLogic.enabled : true;
		}
		
		public function update():void {
			if(_thumbLogic) {
				if(_track) {
					_thumbLogic.dragBounds = new Rectangle(_thumb.x, _track.y, 0, _track.height);
				} else {
					_thumbLogic.dragBounds = new Rectangle(_thumb.x, _thumb.y, 0, 0);
				}
			}
			_scroller.updateValues();
			if(_scroller.maxValue > _scroller.minValue) {
				enabled = true;			
				_scroll = (_scroller.value - _scroller.minValue) / _scroller.valueSpread;
				if(_scroll < 0) {
					_scroll = 0;
					_scroller.setValue(_scroller.minValue, false, false);
				} else if(_scroll > 1) {
					_scroll = 1; 
					_scroller.setValue(_scroller.maxValue, false, false);
				}
			} else {
				enabled = false;
				internalSetScroll(0, false);
			}
			updateSlider();			
		}
		
		// PRIVATE
		
		private function initMargin(target:DisplayObject, width:Number, height:Number):void {
			if(target) {
				_margins[target] = { 
					x : width - target.x, 
					y : height - target.y,
					width : width - target.width,
					height : height - target.height
				};
			}
		}

		protected var _arrowLagInterval:int;
		protected function handleUpArrowMouseDown(e:MouseEvent):void {
			_scroller.scrollUp();
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
			_arrowLagInterval = setTimeout(startConstantScrollUp, 400);
		}
		protected function handleUpArrowMouseUp(e:MouseEvent):void {
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
		}
		protected function handleDownArrowMouseDown(e:MouseEvent):void {
			_scroller.scrollDown();
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
			_arrowLagInterval = setTimeout(startConstantScrollDown, 400);
		}
		protected function handleDownArrowMouseUp(e:MouseEvent):void {
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
		}
		
		protected function startConstantScrollUp():void {
			_scroller.scrollUp();
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
			_arrowLagInterval = setInterval(_scroller.scrollUp, 100);	
		}
		protected function startConstantScrollDown():void {
			_scroller.scrollDown();
			clearInterval(_arrowLagInterval);
			clearTimeout(_arrowLagInterval);
			_arrowLagInterval = setInterval(_scroller.scrollDown, 100);	
		}
				
		protected function set scroller(value:AbstractScroller):void {
			if (_scroller) {
				_scroller.removeEventListener(Event.CHANGE, handleTargetChange);
			}
			_scroller = value;
			if(_scrollStep > 0) _scroller.scrollStep = _scrollStep;
			//_scroller.snapping = _snapping;
			_scroller.addEventListener(Event.CHANGE, handleTargetChange);
			update();
		}
		
		protected function handleTargetChange(e:Event):void {
			update();
		}
		
		protected function internalSetScroll(value:Number, updateScroll:Boolean = true):void {
			if(_scroller.maxValue <= _scroller.minValue) {
				_scroll = 0;
				enabled = false;
			}
			
			if (isNaN(value) || (_thumbLogic != null && !_thumbLogic.enabled)) value = 0;
			
			
			if(value < 0) _scroll = 0;
			else if (value > 1) _scroll = 1;
			else _scroll = value;
			
			_scroller.setValue( _scroller.minValue + _scroll * _scroller.valueSpread, false, false);
			if(updateScroll) updateSlider();
		}
		
		protected function set enabled(value:Boolean):void {
			_enabled = value;
			if(_scroller) _scroller.enabled = _enabled;
			
			var sliderNeeded:Boolean = value && (_scroller.maxValue > _scroller.minValue); 
			if(_thumbLogic) {
				_thumbLogic.enabled = sliderNeeded;
				if(_hideIdleSlider) {
					_thumb.visible = sliderNeeded;
				}
			}
			
			if(_up) {
				_up.mouseEnabled = sliderNeeded;
				if(_hideIdleButtons) _up.visible = value && _scroller.value > _scroller.minValue;
			}
			if(_down) {
				_down.mouseEnabled = sliderNeeded;
				if(_hideIdleButtons) _down.visible = value && (_scroller.maxValue > _scroller.value);
			}
		}
		
				
		protected function updateSlider():void {
			if(_thumbLogic) {
				var value:Number = (_scroller.value - _scroller.minValue) / _scroller.valueSpread;
				_thumbLogic.scroll = value || 0;
			}
		}
		
		////////////////////////////////
		protected function onSliderMove(e:Event):void {
			var value:Number = _scroller.minValue + _thumbLogic.scroll * _scroller.valueSpread;
			_scroller.setValue(value, true, true);
		}
		
		protected function onSliderDrop(e:Event):void {
			internalSetScroll(_thumbLogic.scroll, true);
		}

		public function set hideIdleButtons(hideIdleButtons : Boolean) : void {
			_hideIdleButtons = hideIdleButtons;
		}

		public function set hideIdleSlider(hideIdleSlider : Boolean) : void {
			_hideIdleSlider = hideIdleSlider;
		}		
	}
}
