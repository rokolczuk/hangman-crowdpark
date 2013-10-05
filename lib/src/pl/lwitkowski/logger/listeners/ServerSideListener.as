package pl.lwitkowski.logger.listeners {
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import pl.lwitkowski.logger.Log;


	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class ServerSideListener implements ILoggerListener 
	{
		private var _url:String;
		private var _sessionId:String;
		private var _pushIntervalSeconds:int;
		private var _channelFilter:RegExp;
		
		private var _lastPushTimer:uint;
		
		private var _logs : String;
		private var _timeoutId : uint;
		
		public function ServerSideListener(url:String, sessionId:String, pushIntervalSeconds:int = 5, channelFilter:RegExp = null) {
			_url = url;
			_sessionId = sessionId;
			_pushIntervalSeconds = pushIntervalSeconds;
			_channelFilter = channelFilter;
			
			_logs = "";
			_lastPushTimer = 0;
		}
		
		public function onLog(log:Log):void {
			if(_channelFilter) {
				_channelFilter.lastIndex = -1;
				if(! _channelFilter.test(log.channelId)) {
					return; 
				}
			}
			_logs += "["+log.channelId+"] "+LogFormatter.format(log, false).split('&#60;').join('<').split('&#62;').join('>') + "\n";
			
			clearTimeout(_timeoutId);
			
			var timeFromLastPush:uint = getTimer() - _lastPushTimer; 
			if(timeFromLastPush > _pushIntervalSeconds * 1000) {
				push();
			} else {
				_timeoutId = setTimeout(push, timeFromLastPush);
			}
		}
		
		private function push():void {
			clearTimeout(_timeoutId);
			_lastPushTimer = getTimer();
			
			var request:URLRequest = new URLRequest(_url);
			request.method = URLRequestMethod.POST;
			request.data = new URLVariables();
			request.data.session_id = _sessionId;
			request.data.logs = _logs;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			loader.load(request);
			
			_logs = "";
		}

		private function handleComplete(event : Event) : void {
			event.currentTarget.removeEventListener(Event.COMPLETE, handleComplete);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
		private function handleIOError(event : IOErrorEvent) : void {
			event.currentTarget.removeEventListener(Event.COMPLETE, handleComplete);
			event.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		}
	}
}
