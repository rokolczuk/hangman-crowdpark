/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 11:32 AM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.view.game {
import com.crowdpark.common.view.AbstractMediator;
import com.crowdpark.common.view.TransitionableMediator;
import com.crowdpark.hangman.GameNotifications;
import com.crowdpark.hangman.model.game.GameProxy;
import com.crowdpark.hangman.model.sound.Sounds;
import com.crowdpark.hangman.skins.game.GameSkin;
import com.crowdpark.hangman.view.game.components.Gallows;
import com.crowdpark.hangman.view.game.components.keyboard.Keyboard;
import com.crowdpark.hangman.view.game.components.word.Word;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

import org.puremvc.as3.multicore.patterns.observer.Notification;

public class GameView extends TransitionableMediator {

    public static const NAME:String = "GameView";

    private var _gallows:Gallows;
    private var _keyboard:Keyboard;
    private var _word:Word;


    public function GameView(skin:GameSkin) {

        super(NAME, skin);
        initGameView();
    }

    private function initGameView():void {

        _gallows = new Gallows(view.gibet);
        _keyboard = new Keyboard(view.keyboard);
        _word = new Word(view.word);

        _keyboard.addEventListener(Event.SELECT, letterSelectedHandler);
    }


    override public function onRegister():void {

        updateWinsAndLoses();
    }

    public function get view():GameSkin {

        return GameSkin(viewComponent);
    }


    override protected function init():void {

        start();
    }

    public function start():void {

        gameProxy.start();

    }

    private function get gameProxy():GameProxy {

        return GameProxy(retrieveProxy(GameProxy.NAME))
    }

    public function revealLetters(letter:String,  indexes:Vector.<uint>):void {

    }

    private function letterSelectedHandler(event:Event):void {

        soundsManager.getSound(Sounds.CLICK).play();
        sendNotification(GameNotifications.GUESS, _keyboard.letter);
    }

    public function respondToGameOver(note:Notification):void {

        view.mouseEnabled = view.mouseChildren = false;
        updateWinsAndLoses();

        setTimeout(_word.revealWord, 2000, note.getBody() as String);

        setTimeout(hideAndRestart, 4000);

        soundsManager.getSound(Sounds.LOSE).play();
    }

    private function hideAndRestart():void {

        _gallows.reset(true);
        _keyboard.reset();
        _word.hide();

        setTimeout(gameProxy.start, 1000);

    }

    public function respondToNewWord(note:Notification):void {

        var length:uint = uint(note.getBody());

        _gallows.reset();
        _keyboard.reset();
        _word.createWord(length);

        view.mouseEnabled = view.mouseChildren = true;
    }

    public function respondToWordGuessed(note:Notification):void {

        view.mouseEnabled = view.mouseChildren = false;

        updateWinsAndLoses();

        setTimeout(hideAndRestart, 2000);

        soundsManager.getSound(Sounds.WIN).play();
    }

    public function respondToLetterGuessSuccess(note:Notification):void {

        trace("letter guess success");

        var letter:String = note.getBody().letter;
        var indexes:Vector.<uint> = note.getBody().indexes;

        _word.revealLetter(letter,  indexes);
    }
    public function respondToLetterGuessFailue(note:Notification):void {

        var fails:uint = uint(note.getBody());
        _gallows.step = fails;
    }

    private function updateWinsAndLoses():void {

         view.statsTxt.text = "WON: "  + gameProxy.wins + " LOST: " + gameProxy.loses;
    }

}
}
