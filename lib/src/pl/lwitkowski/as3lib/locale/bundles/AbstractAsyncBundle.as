package pl.lwitkowski.as3lib.locale.bundles 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import pl.lwitkowski.as3lib.locale.ILangFileParser;
	import pl.lwitkowski.as3lib.locale.ILocaleResourceBundle;


	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AbstractAsyncBundle extends EventDispatcher 
			implements ILocaleResourceBundle 
	{
		private var _parser:ILangFileParser;
		private var _data:Object;
		
		public function AbstractAsyncBundle(parser:ILangFileParser) {
			_parser = parser;
		}
		
		public function load():void {
			throw IllegalOperationError("abstract method");
		}
		
		public function get ready():Boolean {
			return _data != null;
		}
		
		public function getString(key:String):String {
			return ready ? (_data[key] as String) : "";
		}
		
		protected function set bytes(value:ByteArray):void {
			_data = _parser.parseLangFile(value);
			if(_data) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}
