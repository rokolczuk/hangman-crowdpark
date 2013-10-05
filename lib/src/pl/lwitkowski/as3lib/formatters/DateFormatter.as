package pl.lwitkowski.as3lib.formatters 
{
	/**
	 * Date formatter, based on Adobe mx.formatters.DateFormatter
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class DateFormatter 
	{
		
			
		public static const YEAR_MS:Number = 31536000000;
		public static const MONTH_MS:Number = 2592000000;
		public static const DAY_MS:Number = 86400000;
		public static const HOUR_MS:Number = 3600000;
		public static const MINUTE_MS:Number = 60000;
		public static const SECOND_MS:Number = 1000;
		
		private static var _dayNamesLong:Array /* of String */= [
	    	"Sunday", 
	    	"Monday", 
	    	"Tuesday", 
	    	"Wednesday",
		   	"Thursday", 
		   	"Friday", 
		   	"Saturday"
	    ];
	    
		public static function get dayNamesLong():Array /* of String */ {
			return _dayNamesLong.concat();
		}

		public static function set dayNamesLong(value:Array /* of String*/):void {
			if(value.length == 7) {
				_dayNamesLong = value.concat();
			} else {
				throw new Error("array must contain exacly 7 elements");
			}
		}
			
		private static var _dayNamesShort:Array /* of String */ = [
			"Sun", 
			"Mon", 
			"Tue", 
			"Wed", 
			"Thu", 
			"Fri", 
			"Sat"
		];
		
	    public static function get dayNamesShort():Array /* of String */ {
			return _dayNamesShort.concat();
		}	
		public static function set dayNamesShort(value:Array /* of String*/):void {
			if(value.length == 7) {
				_dayNamesShort = value.concat();
			} else {
				throw new Error("array must contain exacly 7 elements");
			}
		}
		
		/*static function get defaultStringKey():Array /* of String */
		/*{
			initialize();
	
			return monthNamesLong.concat(timeOfDay);
		}*/
		

		private static var _monthNamesLong:Array /* of String */ = [
			"January", 
			"February", 
			"March", 
			"April", 
			"May", 
			"June", 
		 	"July", 
		 	"August", 
		 	"September", 
		 	"October", 
		 	"November", 
		 	"December"
		];
		

		public static function get monthNamesLong():Array /* of String */ {
			return _monthNamesLong.concat();
		}
	
		public static function set monthNamesLong(value:Array /* of String*/):void {
			if(value.length == 12) {
				_monthNamesLong = value.concat();
			} else {
				throw new Error("array must contain exacly 12 elements");
			}
		}
					
		private static var _monthNamesShort:Array /* of String */ = [
			"Jan", 
			"Feb", 
			"Mar", 
			"Apr", 
			"May", 
			"Jun",
		 	"Jul", 
		 	"Aug", 
		 	"Sep", 
		 	"Oct",
		 	"Nov", 
		 	"Dec"
		];
		
		public static function get monthNamesShort():Array /* of String */ {
			return _monthNamesShort.concat();
		}

		public static function set monthNamesShort(value:Array /* of String*/):void	{
			if(value.length == 12) {
				_monthNamesShort = value.concat();
			} else {
				throw new Error("array must contain exacly 12 elements");
			}
		}
		    	
		private static var _timeOfDay:Array /* of String */ = ["AM", "PM"];
		
	   	public static function get timeOfDay():Array /* of String */ {
			return _timeOfDay.concat();
		}
	
	    /**
		 *  @private
	     */
		public static function set timeOfDay(value:Array /* of String */):void {
			if(value.length == 2) {
				_timeOfDay = value.concat();
			} else {
				throw new Error("array must contain exacly 2 elements");
			}
		}
		
		public static var monthsShort:String = "mths";
		public static var daysShort:String = "d";
		public static var hoursShort:String = "h";
		public static var minutesShort:String = "min";
		public static var secondsShort:String = "s";
		
		private static const patterns:Array = [
			"O {1}", 
			"D {2}",
			"H {3}",
			"N {4}", 
			"S {5}"
		];
		private static const leadingPatterns:Array = [
			"I {1}", 
			"F {2}",
			"G {3}",
			"N {4}", 
			"S {5}"
		];
		private static const bases:Array = [
			MONTH_MS,
			DAY_MS,
			HOUR_MS,
			MINUTE_MS,
			SECOND_MS
		];
		
		public static function formatSince(ms:Number, pattern:String = null, chunks:Number = 3):String {
			if(isNaN(ms)) return "";
			else if(ms == 0) return "0";
			
			var autoPattern:Boolean = false;
			if (!pattern || pattern.length == 0) {
				autoPattern = true;
				
				
				pattern = "";
				var from:Number = -1;
				for (var i:Number = 0; i <  patterns.length; ++i) {
					if(ms >= bases[i]) {
						if (pattern.length > 0) {
							pattern += " ";
						}
						if (from < 0) {
							from = i;
						}
						
						pattern += (i == from) ? leadingPatterns[i] : patterns[i];
						
						if (from >= 0 && ((i - from) >= (chunks - 1))) {
							break;
						}
					}
				}
				
				/*if (ms < MINUTE_MS) {
					pattern = "S {SECONDS_SHORT}";
				} else if (ms < HOUR_MS) {
					pattern = "N {MINUTES_SHORT} S {SECONDS_SHORT}";
				} else if (ms < DAY_MS) {
					pattern = "J {HOURS_SHORT} N {MINUTES_SHORT} S {SECONDS_SHORT}";
				} else if (ms < MONTH_MS) {
					pattern = "F {DAYS_SHORT} J {HOURS_SHORT} N {MINUTES_SHORT}";
				} else {
					pattern = "O {MONHTS_SHORT} F {DAYS_SHORT} J {HOURS_SHORT}";
				}*/
				//trace(pattern);
			}
			
			//trace(ms +" "+pattern)
			
			//trace(["zią: ", ms, ", ", pattern])
			var d:Date = new Date(ms);
			var value:String = format(d, pattern, true);
			if(autoPattern) {
				value = value.split("{1}").join(monthsShort);
				value = value.split("{2}").join(daysShort);
				value = value.split("{3}").join(hoursShort);
				value = value.split("{4}").join(minutesShort);
				value = value.split("{5}").join(secondsShort);
			}
			return value;
		}
		
		public static function format(date:Date, pattern:String, utc:Boolean = false):String {
			var result:String = "";
			
			for(var i:int = 0; i<pattern.length; ++i) {
				var char:String = pattern.charAt(i);
				var singlePattern:String = char;
				while(pattern.charAt(i + 1) == char) {
					singlePattern += char; 
					++i;
				}
				result += extractTokenDate(date, char, singlePattern.length, utc);
			}
			
			return result; 
		}		
		private static var tokenExtractors:Object = {};
		tokenExtractors["I"] = extractYears; // year
		tokenExtractors["Y"] = extractYearToken; // year
		tokenExtractors["O"] = extractMonths; // month in year
		tokenExtractors["M"] = extractMonthToken; // month in year
		tokenExtractors["F"] = extractDays; // days
		tokenExtractors["D"] = extractDayInMonthToken; // day in month
		tokenExtractors["E"] = extractDayInWeekToken; // day in the week
		tokenExtractors["A"] = extractAM_PM_MarkerToken; // am/pm marker
		tokenExtractors["G"] = extractHours; // hours
		tokenExtractors["H"] = extractHours_0_23_Token; // hour in day (0-23)
		tokenExtractors["J"] = extractHours_1_24_Token; // hour in day (1-24)
		tokenExtractors["K"] = extractHourInAM_PM_0_11_Token; // hour in am/pm (0-11)
		tokenExtractors["L"] = extractHourInAM_PM_1_12_Token; // hour in am/pm (1-12)
		tokenExtractors["N"] = extractMinutesToken; // minutes in hour
		tokenExtractors["S"] = extractSecondsToken; // seconds in minute
		tokenExtractors["m"] = extractMilisecondsToken; // miliseconds in second
		
		/**
		 *  @private
		 *  Parses token objects and renders the elements of the formatted String.
		 *  For details about token objects, see StringFormatter.
		 *
		 *  @param date Date object.
		 *  @param tokenInfo Array object that contains token object descriptions.
		 *  @return Formatted string.
		 */
		private static function extractTokenDate(date:Date, token:String, length:int, utc:Boolean):String {
			var extractor:Function = tokenExtractors[token] as Function; 
			if(extractor != null) {
				return extractor(date, length, utc);
			} else {
				return token;
			}
		}
		
		private static function extractYears(date:Date, length:int, utc:Boolean):String {
			return setValue(int(date.getTime() / YEAR_MS), length);
		}

		private static function extractYearToken(date:Date, length:int, utc:Boolean):String {
			// year
			var year:String = date.getFullYear().toString();
			if (length < 3)
				return year.substr(2);
			else if (length > 4)
				return setValue(Number(year), length);
			else
				return year;
		}
	
		
		private static function extractMonths(date:Date, length:int, utc:Boolean):String {
			return setValue(int(date.getTime() / MONTH_MS), length);
		}
		
		private static function extractMonthToken(date:Date, length:int, utc:Boolean):String {
			// month in year
			var month:int = int(date.getMonth());
			if (length < 3) {
				return setValue(month + 1, length); // zero based
			} else if (length == 3) {
				return monthNamesShort[month];
			} else {
				return monthNamesLong[month];
			}
		}
		
		
		private static function extractDays(date:Date, length:int, utc:Boolean):String {
			return setValue(int(date.getTime() / DAY_MS), length);
		}
		
		private static function extractDayInMonthToken(date:Date, length:int, utc:Boolean):String {
			// day in month
			return setValue(int(date.getDate()), length);
		}
	
		private static function extractDayInWeekToken(date:Date, length:int, utc:Boolean):String {
			// day in the week
			var day:int = int(utc ? date.getUTCDay() : date.getDay());
			if (length < 3) {
				return setValue(day, length);
			} else if (length == 3) {
				return dayNamesShort[day];
			} else {
				return dayNamesLong[day];
			}
		}
	
		private static function extractAM_PM_MarkerToken(date:Date, length:int, utc:Boolean):String {
			var hours:int = int(utc ? date.getUTCHours() : date.getHours());
			if (hours < 12)
				return timeOfDay[0];
			else
				return timeOfDay[1];
		}
	
		
		private static function extractHours(date:Date, length:int, utc:Boolean):String {
			return setValue(int(date.getTime() / HOUR_MS), length);
		}
	
		private static function extractHours_1_24_Token(date:Date, length:int, utc:Boolean):String {
			// hour in day (1-24)
			var hours:int = int(utc ? date.getUTCHours() : date.getHours());
			if (hours == 0)
				hours = 24;
			return setValue(hours, length);
		}
			
	
		private static function extractHours_0_23_Token(date:Date, length:int, utc:Boolean):String {
			// hour in day (0-23)
			//trace('extractHours_0_23_Token ' + [date.getHours(), date]);
			return setValue(int(utc ? date.getUTCHours() : date.getHours()), length);
		}
				
				
		private static function extractHourInAM_PM_0_11_Token(date:Date, length:int, utc:Boolean):String {
			// hour in am/pm (0-11)
			var hours:int = int(utc ? date.getUTCHours() : date.getHours());
			if (hours >= 12)
				hours = hours - 12;
			return setValue(hours, length);
		}
		
		private static function extractHourInAM_PM_1_12_Token(date:Date, length:int, utc:Boolean):String {
			// hour in am/pm (1-12)
			var hours:int = int(utc ? date.getUTCHours() : date.getHours());
			if (hours == 0)
				hours = 12;
			else if (hours > 12)
				hours = hours - 12;
			return setValue(hours, length);
		}
	
		private static function extractMinutesToken(date:Date, length:int, utc:Boolean):String {
			// minutes in hour
			var mins:int = int(utc ? date.getUTCMinutes() : date.getMinutes());
			return setValue(mins, length);
		}
	
		private static function extractSecondsToken(date:Date, length:int, utc:Boolean):String {
			// seconds in minute
			var sec:int = int(utc ? date.getUTCSeconds() : date.getSeconds());
			return setValue(sec, length);
		}
		
		private static function extractMilisecondsToken(date:Date, length:int, utc:Boolean):String {
			// miliseconds in second
			var ms:int = int(utc ? date.getUTCMilliseconds() : date.getMilliseconds()) % 1000;
			return setValue(ms, length);
		}
	
		/**
		 *  @private
		 *  Makes a given length of digits longer by padding with zeroes.
		 *
		 *  @param value Value to pad.
		 *
		 *  @param key Length of the string to pad.
		 *
		 *  @return Formatted string.
		 */
		private static function setValue(value:Object, key:int):String
		{
			var result:String = "";
	
			var vLen:int = value.toString().length;
			if (vLen < key)
			{
				var n:int = key - vLen;
				for (var i:int = 0; i < n; i++)
				{
					result += "0";
				}
			}
	
			result += value.toString();
	
			return result;
		}
	}	
}
