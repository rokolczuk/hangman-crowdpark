package pl.lwitkowski.as3lib.controls.tooltip.utils {
	import pl.lwitkowski.as3lib.controls.tooltip.IToolTipDataProvider;
	import pl.lwitkowski.as3lib.locale.LocaleManager;
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com
	 */
	public class LocalizedToolTipData implements IToolTipDataProvider
	{
		private var _locale:LocaleManager;
		private var _stringKey:String;
		
		public function LocalizedToolTipData(locale:LocaleManager, stringKey:String) {
			_locale = locale;
			_stringKey = stringKey;
		}
		
		// IToolTipDataProvider impl
		public function get toolTipData():* {
			return _locale.getString(_stringKey);
		}
	}
}
