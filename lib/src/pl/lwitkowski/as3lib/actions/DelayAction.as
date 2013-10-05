package pl.lwitkowski.as3lib.actions {


	/**
	 * @author lwitkowski
	 */
	public class DelayAction extends AbstractAction 
	{
		public function DelayAction(delay:Number = 0) {
			super(delay);
		}
		override public function execute() : void {
			actionFinished();
		}
	}
}
