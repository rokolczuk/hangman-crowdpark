/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 2/23/13
 * Time: 11:50 AM
 * To change this template use File | Settings | File Templates.
 */
package pl.szataniol.sound.events {
import flash.events.Event;

public class SamplerEvent extends Event {

    public static const START:String = "start";
    public static const STEP:String = "step";
    public static const STOP:String = "stop";
    public static const MUTE_MAP_CHANGED:String = "muteMapChanged";

    public var numStep:uint;

    public function SamplerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
