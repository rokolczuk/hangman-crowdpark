/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:11 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.common.view {
import com.crowdpark.hangman.model.sound.SoundsProxy;

import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FabricationMediator;

import pl.szataniol.sound.SoundManager;

public class AbstractMediator extends FabricationMediator {
    public function AbstractMediator(name:String = null, viewComponent:Object = null) {
        super(name, viewComponent);
    }

    protected function get soundsManager():SoundManager {

        return SoundsProxy(retrieveProxy(SoundsProxy.NAME)).soundManager
    }
}
}
