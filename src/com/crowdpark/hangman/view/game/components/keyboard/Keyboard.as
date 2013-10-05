/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 12:50 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game.components.keyboard {
import com.crowdpark.common.view.AbstractMediator;
import com.crowdpark.hangman.GameNotifications;
import com.crowdpark.hangman.skins.game.keyboard.KeyboardLetterSkin;
import com.crowdpark.hangman.view.game.components.keyboard.KeyboardKey;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

import pl.szataniol.display.layout.concrete.GridLayout;

public class Keyboard extends DisplayObjectWrapper {

    private static const LETTERS:String = "abcdefghijklmnopqrstuwxyz";

    private var _layout:GridLayout = new GridLayout(25, 25, 8);
    private var _letter:String;

    private var _keys:Vector.<KeyboardKey> = new Vector.<KeyboardKey>();

    public function Keyboard(container:Sprite) {

        super(container);
        initKeyboardView();
    }

    public function get view():Sprite {

        return Sprite(viewComponent);
    }

    private function initKeyboardView():void {

        createKeys();
    }

    private function createKeys():void {

        var key:KeyboardKey;

        for (var i:int = 0; i < LETTERS.length; i++) {

            key = new KeyboardKey(new KeyboardLetterSkin(), LETTERS.charAt(i));
            key.addEventListener(MouseEvent.CLICK, keyClickedHandler, false, 0, true);

            _layout.setItemPosition(key.view,  i);

            view.addChild(key.view);

            _keys.push(key);
        }
    }

    public function reset():void {

        for each (var keyboardKey:KeyboardKey in _keys) {

            keyboardKey.enabled = true;
        }
    }

    private function keyClickedHandler(event:MouseEvent):void {

        var key:KeyboardKey = KeyboardKey(event.target);
        key.enabled = false;
        _letter =  key.letter;
        dispatchEvent(new Event(Event.SELECT));
    }

    public function get letter():String {
        return _letter;
    }
}
}
