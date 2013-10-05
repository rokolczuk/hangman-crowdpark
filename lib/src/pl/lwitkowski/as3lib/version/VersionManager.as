package pl.lwitkowski.as3lib.version {
	import pl.lwitkowski.as3lib.events.VersionEvent;
	import pl.lwitkowski.logger.LoggerChannel;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class VersionManager extends EventDispatcher
	{		
		/* INSTANCE */
		private var _loader:URLLoader;

		private var _versionFileUrl:String;
		private var _intervalId:uint;
		
		private var _currentVersion:Version = null;
		private var _availableVersion : Version = null;
		private var _loggerChannel : LoggerChannel;
		
		public function VersionManager(versionFileUrl:String = "", loggerChannel:LoggerChannel = null) {
	 		_loggerChannel = loggerChannel;
	 		
	 		_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handleFirstLoadComplete, false, 1);
			_loader.addEventListener(Event.COMPLETE, handleLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
			
			if(versionFileUrl && versionFileUrl.length > 0) {
				this.versionFileUrl = versionFileUrl;
			}
	 	}
	 	
	 	public function set versionFileUrl(value:String):void {
			if(_loggerChannel) _loggerChannel.info("VersionManager \"versionFileUrl\" setter ("+value+")");
			_versionFileUrl = value;
		}
	
		public function get currentVersionAvailable():Boolean {
			return Boolean(_currentVersion);
		}
	
		public function get currentVersion():Version {
			return _currentVersion; 
		}
		public function get availableVersion():Version {
			return _availableVersion;
		}
		
		// [ms]
		public function set checkPeriod(value:int):void {
			if(value > 0) {
				clearInterval(_intervalId);
				_intervalId = setInterval(loadNow, value);
			}
		}
		
		public function loadNow():void {
			if(_loggerChannel) _loggerChannel.info("VersionChecker.loadNow() ["+_versionFileUrl+"]");
			if(_versionFileUrl) {
				_loader.load(new URLRequest(_versionFileUrl + "?rand=" + (new Date()).getTime()));
				//_loader.load(new URLRequest(_versionFileUrl));
			} else {
				throw new Error("Version file url is undefined");
			}
		}
		
		protected function handleFirstLoadComplete(e:Event):void {
			_loader.removeEventListener(Event.COMPLETE, handleFirstLoadComplete);
			
			var xml:XML = new XML(_loader.data);
			_currentVersion = new Version(xml.@major, xml.@minor, xml.@build);
		}
		
		protected function handleLoadComplete(e:Event):void {
			var xml:XML = new XML(_loader.data);
			if(_loggerChannel) _loggerChannel.info("VersionChecker.handleLoadComplete() data ["+xml+"]");
			_availableVersion = new Version(xml.@major, xml.@minor, xml.@build);
			
			dispatchEvent(new VersionEvent(VersionEvent.VERSION_LOADED, _currentVersion, _availableVersion));
			
			if(availableVersion.fullVersion != currentVersion.fullVersion) {
				clearInterval(_intervalId);
				dispatchEvent(new VersionEvent(VersionEvent.NEW_VERSION_AVAILABLE, _currentVersion, _availableVersion));
			}
		}
		
		protected function handleLoadError(e:IOErrorEvent):void {
			if(_loggerChannel) _loggerChannel.error("VersionChecker.handleLoadError() "+e.toString());
			_currentVersion = new Version("0", "0", "0");
			_availableVersion = new Version("0", "0", "0");
			dispatchEvent(new VersionEvent(VersionEvent.ERROR));
		}
	}
}	
