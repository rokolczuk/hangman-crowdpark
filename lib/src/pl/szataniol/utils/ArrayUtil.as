package pl.szataniol.utils {

	/**
	 * @author Andrzej
	 */
	public class ArrayUtil {

		
		public static function randomSort(...params) : int {
			
			return Math.random() < .5 ? 1 : -1;
		}

		public static function shuffle(array : Array) : void {
			
			array.sort(randomSort);
		}
	}
}
