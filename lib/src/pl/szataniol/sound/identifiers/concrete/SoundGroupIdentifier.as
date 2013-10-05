package pl.szataniol.sound.identifiers.concrete {

	import pl.szataniol.sound.identifiers.AbstractSound;
	import pl.szataniol.sound.playback.PlaybackModes;
	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.playback.SoundChannelWrapper;

	import flash.events.Event;
	import flash.media.SoundChannel;




	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class SoundGroupIdentifier extends AbstractSound {

		private var _sounds : Vector.<SoundIdentifier> = new Vector.<SoundIdentifier>();

		public function SoundGroupIdentifier(identifier : String, playbackProperties : PlaybackProperties = null) {



			super(identifier, playbackProperties);
		}

		public function addSound(sound : SoundIdentifier) : void {

			_sounds.push(sound);

			if (!sound.ready) {

				_ready = false;
				sound.addEventListener(Event.COMPLETE, soundResourceLoadedHandler);
			}
		}

		private function soundResourceLoadedHandler(event : Event) : void {

			event.target.removeEventListener(Event.COMPLETE, soundResourceLoadedHandler);

			_ready = true;

			for (var i : int = 0; i < _sounds.length; i++) {

				if (!_sounds[i].ready) {

					_ready = false;
					break;
				}
			}
		}

		public function playRandom(playbackProperties : PlaybackProperties = null) : void {

			if (!playbackProperties) {

				playbackProperties = _playbackProperties;
			}

			if (ready) {

				if (playbackProperties.playbackMode == PlaybackModes.KILL_PREVIOUS) {

					killAll();
					_lock = false;
				}

				if (!_lock) {
					
					if (playbackProperties.playbackMode == PlaybackModes.ONE_INSTANCE) {

						_lock = true;
					}

					var randomSound : SoundIdentifier = _sounds[Math.floor(Math.random() * _sounds.length)];
					var soundChannelWrapper : SoundChannelWrapper = randomSound.play(playbackProperties);

					if (soundChannelWrapper && soundChannelWrapper.soundChannel) {

						soundChannelWrapper.soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompletedHandler);
						_activeSoundChannels.push(soundChannelWrapper);
					}
				}

			} else {

				trace("SoundGroup " + identifier + " is not ready yet!");
			}
		}

		private function soundCompletedHandler(event : Event) : void {

			handleSoundCompleted(SoundChannel(event.target), true);
		}
	}
}
