/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 3:30 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game.components.word {
import com.crowdpark.hangman.skins.game.word.WordCellSkin;
import com.greensock.TweenLite;
import com.greensock.easing.Back;

import flash.display.DisplayObject;
import flash.display.Sprite;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;
import pl.szataniol.display.layout.concrete.ListLayout;

public class Word extends DisplayObjectWrapper {

    private var _cellsContainer:Sprite = new Sprite();
    private var _cells:Vector.<WordCell> = new Vector.<WordCell>();

    private var _layout:ListLayout = new ListLayout(30, 0);

    public function Word(target:DisplayObject = null) {

        super(target);
        initWord();
    }

    private function initWord():void {

        view.addChild(_cellsContainer);
    }

    public function get view():Sprite {

        return Sprite(viewComponent);
    }

    public function revealLetter(letter:String, indexes:Vector.<uint>):void {

        var index:uint;

          for(var i:uint = 0; i< indexes.length; i++) {

              index = indexes[i];
              _cells[index].revealLetter(letter);
          }
    }

    public function createWord(length:uint):void {

        _cellsContainer.alpha = 1;

        disposeWord();

        var wordCell:WordCell;

        for(var i:uint = 0; i<length; i++) {

            wordCell = new WordCell(new WordCellSkin());
            _layout.setItemPosition(wordCell.view, i);
            _cellsContainer.addChild(wordCell.view);
            _cells.push(wordCell);

            wordCell.view.scaleX = 0;

            TweenLite.to(wordCell.view,.7, {scaleX:1, ease:Back.easeIn, delay:i *.2});
        }

        _cellsContainer.x = -_cellsContainer.width/2;

    }

    private function disposeWord():void {

        _cells.splice(0, _cells.length);
        while(_cellsContainer.numChildren > 0) _cellsContainer.removeChildAt(0);
    }

    public function hide():void {

        TweenLite.to(_cellsContainer,.4, {alpha:0});
    }

    public function revealWord(word:String):void {

        for(var i:uint = 0; i<_cells.length; i++) {

            if(!_cells[i].revealed) {

                _cells[i].revealLetter(word.charAt(i));
            }
        }
    }
}
}
