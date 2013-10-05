package pl.lwitkowski.as3lib.controls.scrollbar.scrollers {
	import flash.geom.Point;
	import pl.lwitkowski.as3lib.controls.list.List;
	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class SpriteScrollRectScroller extends AbstractScroller
	{
		private var _list:List;
		protected var _scrollRectTarget:Sprite;
		protected var _target:Sprite;
		protected var _viewport:Rectangle;
		
		protected var _value:Number;
		private var _horizontal:Boolean;
		
		public function SpriteScrollRectScroller(list:List, target:Sprite, scrollStep:int = 0, 
					snapping:Boolean = false, scrollRectTarget:Sprite = null, horizontal:Boolean = false) 
		{
			_list = list;
			_horizontal = horizontal;
			super(scrollStep || 30, snapping);
			
			
			if(scrollRectTarget) {
				_scrollRectTarget = scrollRectTarget;
			} else {
				_scrollRectTarget = new Sprite();
				_scrollRectTarget.x = target.x;
				_scrollRectTarget.y = target.y;
				target.parent.addChildAt(_scrollRectTarget, target.parent.getChildIndex(target));
			}
			
			_target = target;
			_scrollRectTarget.addChild(_target);
			
			_viewport = new Rectangle();
			updateValues();
			viewport = new Rectangle();
		}
		
		public function set viewport(value:Rectangle):void {
			if(_horizontal) {
				_viewport.width = value.width;
			} else {
				_viewport.height = value.height;
			}
			try {
				_scrollRectTarget.scrollRect = _viewport;
				dispatchEvent(new Event(Event.CHANGE));
			} catch(e:Error) {}
		}
		
		override public function updateTargetScroll(value:Number, dragging:Boolean = false):void {
			var endValue:Number = int(value);
			
			if(dragging) {
				if(_horizontal) {
					_viewport.x = endValue;
				} else {
					_viewport.y = endValue;
				}
				_scrollRectTarget.scrollRect = _viewport;
			} else {
				TweenLite.killTweensOf(_viewport);
				if(_horizontal) {
					TweenLite.to(_viewport, .2, { x : endValue, onUpdate : onAnimationEnd } );
				} else {
					TweenLite.to(_viewport, .2, { y : endValue, onUpdate : onAnimationEnd } );
				}
			}
		}
		
		public override function updateValues():void {
			if(_horizontal) {
				_viewport.height = _target.height;
			} else {
				_viewport.width = _target.width;
			}
			_scrollRectTarget.scrollRect = _viewport;
		}
		
		protected function onAnimationEnd():void {
			_scrollRectTarget.scrollRect = _viewport;
			dispatchEvent(new Event(Event.CHANGE));	
		}
		
		override public function get value():Number {
			return int(_horizontal ? _viewport.x : _viewport.y);
		}
		override public function get minValue():Number {
			return 0;
		}
		override public function get maxValue():Number {
			var size:Point = _list.getSize(); 
			return _horizontal ? int(size.x - _viewport.width) : int(size.y - _viewport.height);
		}
				
		override public function set enabled(value:Boolean):void {
			super.enabled = value;
			_scrollRectTarget.scrollRect = value ? _viewport : null;
		}
	}
}