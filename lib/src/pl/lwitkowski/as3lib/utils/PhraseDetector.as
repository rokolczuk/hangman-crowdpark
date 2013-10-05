package pl.lwitkowski.as3lib.utils 
{
	import com.adobe.crypto.MD5;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;

	/**
	 * @one2tribe
	 * Klasa wykrywająca wpisanie z klawiatury danej frazy
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class PhraseDetector extends EventDispatcher
	{
		public static function prepareCode(phrase:String):String {
			var asCode:Array = [];
			asCode.push("var detector:PhraseDetector = new PhraseDetector(\"" +MD5.hash(phrase)+ "\", "+phrase.length+", stageRef);");
			asCode.push("detector.addEventListener(PhraseDetector.PHRASE_DETECTED, handlePhraseDetected);");
			return asCode.join("\n");
		}
		
		public static const PHRASE_DETECTED:String = "phraseDetected";
		
		private var _phraseHash:String;
		private var _phraseLength:int;
		private var _inputBuffer : String;
		private var _keyboardEventsDispatcher:EventDispatcher;
		
		public function PhraseDetector(phraseHash:String, phraseLength:uint, keyboardEventsDispatcher:EventDispatcher) {
			_phraseHash = phraseHash;
			_phraseLength = phraseLength; 
			
			_inputBuffer = '';
			
			_keyboardEventsDispatcher = keyboardEventsDispatcher;
			_keyboardEventsDispatcher.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
		}
		
		public function check(phrase:String):void {
			if(MD5.hash(phrase) == _phraseHash) {
				_inputBuffer = "";
				dispatchEvent(new Event(PHRASE_DETECTED));
			}
		}
		
		public function dispose():void {
			if(_keyboardEventsDispatcher) {
				_keyboardEventsDispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
				_keyboardEventsDispatcher = null;
			}
			
			_phraseHash = null;
			_phraseLength = -1;
			_inputBuffer = null;
		}
		
		private function handleKeyDown(e:KeyboardEvent):void {
			_inputBuffer += String.fromCharCode(e.charCode);
			if(_inputBuffer.length >= _phraseLength) {
				_inputBuffer = _inputBuffer.substring(_inputBuffer.length - _phraseLength, _inputBuffer.length);
				check(_inputBuffer);
			}
		}
	}
}