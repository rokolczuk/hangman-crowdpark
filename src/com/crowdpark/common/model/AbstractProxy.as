/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:11 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.common.model {
import org.puremvc.as3.multicore.utilities.fabrication.patterns.proxy.FabricationProxy;

public class AbstractProxy extends FabricationProxy {
    public function AbstractProxy(name:String = null, data:Object = null) {
        super(name, data);
    }
}
}
