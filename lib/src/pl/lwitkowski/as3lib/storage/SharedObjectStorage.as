package pl.lwitkowski.as3lib.storage {
	import flash.net.SharedObject;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class SharedObjectStorage implements IStorage 
	{
		private var _sharedObjectName:String;
		private var _localPath:String = "/"; 
		private var _secure : Boolean = false;
		private var _autoFlush : Boolean;
		private var _so : SharedObject;
		
		public function SharedObjectStorage(sharedObjectName:String, localPath:String = "/", secure:Boolean = false, autoFlush:Boolean = true) {
			_sharedObjectName = sharedObjectName;
			_localPath = localPath; 
			_secure = secure;
			_autoFlush = autoFlush;
		}
		
		public function setProperty(key:String, value:*):* {
			so.data[key] = value;
			if(_autoFlush) flush();
			return value;
		}
		
		public function getProperty(key:String):* {
			return so.data[key];
		}
		
		public function clear():void {
			so.clear();
			flush();		
		}
		
		public function flush():void {
			try {
				so.flush();
			} catch(e:Error) {}
		}
		
		private function get so():SharedObject {
			if(_so == null) {
				_so = SharedObject.getLocal(_sharedObjectName, _localPath, _secure);
			}
			return _so;
		}
	}
}