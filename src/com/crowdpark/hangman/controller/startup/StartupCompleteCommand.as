/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 2:16 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.startup {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.transitions.ITransitionable;
import com.crowdpark.hangman.model.transitions.TransitionCall;
import com.crowdpark.hangman.view.rules.RulesView;

import org.puremvc.as3.multicore.interfaces.INotification;

public class StartupCompleteCommand extends AbstractCommand {

    public function StartupCompleteCommand() {
        super();
    }


    override public function execute(notification:INotification):void {

        transitionsProxy.transitionTo(new TransitionCall(ITransitionable(retrieveMediator(RulesView.NAME))));
    }
}
}
