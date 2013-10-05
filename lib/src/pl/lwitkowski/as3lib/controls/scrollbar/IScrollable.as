package pl.lwitkowski.as3lib.controls.scrollbar {
	import flash.events.IEventDispatcher;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public interface IScrollable extends IEventDispatcher
	{
		function setValue(value:Number, noSnapping:Boolean = false, dragging:Boolean = false):void;
		function updateTargetScroll(value:Number, dragging:Boolean = false):void;
		function get value():Number;
		function get minValue():Number;
		function get maxValue():Number;
	}
}