package com.crowdpark.hangman.model.transitions {


	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class TransitionCall {


		private var _params : *;
		private var _transitionable : ITransitionable;
        private var _saveToHistory:Boolean;

		public function TransitionCall(transitionable : ITransitionable, params : * = null, saveToHistory:Boolean = true) {

			_transitionable = transitionable;
			_params = params;
            _saveToHistory = saveToHistory;
        }

		public function get transitionable() : ITransitionable {
			return _transitionable;
		}


		public function get params() : * {

			return _params;
		}

        public function get saveToHistory():Boolean {
            return _saveToHistory;
        }
    }
}
