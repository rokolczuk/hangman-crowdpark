package pl.lwitkowski.as3lib.locale.parsers {

	/**
	 * Parser plików w formacie javowych .properties :
	 * key = value
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class PropertiesFileParser extends AbstractTextFileParser
	{
		public function PropertiesFileParser(charSet:String = "utf-8") {
			super(charSet);
		}
		
		override protected function parseLangText(text:String):Object {
			var dictionary:Object = new Object();	
			
			var newLineChar:String = String.fromCharCode(13);
			text = text.split(newLineChar).join("");
			
			var lines:Array = text.split("\n");
			var separatorIndex:int = -1;
			for each(var line:String in lines) {
				separatorIndex = line.indexOf(" = ");
				if(separatorIndex >= 0) {
					dictionary[line.slice(0, separatorIndex)] = line.slice(separatorIndex + 3);
				}
			}
			return dictionary;
		}
	}
}