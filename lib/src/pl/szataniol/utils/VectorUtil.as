/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 6/6/13
 * Time: 10:25 PM
 * To change this template use File | Settings | File Templates.
 */
package pl.szataniol.utils {
public class VectorUtil {
    public function VectorUtil() {
    }

    public static function removeDuplicates(vector:Vector.<*>):void {

        for (var i:uint = 0; i < vector.length; i++) {

            for(var j:int = i+1; j < vector.length; j++) {

                if(vector[i] == vector[j]) {

                    vector.splice(j, 1);
                    j--;
                }
            }
        }
    }
}
}
