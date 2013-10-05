package pl.lwitkowski.as3lib.actions 
{
	import pl.lwitkowski.logger.Logger;

	import flash.events.Event;

	/**
	 * @author lwitkowski
	 */
	public class ActionsParallelBlock extends AbstractAction implements IAction 
	{
		private var _actionsSource:Vector.<IAction>;
		private var _actions:Vector.<ActionProxy>;
		
		public function ActionsParallelBlock(actions:Vector.<IAction>, delayBefore:Number = 0, delayAfter:Number = 0, timeout:Number = 0) {
			super(delayBefore, delayAfter, timeout);
			
			_actionsSource = actions.concat();
			_actions = new Vector.<ActionProxy>();
			if(actions) {
				for each(var action:IAction in _actionsSource) {
					_actions.push(new ActionProxy(action, Logger.getChannel("actions")));
				}
			}
		}

		override public function execute() : void {
			if(_actions.length > 0) {
				var actions:Vector.<ActionProxy> = _actions.concat();
				for each(var action:ActionProxy in actions) {
					action.addEventListener(Event.COMPLETE, handleActionComplete);
					action.execute();
				}
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function handleActionComplete(e:Event) : void {
			var action:ActionProxy = ActionProxy(e.target);
			_actionsSource.splice(_actions.indexOf(action.action), 1);
			_actions.splice(_actions.indexOf(action), 1);
			if(_actions.length == 0) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function get actionsSource() : Vector.<IAction> {
			return _actionsSource.concat();
		}
		
		override public function cancel() : void {
			super.cancel();
			for each(var action:ActionProxy in _actions) {
				action.removeEventListener(Event.COMPLETE, handleActionComplete);
				action.cancel();
			}
		}
	}
}
