package pl.lwitkowski.as3lib.modules {
	import pl.lwitkowski.as3lib.display.SkinUtil;

	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class AbstractSkinnableModule extends Sprite 
	{
		protected var _skin:SkinUtil; 
		
		protected var _viewMediatorClass:Class;
		protected var _viewMediator:Object;
		protected var _dispatchInitComplete:Boolean = true;
       
		public function AbstractSkinnableModule(viewClass:Class, viewMediatorClass:Class = null, 
						dispatchInitComplete:Boolean = true) 
		{
            _viewMediatorClass = viewMediatorClass;
            _dispatchInitComplete = dispatchInitComplete;

			if(stage) {
				stage.showDefaultContextMenu = false;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				TweenPlugin.activate([AutoAlphaPlugin]);
			}
            if(viewClass) {
				initView(viewClass);
            }
		}
		
		protected function initView(viewClass:Class):void {
    		_skin = new SkinUtil();
			_skin.addEventListener(SkinUtil.SKIN_READY, handleSkinReady);
    		_skin.initSkinUsingEmbededAsset(viewClass);
		}
		
		protected function handleSkinReady(e:Event):void {
			addChild(_skin.skin);
			if(_viewMediatorClass) {
				_viewMediator = new _viewMediatorClass(_skin.skin);
			}
			
			if(_dispatchInitComplete) {
				dispatchEvent(new Event(ModuleLoader.INIT_COMPLETE));
			}
		}
	}
}
