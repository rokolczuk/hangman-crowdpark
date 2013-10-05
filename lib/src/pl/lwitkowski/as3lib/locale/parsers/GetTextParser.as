package pl.lwitkowski.as3lib.locale.parsers {

	/**
	 * Parser plików w formacie xml:
	 * <dictionary>
	 * 	<item id="key">value</item>
	 * </dictionary>
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class GetTextParser extends AbstractTextFileParser
	{
		public function GetTextParser(charSet:String = "utf-8") {
			super(charSet);
		}

		override protected function parseLangText(text:String):Object {
			// TODO
			return null;
		}
	}
}