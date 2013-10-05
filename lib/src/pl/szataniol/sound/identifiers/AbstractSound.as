package pl.szataniol.sound.identifiers {

	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.playback.SoundChannelWrapper;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;



	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	 [Event(name="soundComplete", type="flash.events.Event")]
	public class AbstractSound extends EventDispatcher {
		
		public static const defaultPlaybackProperties : PlaybackProperties = new PlaybackProperties({});

		protected var _activeSoundChannels : Vector.<SoundChannelWrapper> = new Vector.<SoundChannelWrapper>();

		protected var _identifier : String;
		protected var _playbackProperties : PlaybackProperties;
		protected var _muted : Boolean = false;
		protected var _ready : Boolean = true;
		protected var _lock : Boolean = false;


		public function AbstractSound(identifier : String, playbackProperties : PlaybackProperties = null) {

			super();

			_identifier = identifier;
			_playbackProperties = playbackProperties || defaultPlaybackProperties;
		}

		public function get identifier() : String {

			return _identifier;
		}

		public function get playbackProperties() : PlaybackProperties {

			return _playbackProperties;
		}

		public function mute() : void {

			_muted = true;
			handleMutedChanged();
		}

		public function unmute() : void {

			_muted = false;
			handleMutedChanged();
		}

		private function handleMutedChanged() : void {

			for (var i : int = 0; i < _activeSoundChannels.length; i++) {

				_activeSoundChannels[i].soundChannel.soundTransform = new SoundTransform(_muted ? 0 : _activeSoundChannels[i].playbackProperies.volume);
			}
		}

		public function get ready() : Boolean {

			return _ready;
		}

		public function killAll() : void {

			for (var i : int = 0; i < _activeSoundChannels.length; i++) {

                if(_activeSoundChannels[i].soundChannel) {

                    _activeSoundChannels[i].soundChannel.stop();
                }
			}

			_activeSoundChannels.splice(0, _activeSoundChannels.length);
		}

		protected function handleSoundCompleted(soundChannel : SoundChannel, dispatchCompleteEvent:Boolean) : void {

			_lock = false;

			for (var i : int = 0; i < _activeSoundChannels.length; i++) {

				if (_activeSoundChannels[i].soundChannel == soundChannel) {

					_activeSoundChannels.splice(i, 1);
					break;
				}
			}
			
			if(dispatchCompleteEvent) {
				
				dispatchEvent(new Event(Event.SOUND_COMPLETE));
			}
		}
	}
}



