package pl.szataniol.sound.identifiers.concrete {

	import pl.szataniol.sound.identifiers.AbstractSound;
	import pl.szataniol.sound.playback.PlaybackModes;
	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.playback.SoundChannelWrapper;
	import pl.szataniol.sound.resources.AbstractSoundResource;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;






	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class SoundIdentifier extends AbstractSound {

		private var _resource : AbstractSoundResource;

		private var _sound : Sound;

		public function SoundIdentifier(identifier : String, resourceProperties : AbstractSoundResource, playbackProperties : PlaybackProperties = null) {

			super(identifier, playbackProperties);

			_resource = resourceProperties;
			_resource.addEventListener(Event.COMPLETE, resourceLoadedHandler);
		}

		private function resourceLoadedHandler(event : Event) : void {

			_sound = _resource.sound;
			_ready = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get resourceProperties() : AbstractSoundResource {

			return _resource;
		}

		public function play(playbackProperties : PlaybackProperties = null) : SoundChannelWrapper {

			if(!_ready) {
				
				trace("Sound " + identifier + " is not ready yet!"); 
				return null;
			}
			
			if(_muted) {
				
				return null;
			}
			
			if(!playbackProperties) {
				playbackProperties = _playbackProperties;
			}

			if (playbackProperties.playbackMode == PlaybackModes.KILL_PREVIOUS) {

				_lock = false;
				killAll();
			}

			if (!_lock) {

				if (playbackProperties.playbackMode == PlaybackModes.ONE_INSTANCE) {

					_lock = true;
				}
				
				return _play(playbackProperties);

			}
			
			return null;
		}

		private function _play(playbackProperties : PlaybackProperties) : SoundChannelWrapper {

			var soundChannelWrapper : SoundChannelWrapper = _playSoundChannel(playbackProperties);

			_activeSoundChannels.push(soundChannelWrapper);

			return soundChannelWrapper;
		}

		private function _playSoundChannel(playbackProperties : PlaybackProperties) : SoundChannelWrapper {
			
			var soundChannel : SoundChannel = _sound.play(playbackProperties.startTime, playbackProperties.loops, playbackProperties.soundTransform);
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			return new SoundChannelWrapper(identifier, soundChannel, playbackProperties);
		}

		private function soundCompleteHandler(event : Event) : void {

			handleSoundCompleted(SoundChannel(event.target), true);
		}

        public function get length():Number {

            return _sound.length;
        }
	}
}

