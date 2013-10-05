package pl.szataniol.utils.lang {
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class PolishLanguageUtils {
		
		public static function getNumeralWordForm(number:int, singular:String, plural:String, plural2:String):String {
			
			if(number == 1) {
				
				return singular;
			} else 	if(number%100 > 10 && number%100 < 20) {
				
				return plural2;
			} else {
				
				number %= 10;
				
				if(number >= 2 && number <= 4) {
					return plural;
				} else {
					return plural2;
				}
			}
		}
	}
}

