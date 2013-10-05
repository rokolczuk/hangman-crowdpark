package pl.lwitkowski.as3lib.controls.tooltip.utils 
{
	import pl.lwitkowski.as3lib.controls.tooltip.IToolTipDataProvider;
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class StringTemplateData implements IToolTipDataProvider {
		
		private var _template:String;		private var _variables:Object;
		
		public function StringTemplateData(template:String = "", variables:Object = null) {
			_template = template;			_variables = variables;
		}
		
		public function set template(value:String) : void {
			_template = value;
		}
		
		public function set variables(value : Object) : void {
			_variables = value;
		}
		
		public function setVariable(key:String, value:String) : void {
			if (_variables) {
				_variables[key] = value;
 			}
		}
		
		// IToolTipDataProvider impl
		public function get toolTipData():* {
			var stringData:String = _template; 
			if(stringData && _variables) {
				for(var key:String in _variables) {
					//stringData = stringData.replace(new RegExp(key, "g"), _variables[key]);
					stringData = stringData.split(key).join(_variables[key] as String); //  10% faster over RegExp
				}
			}
			return stringData;
		}
	}
}
