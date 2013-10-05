package pl.lwitkowski.as3lib.locale.parsers {

	/**
	 * Parser plików w formacie xml:
	 * <dictionary>
	 * 	<item id="key">value</item>
	 * </dictionary>
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class XMLFileParser extends AbstractTextFileParser
	{	
		public function XMLFileParser(charSet:String = "utf-8") {
			super(charSet);
		}

		override protected function parseLangText(text:String):Object {
			var xml:XML = new XML(text);
			var dictionary:Object = new Object();	
			
			var nodes:XMLList = xml.dictionary.item as XMLList;
			for each(var node:XML in nodes) {
				dictionary[node.@id] = node.toString();
			}
			return dictionary;
		}
	}
}