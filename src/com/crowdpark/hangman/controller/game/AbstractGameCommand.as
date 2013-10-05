/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 3:19 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.controller.game {
import com.crowdpark.common.controller.AbstractCommand;
import com.crowdpark.hangman.model.game.GameProxy;
import com.crowdpark.hangman.view.game.GameView;

public class AbstractGameCommand extends AbstractCommand {

    public function AbstractGameCommand() {
        super();
    }

    protected function get game():GameView {

        return GameView(retrieveMediator(GameView.NAME))
    }

    protected function get gameProxy():GameProxy {

        return GameProxy(retrieveProxy(GameProxy.NAME));
    }
}
}
