package pl.lwitkowski.logger {
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import pl.lwitkowski.as3lib.formatters.DateFormatter;
	import pl.lwitkowski.as3lib.utils.PhraseDetector;
	import pl.lwitkowski.logger.listeners.ILoggerListener;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Logger 
	{
		private static var _instance:Logger;
		protected static var _initPhase:Boolean;
		
		private var _enabled:Boolean = false;
		private var _loggerId:String;
		private var _loggerRawId:String;
		private var _channels:Object; 
		private var _listeners:Array;
		private var _phraseDetector:PhraseDetector;
		
		public function Logger() {
			if(!_initPhase) throw new IllegalOperationError("Singleton");
			
			_loggerId = "logger ("+DateFormatter.format(new Date(), "HH:NN:SS") + ")";
			_channels = new Object();
			_listeners = [];
		}
		
		public static function getInstance():Logger {
			if(!_instance) {
				_initPhase = true;
				_instance = new Logger();
				_initPhase = false;
			}
			return _instance;
		}
		
		public function set id(value:String):void {
			if(_loggerRawId != value) {
				_loggerRawId = value;
				_loggerId = _loggerRawId +" ("+DateFormatter.format(new Date(), "HH:NN:SS") + ")";
			}
		}
		public function get id() : String {
			return _loggerId;
		}
		
		public function enable():void {
			if(!_enabled) {
				_enabled = true;
				getChannel().debug("** Logger enabled");
			}
		}	
		// Wyłącza logger
		public function disable():void {
			if(_enabled) {
				getChannel().debug("** Logger disabled");
				_enabled = false;
			}
		}	
		
		public static function getChannel(id:String = "main"):LoggerChannel {
			if(!getInstance()._channels[id]) {
				getInstance().addChannel(new LoggerChannel(id));
			}
			return getInstance()._channels[id] as LoggerChannel;
		}
		
		private function addChannel(channel:LoggerChannel):void {
			_channels[channel.id] = channel;
			channel.addEventListener(LogEvent.LOG, handleChannelLog);
		}
		
		public function addListener(listener:ILoggerListener):void {
			removeListener(listener);
			_listeners.push(listener);
		}
		public function removeListener(listener:ILoggerListener):void {
			var index:int = _listeners.indexOf(listener);
			if(index >= 0) {
				_listeners.splice(index, 1);
			}
		}
		
		public function initAutoEnable(stage:Stage, phraseHash:String, phraseLength:int):void {
			_phraseDetector = new PhraseDetector(phraseHash, phraseLength, stage);
			_phraseDetector.addEventListener(PhraseDetector.PHRASE_DETECTED, handleEnablePhraseDetected);
			if(stage.loaderInfo.parameters['logger_pass']) {
				_phraseDetector.check(decodeURI(stage.loaderInfo.parameters['logger_pass'] as String));
			}
		}
		
		// PRIVATE
		private function handleChannelLog(e:LogEvent):void {
			if(_enabled) {
				for each(var listener:ILoggerListener in _listeners) {
					listener.onLog(e.log);
				}
			}
		}
		private function handleEnablePhraseDetected(event:Event):void {
			_phraseDetector.removeEventListener(PhraseDetector.PHRASE_DETECTED, handleEnablePhraseDetected);
			_phraseDetector.dispose();
			_phraseDetector = null;
			enable();
		}
	}
}
