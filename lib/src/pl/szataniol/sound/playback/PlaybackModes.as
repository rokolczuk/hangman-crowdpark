package pl.szataniol.sound.playback {
	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class PlaybackModes {
		
		/**
		 * creates new SoundChannel instance for each Sound.play
		 */
		public static const OVERLAP:String = "overlap";
		
		/**
		 *  blocks next playback until previous is complete
		 */
		public static const ONE_INSTANCE:String = "oneInstance";
		
		/**
		 * kills previous playback and initiates next one
		 */
		public static const KILL_PREVIOUS:String = "killPrevious";
	}
}
