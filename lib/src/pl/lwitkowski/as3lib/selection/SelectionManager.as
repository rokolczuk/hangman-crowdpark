package pl.lwitkowski.as3lib.selection 
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class SelectionManager extends MultiSelectionManager 
	{
		public static const SELECTION_CHANGE:String = "selectionChange";
		
		public function SelectionManager(selectEventType:String = Event.SELECT, deselectEventType:String = null) {
			super(selectEventType, deselectEventType);
		}

		public function get selectedItem():ISelectable {
			var selected:Array = selectedItems;
			return selected.length > 0 ? (selected[0] as ISelectable) : null;
		}
		
		public function set selectedItem(value:ISelectable):void {
			internalDeselectAll();
			select(value);
		}
		
		override public function selectAll():void {
			throw new IllegalOperationError("");
		}
		override public function select(value:ISelectable):void {
			internalDeselectAll();
			super.select(value);
		}
		
	}
}
