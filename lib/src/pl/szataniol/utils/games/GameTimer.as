package pl.szataniol.utils.games {
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;


	/**
	 * @author akorolczuk
	 */
	public class GameTimer extends EventDispatcher {
		
		private var timeStarted:int;		private var timeStopped:int;
		private var timePauseStarted:int;
		
		private var _paused:Boolean;		private var _started:Boolean;
		private var timeCountdownStarted : int;
		private var _countdownInProgress : Boolean = false;
		private var countdownTimeout : uint;
		private var timeCountdownPaused : int;
		private var pauseTimerWhenFinished : Boolean;
		private var countdownTime : int;

		public function GameTimer() {
			
			super();
		}
		
		public function start():void {
			
			if(_started) {
				trace("GameTimer.start Error - timer already started.");
				return;
			}
			timeStarted = getTimer();
			_started = true;
		}
		
		public function stop():void {
			
			timeStopped = getTimer();
			
			if(!_started) {
				trace("GameTimer.stop Error - timer is not running.");
				return;
			}
			if(_countdownInProgress) {
				clearTimeout(countdownTimeout);
				_countdownInProgress = false;
			}
			
			_started = false;
		}
		
		public function pause():void {
			trace("time pause");
			if(_paused) {
				trace("GameTimer.pause Error - timer already paused.");
				return;
			}
			if(_countdownInProgress) {
				clearTimeout(countdownTimeout);
				timeCountdownPaused = getTimer();
			}
			
			_paused = true;
			timePauseStarted = getTimer();
		}

		public function resume():void {
			
			trace("timer resume");
			if(!_paused) {
				trace("GameTimer.resume Error - timer is not paused.");
			}
			
			if(_countdownInProgress) {
				
				countdownTime = countdownTime-(timePauseStarted - timeCountdownStarted);
				timeCountdownStarted = getTimer();
				
				countdownTimeout = setTimeout(countDownFinished, countdownTime);
			}
			
			timeStarted += (getTimer() - timePauseStarted);
			
			_paused = false;			
		}
		public function countdown(milisecons:int, pauseTimerWhenFinished:Boolean = false):void {

			
			if(_countdownInProgress) {
				trace("GameTimer.countdown Error - already counting down.");
			}
			if(!_started) {
				start();
			}
			
			timeCountdownStarted = getTimer();
			this.pauseTimerWhenFinished = pauseTimerWhenFinished;
			this.countdownTime = milisecons;
			
			_countdownInProgress = true;
			countdownTimeout = setTimeout(countDownFinished, milisecons);
		}
		
		private function countDownFinished() : void {
			
			_countdownInProgress = false;
			
			if(pauseTimerWhenFinished) {
				pause();
			}
			dispatchEvent(new GameTimerEvent(GameTimerEvent.COUNTDOWN_FINISHED));
		}

		public function get paused() : Boolean {
			
			return _paused;
		}
		public function get totalTime():int {
			
			if(_started) {
				return getTimer() - timeStarted;
			} else{
				return timeStopped - timeStarted;
			}
		}
		
		public function get started() : Boolean {
			return _started;
		}
		public function get timeleft():int {
			
			if(!_started) {
				trace("GameTimer.timeleft Error - timer is stopped.");
				return -1;
			}
			if(!_countdownInProgress) {
				trace("GameTimer.timeleft Error - there is no countdown in progress.");
				return -1;
			}
			if(_paused) {
				
				return countdownTime-getTimer() - (timePauseStarted - timeCountdownStarted);
			}
			return countdownTime-(getTimer() - timeCountdownStarted);

		}

		public function get countdownInProgress() : Boolean {
			return _countdownInProgress;
		}
		
		public function modifyCountDownTime(time:Number):void {
			
			countdownTime += time;
		}
	}
}
