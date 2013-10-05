package pl.szataniol.sound.resources.concrete {

	import pl.szataniol.sound.resources.AbstractSoundResource;
	import pl.szataniol.sound.resources.SoundResourceType;

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class ExternalSoundResource extends AbstractSoundResource {

		private var _path : String;
		private var _loaderName : String;

		public function ExternalSoundResource(path : String) {

			super(SoundResourceType.EXTERNAL_FILE);
			_path = path;
		}

		public function get path() : String {
			
			return _path;
		}
		
		private function get loader():MP3Loader {
			
			return LoaderMax.getLoader(_loaderName);
		}
		
		override protected function createSoundInstance() : void {
			
			_sound = loader.content;
		}

		public function set loaderName(newLoaderName : String) : void {
			
			_loaderName = newLoaderName;
			loader.addEventListener(LoaderEvent.COMPLETE, externalFileLoadedHandler);
		}

		private function externalFileLoadedHandler(event : LoaderEvent) : void {

			loader.removeEventListener(LoaderEvent.COMPLETE, externalFileLoadedHandler);
			handleReady();
		}
	}
}
