/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 4:47 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.startup {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.sound.Sounds;
import com.crowdpark.hangman.model.sound.SoundsProxy;

import org.puremvc.as3.multicore.interfaces.INotification;

import pl.szataniol.sound.identifiers.concrete.SoundIdentifier;
import pl.szataniol.sound.resources.concrete.LinkageResource;
import pl.szataniol.sound.resources.concrete.SimpleSoundResource;

public class InitSoundsCommand extends AbstractCommand {

    public function InitSoundsCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        var soundsProxy:SoundsProxy = new SoundsProxy();
        soundsProxy.soundManager.registerSound(new SoundIdentifier(Sounds.CLICK, new SimpleSoundResource(new sound_click)));
        soundsProxy.soundManager.registerSound(new SoundIdentifier(Sounds.WIN, new SimpleSoundResource(new sound_win)));
        soundsProxy.soundManager.registerSound(new SoundIdentifier(Sounds.LOSE, new SimpleSoundResource(new sound_lose)));

        trace("click", soundsProxy.soundManager.getSound(Sounds.CLICK));

        registerProxy(new SoundsProxy());
    }
}
}
