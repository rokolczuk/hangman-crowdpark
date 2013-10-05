package pl.lwitkowski.as3lib.controls.scrollbar.scrollers {
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextField;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class TextFieldScroller extends AbstractScroller
	{
		protected var _target:TextField;
		protected var _ignoreNextChangeEvent:Boolean;
		
		public function TextFieldScroller(target:TextField) {
			super(1, false);
			
			_target = target;
			_target.addEventListener(Event.SCROLL, handleTargetChange);
			_target.addEventListener(TextEvent.TEXT_INPUT, handleTargetChange);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		override public function updateTargetScroll(value:Number, dragging:Boolean = false):void {
			_ignoreNextChangeEvent = dragging;
			_target.scrollV = Math.round(value);
		}
		
		override public function get value():Number {
			return _target.scrollV;
		}
		override public function get minValue():Number {
			return 1;
		}
		override public function get maxValue():Number {
			return _target.maxScrollV;
		}		
		protected function handleTargetChange(p_event:Event):void {
			if (_ignoreNextChangeEvent) {
				_ignoreNextChangeEvent = false;
			} else {
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}