package pl.szataniol.utils.validation {

	/**
	 * @author Andrzej Korolczuk
	 */
	public class Validator {

		
		public static function validateEmail(emailString : String) : Boolean {
				
			const emailPattern : RegExp = /([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}/;
				
			return emailPattern.test(emailString);
		}
	}
}
