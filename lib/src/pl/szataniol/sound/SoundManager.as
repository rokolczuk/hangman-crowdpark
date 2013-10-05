package pl.szataniol.sound {

	import pl.szataniol.sound.events.SoundsLoadingProgressEvent;
	import pl.szataniol.sound.identifiers.concrete.SoundGroupIdentifier;
	import pl.szataniol.sound.identifiers.concrete.SoundIdentifier;
	import pl.szataniol.sound.identifiers.concrete.SoundSequenceIdentifier;
	import pl.szataniol.sound.resources.SoundResourceType;
	import pl.szataniol.sound.resources.concrete.ExternalSoundResource;
	import pl.szataniol.sound.resources.concrete.LibrarySoundResources;
	import pl.szataniol.sound.resources.concrete.LinkageResource;

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;

	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

import pl.szataniol.sound.resources.concrete.SimpleSoundResource;


[Event(name="soundsLoadingProgress", type="pl.szataniol.sound.events.SoundsLoadingProgressEvent")]
	[Event(name="soundsLoadingComplete", type="pl.szataniol.sound.events.SoundsLoadingProgressEvent")]
	[Event(name="soundLoadingError", type="pl.szataniol.sound.events.SoundsLoadingProgressEvent")]

	public class SoundManager extends EventDispatcher {

		private static var _instance : SoundManager;

		private var _loader : LoaderMax = new LoaderMax({auditSize :false, name:"soundsLoader", onProgress:progressHandler, onComplete:completeHandler, onError:errorHandler});

		private var _sounds : Dictionary = new Dictionary();
		private var _groups : Dictionary = new Dictionary();
		private var _sequences : Dictionary = new Dictionary();
		
		public static function getInstance() : SoundManager {

			return (_instance || (_instance = new SoundManager()));
		}

		public function SoundManager() {
		}

		public function registerSound(sound : SoundIdentifier) : void {

			if (!_sounds[sound.identifier]) {

				_sounds[sound.identifier] = sound;
				_loadSound(sound);
				
			} else {
				trace("sound with identifier " + sound.identifier + " is already registered!");
			}
		}
		
		public function getSound(identifier:String):SoundIdentifier {
			
			return _sounds[identifier];
		}

		public function registerGroup(group : SoundGroupIdentifier) : void {

			if (!_groups[group.identifier]) {

				_groups[group.identifier] = group;
			} else {
				trace("group with identifier " + group.identifier + " is already registered!");
			}
		}

		public function getGroup(identifier : String) : SoundGroupIdentifier {
		
			return _groups[identifier];
		}
		
		public function registerSequence(sequence:SoundSequenceIdentifier):void {
			
			if (!_sequences[sequence.identifier]) {

				_sequences[sequence.identifier] = sequence;
				
			} else {
				
				trace("sequence with identifier " + sequence.identifier + " is already registered!");
			}	
		}
		
		public function getSequence(identifier:String):SoundSequenceIdentifier {
			
			return _sequences[identifier];
		}

		public function startLoading() : void {

			_loader.load();
		}
		
		public function mute():void {
			
			for each (var sound : SoundIdentifier in _sounds) {
				
				sound.mute();
			}
		}
	
		public function unmute():void {
			
			for each (var sound : SoundIdentifier in _sounds) {
				
				sound.unmute();
			}
		}

		private function _loadSound(sound : SoundIdentifier) : void {

			switch(sound.resourceProperties.resourceType) {

				case SoundResourceType.EXTERNAL_FILE:

					_loader.append(new MP3Loader(ExternalSoundResource(sound.resourceProperties).path, {name:"external_" + sound.identifier, autoPlay:false}));
					ExternalSoundResource(sound.resourceProperties).loaderName = "external_" + sound.identifier;
					break;

				case SoundResourceType.LIBRARY:

					if (!LibrarySoundResources(sound.resourceProperties).libraryInLoadingQueue) {

						var libraryPath : String = LibrarySoundResources(sound.resourceProperties).libraryPath;
						_loader.append(new SWFLoader(libraryPath, {name:"library_" + libraryPath}));
					}

					break;

				case SoundResourceType.LINKAGE:

					LinkageResource(sound.resourceProperties).handleReady();

					break;
                case SoundResourceType.SIMPLE:

                    SimpleSoundResource(sound.resourceProperties).handleReady();
                    break;
			
				default:

					throw new IllegalOperationError("Unkown sound resource type: " + sound.resourceProperties.resourceType);
			}

			sound.resourceProperties.handleLoadingStart();
		}

		private function progressHandler(event : LoaderEvent) : void {

			var progressEvent : SoundsLoadingProgressEvent = new SoundsLoadingProgressEvent(SoundsLoadingProgressEvent.PROGRESS);
			progressEvent.progressPercent = _loader.rawProgress;
			dispatchEvent(progressEvent);
		}

		private  function completeHandler(event : LoaderEvent) : void {

			dispatchEvent(new SoundsLoadingProgressEvent(SoundsLoadingProgressEvent.COMPLETE));
		}

        private function errorHandler(event:LoaderEvent):void {

            var errorEvent:SoundsLoadingProgressEvent = new SoundsLoadingProgressEvent(SoundsLoadingProgressEvent.ERROR);
            errorEvent.error = event.text;
            dispatchEvent(errorEvent);
        }
	}
}
