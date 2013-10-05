/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 2:31 PM
 * To change this template use File | Settings | File Templates.
 */
package com.crowdpark.hangman.model.game {
import com.crowdpark.common.model.AbstractProxy;
import com.crowdpark.hangman.GameNotifications;

import pl.szataniol.games.security.ProtectedInt;

import pl.szataniol.utils.ArrayUtil;

public class GameProxy extends AbstractProxy {

    public static const NAME:String = "GameProxy";
    private static const NUM_FAILURES_TO_LOSE:uint = 7;

    private var _dictionary:Vector.<String>;
    private var _dictionaryCopy:Vector.<String>;

    private var _currentWord:String;

    private var _numTries:ProtectedInt = new ProtectedInt();
    private var _numFailures:ProtectedInt = new ProtectedInt();
    private var _numGuessedLetters:ProtectedInt = new ProtectedInt();
    private var _numWins:ProtectedInt = new ProtectedInt();
    private var _numLoses:ProtectedInt = new ProtectedInt();



    public function GameProxy() {

        super(NAME);
    }

    public function set dictionary(dictionary:Vector.<String>):void {

        _dictionary = dictionary
    }

    private function createDictionaryCopy():void {

        _dictionaryCopy = _dictionary.concat();
        _dictionaryCopy.sort(ArrayUtil.randomSort)
    }

    public function start():void {

        if(!_dictionaryCopy || _dictionaryCopy.length == 0) {
            createDictionaryCopy();
        }

        _currentWord = _dictionaryCopy.pop();

        _numTries.setValue(0);
        _numFailures.setValue(0);
        _numGuessedLetters.setValue(0);

        sendNotification(GameNotifications.NEW_WORD, _currentWord.length);

        trace("word: " + _currentWord);
    }

    public function guess(letter:String):void {

        trace("guess", _currentWord, letter);

        _numTries.add(1);

        if(_currentWord.indexOf(letter) > -1) {

            var indexes:Vector.<uint> = new Vector.<uint>();
            var start:uint = 0;
            var index:int;

            while((index = _currentWord.indexOf(letter, start)) != -1) {

                indexes.push(index);
                start = index + 1;
            }

            _numGuessedLetters.add(indexes.length);

            sendNotification(GameNotifications.LETTER_GUESS_SUCCESS, {letter:letter,  indexes:indexes});

            trace(_numGuessedLetters.getValue() , _currentWord.length)

            if(_numGuessedLetters.getValue() == _currentWord.length) {

                _numWins.add(1);
                sendNotification(GameNotifications.WORD_GUESSED);
            }

        } else {

           _numFailures.add(1);

           sendNotification(GameNotifications.LETTER_GUESS_FAILURE, _numFailures.getValue());

            if(_numFailures.getValue() == NUM_FAILURES_TO_LOSE) {

                _numLoses.add(1);
                sendNotification(GameNotifications.GAME_OVER, _currentWord);
            }
        }
    }

    public function get wins():uint {

        return _numWins.getValue();
    }

    public function get loses():uint {

        return _numLoses.getValue();
    }
}
}
