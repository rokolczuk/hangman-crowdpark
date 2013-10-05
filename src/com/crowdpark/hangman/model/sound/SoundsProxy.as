/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 4:47 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.sound {
import com.crowdpark.common.model.AbstractProxy;

import pl.szataniol.sound.SoundManager;

public class SoundsProxy extends AbstractProxy {

    public static const NAME:String = "SoundsProxy";

    private var _soundManager:SoundManager = SoundManager.getInstance();

    public function SoundsProxy() {
        super(NAME);
    }

    public function get soundManager():SoundManager {
        return _soundManager;
    }
}
}
