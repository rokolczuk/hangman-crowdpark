/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 1:01 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game.components.keyboard {
import com.crowdpark.hangman.skins.game.keyboard.KeyboardLetterSkin;
import com.greensock.TweenLite;

import flash.display.DisplayObject;
import flash.events.MouseEvent;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

public class KeyboardKey extends DisplayObjectWrapper {

    private var _letter:String;

    public function KeyboardKey(target:KeyboardLetterSkin, letter:String) {

        super(target);
        _letter = letter;
        initKeyboardKey();
    }

    private function initKeyboardKey():void {

        turnMouseEventsRedispatchOn();

        view.labelTxt.text = _letter.toUpperCase();

        view.useHandCursor = view.buttonMode = true;
        view.mouseChildren = false;

        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }

    private function rollOutHandler(event:MouseEvent):void {

        TweenLite.to(view.background,.2, {tint:0xffffff});
    }

    private function rollOverHandler(event:MouseEvent):void {

        TweenLite.to(view.background,.2, {tint:0xdddddd});
    }

    public function get view():KeyboardLetterSkin {

        return KeyboardLetterSkin(viewComponent);
    }

    public function get letter():String {
        return _letter;
    }

    public function set enabled(enabled:Boolean):void {

        view.mouseEnabled = enabled;
        TweenLite.to(view, .2, {alpha:enabled ? 1 : 0});

    }
}
}
