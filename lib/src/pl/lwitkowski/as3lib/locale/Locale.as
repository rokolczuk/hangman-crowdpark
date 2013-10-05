package pl.lwitkowski.as3lib.locale {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Locale extends EventDispatcher 
	{
		public static const READY:String = "ready";
		
		protected var _id:String;
		protected var _resourceBundle:ILocaleResourceBundle;
		
		public function Locale(id:String, resourceBundle:ILocaleResourceBundle) {
			_id = id;
			_resourceBundle = resourceBundle;
			_resourceBundle.addEventListener(Event.COMPLETE, handleDataReady);
		}
		
		public function get id():String {
			return _id;
		}
		
		public function get ready():Boolean {
			return _resourceBundle.ready;
		}
		
		public function load():void {
			_resourceBundle.load();
		}
		
		public function getString(key:String):String {
			return _resourceBundle.getString(key) || "";
		}
		
		protected function handleDataReady(e:Event):void {
			dispatchEvent(new Event(READY));
		}
	}
}
