package pl.lwitkowski.as3lib.locale {
	import flash.events.IEventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public interface ILocaleResourceBundle extends IEventDispatcher
	{
		function load():void;
		function get ready():Boolean;
		function getString(key:String):String;
	}
}
