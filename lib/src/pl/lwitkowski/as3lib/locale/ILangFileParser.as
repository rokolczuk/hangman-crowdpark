package pl.lwitkowski.as3lib.locale 
{
	import flash.utils.ByteArray;
	
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public interface ILangFileParser 
	{
		function parseLangFile(fileContents:ByteArray):Object;
	}
	
}