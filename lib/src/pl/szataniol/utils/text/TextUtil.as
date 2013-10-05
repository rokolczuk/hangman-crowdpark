package pl.szataniol.utils.text {

	import flash.text.TextFormat;
	import flash.text.TextField;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class TextUtil {

		public static function applyLetterSpacing(textfield : TextField, letterSpacing : int) : void {

			var tf : TextFormat = textfield.getTextFormat(0, textfield.text.length);
			tf.letterSpacing = letterSpacing;
			textfield.setTextFormat(tf);
		}
	}
}
