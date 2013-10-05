package pl.lwitkowski.as3lib.events 
{
	import pl.lwitkowski.as3lib.modules.ModuleLoader;

	import flash.events.Event;
	
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class ModuleStackProgressEvent extends ModuleStackEvent 
	{
		public static const MODULE_LOAD_PROGRESS:String = "moduleLoadProgress";
		
		private var _bytesLoaded:uint = 0;
		private var _bytesTotal:uint = 0;
		
		public function ModuleStackProgressEvent(type:String, loader:ModuleLoader, bytesLoaded:uint, bytesTotal:uint) {
			super(type, loader);
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
		}

		public function get bytesLoaded():uint {
			return _bytesLoaded;
		}

		public function get bytesTotal():uint {
			return _bytesTotal;
		}

		override public function clone() : Event {
			return new ModuleStackProgressEvent(type, loader, bytesLoaded, bytesTotal);
		}

	}
}
