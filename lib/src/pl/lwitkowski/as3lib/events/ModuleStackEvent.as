package pl.lwitkowski.as3lib.events 
{
	import pl.lwitkowski.as3lib.modules.ModuleLoader;

	import flash.events.Event;
	
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class ModuleStackEvent extends Event 
	{
		public static const MODULE_LOAD_START:String = "moduleLoadStart";
		public static const MODULE_LOAD_COMPLETE:String = "moduleLoadComplete";		public static const MODULE_LOAD_ERROR:String = "moduleLoadError";
		
		private var _loader:ModuleLoader;
		
		public function ModuleStackEvent(type:String, loader:ModuleLoader) {
			super(type);
			_loader = loader;
		}
		
		public function get loader():ModuleLoader {
			return _loader;
		}

		override public function clone() : Event {
			return new ModuleStackEvent(type, loader);
		}
	}
}
