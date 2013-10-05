/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 4:14 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.game {
import com.crowdpark.hangman.GameNotifications;

import org.puremvc.as3.multicore.interfaces.INotification;

public class InitGameCommand extends AbstractGameCommand {

    public function InitGameCommand() {
        super();
    }

    override public function execute(notification:INotification):void {

        registerCommand(GameNotifications.GUESS, GuessCommand);
    }
}
}
