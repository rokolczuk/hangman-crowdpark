package pl.lwitkowski.as3lib.formatters {
	import pl.lwitkowski.as3lib.math.ExtMath;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class NumberFormatter 
	{
		public static function formatValue(value:Number, digitsAfterComa:int = 0):String {
			if(isNaN(value)) return "0";
			digitsAfterComa = Math.max(0, digitsAfterComa);
			var mod:int = Math.pow(10, digitsAfterComa);
			return String(Math.round(value * mod)/mod);
		}
		
		
		protected static const POSTFIXES:Array = ["", "k", "M", "G", "T"];
		
		// TODO
		public static function formatBigNumber(input:Number, digitsAfterComa:int = 2):String {
			var negative:Boolean = input < 0; 
			var value:Number = Math.abs(input) || 0;
			
			var log10Value:int = int(ExtMath.log(10, value));
			value /= Math.pow(10, int(log10Value/3) * 3);
			var stringValue:String = String(value);
			var separator:String = (stringValue.indexOf(".") > 0) ? "." : ","; 
			var separatorIndex:int = stringValue.indexOf(separator);
			if(separatorIndex >= 0) {
				if(digitsAfterComa > 0) digitsAfterComa += 1;
				stringValue = stringValue.substr(0, separatorIndex + digitsAfterComa);
			}  

			return (negative ? "-" : "") + stringValue + POSTFIXES[int(log10Value/3)];
		}
		
		
		
		public static const SI_PREFIXES:Array = [
			"",
			"k", // kilo (gr. khilioi – tysiąc)	k	10³	tysiąc
			"M", // mega (gr. megas – wielki)	M	106	milion
			"G", // giga (gr. gigas – olbrzymi)	G	109	miliard
			"T", // tera (gr. teras – potwór)	T	1012	bilion
			"P", // peta (gr. penta - pięć)	P	1015	biliard
			"E", // eksa (gr. ex - sześć)	E	1018	trylion
			"Z", // zetta (łac. septem - siedem)	Z	1021	tryliard
			"Y" // jotta (gr. okto - osiem)	Y	1024	kwadrylion
		];
		
		public static const SI_PREFIXES_NEGATIVE:Array = [
			"m", // mili (łac. mille – tysiąc)	m	10-3	jedna tysięczna
			"µ", // mikro (gr. mikros – mały)	µ	10-6	jedna milionowa
			"n", // nano (gr. nanos – karzeł)	n	10-9	jedna miliardowa
			"p", // piko (wł. piccolo – mały)	p	10-12	jedna bilionowa
			"f", // femto (duń. femten – piętnaście)	f	10-15	jedna biliardowa
			"a", // atto (duń. atten – osiemnaście)	a	10-18	jedna trylionowa
			"z", // zepto (łac. septem - siedem)	z	10-21	jedna tryliardowa
			"y" // jokto (gr. okto - osiem)	y	10-24	jedna kwadrylionowa
		];
		
		public static function formatNumber(input:Number, digitsAfterComa:int = 2):String {
			var value:Number = input || 0;
			
			var log10Value:int = int(ExtMath.log(10, value));
			value /= Math.pow(10, int(log10Value/3) * 3);
			
			var stringValue:String = String(value);
			var separatorIndex:int = stringValue.indexOf(separator);
			if(separatorIndex >= 0) {
				stringValue = stringValue.substr(0, separatorIndex + digitsAfterComa + 1);
			}  
			return stringValue + SI_PREFIXES[int(log10Value/3)];
		}
		
		public static function getPrefixForValue(value:Number):String {
			if(value == 0) return "";
			else if(value < 0) value = -value;
			
			var orderOfMagnitude:int = int(ExtMath.log(10, value));
			trace("orderOfMagnitude "+[value, ExtMath.log(10, value), orderOfMagnitude]);
			if(value < 1) {
				value *= Math.pow(10, int(orderOfMagnitude/3) * 3);
				return SI_PREFIXES_NEGATIVE[- int(orderOfMagnitude/3)];
			} else {
				value /= Math.pow(10, int(orderOfMagnitude/3) * 3);
				return SI_PREFIXES[int(orderOfMagnitude/3)];
			}
		}
		
		private static var _separator:String = null;
		public static function get separator():String {
			if(!_separator) {
				_separator = (String(1.1).indexOf(",") > 0) ? "," : "."; 
			}
			return _separator;	 
		}  
	}
}