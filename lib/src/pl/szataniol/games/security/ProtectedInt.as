package pl.szataniol.games.security {

	/**
	 * @author Andrzej Korolczuk
	 */
	public class ProtectedInt {

		private var _value : Number;
		private var shift : int;

		public function ProtectedInt() {
			
			shift = 10 + int(Math.random() * 990);
			_value = shift;
		}
		
		public function setZero() : void {
			
			_value = shift;  
		}
		
		public function add(value : int) : void {
			
			var nextShift:int = 10 + int(Math.random() * 990);
			_value += nextShift - shift + value;
			shift = nextShift;
		}
		
		public function subtract(value:int):void {
			
			add(-value);
		}
		
		public function multiply(value:Number):void {
			
			var nextShift:int = 10 + int(Math.random() * 990);
			_value -= shift;
			_value *= value;
			_value += nextShift;
			shift = nextShift;
		}
		
		public function divide(value:Number):void {
			
			multiply(1/value);
		}

		public function getValue() : int {
			
			return _value - shift;
		}
		public function toString():String {
			
			return String(getValue());
		}

		public function setValue(value : int) : void {
			
			_value = shift + value;  
		}
	}
}
