package pl.lwitkowski.as3lib.actions.scripting {
	/**
	 * @author lwitkowski
	 */
	public class ActionHandlerDefinition 
	{
		private var _action:String;
		private var _handlerFunction:Function;
		private var _parameters:Vector.<ActionParameter>;
		
		public function ActionHandlerDefinition(action:String, handler:Function, parameters:Vector.<ActionParameter>) {
			_action = action;
			_handlerFunction = handler;
			_parameters = parameters;
		}

		public function get action() : String {
			return _action;
		}

		public function get handlerFunction() : Function {
			return _handlerFunction;
		}

		public function get parameters() : Vector.<ActionParameter> {
			return _parameters;
		}
	}
}
