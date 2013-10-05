package pl.lwitkowski.as3lib.actions 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author lwitkowski
	 */
	public class AbstractAction extends EventDispatcher implements IAction 
	{
		private var _delayBefore : Number = 0;
		private var _delayAfter : Number = 0;
		private var _timeout : Number = 0;
		private var _priority : Number = 0;
		private var _cancelled : Boolean = false;
		
		public function AbstractAction(delayBefore:Number = 0, delayAfter:Number = 0, 
					timeout:Number = 0, priority:int = 0) 
		{
			_delayBefore = delayBefore;
			_delayAfter = delayAfter;
			_timeout = timeout;
			_priority = priority;
		}
		
		public function execute() : void {
			throw new IllegalOperationError("abstract method");
		}
		public function cancel() : void {
			_cancelled = true;
		}
		
		public function get delayBefore():Number {
			return _delayBefore;
		}

		public function get delayAfter():Number {
			return _delayAfter;
		}

		public function get timeout() : Number {
			return _timeout;
		}
		public function set timeout(value : Number) : void {
			_timeout = value;
		}
		public function get priority() : int {
			return _priority;
		}
		
		public final function actionFinished():void {
			if(!_cancelled) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		protected function get cancelled() : Boolean {
			return _cancelled;
		}
	}
}
