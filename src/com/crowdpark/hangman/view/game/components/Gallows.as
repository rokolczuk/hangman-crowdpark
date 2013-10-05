/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 1:26 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game.components {
import com.greensock.TweenLite;

import flash.display.DisplayObject;
import flash.display.Sprite;

import pl.lwitkowski.as3lib.display.DisplayObjectWrapper;

public class Gallows extends DisplayObjectWrapper {

    private var _steps:Vector.<Sprite> = new Vector.<Sprite>();
    private var _step:uint;

    public function Gallows(target:Sprite) {

        super(target);
        initGallows();
    }

    public function get view():Sprite {

        return Sprite(viewComponent);
    }

    private function initGallows():void {

        for(var i:uint = 0; i < view.numChildren; i++) {

            _steps.push(view.getChildAt(i));
            view.getChildAt(i).visible = false;
        }

        view.mouseEnabled = view.mouseChildren = false;
        view.blendMode = "layer";
    }

    public function set step(step:uint):void {

        _step = step;

        var graphic:Sprite = _steps[_step-1]

        graphic.visible = true;
        graphic.alpha = 0;
        TweenLite.to(graphic,.3, {alpha:1});
    }

    public function reset(smooth:Boolean = false):void {

        if(smooth) {

            TweenLite.to(view,.4, {alpha:0, onComplete:reset});

        }   else {

            view.alpha = 1;

            for each (var graphic:Sprite in _steps) {

                graphic.visible = false;
            }
        }


    }
}
}
