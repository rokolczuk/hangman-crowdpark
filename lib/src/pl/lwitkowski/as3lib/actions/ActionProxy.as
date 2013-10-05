package pl.lwitkowski.as3lib.actions {
	import pl.lwitkowski.logger.LoggerChannel;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * @author lwitkowski
	 */
	internal class ActionProxy extends EventDispatcher 
	{
		private var _action:IAction;
		private var _actionTimeoutId:uint;
		
		private var _logChannel:LoggerChannel;
		
		public function ActionProxy(action:IAction, logChannel:LoggerChannel = null) {
			_action = action;
			_logChannel = logChannel;
		}

		public function execute():void {
			if(_action.delayBefore > 0) {
				setTimeout(internalExecute, 1000 * _action.delayBefore);
			} else {
				internalExecute();
			}
		}
		
		private function internalExecute():void {
			if(_logChannel) {
				_logChannel.info("Executing action: " + _action + ", delayBefore: " + _action.delayBefore + ", delayAfter: " + _action.delayAfter + ", timeout: " + _action.timeout);
			}
			
			clearTimeout(_actionTimeoutId);
			if(_action.timeout > 0) {
				_actionTimeoutId = setTimeout(handleActionTimeout, 1000 * _action.timeout);
			}
			_action.addEventListener(Event.COMPLETE, handleActionComplete);
			
			CONFIG::release {
			try {
				_action.execute();
			} catch(e:Error) {
				if(_logChannel) {
					_logChannel.error(_action + ".execute() exception");
					_logChannel.debug(e.getStackTrace());
				}
			}
			}
			CONFIG::debug { // morrrr errors
				_action.execute();
			}
		}

		private function handleActionComplete(e:Event = null) : void {
			if(_logChannel) {
				_logChannel.debug("* finished: " + _action);
			}
			clearTimeout(_actionTimeoutId);
			if(_action.delayAfter > 0) {
				setTimeout(actionFinished, 1000 * _action.delayAfter);
			} else {
				actionFinished();
			}
		}
		
		private function handleActionTimeout():void {
			if(_logChannel) {
				_logChannel.warning(_action + " timeout");
			}
			actionFinished();
		}
		
		private function actionFinished():void {
			_action.removeEventListener(Event.COMPLETE, handleActionComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get action() : IAction {
			return _action;
		}

		public function cancel() : void {
			_action.removeEventListener(Event.COMPLETE, handleActionComplete);
			_action.cancel();
		}
	}
}
