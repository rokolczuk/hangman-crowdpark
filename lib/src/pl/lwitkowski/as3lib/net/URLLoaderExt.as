package pl.lwitkowski.as3lib.net {
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class URLLoaderExt extends URLLoader 
	{
		private var _maxRetries : int;
		private var _retries : int;
		private var _retryTimeout : uint;
		private var _request : URLRequest;
		
		public function URLLoaderExt(maxRetries:int = 1, request : URLRequest = null) {
			super();
			_maxRetries = maxRetries;
			addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, int.MAX_VALUE);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError, false, int.MAX_VALUE);
		}
		
		
		override public function load(request : URLRequest) : void {
			_retries = _maxRetries;
			_request = request;
			super.load(request);
		}

		override public function close() : void {
			clearTimeout(_retryTimeout);
			_request = null;
			super.close();
		}
		
		private function retry():void {
			_retries -= 1;
			super.load(_request);
		}

		private function handleSecurityError(e : SecurityErrorEvent) : void {
			if(_retries > 0) {
				e.stopImmediatePropagation();
				_retryTimeout = setTimeout(retry, 100);
			}
		}

		private function handleIOError(e : IOErrorEvent) : void {
			if(_retries > 0) {
				e.stopImmediatePropagation();
				_retryTimeout = setTimeout(retry, 100);
			}
		}
	}
}
