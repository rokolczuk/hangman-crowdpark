/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:09 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman {
import com.crowdpark.hangman.controller.HangmanStartupCommand;

import flash.display.StageScaleMode;

import org.puremvc.as3.multicore.utilities.fabrication.components.FlashApplication;

[SWF(backgroundColor="0x000000", frameRate="31", width="310", height="450")]
public class GameModule extends FlashApplication {

    public function GameModule() {
        super();
    }

    override public function getStartupCommand():Class {

        return HangmanStartupCommand;
    }
}
}
