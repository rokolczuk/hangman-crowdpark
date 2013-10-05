package pl.lwitkowski.logger {
	import pl.lwitkowski.as3lib.formatters.DateFormatter;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Log 
	{
		// levels
		public static const DEBUG:uint = 	1 << 0;
		public static const INFO:uint = 	1 << 1;
		public static const WARNING:uint = 	1 << 2;
		public static const ERROR:uint = 	1 << 3;
		public static const FATAL:uint = 	1 << 4;
		
		public var channelId:String;
		public var level:uint;
		public var timestamp:Date;
		public var message:String;
		
		public function Log(channelId:String = "", level:uint = 0, timestamp:Date = null, message:String = "") {
			this.channelId = channelId;
			this.level = level;
			this.timestamp = timestamp;
			this.message = message;
		} 
		
		public function toString():String {
			return "log "+channelId+", "+level+", " + DateFormatter.format(timestamp, "DD MMM HH:MM:SS")+ ": "+message; 
		}
	}
}
