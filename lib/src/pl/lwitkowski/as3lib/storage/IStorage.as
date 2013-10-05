package pl.lwitkowski.as3lib.storage 
{
	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public interface IStorage
	{
		function setProperty(key:String, value:*):*;
		function getProperty(key:String):*;
		function clear():void;
	}
}