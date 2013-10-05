/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:11 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller {
import com.crowdpark.hangman.controller.startup.InitStartupCommand;
import com.crowdpark.hangman.model.game.GameProxy;
import com.crowdpark.hangman.model.transitions.controler.InitTransitionsCommand;
import com.crowdpark.hangman.skins.MainSkin;
import com.crowdpark.hangman.skins.game.GameSkin;
import com.crowdpark.hangman.view.game.GameView;
import com.crowdpark.hangman.view.main.MainView;

import flash.display.MovieClip;

import org.puremvc.as3.multicore.interfaces.INotification;

import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.startup.ModuleStartupCommand;

public class HangmanStartupCommand extends ModuleStartupCommand {

    public function HangmanStartupCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        registerProxy(new GameProxy());

        executeCommand(InitStartupCommand);

        MovieClip(fabrication).addChild(MainView(registerMediator(new MainView(new MainSkin()))).view);

    }
}
}
