package pl.szataniol.utils.sound {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	/**
	 * @author Administrator
	 */
	public class Speaker {
		
		private var music : Boolean = true;

		private var _view : MovieClip;

		public function Speaker(view : MovieClip) { 
			
			_view = view;
			initSpeaker();
		}

		private function initSpeaker() : void {
			
			_view.stop();
			_view.useHandCursor = _view.buttonMode = true;
			_view.addEventListener(MouseEvent.CLICK, clickHandler);
			_view.gotoAndStop("on");
		}

		private function clickHandler(event : MouseEvent) : void {
			
			music = !music;
			_view.gotoAndStop(music ? "on" : "off");
			SoundMixer.soundTransform = new SoundTransform(music ? 1 : 0);
		}

		public function off() : void {
			
			music = false;
			_view.gotoAndStop("off");
		}
	}
}
