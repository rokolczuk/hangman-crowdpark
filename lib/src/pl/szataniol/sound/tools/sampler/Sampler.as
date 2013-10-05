/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 2/21/13
 * Time: 8:39 PM
 * To change this template use File | Settings | File Templates.
 */
package pl.szataniol.sound.tools.sampler {

	import flash.media.SoundChannel;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	import pl.mentos.enigma.common.controller.InitSoundsCommand;
	import pl.szataniol.bonduelle.musicbox.sampler.song.ISamplerInterface;

	import pl.szataniol.sound.SoundManager;
	import pl.szataniol.sound.events.SamplerEvent;
	import pl.szataniol.sound.identifiers.concrete.SoundIdentifier;
	import pl.szataniol.sound.playback.PlaybackModes;
	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.playback.SoundChannelWrapper;
	import pl.szataniol.sound.playback.SoundChannelWrapper;

	[Event(name="start", type="pl.szataniol.sound.events.SamplerEvent")]
	[Event(name="step", type="pl.szataniol.sound.events.SamplerEvent")]
	[Event(name="stop", type="pl.szataniol.sound.events.SamplerEvent")]
	[Event(name="muteMapChanged", type="pl.szataniol.sound.events.SamplerEvent")]

	public class Sampler extends EventDispatcher implements ISamplerInterface {

		private var _soundManager : SoundManager = SoundManager.getInstance();

		private var _interval : int;
		private var _stepTimeout : uint;

		private var _maxSteps : int;
		private var _numStep : int;

		private var _playing : Boolean = false;

		private var _tracks : Vector.<String> = new Vector.<String>();
		private var _tracksMap : Dictionary = new Dictionary(true);
		private var _muteMap : Array = [];
		private var _soundChannelWrappers : Vector.<SoundChannelWrapper> = new Vector.<SoundChannelWrapper>();

		private var _stepStartTime : uint;

		private var _alignSamples : Boolean;
		private var _samplesAlignDivisor : int;
		private var _endless : Boolean;

		private var _endLoopSoundChannel : SoundChannel;
		private var _endLoopAction : Function;

		public function Sampler(maxSteps : int, alignSamples : Boolean = true, samplesAlignDivisor : int = 4) {

			_maxSteps = maxSteps;
			_alignSamples = alignSamples;
			_samplesAlignDivisor = samplesAlignDivisor;

			stop();
		}

		public function start(endless : Boolean = false) : void {

			_endless = endless;

			if (_playing) {

				stop(false);
			}

			_playing = true;
			dispatchEvent(new SamplerEvent(SamplerEvent.START));

			step();
		}

		public function  stop(dispatch : Boolean = true) : void {

			_playing = false;
			clearTimeout(_stepTimeout);
			_numStep = 0;
			
			if(_endLoopSoundChannel) {
				
				_endLoopSoundChannel.removeEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
				_endLoopSoundChannel = null;
			}

			killAllSoundChannels();

			if (dispatch) {

				dispatchEvent(new SamplerEvent(SamplerEvent.STOP));
			}

		}

		protected function step() : void {

			_soundChannelWrappers.splice(0, _soundChannelWrappers.length);

			// if(!_endless) {

			var event : SamplerEvent = new SamplerEvent(SamplerEvent.STEP);
			event.numStep = _numStep;
			dispatchEvent(event);
			// }

			for (var i : int = 0; i < _tracks.length; i++) {

				if (_tracksMap[_tracks[i]]) {

					var soundChannelWrapper : SoundChannelWrapper = _soundManager.getSound(_tracks[i]).play(new PlaybackProperties(null, PlaybackModes.KILL_PREVIOUS));

					if (isMuted(_tracks[i])) {

						soundChannelWrapper.mute();
					}

					_soundChannelWrappers.push(soundChannelWrapper);

					if (!_endLoopSoundChannel) {

						_endLoopSoundChannel = soundChannelWrapper.soundChannel;
						_endLoopSoundChannel.addEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
					}
				}
			}

			_stepStartTime = getTimer();

			if (!_endless) {

				_numStep++;

				if (_numStep < _maxSteps) {

					_endLoopAction = step;
					// _stepTimeout = setTimeout(step, _interval);

				} else {

					// setTimeout(stop,  _interval);
					_endLoopAction = stop;
				}
			} else {

				// _stepTimeout = setTimeout(step, _interval);
				_endLoopAction = step;
			}
			
			if(!_endLoopSoundChannel) {
				
				_stepTimeout = setTimeout(_endLoopAction, _interval);
			}
		}

		private function loopCompleteHandler(event : Event) : void {
			
			_endLoopSoundChannel.removeEventListener(Event.SOUND_COMPLETE, loopCompleteHandler);
			_endLoopSoundChannel = null;
			_endLoopAction.call();
		}

		public function registerTrack(identifier : String) : void {

			_tracks.push(identifier);
			_tracksMap[identifier] = false;
			_muteMap[identifier] = false;

			if (_interval == 0) {

				_interval = _soundManager.getSound(identifier).length;

			} else {

				if (_interval != int(_soundManager.getSound(identifier).length)) {

					trace("Sampler warning: sounds lengths are not exact!");
				}
			}
		}

		public function playSample(identifier : String) : int {

			if (_playing) {

				if (_alignSamples) {

					var barNumber : int = Math.ceil(stepTime / _interval * _samplesAlignDivisor);
					var barTime : int = barNumber / _samplesAlignDivisor * _interval;
					var delay : int = (barTime - stepTime);


					setTimeout(_soundManager.getSound(identifier).play, delay, new PlaybackProperties(null, PlaybackModes.KILL_PREVIOUS))

					return delay;

				} else {

					_soundManager.getSound(identifier).play(new PlaybackProperties(null, PlaybackModes.KILL_PREVIOUS));
				}
			}

			return 0;


		}

		public function toggleTrack(identifier : String, on : Boolean) : void {

			if (_tracksMap[identifier] == null) {

				throw new IllegalOperationError("Sampler.toggleSound error: sound is not registered");
			}

			_tracksMap[identifier] = on;

			return;

			for (var i : int = 0; i < _soundChannelWrappers.length; i++) {

				var soundChannelWrapper : SoundChannelWrapper = _soundChannelWrappers[i];

				if (soundChannelWrapper.soundIdentifier == identifier) {

					soundChannelWrapper.soundChannel.stop();
				}
			}
		}

		public function muteTrack(identifier : String, mute : Boolean) : void {

			_muteTrack(identifier, mute);
			handleMuteMapChanged();

		}

		private function _muteTrack(identifier : String, mute : Boolean) : void {

			_muteMap[identifier] = mute;
		}

		public function muteOthers(identifier : String) : void {

			for (var otherIdentifier:String in _muteMap) {

				muteTrack(otherIdentifier, otherIdentifier != identifier);
			}

			handleMuteMapChanged();

		}

		private function handleMuteMapChanged() : void {

			for (var i : int = 0; i < _soundChannelWrappers.length; i++) {

				var soundChannelWrapper : SoundChannelWrapper = _soundChannelWrappers[i];

				isMuted(soundChannelWrapper.soundIdentifier) ? soundChannelWrapper.mute() : soundChannelWrapper.unmute();

			}

			dispatchEvent(new SamplerEvent(SamplerEvent.MUTE_MAP_CHANGED));
		}

		public function unmuteAll() : void {

			for (var identifier:String in _muteMap) {

				muteTrack(identifier, false);
			}

			dispatchEvent(new SamplerEvent(SamplerEvent.MUTE_MAP_CHANGED));
		}

		public function isMuted(identifier : String) : Boolean {

			return _muteMap[identifier];
		}

		public function areOthersMuted(identifier : String) : Boolean {

			if (_muteMap[identifier]) {
				return false;
			}

			for (var otherIdentifier:String in _muteMap) {

				if (otherIdentifier != identifier && !isMuted(otherIdentifier)) {

					return false;
				}
			}

			return true;
		}

		public function get numStep() : int {

			return _numStep;
		}

		public function get maxSteps() : int {

			return _maxSteps;
		}

		public function get stepTime() : uint {

			return getTimer() - _stepStartTime;
		}

		public function get stepProgress() : Number {

			return  _playing ? Math.min(1, stepTime / _interval) : 0;
		}

		public function get soundManager() : SoundManager {
			return _soundManager;
		}

		private function killAllSoundChannels() : void {

			for (var i : int = 0; i < _soundChannelWrappers.length; i++) {

				var soundChannelWrapper : SoundChannelWrapper = _soundChannelWrappers[i];
				soundChannelWrapper.kill();
			}

			_soundChannelWrappers.splice(0, _soundChannelWrappers.length);
		}

		public function get songProgress() : Number {

			return Math.max(0, (_numStep - 1) / _maxSteps + stepProgress / _maxSteps);
		}

		public function getToggledSounds(toggled : Boolean) : Vector.<String> {

			var sounds : Vector.<String> = new Vector.<String>();

			for (var identifier:String in _tracksMap) {

				if (_tracksMap[identifier] == toggled) {

					sounds.push(identifier);
				}
			}

			return sounds;
		}

		public function resetSamplesMap() : void {

			for (var identifier:String in _tracksMap) {

				_tracksMap[identifier] = false;
			}
		}

		public function get playing() : Boolean {
			return _playing;
		}
	}
}
