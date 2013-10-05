/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 1:33 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.main {
import com.crowdpark.common.view.AbstractMediator;
import com.crowdpark.hangman.skins.MainSkin;
import com.crowdpark.hangman.view.game.GameView;
import com.crowdpark.hangman.view.rules.RulesView;

public class MainView extends AbstractMediator {

    public static const NAME:String = "MainView";

    public function MainView(skin:MainSkin) {

        super(NAME, skin);
    }

    public function get view():MainSkin {

        return MainSkin(viewComponent);
    }


    override public function onRegister():void {

        registerMediator(new GameView(view.game));
        registerMediator(new RulesView(view.rules));
    }
}
}
