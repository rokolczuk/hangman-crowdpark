package pl.lwitkowski.as3lib.storage 
{
	import flash.utils.Dictionary;
	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class RuntimeStorage implements IStorage 
	{
		private var _data:Dictionary;
		
		public function RuntimeStorage() {
			_data = new Dictionary();
		}
		
		public function setProperty(key:String, value:*):* {
			_data[key] = value;
			return value;
		}
		public function getProperty(key:String):* {
			return _data[key];
		}
		
		public function clear():void {
			_data = new Dictionary();
		}
	}
}