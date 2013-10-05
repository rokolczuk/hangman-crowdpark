package pl.lwitkowski.as3lib.controls.tooltip 
{
	import pl.lwitkowski.as3lib.controls.tooltip.view.AbstractToolTipView;

	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class ToolTip extends Sprite 
	{
		private static var _instance : ToolTip;
		public static function getInstance():ToolTip {
			return _instance || (_instance = new ToolTip());
		}
		
		// INSTANCE
		private var _defaultShowDelay:Number = 0;
		private var _dataClass2tooltip:Dictionary;
		private var _tooltip2delay:Dictionary;
		
		private var _currentToolTip:AbstractToolTipView = null;
		private var _showTimeoutId:uint;
		private var _updateInterval:uint;
		
		public function ToolTip(defaultShowDelay:Number = 0.4) {
			this.defaultShowDelay = defaultShowDelay;
			
			_dataClass2tooltip = new Dictionary(true);
			_tooltip2delay = new Dictionary(true);
			
			TweenPlugin.activate([AutoAlphaPlugin]);
		
			//registerView(new SimpleStringToolTipView(), String);
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);			addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage, false, 0, true);
			
			visible = false;
			alpha = 0;
		}
		
		public function set defaultShowDelay(value:Number) : void {
			_defaultShowDelay = Math.max(0, value);
		}

		public function registerView(tooltip:AbstractToolTipView, feedClass:Class, delay:Number = -1):void {
			_dataClass2tooltip[feedClass] = tooltip;
			_tooltip2delay[tooltip] = (delay >= 0) ? delay : _defaultShowDelay;
		}
		
		public function show(dataArg:* = null, delay:Number = -1, updateInterval:Number = 0):void {
			var data:* = processData(dataArg);
			if(data == null) {
				hide();
				return;
			}
			
			clearInterval(_updateInterval);
		
			// <extendsClass type="pl.artfolia.players.image.view.content.imageviewer::ImageViewerWrapper"/>
			/*var classNames:Array = [getQualifiedClassName(data)];
			var extendsClassList:XMLList = describeType(data).extendsClass as XMLList;
			for each(var extendsClassItem:XML in extendsClassList) {
				classNames.push(String(extendsClassItem.@type));
			}
			trace(classNames);
			for each(var className:String in classNames) {
				trace("traversing "+className);
				var currentDataClass:Class = getDefinitionByName( className.replace("::", ".") ) as Class;
				if(_dataClass2tooltip[currentDataClass] != null) {
					setCurrentToolTip(ToolTipBase(_dataClass2tooltip[currentDataClass]), data, delay);
					return;
				}
			}*/
			var dataClass:Class;
			for(var dataClassIterator:Object in _dataClass2tooltip) {
				dataClass = Class(dataClassIterator);
				if(data is dataClass) {
					setCurrentToolTip(AbstractToolTipView(_dataClass2tooltip[dataClass]), data, delay);
					
					if (_currentToolTip && (updateInterval > 0)) {
						_updateInterval = setInterval(updateCurrentToolTipData, updateInterval * 1000, dataArg);
					}
					return;
				}
			}
		}

		private function processData(dataArg:*):* {
			var dataClass:Class = null;
			try {
				dataClass = getDefinitionByName(getQualifiedClassName(dataArg)) as Class;
			} catch(e:Error) {};
			
			if((dataArg is Function) && (_dataClass2tooltip[Function] == null)) {
				var getter:Function = dataArg as Function;
				return getter();
			} else if(dataArg is IToolTipDataProvider) {
				return IToolTipDataProvider(dataArg).toolTipData;
			} else if(dataClass && _dataClass2tooltip[dataClass] == null 
						&& ("toString" in dataArg) && dataArg["toString"] is Function) 
			{
				return dataArg.toString();
			} else {
				return dataArg;
			}
		}
		
		public function hide():void {
			setCurrentToolTip(null);
			clearInterval(_updateInterval);
		}
		
		private function setCurrentToolTip(value:AbstractToolTipView, data:Object = null, delay:Number = -1):void {
			internalHide(true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				
			if(_currentToolTip && contains(_currentToolTip)) {
				removeChild(_currentToolTip);
			}
			_currentToolTip = value;
			if(_currentToolTip) {
				if(_currentToolTip.setData(data)) {
					addChild(_currentToolTip);
					stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
					
					var showDelay:Number = (delay >= 0) ? delay : Number(_tooltip2delay[_currentToolTip]);
					_showTimeoutId = setTimeout(internalShow, Math.max(0, (showDelay - 0.1) * 1000));
				}
			} else {
				internalHide();
			}
		}
		
		private function internalShow():void {
			_currentToolTip.update();
			TweenLite.to(this, 0.1, { autoAlpha : 1 });
		}
		private function internalHide(immediate:Boolean = false):void {
			clearTimeout(_showTimeoutId);
			TweenLite.to(this, immediate ? 0 : 0.1, { autoAlpha : 0 });
		}
		private function updateCurrentToolTipData(data:* = null):void {
			_currentToolTip.setData(processData(data));
		}
		private function handleMouseMove(e:MouseEvent):void {
			_currentToolTip.update();
			e.updateAfterEvent();
		}	
		
		//
		private function handleAddedToStage(event : Event) : void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown, false, 0, true);
		}
		private function handleRemovedFromStage(event : Event) : void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleStageMouseDown, false);
		}
		
		private function handleStageMouseDown(e:MouseEvent):void {
			hide();	
		}

		// UTILS
		private var _target2feed:Dictionary;
		
		// data object
		public function setupRollOverToolTip(target:EventDispatcher, feed:* = null, showDelay:Number = -1, updateInterval:Number = 0):void 
		{
			setupToolTip(target, MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT, feed, showDelay, updateInterval);
		}
		
		public function setupToolTip(target:EventDispatcher, showEvent:String, hideEvent:String, feed:* = null, 
					showDelay:Number = -1, updateInterval:Number = 0):void 
		{
			if(target) {
				if(!_target2feed) {
					_target2feed = new Dictionary(true);
				}
				if(feed == null && target is IToolTipDataProvider) {
					feed = target;
				}
				if(feed) {
					_target2feed[target] = new ToolTipData(showEvent, hideEvent, feed, showDelay, updateInterval);
					target.addEventListener(showEvent, handleShowEvent, false, 0, true);
				} else {
					var data:ToolTipData = _target2feed[target] as ToolTipData;  
					if(data) {
						_target2feed[target] = null;
						delete _target2feed[target];
						target.removeEventListener(data.showEvent, handleShowEvent);
						target.removeEventListener(data.hideEvent, handleHideEvent);
					}
				}
			}
		}
		
		private function handleShowEvent(e:MouseEvent):void {
			var target:EventDispatcher = e.currentTarget as EventDispatcher;
			var toolTipData:ToolTipData = _target2feed[target] as ToolTipData;
			
			target.addEventListener(toolTipData.hideEvent, handleHideEvent, false, 0, true);
			show(toolTipData.feed, toolTipData.showDelay, toolTipData.updateInterval);
		}
		private function handleHideEvent(e:MouseEvent):void {
			var target:EventDispatcher = e.currentTarget as EventDispatcher;
			var toolTipData:ToolTipData = _target2feed[target] as ToolTipData;
			target.removeEventListener(toolTipData.hideEvent, handleShowEvent, false);
			hide();
		}
	}
}

internal class ToolTipData 
{
	private var _showEvent:String;
	private var _hideEvent:String;
	private var _feed:*;
	private var _showDelay:Number = -1;
	private var _updateInterval:Number = 0;
	
	public function ToolTipData(showEvent:String, hideEvent:String, feed:*, 
				showDelay:Number = -1, updateInterval:Number = 0) 
	{
		_showEvent = showEvent;
		_hideEvent = hideEvent;
		_feed = feed;
		_showDelay = showDelay;
		_updateInterval = updateInterval;
	}

	public function get showEvent() : String {
		return _showEvent;
	}

	public function get hideEvent() : String {
		return _hideEvent;
	}

	public function get feed() : * {
		return _feed;
	}

	public function get showDelay() : Number {
		return _showDelay;
	}

	public function get updateInterval() : Number {
		return _updateInterval;
	}
}
