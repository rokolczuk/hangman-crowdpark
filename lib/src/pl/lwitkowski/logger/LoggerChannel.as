package pl.lwitkowski.logger {
	import mx.utils.ObjectUtil;

	import flash.events.EventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class LoggerChannel extends EventDispatcher
	{
		private var _id:String;
		
		public function LoggerChannel(id:String) {
			_id = id;
		}
		
		public function get id():String {
			return _id;
		}	
		public function debug(message:String):void {
			log(Log.DEBUG, message);
		}		
		public function info(message:String):void {
			log(Log.INFO, message);
		}		
		public function warning(message:String):void {
			log(Log.WARNING, message);
		}		
		public function error(message:String):void {
			log(Log.ERROR, message);
		}		
		public function fatal(message:String):void {
			log(Log.FATAL, message);
		}
		
		public function logObject(target:Object, level:uint = 1):void {
			log(level, ObjectUtil.toString(target));
		}
		
		public function log(level:uint, message:String):void {
			dispatchEvent(
				new LogEvent(
					LogEvent.LOG, 
					new Log(_id, level, new Date(), message)
				)
			);
		}
	}
}
