package pl.szataniol.utils.games {
	import flash.events.Event;

	/**
	 * @author akorolczuk
	 */
	public class GameTimerEvent extends Event {
		
		public static const COUNTDOWN_FINISHED:String = "countdownFinished";
		
		public function GameTimerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
