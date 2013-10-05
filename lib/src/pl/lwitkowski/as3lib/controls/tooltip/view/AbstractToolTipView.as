package pl.lwitkowski.as3lib.controls.tooltip.view {
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AbstractToolTipView extends Sprite 
	{
		private static const MARGIN:int = 3;
		
		public function AbstractToolTipView() {
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		protected function handleAddedToStage(e:Event):void {
			update();
		}

		// true, jesli dane są ok i mozna pokazac
		public function setData(value:*):Boolean {
			throw new IllegalOperationError("abstract method");
			return false;
		}
		
		public function update():void {
			if(parent) {
				x = parent.mouseX;
				y = parent.mouseY;
				
				var globalBounds:Rectangle = localBounds;
				globalBounds.topLeft = localToGlobal(globalBounds.topLeft);
				globalBounds.bottomRight = localToGlobal(globalBounds.bottomRight);
				if(stage.stageHeight < globalBounds.bottom + MARGIN) {
					y -= (globalBounds.bottom + MARGIN - stage.stageHeight);
				} 
				
				
				if(stage.stageWidth < globalBounds.right + MARGIN) {
					if(globalBounds.left > globalBounds.width) {
						flip();
					} else {
						unflip();
						x -= (globalBounds.right + MARGIN - stage.stageWidth);
						y += 20;
					}
				} else {
					unflip();
				}
			}
		}
		
		protected function get localBounds():Rectangle {
			return new Rectangle(0, 0, width, height);
		}
		
		protected function unflip():void {}
		protected function flip():void {}
	}
}
