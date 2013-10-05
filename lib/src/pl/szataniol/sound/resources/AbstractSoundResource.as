package pl.szataniol.sound.resources {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class AbstractSoundResource extends EventDispatcher {

		private var _resourceType : String;
		
		protected var _sound:Sound;

		public function AbstractSoundResource(resourceType : String) {
			
			_resourceType = resourceType;
		}

		public function get resourceType() : String {
			return _resourceType;
		}
		
		public final function handleReady() : void {
			
			createSoundInstance();
			
 			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function handleLoadingStart():void {
		}

		protected function createSoundInstance() : void {
		}

		public function get sound() : Sound {
			
			return _sound;
		}
	}
}
