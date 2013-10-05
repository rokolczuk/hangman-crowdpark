package pl.lwitkowski.as3lib.locale.parsers {
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import pl.lwitkowski.as3lib.locale.ILangFileParser;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AbstractTextFileParser implements ILangFileParser
	{
		private var _charSet:String;
		
		public function AbstractTextFileParser(charSet:String = "utf-8") {
			_charSet = charSet;
		}

		final public function parseLangFile(fileContents:ByteArray):Object {
			return parseLangText(fileContents.readMultiByte(fileContents.length, _charSet) );
		}
		
		protected function parseLangText(text:String):Object {
			throw new IllegalOperationError("abstract method");
			return null;
		}
	}
}