/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 3/14/13
 * Time: 8:45 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.transitions.controler {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.transitions.ITransitionable;
import com.crowdpark.hangman.model.transitions.TransitionsProxy;

import org.puremvc.as3.multicore.interfaces.INotification;


public class TransitionInCompleteCommand extends AbstractCommand {
    public function TransitionInCompleteCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

       TransitionsProxy(retrieveProxy(TransitionsProxy.NAME)).transitionInCompleted(notification.getBody() as ITransitionable);
    }
}
}
