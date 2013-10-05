package pl.szataniol.utils.games {

	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * @author maciek
	 */
	public class FPSTracker extends EventDispatcher {

		private var _target : Sprite;

		private var _prevTime : int;
		private var _time : int;
		private var _fps : Number;
		private var _numSamples : int;

		private var _samples : Vector.<Number> = new Vector.<Number>();


		function FPSTracker() {

		}

		public function init(target : Sprite, numSamples : int) : void {

			_numSamples = numSamples;
			_target = target;
			_target.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		public function dispose() : void {

			_target.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event : Event) : void {

			_time = getTimer();
			_fps = 1000 / (_time - _prevTime);
			_prevTime = getTimer();

			_samples.push(_fps);
			 
			 if(_samples.length > _numSamples) {
				
				_samples.splice(0, _samples.length - _numSamples);
			 }
		}
		
		public function canSample():Boolean {
			
			return _samples.length == _numSamples;
		}
		
		public function getAverage():Number {
			
			var i:uint = 0;
			var sum:Number = 0;
			
			while(i < _samples.length) {
				
				sum+=_samples[i];	
				i++;		
			}
			
			return sum/_samples.length;
		}
	}
}
