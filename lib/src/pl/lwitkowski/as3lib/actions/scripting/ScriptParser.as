package pl.lwitkowski.as3lib.actions.scripting 
{
	import pl.lwitkowski.as3lib.actions.ActionsParallelBlock;
	import pl.lwitkowski.as3lib.actions.DelayAction;
	import pl.lwitkowski.as3lib.actions.IAction;
	import pl.lwitkowski.as3lib.actions.TraceAction;
	import pl.lwitkowski.logger.Logger;

	/**
	 * @author lwitkowski
	 */
	public class ScriptParser 
	{
		private var _handlers:Object;
		
		public function ScriptParser() {
			_handlers = {};
			registerHandlers(Vector.<ActionHandlerDefinition>([
				new ActionHandlerDefinition("delay", delayHandler, Vector.<ActionParameter>([new ActionParameter("delay", Number)])),
				new ActionHandlerDefinition("trace", traceHandler, Vector.<ActionParameter>([new ActionParameter("message", String)]))
			]));
		}

		private function delayHandler(delay:Number) : Vector.<IAction> {
			var actions:Vector.<IAction> = new Vector.<IAction>();
			actions.push(new DelayAction(delay));
			return actions;
		}
		private function traceHandler(message:String) : Vector.<IAction> {
			var actions:Vector.<IAction> = new Vector.<IAction>();
			actions.push(new TraceAction(message));
			return actions;
		}
		
		public function registerHandlers(handlers:Vector.<ActionHandlerDefinition>):void {
			for each(var actionHandler:ActionHandlerDefinition in handlers) {
				if(_handlers[actionHandler.action.toLowerCase()] == null) {
					_handlers[actionHandler.action.toLowerCase()] = actionHandler;
				} else {
					//throw new Error("Parser exists for this action: " + actionHandler.action);
				}
			}
		}
		
		public function parseScript(input:String, group:String = null):Vector.<IAction> {
			var groups:Object = parseScriptIntoGroups(input);
			var actions:Vector.<IAction> = new Vector.<IAction>();
			if(group) {
				actions = (groups[group.toLowerCase()] as Vector.<IAction>) || new Vector.<IAction>(); 
			} else {
				for(group in groups) {
					actions = actions.concat(groups[group.toLowerCase()] as Vector.<IAction>);
				}
			}
			return actions;
		}
		
		/**
		 * @param input skrypt
		 * @param onlyStateActions jesli true, omija akcje, które nie odtwarzają stanu swiata (showDialog, playAnimation itp), zwraca takze płaską liste akcji (bez bloków równoległych)
		 */
		public  function parseScriptIntoGroups(input:String):Object { // mapa group -> Vector.<IAction>
			if(!input) return {};
			
			var groups:Object = {};			
			
			var currentGroupName:String = "_main";
			var currentGroupTokens:Vector.<String> = new Vector.<String>();
			
			var tokens:Array = input.split("\n").join(";").split("\r").join(";").split(";");
			while(tokens.length > 0) {
				var token:String = trim(tokens.shift());
				
				if(token.indexOf("#") == 0) {
					if(currentGroupName) {
						groups[currentGroupName] = parseTokens(currentGroupTokens);
					}
					currentGroupName = token.slice(1).toLowerCase(); 
					currentGroupTokens = new Vector.<String>();
				} else {
					currentGroupTokens.push(token);
				}
			}
			if(currentGroupName) {
				groups[currentGroupName] = parseTokens(currentGroupTokens);
			}
			return groups;
		}
		
		private function parseTokens(tokens:Vector.<String>):Vector.<IAction> {
			var actions:Vector.<IAction> = new Vector.<IAction>();
			
			while(tokens.length > 0) {
				var token:String = trim(tokens.shift());
				if(token.indexOf("//") >= 0) token = token.slice(0, token.indexOf("//")); // remove comments

				if(token.length == 0) continue;
				
				if(token.toLowerCase() == "beginparallelblock()") {
					var parallelTokens:Vector.<String> = tokens.splice(0, tokens.indexOf("EndParallelBlock()"));
					actions.push(new ActionsParallelBlock( parseTokens( parallelTokens ) ));
					tokens.shift(); // usun EndParallelBlock()
				} else if(token.toLowerCase() == "endparallelblock()") {
					// ntbd
				} else {
					var method:String = token.slice(0, token.indexOf("(")).toLowerCase();
					if(_handlers[method]) {
						var handler:ActionHandlerDefinition = _handlers[method];
						var rawParamsStr:String = token.slice(token.indexOf("(") + 1, token.lastIndexOf(")"));
						if(rawParamsStr.indexOf(String.fromCharCode(1)) != -1 || rawParamsStr.indexOf(String.fromCharCode(2)) != -1) {
							throw new Error("rawParamsString contains costam");
						}
						rawParamsStr = rawParamsStr.split("\\/").join("/");
						rawParamsStr = rawParamsStr.split("\\,").join(String.fromCharCode(1));
						rawParamsStr = rawParamsStr.split(",").join(String.fromCharCode(2));
						rawParamsStr = rawParamsStr.split(String.fromCharCode(1)).join(",");
						var rawParams:Array = rawParamsStr.split(String.fromCharCode(2));
						var params:Array = parseParams(rawParams, handler);
						var newActions:Vector.<IAction> = handler.handlerFunction.apply(null, params) as Vector.<IAction>;
						for each(var a:IAction in newActions) {
							actions.push(a);
						}
					} else {
						Logger.getChannel("actions").warning("action '" + method + "' not supported, full token: " + token);
					}
				}
			}
			return actions;
		}

		private function parseParams(rawParams:Array, handler:ActionHandlerDefinition):Array {
			var params:Array = [];
			for(var i:int = 0; i < handler.parameters.length; ++i) {
				var actionDefaultParam:ActionParameter = handler.parameters[i];
				var paramValue:* = null;
				if(i < rawParams.length) {
					var rawParam:* =  trim(rawParams[i]);
					switch(actionDefaultParam.valueClass) {
						case Boolean:
							paramValue = (rawParam == "true");
							break;
							
						case String:
							if(rawParam !== "NULL" && rawParam !== "null") {
								paramValue = actionDefaultParam.valueClass(rawParam);
							}
							break;				
						default:
							paramValue = actionDefaultParam.valueClass(rawParam);
					}
				} else {
					paramValue = actionDefaultParam.defaultValue;
				}
				params.push(paramValue);
			}
			return params;
		}
	}
}
