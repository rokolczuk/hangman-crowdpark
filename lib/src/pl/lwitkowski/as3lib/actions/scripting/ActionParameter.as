package pl.lwitkowski.as3lib.actions.scripting {
	/**
	 * @author lwitkowski
	 */
	public class ActionParameter 
	{
		
		private var _name:String;
		private var _valueClass:Class;
		private var _defaultValue:* = null;
		
		public function ActionParameter(name:String, valueClass:Class, defaultValue:* = null) {
			_name = name;
			_valueClass = valueClass;
			_defaultValue = defaultValue;
		}

		public function get name() : String {
			return _name;
		}
		public function get valueClass() : Class {
			return _valueClass;
		}
		public function get defaultValue() : * {
			return _defaultValue;
		}
	}
}
