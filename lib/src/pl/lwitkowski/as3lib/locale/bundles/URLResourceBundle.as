package pl.lwitkowski.as3lib.locale.bundles {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import pl.lwitkowski.as3lib.locale.ILangFileParser;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class URLResourceBundle extends AbstractAsyncBundle
	{
		private var _resourceUrl:String;
		private var _dataLoader:URLStream;
		
		public function URLResourceBundle(fileUrl:String, parser:ILangFileParser) {
			super(parser);
			_resourceUrl = fileUrl;

			_dataLoader = new URLStream();
			_dataLoader.addEventListener(Event.COMPLETE, handleFileLoadComplete);
			_dataLoader.addEventListener(IOErrorEvent.IO_ERROR, handleFileLoadError);
		}
		
		override public function load():void {
			_dataLoader.load(new URLRequest(_resourceUrl));
		}
		
		protected function get loader():URLStream {
			return _dataLoader;
		}
		protected function handleFileLoadComplete(e:Event):void {
			var bytes:ByteArray = new ByteArray();
			_dataLoader.readBytes(bytes, 0, _dataLoader.bytesAvailable);
			this.bytes = bytes;
		}
		protected function handleFileLoadError(e:IOErrorEvent):void {
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
		}
	}
}
