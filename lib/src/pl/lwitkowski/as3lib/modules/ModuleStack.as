package pl.lwitkowski.as3lib.modules 
{
	import pl.lwitkowski.as3lib.events.ModuleStackEvent;
	import pl.lwitkowski.as3lib.events.ModuleStackProgressEvent;
	import pl.lwitkowski.logger.LoggerChannel;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class ModuleStack extends Sprite
	{		
		// const
    	public static const NO_FADE_IN:uint = 1 << 0;
    	
    	protected var _stack:Array;
    	protected var _logger:LoggerChannel = null;
    	
    	private var _moduleProxies:Object;
    	
		public function ModuleStack(logger:LoggerChannel = null) {
			_stack = [];
			_logger = logger;
			
			_moduleProxies = {};
		}
		
		public function registerModule(module:ModuleLoader):void {
			if(module) {
				_moduleProxies[module.id] = module;
				
				module.addEventListener(ModuleLoader.LOAD_START, handleLoadStart);
	 			module.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
        		module.addEventListener(Event.COMPLETE, handleLoadComplete);
        		
        		module.addEventListener(ModuleLoader.INIT_START, handleModuleInitStart);
        		module.addEventListener(ModuleLoader.INIT_COMPLETE, handleModuleInitComplete);
            	
            	module.addEventListener(ModuleLoader.LOAD_ERROR, handleLoadError);				
            	
            	//module.addEventListener(Event.UNLOAD, handleModuleUnload);
			}
		}
		
		public function getModule(id:String):ModuleLoader {
			return _moduleProxies[id] as ModuleLoader;
		}
		
		//
		public function pushStack(module:ModuleLoader):void {
			for(var i:int = 0; i < _stack.length; ++i) {
				if(_stack[i] == module) {
					_stack.splice(i, 1);
					--i;
				}
			}
			_stack.push(module);
		}
		
		public function unloadCurrentModule():void {
			kupa(null);
		}
		
		// EVENTS
        protected function handleLoadStart(e:Event):void {
        	var module:ModuleLoader = e.currentTarget as ModuleLoader;
        	for(var i:int = 0; i < _stack.length; ++i) {
        		if(_stack[i] != module) {
        			ModuleLoader(_stack[i]).stopLoading();
        		}
        	}
        	pushStack(module);
        	
            if(_logger) _logger.debug("ModuleLoader.onLoadStart id["+ModuleLoader(e.currentTarget).id+"]");
        	dispatchEvent(new ModuleStackEvent(ModuleStackEvent.MODULE_LOAD_START, module));
        }
        protected function handleLoadProgress(e:ProgressEvent):void {
          	if(_logger) _logger.debug("ModuleLoader.handleLoadProgress id["+ModuleLoader(e.currentTarget).id+"] progress["+Math.round(1000 * e.bytesLoaded/e.bytesTotal)/1000+"]");
        	dispatchEvent(new ModuleStackProgressEvent(ModuleStackProgressEvent.MODULE_LOAD_PROGRESS, 
        				e.currentTarget as ModuleLoader, e.bytesLoaded, e.bytesTotal));
        }
		protected function handleLoadComplete(e:Event):void {
        	var module:ModuleLoader = ModuleLoader(e.currentTarget);
        	if(_logger) _logger.info("ModuleLoader.handleLoadComplete id["+module.id+"]");
        	dispatchEvent(new ModuleStackEvent(ModuleStackEvent.MODULE_LOAD_COMPLETE, module));
        	
        	if(module.hasInitPhase) {
        		
        	} else {
        		kupa(module);
        	}
        }
        
        protected function handleModuleInitStart(e:Event):void {
        	if(_logger) _logger.info("ModuleLoader.handleModuleInitStart id["+ModuleLoader(e.currentTarget).id+"]");
        }
        protected function handleModuleInitComplete(e:Event):void {
        	if(_logger) _logger.info("ModuleLoader.handleModuleInitComplete id["+ModuleLoader(e.currentTarget).id+"]");
        
        	// mozna wywalic/schowac poprzeni moduł
        	kupa(e.currentTarget as ModuleLoader);
		}

		private function kupa(moduleLoader:ModuleLoader):void {
			var module:ModuleLoader;
        	for(var i:int = 0; i < _stack.length; ++i) {
        		module = ModuleLoader(_stack[i]);
        		if(module != moduleLoader) {
        			module.unloadModule();
        			if(contains(module)) removeChild(module);
        		}
        	}
			if(moduleLoader) addChild(moduleLoader);
		}

		protected function handleLoadError(e:Event):void {
        	if(_logger) _logger.error("ModuleLoader.handleLoadError id["+ModuleLoader(e.currentTarget).id+"]");
        	dispatchEvent(new ModuleStackEvent(ModuleStackEvent.MODULE_LOAD_ERROR, e.currentTarget as ModuleLoader));
        }
        
//        protected function handleModuleUnload(e:Event):void {
//        	return;
//        	var module:ModuleLoader = event.currentTarget as ModuleLoader;
//        	if(_stack.length > 1) {
//        		ModuleLoader(_stack[_stack.length - 2]).loadUsingLastContext();
//       		} else {
//       			_stack.pop();
//       			module.unloadModule();
//       			if(contains(module)) removeChild(module);
//        	}
//		}
    }
}
