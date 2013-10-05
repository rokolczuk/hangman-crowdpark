package pl.szataniol.utils {
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class TimeUtil {

		public static function toTimerString(miliseconds:Number, showDays:Boolean, showHours:Boolean, showMinutes:Boolean, showSeconds:Boolean, showHunderdsOfSeconds:Boolean):String {

			var timerString:String = "";

			var hundredsOfSeconds:Number = Math.floor(miliseconds / 10);
			var seconds:Number = Math.floor(miliseconds / 1000);
			var minutes:Number = Math.floor(seconds / 60);
			var hours:Number = Math.floor(minutes / 60);
			var days:Number = Math.floor(hours / 24);

			hundredsOfSeconds %= 100;
			seconds %= 60;
			minutes %= 60;
			hours %= 24;

			if (showDays) {
				if (days < 10) {
					timerString += "0" + days + ":";
				} else {
					timerString += days + ":";
				}
			}
			if (showHours) {
				if (hours < 10) {
					timerString += "0" + hours + (showMinutes ? ":" : "");
				} else {
					timerString += hours + (showMinutes ?  ":" : "");
				}
			}
			if (showMinutes) {
				if (minutes < 10) {
					timerString += "0" + minutes + (showSeconds ? ":" : "");
				} else  {
					timerString += minutes + (showSeconds ? ":" : "");
				}
			}
			if (showSeconds) {
				if (seconds < 10) {
					timerString += "0" + seconds;
				} else {
					timerString += seconds;
				}
			}
			if (showHunderdsOfSeconds) {
				timerString += ":";

				if (hundredsOfSeconds < 10) {
					timerString += "0" + hundredsOfSeconds;
				} else {
					timerString += hundredsOfSeconds;
				}
			}

			return timerString;
		}
	}
}
