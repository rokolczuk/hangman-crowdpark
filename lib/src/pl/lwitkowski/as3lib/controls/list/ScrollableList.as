package pl.lwitkowski.as3lib.controls.list {
	import flash.geom.Rectangle;
	import pl.lwitkowski.as3lib.controls.scrollbar.ScrollBar;
	import pl.lwitkowski.as3lib.controls.scrollbar.scrollers.SpriteScrollRectScroller;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class ScrollableList extends List 
	{
		protected var _scrollbar:ScrollBar;
		
		public function ScrollableList(content:Sprite, mask:DisplayObject, 
							scrollbar:ScrollBar, scrollStep:int, horizontal:Boolean = false) 
		{
			super(content);
			
			var scroller:SpriteScrollRectScroller = new SpriteScrollRectScroller(this, itemsContainer, scrollStep, false, content, horizontal);
			scroller.viewport = new Rectangle(0, 0, mask.width, mask.height);

			if(mask is InteractiveObject) {
				InteractiveObject(mask).mouseEnabled = false;
				if(mask is DisplayObjectContainer) {
					DisplayObjectContainer(mask).mouseChildren = false;
				}
			}

			_scrollbar = scrollbar;
			_scrollbar.target = scroller;
			_scrollbar.mouseWheelTarget = content;

			addEventListener(Event.RESIZE, handleResize);
		}
		
		private function handleResize(e:Event):void {
			_scrollbar.update();
		}
		
		public function get scrollbar():ScrollBar {
			return _scrollbar;
		}
	}
}
