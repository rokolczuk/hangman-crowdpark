package pl.szataniol.sound.playback {

	import flash.media.SoundTransform;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class PlaybackProperties {

		private var _volume : Number;
		private var _startTime:Number;
		private var _panning:Number;
		private var _loops:int;

		private var _playbackMode : String;
		
		/**
		 * @param vars
		 *    volume:Number
		 *    startTime:Number
		 * @param playbackMode @see PlaybackModes
		 *  
		 */
		public function PlaybackProperties(vars:Object = null, playbackMode : String = "overlap") {
			
			if(!vars) {
				vars = {};
			}

			_playbackMode = playbackMode;
			_volume = isNaN(vars.volume) ? 1 : vars.volume;
			_startTime = isNaN(vars.startTime) ? 0 : vars.startTime;
			_loops = isNaN(vars.loops) ? 0 : vars.loops;
			_panning = isNaN(vars.panning) ? 0 : vars.panning;
		}

		public function get volume() : Number {
			
			return _volume;
		}

		public function get playbackMode() : String {
			
			return _playbackMode;
		}

		public function get startTime() : Number {
			return _startTime;
		}

		public function get loops() : int {
			return _loops;
		}

		public function get soundTransform() : SoundTransform {

			return new SoundTransform(_volume, _panning);
		}

        public function get panning():Number {
            return _panning;
        }
    }
}
