/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 3/14/13
 * Time: 8:49 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.transitions.controler {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.transitions.TransitionCall;
import com.crowdpark.hangman.model.transitions.TransitionsProxy;

import org.puremvc.as3.multicore.interfaces.INotification;


public class TransitionCommand extends AbstractCommand {

    public function TransitionCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        TransitionsProxy(retrieveProxy(TransitionsProxy.NAME)).transitionTo(notification.getBody() as TransitionCall);
    }
}
}
