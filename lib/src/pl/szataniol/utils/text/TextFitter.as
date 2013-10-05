package pl.szataniol.utils.text {
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.text.TextField;

	/**
	 * @author Andrzej Korolczuk
	 */
	public class TextFitter {

		
		
		private var _margin : int;
		private var _textfield : TextField;

		public function TextFitter(textfield : TextField, margin : int = 5) {
			
			_textfield = textfield;
			_margin = margin;
			
			_textfield.addEventListener(Event.CHANGE, textfieldChangedHandler, false, 0, true);
		}

		private function textfieldChangedHandler(event : Event) : void {
			
			var textFormat : TextFormat;
			
			while(_textfield.textWidth + _margin > _textfield.width) {
				
				textFormat = _textfield.getTextFormat(0, _textfield.text.length);
				textFormat.size = int(textFormat.size) - 1;
				_textfield.setTextFormat(textFormat, 0, _textfield.text.length);
			}
			
			while(_textfield.textWidth + _margin < _textfield.width) {
				
				textFormat = _textfield.getTextFormat(0, _textfield.text.length);
				textFormat.size = int(textFormat.size) + 1;
				
				_textfield.setTextFormat(textFormat, 0, _textfield.text.length);
				
			}
			
			trace(_textfield.name+": " + textFormat.size, _textfield.textWidth, _textfield.width);
		}
		
		public function forceFit():void {
			
			textfieldChangedHandler(null);
		}
	}
}
