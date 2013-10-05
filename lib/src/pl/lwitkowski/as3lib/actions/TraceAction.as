package pl.lwitkowski.as3lib.actions {


	/**
	 * @author lwitkowski
	 */
	public class TraceAction extends AbstractAction 
	{
		private var _message : String;
		
		public function TraceAction(message:String) {
			super();
			_message = message;
		}
		override public function execute() : void {
			trace(_message);
			actionFinished();
		}
	}
}
