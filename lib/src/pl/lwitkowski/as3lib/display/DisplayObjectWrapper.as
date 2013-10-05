package pl.lwitkowski.as3lib.display {
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class DisplayObjectWrapper extends EventDispatcher {
		
		protected var _target:DisplayObject;
		
		public function DisplayObjectWrapper(target:DisplayObject = null) {
			_target = target;
			if(_target) {
				_target.addEventListener(Event.ADDED_TO_STAGE, handleViewAddedToStage);
				_target.addEventListener(Event.REMOVED_FROM_STAGE, handleViewRemovedFromStage);
				if(_target.stage) {
					handleViewAddedToStage(new Event(Event.ADDED_TO_STAGE));
				}
			}
		}
		
		public function get viewComponent():DisplayObject {
			return _target;
		}
		
		public function registerAutoRedispatch(eventTypes:Array, customTarget:EventDispatcher = null, useWeakReference:Boolean = true):void {
			if(!customTarget) {
				customTarget = _target; 
			}
			for each(var type:String in eventTypes) {
				customTarget.addEventListener(type, dispatchEvent, false, 0, useWeakReference);
			}
		}
		
		public function turnMouseEventsRedispatchOn(customTarget:EventDispatcher = null, useWeakReference:Boolean = true) : void {
			registerAutoRedispatch([
					MouseEvent.MOUSE_WHEEL,
					MouseEvent.MOUSE_MOVE,
					MouseEvent.ROLL_OUT,
					MouseEvent.MOUSE_OVER,
					MouseEvent.CLICK,
					MouseEvent.MOUSE_OUT,
					MouseEvent.MOUSE_UP,
					MouseEvent.DOUBLE_CLICK,
					MouseEvent.MOUSE_DOWN,
					MouseEvent.ROLL_OVER
			], customTarget, useWeakReference);
		}
		
		private function handleViewAddedToStage(e:Event):void {
			setUp();
		}
		private function handleViewRemovedFromStage(e:Event):void {
			tearDown();
		}
		
		protected function setUp():void {}
		protected function tearDown():void {}
		
		
		// wrappers		
		public function set x(value:Number):void { _target.x = value; }
		public function get x():Number { return _target.x; }
		
		public function set y(value:Number):void { _target.y = value; }
		public function get y():Number { return _target.y; }
		
		public function get mouseX():Number { return _target.mouseX; }
		public function get mouseY():Number { return _target.mouseY; }
		
		public function set width(value:Number):void { _target.width = value; }
		public function get width():Number { return _target.width; }
		
		public function set height(value:Number):void { _target.height = value; }
		public function get height():Number { return _target.height; }
		
		public function set visible(value:Boolean):void { _target.visible = value; }
		public function get visible():Boolean { return _target.visible; }
		
		public function set alpha(value:Number):void { _target.alpha = value; }
		public function get alpha():Number { return _target.alpha; }
		
		public function set rotation(value:Number):void { _target.rotation = value; }
		public function get rotation():Number { return _target.rotation; }
		
		public function get stage():Stage { return _target.stage; }
	}
}
