package pl.lwitkowski.as3lib.version 
{
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Version 
	{
		public static const PRE_ALPHA:String = "preAlpha"; // prealpha
		public static const ALPHA:String = "alpha"; // alpha
		public static const BETA:String = "beta"; // beta
		public static const RC:String = "rc"; // release candidate
		public static const R:String = "r"; // release
		
		protected var _major:String = "";
		protected var _minor:String = "";
		protected var _build:String = "";
		
		public function Version(major:String, minor:String = "", build:String = "") {
			_major = major;
			_minor = minor;
			_build = build;
		}
		
		public function get major():String {
			return _major;
		}
		public function get minor():String {
			return _minor;
		}
		public function get build():String {
			return _build;
		}
		
		public function get fullVersion():String {
			return major + "." + minor + "." + build; 
		}
		
		public function toString():String {
			return fullVersion;
		}
	}
}
