package pl.lwitkowski.as3lib.net {
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class LoaderExt extends Loader 
	{
		private var _maxRetries : int;
		private var _retries : int;
		private var _retryTimeout : uint;
		private var _request : URLRequest;
		private var _context : LoaderContext;
		
		public function LoaderExt(maxRetries:int = 1, request : URLRequest = null) {
			_maxRetries = maxRetries;
			addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, int.MAX_VALUE);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError, false, int.MAX_VALUE);
		}
		
		override public function load(request : URLRequest, context : LoaderContext = null) : void {
			_retries = _maxRetries;
			_request = request;
			_context = context;
			super.load(request, context);
		}

		override public function close() : void {
			clearTimeout(_retryTimeout);
			_request = null;
			super.close();
		}
		override public function unload() : void {
			clearTimeout(_retryTimeout);
			_request = null;
			super.unload();
		}
		
		private function retry():void {
			_retries -= 1;
			super.load(_request, _context);
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
