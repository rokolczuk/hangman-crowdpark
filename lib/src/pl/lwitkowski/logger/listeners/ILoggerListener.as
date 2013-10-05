package pl.lwitkowski.logger.listeners {
	import pl.lwitkowski.logger.Log;
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public interface ILoggerListener {
		function onLog(log:Log):void;
	}
}
