package pl.szataniol.sound.playback {

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;


public class SoundChannelWrapper {

        private static const SOUND_TRANSFORM_MUTE:SoundTransform = new SoundTransform(0);

		private var _soundChannel : SoundChannel;
		private var _playbackProperies : PlaybackProperties;
        private var _soundIdentifier:String;

		public function SoundChannelWrapper(soundIdentifier:String,  soundChannel : SoundChannel, playbackProperies : PlaybackProperties) {
            _soundIdentifier = soundIdentifier;

            _playbackProperies = playbackProperies;
			_soundChannel = soundChannel;
		}

		public function get soundChannel() : SoundChannel {
			
			return _soundChannel;
		}

		public function get playbackProperies() : PlaybackProperties {
			
			return _playbackProperies;
		}

        public function get soundIdentifier():String {

            return _soundIdentifier;
        }

        public function mute():void {

            soundTransform = SOUND_TRANSFORM_MUTE;
        }

        public function unmute():void {

            soundTransform = new SoundTransform(playbackProperies.volume, playbackProperies.panning);
        }

        public function set soundTransform(transform:SoundTransform):void {

            _soundChannel.soundTransform = transform;
        }

    public function kill():void {

        if(_soundChannel) {
            _soundChannel.stop();
            _soundChannel = null;
        }
    }
}
}