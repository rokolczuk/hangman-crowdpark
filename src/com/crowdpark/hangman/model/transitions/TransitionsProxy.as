package com.crowdpark.hangman.model.transitions {
import com.crowdpark.common.model.AbstractProxy;

/**
 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
 */
public class TransitionsProxy extends AbstractProxy {

    public static const NAME:String = "TransitionsProxy";

    protected var _history:Vector.<TransitionCall> = new Vector.<TransitionCall>();
    protected var _currentCall:TransitionCall;
    protected var _nextCall:TransitionCall;
    protected var _transition:Boolean = false;

    public function TransitionsProxy() {

        super(NAME);
    }

    public function transitionTo(call:TransitionCall):Boolean {

        if ((_currentCall && _currentCall.transitionable == call.transitionable)) {
            return false;
        }

        if (call.saveToHistory) {

            if (getTransitionable(_currentCall) && getTransitionable(_currentCall).saveToHistory) {
                _history.push(_currentCall);
            }
        }
        _nextCall = call;

        if (_transition) {

            return false;
        }

        if (_currentCall) {

            _transition = true;

            getTransitionable(_currentCall).transitionOut();

        } else if(call.transitionable) {

            nextTransitionIn();
        }

        return true;
    }

    public function goBack():Boolean {

        if(_history.length > 0) {

            transitionTo(_history.pop());
            return true;
        }

        return false;
    }

    public function transitionOutCompleted(transitionable:ITransitionable):void {

        if(_currentCall.transitionable == transitionable) {
            nextTransitionIn();
        }
    }

    public function transitionInCompleted(transitionable:ITransitionable):void {

        _transition = false;
    }

    protected function nextTransitionIn():void {

        _currentCall = _nextCall;

        if(_currentCall.transitionable) {

            getTransitionable(_currentCall).call = _currentCall;
            getTransitionable(_currentCall).transitionIn();

            _transition = true;
        } else {
            _currentCall = null;
            _nextCall = null;
            _transition = false;
        }
    }

    private function getTransitionable(call:TransitionCall):ITransitionable {

        return call ? call.transitionable : null;
    }

    public function get current():ITransitionable {

        return _currentCall ? _currentCall.transitionable : null;
    }
}
}
