/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 3:37 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game.components.word {
import com.crowdpark.hangman.skins.game.word.WordCellSkin;

import flash.display.DisplayObject;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

public class WordCell extends DisplayObjectWrapper {

    private var _revealed:Boolean;

    public function WordCell(skin:WordCellSkin) {

        super(skin);
        skin.labelTxt.visible = false;
    }

    public function get view():WordCellSkin {

        return WordCellSkin(viewComponent);
    }

    public function revealLetter(letter:String):void {

        view.labelTxt.visible = true;
        view.labelTxt.text = letter.toUpperCase();

        _revealed = true;
    }

    public function get revealed():Boolean {

        return _revealed;
    }
}
}
