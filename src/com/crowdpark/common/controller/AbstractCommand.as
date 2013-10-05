/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:10 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.common.controller {
import com.crowdpark.hangman.model.game.GameProxy;
import com.crowdpark.hangman.model.transitions.TransitionsProxy;

import org.puremvc.as3.multicore.utilities.fabrication.patterns.command.SimpleFabricationCommand;

public class AbstractCommand extends SimpleFabricationCommand {
    public function AbstractCommand() {
        super();
    }

    protected function get transitionsProxy():TransitionsProxy {

        return TransitionsProxy(retrieveProxy(TransitionsProxy.NAME));
    }
}
}
