package pl.lwitkowski.as3lib.display {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class SkinUtil extends EventDispatcher 
	{
		public static const SKIN_READY:String = "skinReady";		public static const SKIN_LOAD_ERROR:String = "skinLoadError";
		
        private var _skinLoader:Loader; 
        
        private var _skinFileUrl:String;
        private var _domain:ApplicationDomain = null;
        private var _maxLoadAttempts:int = 3;
        
        private var _skin:DisplayObject;

		public function SkinUtil() {
			_skinLoader = new Loader();
    	}
		
		public function initSkinUsingEmbededAsset(assetClass:Class, domain:ApplicationDomain = null):void {
			_skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSkinLoadComplete);
			_skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleSkinLoadError);
			_skinLoader.loadBytes(
        		new assetClass(), 
        		new LoaderContext(false, domain || ApplicationDomain.currentDomain)
        	);
       	}

		public function initSkinUsingFile(skinFileUrl:String, domain:ApplicationDomain = null, 
						maxLoadAttempts:int = 3):void 
		{
        	if(maxLoadAttempts > 0) {
	        	_skinFileUrl = skinFileUrl;
	        	_domain = domain;
	        	_maxLoadAttempts = maxLoadAttempts;
	        	
	        	_skinLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleSkinLoadComplete);
    			_skinLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleSkinLoadError);
				
				var loaderContext:LoaderContext = new LoaderContext(false);
				loaderContext.applicationDomain = domain || ApplicationDomain.currentDomain;
				_skinLoader.load(new URLRequest(skinFileUrl), loaderContext);
        	}
       	}
       	
       	public function get skin():DisplayObject {
       		return _skin;
       	}

		protected function handleSkinLoadComplete(e:Event):void {
			_skin = _skinLoader.content;
    		_skinLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleSkinLoadComplete);
    		_skinLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleSkinLoadError);
			dispatchEvent(new Event(SKIN_READY));
		}
		
		protected function handleSkinLoadError(e:IOErrorEvent):void {
			_skinLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleSkinLoadComplete);
    		_skinLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleSkinLoadError);
				
			if(_skinFileUrl && (_maxLoadAttempts - 1 > 0)) {
				initSkinUsingFile(_skinFileUrl, _domain, _maxLoadAttempts - 1);
			} else {
	    		dispatchEvent(new Event(SKIN_LOAD_ERROR));
			}
		}
    }
}

