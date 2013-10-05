/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 3:11 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.game {
import com.crowdpark.common.controller.AbstractCommand;

import org.puremvc.as3.multicore.interfaces.INotification;

public class GuessCommand extends AbstractGameCommand {
    public function GuessCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        var letter:String = String(notification.getBody());
        gameProxy.guess(letter);
    }
}
}
