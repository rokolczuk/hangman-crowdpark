package pl.lwitkowski.as3lib.controls.accordion {
	import com.greensock.easing.Linear;
	import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

	import com.greensock.TweenLite;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AccordionItem extends DisplayObjectWrapper 
	{
		public static var ANIMATION_DURATION:Number = 0.1;
		
		public static const EXPAND:String = "expand";
		public static const COLLAPSE:String = "collapse";
		
		private var _expanded:Boolean;
		private var _expandPercent:Number = 0;
		
		public function AccordionItem(view:Sprite, hitarea:InteractiveObject = null) {
			super(view);
			
			if(hitarea != null) {
				hitarea.addEventListener(MouseEvent.CLICK, toogleSize);
				if(hitarea is Sprite) {
					Sprite(hitarea).buttonMode = true;
				}
			}
			collapse(true);
		}
		
		public function expand(immediate:Boolean = false):void {
			var e:Event = new Event(EXPAND, false, true);
			dispatchEvent(e);
			if(!e.isDefaultPrevented()) {
				_expanded = true;
				TweenLite.to(this, immediate ? 0 : ANIMATION_DURATION, { expandPercent : 1, ease : Linear.easeNone });
			}
		}
		public function collapse(immediate:Boolean = false):void {
			var e:Event = new Event(COLLAPSE, false, true);
			dispatchEvent(e);
			if(!e.isDefaultPrevented()) {
				_expanded = false;
				TweenLite.to(this, immediate ? 0 : ANIMATION_DURATION, { expandPercent : 0, ease : Linear.easeNone });
			}
		}
		
		public function get accordionHeight():Number {
			return viewComponent.height;
		}
		
		public function get expandPercent():Number {
			return _expandPercent;
		}
		public function set expandPercent(value:Number) : void {
			_expandPercent = value;
			dispatchEvent(new Event(Event.RESIZE));
		} 
		private function toogleSize(e:MouseEvent):void {
			if(_expanded) collapse();
			else expand();
		}
	}
}
