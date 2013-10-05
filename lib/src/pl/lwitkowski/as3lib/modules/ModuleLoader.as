package pl.lwitkowski.as3lib.modules {
	import pl.lwitkowski.logger.LoggerChannel;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
    public class ModuleLoader extends Loader 
    {
        // events
        public static const LOAD_START:String = "contentLoadStart"; // Event        public static const LOAD_PROGRESS:String = ProgressEvent.PROGRESS; // Event        public static const LOAD_COMPLETE:String = Event.COMPLETE; // Event
        public static const INIT_START:String = "contentInitStart"; // Event
        public static const INIT_COMPLETE:String = "contentInitComplete"; // Event
        
        public static const LOAD_ERROR:String = "contentLoadError"; // Event        
        public static const UNLOAD:String = "unload"; // Event
        
        // data
        private var _id:String;
        private var _url:String;
        
        private var _loading:Boolean = false;        private var _loaded:Boolean = false;
        
        private var _logger:LoggerChannel = null;
        private var _hasInitPhase:Boolean = false;
        
        public function ModuleLoader(id:String, url:String, logger:LoggerChannel = null, hasInitPhase:Boolean = false) {
            _id = id;
            _url = url;
            _logger = logger;
            _hasInitPhase = hasInitPhase;

			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
        	contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
            contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError);
		}
		
		public function get id():String {
			return _id;
		}
		public function get url():String {
			return _url;
		}
        
        public function loadModule(vars:Object = null, domain:ApplicationDomain = null):void {
            //_loader.load(id, vars, options);
            var request:URLRequest = new URLRequest(_url);
            request.method = URLRequestMethod.GET;
            if(vars) {
            	if(!request.data) {
            		request.data = new URLVariables();
            	}
            	for(var i:String in vars) {
            		request.data[i] = vars[i];
            	}
            }
            load(request, new LoaderContext(false, domain || ApplicationDomain.currentDomain));
            
            if(_logger) _logger.info("Module.loadModule "+id+" ("+request.url+")");
            
        	_loading = true;
        	_loaded = false;
            dispatchEvent(new Event(LOAD_START));
        }
        
        public function loadUsingLastContext():void {
        	loadModule(); // TODO
        }
        
        public function unloadModule():void {
        	if(_logger) _logger.info("Module.unloadModule "+_id);
            
        	stopLoading();
        	
        	try {
        		unloadAndStop(true);
        	} catch(e:Error) {
	        	try {
	        		unload();
	        	} catch(e:Error) {}
	        }
        	
        	_loading = false;
        	_loaded = false;
        	dispatchEvent(new Event(UNLOAD));
        }
        
        public function stopLoading():void {
        	try {
        		close();
        	} catch(e:Error) {}
        	
        	_loading = false;
        }
        
        protected function handleLoadProgress(e:ProgressEvent):void {
        	dispatchEvent(e);			
		}		
        protected function handleLoadComplete(e:Event):void {
        	_loading = false;
        	_loaded = true;
        	
        	//content.addEventListener(Event.UNLOAD, handleContentUnload);
			dispatchEvent(new Event(Event.COMPLETE));
			
			if(hasInitPhase) {
				content.addEventListener(INIT_COMPLETE, handleContentInitComplete, false, 0, true);
        		dispatchEvent(new Event(INIT_START));
			}
		}
		protected function handleLoadError(e:IOErrorEvent):void {
			dispatchEvent(new Event(LOAD_ERROR));
		}
		
		// content event listeners
		protected function handleContentInitComplete(e:String):void {
			content.removeEventListener(INIT_COMPLETE, handleContentInitComplete, false);
        	dispatchEvent(new Event(INIT_COMPLETE));
		}
		//protected function handleContentUnload(e:String):void {
		//	dispatchEvent(new Event(Event.UNLOAD));
		//}
		
		public function get hasInitPhase():Boolean {
			return _hasInitPhase;
		}

		public function get loading() : Boolean {
			return _loading;
		}

		public function get loaded() : Boolean {
			return _loaded;
		} 
	}
}
