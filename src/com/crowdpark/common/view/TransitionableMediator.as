/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 2:12 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.common.view {
import com.crowdpark.hangman.model.transitions.ITransitionable;
import com.crowdpark.hangman.model.transitions.TransitionCall;
import com.crowdpark.hangman.model.transitions.TransitionsNotifications;
import com.crowdpark.hangman.model.transitions.TransitionsProxy;
import com.greensock.TweenLite;

public class TransitionableMediator extends AbstractMediator implements ITransitionable {

    protected  var _call:TransitionCall;

    public function TransitionableMediator(name:String = null, viewComponent:Object = null) {

        super(name, viewComponent);
        viewComponent.visible = false;
    }

    protected function init():void {

    }

    public function transitionIn():void {

        viewComponent.visible = true;
        viewComponent.alpha = 0;
        TweenLite.to(viewComponent,.4, {alpha:1, onComplete:transitionInComplete});
    }

    public function transitionOut():void {

        TweenLite.to(viewComponent,.4, {alpha:0, onComplete:transitionOutComplete});
    }

    private function transitionInComplete():void {

        init();
        sendNotification(TransitionsNotifications.TRANSITION_IN_COMPLETE, this);
    }

    private function transitionOutComplete():void {

        viewComponent.visible = false;
        sendNotification(TransitionsNotifications.TRANSITION_OUT_COMPLETE, this);
    }

    public function get saveToHistory():Boolean {

        return false;
    }

    public function set call(call:TransitionCall):void {

        _call = call;
    }

    protected function get transitionsProxy():TransitionsProxy {

        return TransitionsProxy(retrieveProxy(TransitionsProxy.NAME));
    }
}
}
