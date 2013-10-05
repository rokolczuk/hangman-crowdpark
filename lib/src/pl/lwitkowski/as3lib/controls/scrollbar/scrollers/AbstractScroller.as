package pl.lwitkowski.as3lib.controls.scrollbar.scrollers {
	import flash.events.EventDispatcher;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AbstractScroller extends EventDispatcher
	{
		protected var _step:Number;
		protected var _snapping:Boolean;
		
		protected var _enabled:Boolean;
		
		public function AbstractScroller(step:Number = 0, snapping:Boolean = false) {
			_step = step || 30;
			_snapping = snapping;
		}
		
		public function setValue(value:Number, noSnapping:Boolean = false, dragging:Boolean = false):void {
			if(maxValue > minValue) { // scroll potrzebny
				if (value > maxValue) value = maxValue;
				else if (value < minValue) value = minValue;
			} else {
				value = 0;
			}
			
			var newValue:Number = (_snapping && !noSnapping) ? getSnappedScrollValue(value) : value;
			updateTargetScroll(newValue, dragging);
		}
		public function updateTargetScroll(value:Number, dragging:Boolean = false):void {}	
		public function get value():Number { return 0;  }
		public function get minValue():Number { return 0; }
		public function get maxValue():Number { return 0; }
		public function get valueSpread():Number { 
			return maxValue - minValue; 
		}
		
		public function scrollUp(multiplyer:int = 1):void {
			setValue(value - _step * multiplyer);
		}
		public function scrollDown(multiplyer:int = 1):void {
			setValue(value + _step * multiplyer);
		}
		
		public function update():void {
			setValue(value);
		}
		
		public function updateValues():void {}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
		}
		
		protected function getSnappedScrollValue(value:Number):Number {
			var modulo:Number = value % _step;
			var endValueInt:Number =  value - modulo;
			if(modulo > _step/2) endValueInt += _step;
			return endValueInt;
		}
		
		
		////////////////////////////////
		// setters
		public function set scrollStep(value:Number):void {
			_step = value;
		}
		
		public function set snapping(value:Boolean):void {
			_snapping = value;
			update();
		}
	}
}