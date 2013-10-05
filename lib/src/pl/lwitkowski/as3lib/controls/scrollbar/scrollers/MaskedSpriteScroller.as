package pl.lwitkowski.as3lib.controls.scrollbar.scrollers {
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class MaskedSpriteScroller extends AbstractScroller
	{
		protected var _target:DisplayObject;
		protected var _mask:DisplayObject;
		
		protected var _value:Number;
		
		public function MaskedSpriteScroller(target:DisplayObject, mask:DisplayObject, scrollStep:int = 0, 
					snapping:Boolean = false) 
		{
			super(scrollStep || 30, snapping);

			_target = target;
			_mask = mask;
			updateValues();
		}
		
		override public function updateTargetScroll(value:Number, dragging:Boolean = false):void {
			var endValue:Number = int(value);
			
			if(dragging) {
				_target.y = endValue;
			} else {
				TweenLite.killTweensOf(_target);
				TweenLite.to(_target, .2, { y : endValue, onUpdate : onAnimationEnd } );
			}
		}
		
		protected function onAnimationEnd():void {
			dispatchEvent(new Event(Event.CHANGE));	
		}
		
		public override function get value():Number {
			return int(_target.y);
		}
		public override function get minValue():Number {
			return _mask.y;
		}
		public override function get maxValue():Number {
			return int(_target.height - _mask.height);
		}
	}
}