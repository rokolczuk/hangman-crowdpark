package pl.lwitkowski.as3lib.controls.list {
	import flash.events.IEventDispatcher;
	import flash.display.DisplayObject;
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public interface IListLayout extends IEventDispatcher
	{
		function updateListLayout(items:Vector.<DisplayObject>):void;
	}
}
