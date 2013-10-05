package pl.lwitkowski.as3lib.actions {


	/**
	 * @author lwitkowski
	 */
	public class CallFunctionAction extends AbstractAction implements IAction 
	{
		private var _function:Function;
		private var _functionArgs:Array;
		
		public function CallFunctionAction(functionRef:Function, functionArgs:Array = null, delayBefore:Number = 0, 
							delayAfter:Number = 0, timeout:Number = 0, priority:int = 0) 
		{
			super(delayBefore, delayAfter, timeout, priority);
			_function = functionRef;
			_functionArgs = functionArgs;
		}
		
		override public function execute() : void {
			_function.apply(null, _functionArgs);
			actionFinished();
		}
	}
}
