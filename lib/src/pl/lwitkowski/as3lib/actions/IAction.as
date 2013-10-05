package pl.lwitkowski.as3lib.actions {
	import flash.events.IEventDispatcher;
	/**
	 * @author lwitkowski
	 */
	public interface IAction extends IEventDispatcher 
	{
		function execute():void;
		function cancel():void;
		function get priority():int;
		function get delayBefore():Number;
		function get delayAfter():Number;
		function get timeout():Number;
	}
}
