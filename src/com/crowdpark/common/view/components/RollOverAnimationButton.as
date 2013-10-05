/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 1:54 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.common.view.components {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.MouseEvent;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

public class RollOverAnimationButton extends DisplayObjectWrapper {

    public function RollOverAnimationButton(view:MovieClip) {
        super(view);
        initPlayButton();

    }

    private function initPlayButton():void {

        turnMouseEventsRedispatchOn();
        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        view.addFrameScript(0, view.stop);
        view.useHandCursor = view.buttonMode = true;
        view.mouseChildren = false;
    }

    private function rollOverHandler(event:MouseEvent):void {

        view.play();
    }

    public function get view():MovieClip {

        return MovieClip(viewComponent);
    }
}
}
