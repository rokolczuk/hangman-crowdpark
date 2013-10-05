/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 3/14/13
 * Time: 8:48 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.transitions.controler {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.transitions.TransitionsNotifications;
import com.crowdpark.hangman.model.transitions.TransitionsProxy;

import org.puremvc.as3.multicore.interfaces.INotification;

public class InitTransitionsCommand extends AbstractCommand {

    public function InitTransitionsCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        registerProxy(new TransitionsProxy());
        registerCommand(TransitionsNotifications.TRANSITION_IN_COMPLETE, TransitionInCompleteCommand) ;
        registerCommand(TransitionsNotifications.TRANSITION_OUT_COMPLETE, TransitionOutCompleteCommand) ;
        registerCommand(TransitionsNotifications.TRANSITION, TransitionCommand);
    }
}
}
