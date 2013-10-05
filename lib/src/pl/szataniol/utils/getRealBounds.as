package pl.szataniol.utils {
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	/**
	 * @author Joe Wheeler
	 */
	public function getRealBounds( displayObject : DisplayObject ) : Rectangle {
			
		var bounds : Rectangle, transform : Transform,
	            toGlobalMatrix : Matrix, currentMatrix : Matrix;
 
		transform = displayObject.transform;
		currentMatrix = transform.matrix;
		toGlobalMatrix = transform.concatenatedMatrix;
		toGlobalMatrix.invert();
		transform.matrix = toGlobalMatrix;
 
		bounds = transform.pixelBounds.clone();
 
		transform.matrix = currentMatrix;
 
		return bounds;
	}
}
