/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 1:52 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.rules {
import com.crowdpark.common.view.AbstractMediator;
import com.crowdpark.common.view.TransitionableMediator;
import com.crowdpark.common.view.components.RollOverAnimationButton;
import com.crowdpark.hangman.GameNotifications;
import com.crowdpark.hangman.model.transitions.ITransitionable;
import com.crowdpark.hangman.model.transitions.TransitionCall;
import com.crowdpark.hangman.model.transitions.TransitionsNotifications;
import com.crowdpark.hangman.skins.rules.RulesSkin;
import com.crowdpark.hangman.view.game.GameView;

import flash.events.MouseEvent;

public class RulesView extends TransitionableMediator {

    public static const NAME:String = "RulesView";

    private var _playBtn:RollOverAnimationButton;

    public function RulesView(skin:RulesSkin) {

        super(NAME, skin);
        initRulesView();
    }

    private function initRulesView():void {

        _playBtn = new RollOverAnimationButton(view.playBtn);
        _playBtn.addEventListener(MouseEvent.CLICK, playBtnClickedHandler);
    }

    private function playBtnClickedHandler(event:MouseEvent):void {

        sendNotification(TransitionsNotifications.TRANSITION, new TransitionCall(ITransitionable(retrieveMediator(GameView.NAME))));
        _playBtn.view.mouseEnabled = false;
    }

    public function get view():RulesSkin {

        return RulesSkin(viewComponent);
    }
}
}
