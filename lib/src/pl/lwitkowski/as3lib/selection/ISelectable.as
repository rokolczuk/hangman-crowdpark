package pl.lwitkowski.as3lib.selection 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public interface ISelectable extends IEventDispatcher 
	{
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		function equals(value:ISelectable):Boolean;
	}
}
