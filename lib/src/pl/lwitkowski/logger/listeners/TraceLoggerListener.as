package pl.lwitkowski.logger.listeners {
	import pl.lwitkowski.logger.Log;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class TraceLoggerListener implements ILoggerListener 
	{
		private var _channelFilter:RegExp;
		
		public function TraceLoggerListener(channelFilter:RegExp = null) {
			_channelFilter = channelFilter;
		}
		
		public function onLog(log:Log):void {
			if(_channelFilter) {
				_channelFilter.lastIndex = -1;
				if(! _channelFilter.test(log.channelId)) {
					return; 
				}
			}
			trace("["+log.channelId+"] "+LogFormatter.format(log, false));
		}
	}
}
