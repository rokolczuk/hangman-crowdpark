package pl.szataniol.utils {

	/**
	 * @author akorolczuk
	 */
	public class StringUtil {
		
		public static function xor(string:String, key:String, push:int = 0):String {
			
			var xored:String = "";
			
			for (var i : int = 0; i < string.length; i++) {
				xored += String.fromCharCode(push + ((string.charCodeAt(i)) ^ (key.charCodeAt(i % key.length))));	
			}
			return xored;
		}

		public static function zerolize(string : String, numDigits : int) : String {
			
			while(string.length < numDigits) {
				
				string = "0" + string;
			}
			
			return string;
		}
	}
}
