package pl.szataniol.sound.identifiers.concrete {

	import pl.szataniol.sound.identifiers.AbstractSound;
	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.playback.SoundChannelWrapper;

	import flash.events.Event;
	import flash.media.SoundChannel;




	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class SoundSequenceIdentifier extends AbstractSound {

		private var _sounds : Vector.<SoundIdentifier>;
		private var _currentSoundId : int;

		public function SoundSequenceIdentifier(identifier : String, sounds : Vector.<SoundIdentifier>, playbackProperties : PlaybackProperties = null) {

			_sounds = sounds;
			super(identifier, playbackProperties);
			initSoundSequenceIdentifier();
		}

		private function initSoundSequenceIdentifier() : void {

			checkReady(true);
		}

		private function checkReady(setListeners : Boolean) : void {

			_ready = true;

			for (var i : int = 0; i < _sounds.length; i++) {

				if (!_sounds[i].ready) {

					_ready = false;

					if (setListeners) {

						_sounds[i].addEventListener(Event.COMPLETE, soundResourceCompleteHandler);
					}
				}
			}
		}

		private function soundResourceCompleteHandler(event : Event) : void {

			event.target.removeEventListener(Event.COMPLETE, soundResourceCompleteHandler);
			checkReady(false);
		}

		public function play(playbackProperties : PlaybackProperties = null) : void {

			if (ready) {

				if (!playbackProperties) {

					playbackProperties = _playbackProperties ;
				}

				_currentSoundId = 0;
				playNext();

			} else {

				trace("SoundSequence " + identifier + " is not ready yet");
			}
		}

		private function playNext() : void {

			var sound : SoundIdentifier = _sounds[_currentSoundId];
			var soundChannelWrapper : SoundChannelWrapper = sound.play(_playbackProperties);

			if (soundChannelWrapper) {

				_activeSoundChannels.push(soundChannelWrapper);
				soundChannelWrapper.soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompletedHandler);
			} else {
				
				_currentSoundId++;
				
				if (_currentSoundId < _sounds.length) {

					playNext();
				}
			}

		}

		private function soundCompletedHandler(event : Event) : void {

			_currentSoundId++;

			handleSoundCompleted(SoundChannel(event.target), _currentSoundId == _sounds.length);

			if (_currentSoundId < _sounds.length) {

				playNext();
			}
		}

	}
}
