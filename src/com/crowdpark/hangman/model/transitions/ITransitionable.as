/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 3/13/13
 * Time: 9:11 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.transitions {
public interface ITransitionable {

    function transitionIn():void;
    function transitionOut():void;
    function get saveToHistory():Boolean;
    function set call(call:TransitionCall):void;
}
}
