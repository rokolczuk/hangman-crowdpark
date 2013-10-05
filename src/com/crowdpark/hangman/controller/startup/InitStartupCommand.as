/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 2:19 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.startup {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.controller.game.InitGameCommand;
import com.crowdpark.hangman.model.transitions.controler.InitTransitionsCommand;
import com.greensock.plugins.TintPlugin;
import com.greensock.plugins.TweenPlugin;

import org.puremvc.as3.multicore.interfaces.INotification;

public class InitStartupCommand extends AbstractCommand {

    public function InitStartupCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        executeCommand(InitTransitionsCommand);
        executeCommand(LoadDictionaryFileCommand);
        executeCommand(InitGameCommand);
        executeCommand(InitSoundsCommand);

        TweenPlugin.activate([TintPlugin]);
    }
}
}
