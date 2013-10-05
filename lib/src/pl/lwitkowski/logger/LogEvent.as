package pl.lwitkowski.logger {
	import flash.events.Event;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	internal class LogEvent extends Event 
	{
		public static const LOG:String = "log";
		
		protected var _log:Log;
		
		public function LogEvent(type:String, log:Log) {
			super(type);
			_log = log;
		}
		
		public function get log():Log {
			return _log;
		}
		
		override public function clone():Event {
			return new LogEvent(type, log);
		} 
	}
}
