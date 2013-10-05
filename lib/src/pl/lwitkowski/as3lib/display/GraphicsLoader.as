package pl.lwitkowski.as3lib.display {
	import flash.display.DisplayObject;
	import com.greensock.TweenLite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class GraphicsLoader extends Sprite 
	{
		// events
		public static const COMPLETE:String = Event.COMPLETE;
		public static const ERROR:String = "unknownError";

		// options
		public static const MAINTAIN_ASPECT_RATIO:int =			1 << 0;
		public static const FILL_AREA:int = 					1 << 1;
		public static const CENTER_H:int = 						1 << 3;
		public static const CENTER_V:int = 						1 << 4;
		public static const CENTER:int = CENTER_H | CENTER_V;
		public static const SMOOTHING:int = 					1 << 5;
		public static const FADE_IN:int = 						1 << 6;
		public static const UNLOAD_ON_START:int = 				1 << 7;
		public static const CACHE:int = 						1 << 8;
		public static const IGNORE_ERRORS:int = 				1 << 9;
		
		// TODO		//public static const ALIGH_CENTER_H:int = 				1 << 20;		//public static const ALIGH_CENTER_V:int = 				1 << 21;
		//public static const CONTENT_ALIGH_CENTER_H:int = 		1 << 20;		//public static const CONTENT_ALIGH_CENTER_V:int = 		1 << 20;		//public static const CONTENT_ALIGH_LEFT_H:int = 			1 << 20;		//public static const CONTENT_ALIGH_RIGHT_H:int = 		1 << 20;
		// TODO end

		private static const _cache:Object = {};

		// instance
		private var _defaultOptions:int = 0;
		private var _defaultWidth:int = 0;
		private var _defaultHeight:int = 0;
		private var _context:LoaderContext;

		private var _url:String;
		private var _options:int = -1;
		private var _width:Number = 0;
		private var _height:Number = 0;

		private var _loader:Loader;
		private var _container:Sprite;

		public function GraphicsLoader(defaultOptions:int = 0, defaultWidth:int = 0, 
							defaultHeight:int = 0, defaultContext:LoaderContext = null) 
		{
			_defaultOptions = defaultOptions;
			_defaultWidth = defaultWidth;
			_defaultHeight = defaultHeight;
			_context = defaultContext;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError, false, 0, true);
		}

		public function load(url:String, options:int = -1, width:int = -1, height:int = -1, 
									context:LoaderContext = null, force:Boolean = false):void {
			if((url == null) || (url.length == 0)) {
				unload();
			} else if((_url != url) || force) {
				_options = (options >= 0) ? options : _defaultOptions;
				_width = (width >= 0) ? width : _defaultWidth;
				_height = (height >= 0) ? height : _defaultHeight;
				
				if(testOption(UNLOAD_ON_START)) {
					unload();
				}
				_url = url;
				
				if(testOption(CACHE) && _cache[_url] is BitmapData) {
					processContent(new Bitmap(_cache[_url] as BitmapData));
				} else {
					try {
						_loader.load(new URLRequest(url), context || _context);
					} catch(e:SecurityError) {
						_loader.unload();
					}
				}	
			}
		}

		public function unload():void {
			while(numChildren) {
				removeChildAt(numChildren - 1);
			}
			try {
				_loader.close();
			} catch(e:Error) {}
			_loader.unloadAndStop();
			_url = null;
		}
		
		public function setDefaultOption(option:uint, value:Boolean):void {
			if(value) {
				_defaultOptions = _defaultOptions | option;
			} else {
				_defaultOptions = _defaultOptions & (~option);
			} 
		}
		
		public function get bitmapData():BitmapData {
			var bitmapData:BitmapData = null;
			try {
				var bounds:Rectangle = _container.getBounds(this); 
				var mtx:Matrix = new Matrix();
				mtx.translate(-bounds.x, -bounds.y);
				
				bitmapData = new BitmapData(bounds.width, bounds.height, true, 0xFFFFFF);
				bitmapData.draw(this, mtx);
			} catch(e:Error) {
				bitmapData = null;
			}
			
			return bitmapData;
		}

		protected function testOption(option:uint):Boolean {
			return (_options & option) > 0; 
		}

		protected function handleLoadComplete(e:Event):void {
			var content:DisplayObject;
			try {
				content = Bitmap(_loader.content);
				if(testOption(CACHE)) {
					_cache[_url] = Bitmap(content).bitmapData.clone();
				}
			} catch (e:Error) {
				content = _loader;
			}
			if(content == null) {
				if(!testOption(IGNORE_ERRORS)) {
					dispatchEvent(new Event(ERROR));
				}
				return;
			} else {
				
				processContent(content);
				dispatchEvent(new Event(COMPLETE));
			}
		} 

		protected function handleLoadError(e:IOErrorEvent):void {
			while(numChildren) {
				removeChildAt(numChildren - 1);
			}
			if(!testOption(IGNORE_ERRORS)) {
				dispatchEvent(e);
			}
		}

		private function processContent(content:DisplayObject):void {
			var scaleX:Number = 1;
			var scaleY:Number = 1;
			var visibleAreaWidth:Number = content.width;
			var visibleAreaHeight:Number = content.height;
			
			_container = new Sprite();
			
			// scaling 
			if (_width > 0 && _height > 0) {
				content.width = _width;
				content.height = _height;
					
				scaleX = content.scaleX;
				scaleY = content.scaleY;
				
				content.scaleX = content.scaleY = 1;
				
				if (testOption(MAINTAIN_ASPECT_RATIO)) {
					scaleX = scaleY = testOption(FILL_AREA) ? Math.max(scaleX, scaleY) : Math.min(scaleX, scaleY);
				}
				
				content.scaleX = scaleX;
				content.scaleY = scaleY;
				
				visibleAreaWidth = Math.min(content.width, _width);
				visibleAreaHeight = Math.min(content.height, _height);
			}
			
			//trace("after scaling: "+[scaleX, scaleY, visibleAreaWidth, visibleAreaHeight]);
			
			// clipping
			try {
				var bitmapContent:Bitmap = Bitmap(content);
				var mtx:Matrix = new Matrix();
				mtx.scale(scaleX, scaleY);
				
				var bitmapData:BitmapData = new BitmapData(visibleAreaWidth, visibleAreaHeight, true, 0);
				bitmapData.draw(content, mtx, null, null, null, testOption(SMOOTHING));
				bitmapContent.bitmapData = bitmapData;
				bitmapContent.smoothing = testOption(SMOOTHING);
				content.scaleX = content.scaleY = 1;
			} catch(e:Error) { 
				// nie mozna robic draw
				//trace("setting scroll rect "+[visibleAreaWidth, visibleAreaHeight]);
				_container.scrollRect = new Rectangle(0, 0, visibleAreaWidth, visibleAreaHeight);
			}
			
			// center
			if(testOption(CENTER_H)) {
				_container.x -= (visibleAreaWidth >> 1);
			} else if(visibleAreaWidth < _width) {
				_container.x += (_width - visibleAreaWidth)/2; 
			}
			if(testOption(CENTER_V)) {
				_container.y -= (visibleAreaHeight >> 1);
			} else if(visibleAreaHeight < _height) {
				_container.y += (_height - visibleAreaHeight)/2; 
			}
			
			// fadeIn	
			if (testOption(FADE_IN)) {
				content.alpha = 0;
				TweenLite.to(content, 0.3, { alpha : 1 });
			}
			
			_container.addChild(content);
			
			while(numChildren) {
				removeChildAt(numChildren - 1);
			}
			addChild(_container);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}