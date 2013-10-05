package pl.lwitkowski.as3lib.locale.parsers 
{
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class XLIFFParser extends AbstractTextFileParser
	{	
		public function XLIFFParser(charSet:String = "utf-8") {
			super(charSet);
		}

		override protected function parseLangText(text:String):Object {
			var xml:XML = new XML(text);
			var dictionary:Object = new Object();	
			
			var nodes:XMLList = xml.file.body.child("trans-unit") as XMLList;
			for each(var node:XML in nodes) {
				dictionary[node.@id] = node.source.toString();
			}
			return dictionary;
		}
	}
}
