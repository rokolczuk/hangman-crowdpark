package pl.szataniol.sound.resources.concrete {

	import pl.szataniol.sound.resources.AbstractSoundResource;
	import pl.szataniol.sound.resources.SoundResourceType;

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.SWFLoader;

	import flash.media.Sound;
	import flash.utils.Dictionary;



	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class LibrarySoundResources extends AbstractSoundResource {

		private var _libraryPath : String;
		private var _assetName : String;
		
		private static var _loadingLibraries:Dictionary = new Dictionary();

		public function LibrarySoundResources(libraryPath : String, assetName : String) {
			
			super(SoundResourceType.LIBRARY);

			_assetName = assetName;
			_libraryPath = libraryPath;
		}

		public function get libraryPath() : String {
			
			return _libraryPath;
		}

		override public function handleLoadingStart() : void {
			
			_loadingLibraries[_libraryPath] = true;
			
			if(loader.status == LoaderStatus.COMPLETED){
				
				handleReady();
			} else {
				
				loader.addEventListener(LoaderEvent.COMPLETE, libraryLoadedHandler);
			}
		}

		private function libraryLoadedHandler(event : LoaderEvent) : void {
			
			handleReady();
		}
		
		public function get libraryInLoadingQueue():Boolean {
			
			return _loadingLibraries[_libraryPath];
		}
		
		private function get loader():SWFLoader {
			
			return SWFLoader(LoaderMax.getLoader("library_"+_libraryPath));
		}

		override protected function createSoundInstance() : void {
				
			try {
					
				_sound = new (loader.getClass(_assetName) as Class) as Sound;
			} catch(e:Error) {
				
				trace("missing sound " + _libraryPath, _assetName);
			}
		}
	}
}
