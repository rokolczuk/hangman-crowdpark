package pl.lwitkowski.as3lib.locale {
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.utils.Dictionary;

	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class LocaleManager extends EventDispatcher
	{
		private static var _instance:LocaleManager;
		public static function getInstance():LocaleManager {
			if(!_instance) {
				_instance = new LocaleManager();
			}
			return _instance;
		}
		
		private var _registeredLocales:Object;
		private var _registeredLocalesArray:Array;
		
		private var _current:Locale;
		private var _default:Locale;
		
		protected var _registeredFields:Dictionary;

		public function LocaleManager() {
			_registeredLocales = new Object();
			_registeredLocalesArray = [];			
			_registeredFields = new Dictionary(true);
			
			addEventListener(Event.CHANGE, handleLangChange, false, 0xFFFFFF);
		}
	
		public function registerLocale(lang:Locale, asDefault:Boolean = false):void {
			if(hasRegisteredLocale(lang.id)) {
				throw new IllegalOperationError("lang already registered");
			} else {
				_registeredLocales[lang.id] = lang;
				_registeredLocalesArray.push(lang);
				if(asDefault) {
					_default = lang;
					if(currentLocale == null) {
						currentLocale = lang;
					}
				}
			}
		}
		
		public function unregisterLocale(lang:Locale):void {
			if(hasRegisteredLocale(lang.id)) {
				_registeredLocales[lang.id] = null;
				var index:int = _registeredLocalesArray.indexOf(lang);
				if(index >= 0) {
					_registeredLocalesArray.splice(index, 1);
				}
				if(_default == lang) _default = null;
				if(currentLocale == lang) currentLocale = null;
				lang.removeEventListener(Locale.READY, handleLangFileLoadComplete);
			}
		}

		public function hasRegisteredLocale(langId:String):Boolean {
			return (_registeredLocales[langId] is Locale);
		}
		
		public function get defaultLocale():Locale {
			return _default;
		}
		
		public function getLocaleById(langId:String):Locale {
			return Locale(_registeredLocales[langId]);
		}

		/**
		* Zmienia aktualny jzyk, i rozgasza to zdarzenie
		* @param	lang
		*/
		public function set currentLocaleById(value:String):void {
			try {
				if(_current.id == value) return;
			} catch(e:Error) {}
			
			if(_registeredLocales[value] == null) throw new IllegalOperationError('no lang');
			currentLocale = _registeredLocales[value];
		}
		
		[Bindable]
		/**
		* Zwraca obiekt z aktualna wersja jezykowa
		* @return
		*/
		public function get currentLocale():Locale {
			return _current;
		}
		
		private var _loadingLocale:Locale; 
		public function set currentLocale(value:Locale):void {
			if(value && !hasRegisteredLocale(value.id)) {
				registerLocale(value);
			}
			if(_loadingLocale) {
				_loadingLocale.removeEventListener(Locale.READY, handleLangFileLoadComplete);
				_loadingLocale = null;
			}
			if(value) {
				if(value.ready) {
					_current = value;
					dispatchEvent(new Event(Event.CHANGE));
				} else {
					_loadingLocale = value;
					value.addEventListener(Locale.READY, handleLangFileLoadComplete);
					value.load();
				}
			} else {
				_current = null;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function getString(key:String):String {
			return _current ? _current.getString(key) : ""; 
		}
		
		public function get allRegisteredLocales():Array {
			return _registeredLocalesArray.concat();
		}

		// GETTERS
		
		
		// UTILS
		public function registerTextField(target:TextField, labelId:String, updateNow:Boolean = true):void {
			if(target != null) {
				_registeredFields[target] = labelId;
		
				if (updateNow && _current && _current.getString(labelId).length > 0) {
					target.htmlText = _current.getString(labelId);
					target.dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}
		
		public function unregisterTextField(target:TextField):void {
			_registeredFields[target] = null;
			delete _registeredFields[target];
		}
		
		private function handleLangFileLoadComplete(e:Event):void {
			currentLocale = Locale(e.target);
		}

		private function handleLangChange(e:Event):void {
			for(var key:Object in _registeredFields) {
				var field:TextField = TextField(key);
				if(field) {
					field.htmlText = _current.getString(_registeredFields[field] as String) || '';
					field.dispatchEvent(new Event(Event.RESIZE));
				}
			}
		}
	}
} 