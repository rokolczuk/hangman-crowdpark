package pl.lwitkowski.logger.listeners {
	import flash.events.AsyncErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.net.registerClassAlias;
	import flash.system.Security;
	import pl.lwitkowski.logger.Log;
	import pl.lwitkowski.logger.Logger;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class LocalConnectionListener implements ILoggerListener 
	{
		public static const OUTPUT_CONNECTION_ID:String = "_pl.lwitkowski.logger.output";
		
		private var _connection:LocalConnection;
		private var _logger:Logger;
		
		public function LocalConnectionListener(logger:Logger) {
			_logger = logger;
			Security.allowDomain("*");
			registerClassAlias("pl.lwitkowski.logger.Log", Log);
		
			_connection = new LocalConnection();
			_connection.allowDomain('*');
			_connection.addEventListener(StatusEvent.STATUS, handleConnectionStatus);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handleConnectionError);
		}
		
		
		public function onLog(log:Log):void {
			try {
				_connection.send(OUTPUT_CONNECTION_ID, "log", _logger.id, log);
			} catch(e:Error) {}
		}
		
		private function handleConnectionStatus(event:StatusEvent):void {
			// nothing to be done
		}
		private function handleConnectionError(event:AsyncErrorEvent):void {
			// nothing to be done
		}
	}
}
