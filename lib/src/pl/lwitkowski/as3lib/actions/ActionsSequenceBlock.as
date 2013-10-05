package pl.lwitkowski.as3lib.actions 
{
	import flash.events.Event;
	import pl.lwitkowski.logger.Logger;
	
	/**
	 * @author lwitkowski
	 */
	public class ActionsSequenceBlock extends AbstractAction implements IAction
	{		
		public static const NOT_EMPTY:String = "notEmpty";
		public static const EMPTY:String = "empty";
		
		private var _actions:Vector.<ActionProxy>;
		private var _currentAction:ActionProxy;
		private var _currentActionFinished:Boolean = false;
		
		private var _paused : Boolean = false;
		private var _autoExecute : Boolean = false;
		
		
		public function ActionsSequenceBlock(actions:Vector.<IAction> = null, delayBefore:Number = 0, delayAfter:Number = 0, timeout:Number = 0, priority:int = 0) {
			super(delayBefore, delayAfter, timeout, priority);
			_actions = new Vector.<ActionProxy>();
			if(actions) {
				pushActions(actions);
			}
		}
		
		override public function execute():void {
			nextAction();
		}
		
		public function get empty():Boolean {
			return _currentAction == null;
		}
		
		public function set autoExecute(value:Boolean):void {
			_autoExecute = value;
		}
		
		public function pushAction(action:IAction):void {
			if(action) {
				var i:int = 0;
				while(i < _actions.length && _actions[i].action.priority >= action.priority) {
					++i;
				}
				Logger.getChannel("actions").info("adding action [" +action+ "] on position : " + i + ", priority : " + action.priority);
				//trace("adding action [" +action+ "] on position : " + i + ", priority : " + action.priority);
				_actions.splice(i, 0, new ActionProxy(action, Logger.getChannel("actions")));
				//_actions = _actions.sort(compareActionProxies);
				if(_autoExecute && empty && !_paused) {
					nextAction();
				}
			}
		}
		
		public function pushActions(actions:Vector.<IAction>):void {
			if(actions) {
				while(actions.length > 0) {
					pushAction(actions.shift());
				}
			}
		}

		protected function nextAction() : void {
			var wasEmpty:Boolean = empty;
			
			if(_currentAction) {
				_currentAction.removeEventListener(Event.COMPLETE, handleActionComplete);
			}
			if(_actions.length > 0) {
				if(wasEmpty) {
					dispatchEvent(new Event(NOT_EMPTY));
				}
				_currentAction = _actions.shift() as ActionProxy;
				_currentAction.addEventListener(Event.COMPLETE, handleActionComplete);
				_currentActionFinished = false;
				_currentAction.execute();
			} else {
				_currentAction = null;
				dispatchEvent(new Event(Event.COMPLETE));
				if(!wasEmpty) {
					dispatchEvent(new Event(EMPTY));
				}
			}
		}		

		private function handleActionComplete(e:Event = null) : void {
			_currentActionFinished = true;
			if(!_paused) {
				nextAction();
			}
		}

		public function get paused() : Boolean {
			return _paused;
		}

		public function set paused(value:Boolean) : void {
			_paused = value;
//			trace('actionsSequenceblock: ' + (value));
			//trace(" --- actions queue paused:" + _paused);
			/*if(!_paused) { 
				if(_currentAction == null || _currentActionFinished) {
					nextAction();
				}
			}*/
			if(!_paused && _currentAction && _currentActionFinished) {
				nextAction();
			}
		}

		public function trace() : String {
			return "current: " + (_currentAction ? _currentAction.action : null) + ", queue (" +_actions.length + "): " + traceActions(_actions);
		}

		private function traceActions(actions : Vector.<ActionProxy>) : String {
			var strings:Array = [];
			for each(var a:ActionProxy in actions) {
				strings.push(a.action);
			} 
			return strings.join(", ");
		}
		
		
		override public function cancel() : void {
			super.cancel();
			if(_currentAction) {
				_currentAction.cancel();
				_currentAction.removeEventListener(Event.COMPLETE, handleActionComplete);
				_currentAction = null;
			}
		}
	}
}
