package pl.lwitkowski.logger.listeners {
	import pl.lwitkowski.as3lib.formatters.DateFormatter;
	import pl.lwitkowski.logger.Log;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class LogFormatter
	{
		protected static const HTML_TEMPLATE:String = "<span class=\"timestamp\">[[TIMESTAMP]]</span> <span class=\"[LEVEL_STYLE_CLASS]\">[[LEVEL_NAME]] [MESSAGE]</span>"; 
		protected static const PLAIN_TEXT_TEMPLATE:String = "[[TIMESTAMP]] [[LEVEL_NAME]] [MESSAGE]"; 
		
		public static function format(log:Log, html:Boolean = true):String {
			var logString:String = html ? HTML_TEMPLATE : PLAIN_TEXT_TEMPLATE;
			logString = logString.replace("[TIMESTAMP]", DateFormatter.format(log.timestamp, "DD/MM HH:NN:SS.mmm"));
			logString = logString.replace("[LEVEL_STYLE_CLASS]", getLevelStyleClassName(log.level));
			logString = logString.replace("[LEVEL_NAME]", getLevelName(log.level));
			logString = logString.replace("[MESSAGE]", log.message.split('&#62;').join(">").split('&#60;').join("<"));
			return logString;
		}				
		
		protected static function getLevelName(level:int):String {
			switch(level) {
				case Log.DEBUG:		return "DEBUG";
				case Log.INFO:		return "INFO";
				case Log.WARNING:	return "WARNING";
				case Log.ERROR:		return "ERROR";
				case Log.FATAL:		return "FATAL";
				default:			return "";
			}
		}
		
		protected static function getLevelStyleClassName(level:int):String {
			switch(level) {
				case Log.DEBUG:		return "debug";
				case Log.INFO:		return "info";
				case Log.WARNING:	return "warning";
				case Log.ERROR:		return "error";
				case Log.FATAL:		return "fatal";
				default:			return "";
			}
		}
	}
}