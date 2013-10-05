package pl.szataniol.utils.text {
	import flash.events.FocusEvent;
	import flash.text.TextField;

	/**
	 * @author Andrzej Korolczuk
	 */
	public class SmartTextfield {

		private var defaultText : String;
		private var _textfield : TextField;

		public function SmartTextfield(textfield : TextField, defaultText : String = null) : void {
			
			_textfield = textfield;
			this.defaultText = defaultText == null ? textfield.text : defaultText;		
			
			_textfield.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);	
			_textfield.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);	
		}

		private function focusOutHandler(event : FocusEvent) : void {
			
			if(_textfield.text == '') {
				_textfield.text = defaultText;
			}
		}

		private function focusInHandler(event : FocusEvent) : void {
			
			if(_textfield.text == defaultText) {
				_textfield.text = '';
			}
		}

		public function dispose() : void {
			
			if(_textfield) {
				
				_textfield.removeEventListener(FocusEvent.FOCUS_IN, focusInHandler);	
				_textfield.removeEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);	
			}
			
			_textfield = null;
			
		}

        public function isEmpty():Boolean {

            return _textfield.text == "" || _textfield.text == defaultText;
        }

        public function get text():String {

            return _textfield.text;
        }
	}
}
