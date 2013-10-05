package pl.lwitkowski.as3lib.locale.bundles {
	import pl.lwitkowski.as3lib.locale.ILocaleResourceBundle;

	import flash.events.EventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class SimpleResourceBundle extends EventDispatcher implements ILocaleResourceBundle 
	{
		private var _data:Object = null;
		
		public function SimpleResourceBundle(data:Object) {
			_data = data;
		}
		
		public function load() : void {
			// ntbd
		}
		public function get ready() : Boolean {
			return true;
		}

		public function getString(key:String):String {
			return (_data[key] as String);
		}
	}
}
