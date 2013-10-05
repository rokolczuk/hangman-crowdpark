package pl.lwitkowski.logger.listeners {
	import flash.text.TextField;
	import pl.lwitkowski.logger.Log;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class TextFieldListener implements ILoggerListener 
	{
		private var _textField:TextField;
		private var _channelFilter : RegExp;
		private var _html : Boolean;
		
		public function TextFieldListener(textField:TextField, channelFilter:RegExp = null, html:Boolean = false) {
			_textField = textField;
			_channelFilter = channelFilter;
			_html = html;
		}
		
		public function onLog(log:Log):void {
			if(_channelFilter) {
				_channelFilter.lastIndex = -1;
				if(! _channelFilter.test(log.channelId)) {
					return; 
				}
			}
			var logText:String = "["+log.channelId+"] "+LogFormatter.format(log, _html);
			if(_html) {
				_textField.htmlText += logText + "<br>"; 
			} else {
				_textField.appendText(logText + "\n");
			}
		}
	}
}
