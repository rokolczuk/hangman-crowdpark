package pl.lwitkowski.as3lib.events {
	import pl.lwitkowski.as3lib.version.Version;

	import flash.events.Event;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class VersionEvent extends Event {
		
		public static const VERSION_LOADED:String = "versionLoaded";
		public static const NEW_VERSION_AVAILABLE:String = "newVersionAvailable";
		
		public static const ERROR:String = "error";
		
		protected var _currentVersion:Version;
		protected var _availableVersion:Version;
		
		public function VersionEvent(type:String, currentVersion:Version = null, availableVersion:Version = null) {
			super(type);
			
			_currentVersion = currentVersion;    
			_availableVersion = availableVersion;
		}
		
		public function get currentVersion():Version {
			return _currentVersion;
		}
		
		public function get availableVersion():Version {
			return _availableVersion;
		}
		
		override public function clone():Event {
			return new VersionEvent(type, currentVersion, availableVersion);
		} 
		
		override public function toString():String {
			return "VersionEvent type["+type+"] currentVersion["+currentVersion+"] availableVersion["+availableVersion+"]";
		} 
	}
}
