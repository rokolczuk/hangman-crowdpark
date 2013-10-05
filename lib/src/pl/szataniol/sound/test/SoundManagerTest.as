package pl.szataniol.sound.test {

	import pl.szataniol.sound.SoundManager;
	import pl.szataniol.sound.events.SoundsLoadingProgressEvent;
	import pl.szataniol.sound.identifiers.concrete.SoundGroupIdentifier;
	import pl.szataniol.sound.identifiers.concrete.SoundIdentifier;
	import pl.szataniol.sound.identifiers.concrete.SoundSequenceIdentifier;
	import pl.szataniol.sound.playback.PlaybackModes;
	import pl.szataniol.sound.playback.PlaybackProperties;
	import pl.szataniol.sound.resources.concrete.ExternalSoundResource;
	import pl.szataniol.sound.resources.concrete.LibrarySoundResources;

	import flash.display.Sprite;
	import flash.utils.setTimeout;


	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class SoundManagerTest extends Sprite {

		public function SoundManagerTest() {

			initSoundManagerTest();
		}

		private function initSoundManagerTest() : void {

			SoundManager.getInstance().registerSound(new SoundIdentifier("gameOver", new ExternalSoundResource("mp3/game_over.mp3")));
			SoundManager.getInstance().registerSound(new SoundIdentifier("gameFadeIn", new LibrarySoundResources("swf/lib.swf", "game_fade_in")));
			SoundManager.getInstance().registerSound(new SoundIdentifier("potatoCollected", new LibrarySoundResources("swf/lib.swf", "potato_collected")));
			SoundManager.getInstance().registerSound(new SoundIdentifier("prizesFadeIn", new LibrarySoundResources("swf/lib.swf", "prizes_fade_in")));

			SoundManager.getInstance().addEventListener(SoundsLoadingProgressEvent.PROGRESS, progressHandler);
			SoundManager.getInstance().addEventListener(SoundsLoadingProgressEvent.COMPLETE, soundsLoadedHandler);
			
			SoundManager.getInstance().registerGroup(new SoundGroupIdentifier("testGroup"));
			
			SoundManager.getInstance().getGroup("testGroup").addSound(SoundManager.getInstance().getSound("gameFadeIn"));
			SoundManager.getInstance().getGroup("testGroup").addSound(SoundManager.getInstance().getSound("potatoCollected"));
			SoundManager.getInstance().getGroup("testGroup").addSound(SoundManager.getInstance().getSound("prizesFadeIn"));
			
			SoundManager.getInstance().registerSequence(new SoundSequenceIdentifier("testSequence", 
				Vector.<SoundIdentifier>([
					SoundManager.getInstance().getSound("gameOver"),
					SoundManager.getInstance().getSound("potatoCollected"),
					SoundManager.getInstance().getSound("potatoCollected"),
					SoundManager.getInstance().getSound("gameOver")
				])
			));

			SoundManager.getInstance().startLoading();
		}

		private function soundsLoadedHandler(event : SoundsLoadingProgressEvent) : void {

			trace("complete");

//			testKillPrevious();
//			testOverlap();
//			testGroup();
			testSequence();
		}

		private function testSequence() : void {
			
			SoundManager.getInstance().getSequence("testSequence").play();
		}

		private function testGroup() : void {
			
			setTimeout(playSoundFromGroup, 300, "testGroup", new PlaybackProperties(null, PlaybackModes.ONE_INSTANCE));
			setTimeout(playSoundFromGroup, 500, "testGroup", new PlaybackProperties(null, PlaybackModes.OVERLAP)); //should skip
			setTimeout(playSoundFromGroup, 1000, "testGroup", new PlaybackProperties(null, PlaybackModes.KILL_PREVIOUS)); //should kill first call and play sound
		}
		
		private function playSoundFromGroup(groupName:String, playbackProperties:PlaybackProperties):void {
			
			SoundManager.getInstance().getGroup(groupName).playRandom(playbackProperties);
		}


		private function progressHandler(event : SoundsLoadingProgressEvent) : void {

			trace("progress", event.progressPercent);
		}

		private function testKillPrevious() : void {

			playSound("gameOver", new PlaybackProperties({volume:1}, PlaybackModes.ONE_INSTANCE));
			setTimeout(playSound, 1500, "gameOver", new PlaybackProperties({volume:.6}, PlaybackModes.KILL_PREVIOUS));
		}

		private function testOverlap() : void {

			playSound("gameOver", new PlaybackProperties({volume:1}, PlaybackModes.OVERLAP));
			setTimeout(playSound, 1500, "gameOver", new PlaybackProperties({volume:.6}, PlaybackModes.OVERLAP));
		}

		private function playSound(identifier : String, playbackProperties : PlaybackProperties) : void {

			trace("play");
			SoundManager.getInstance().getSound(identifier).play(playbackProperties);
		}
	}
}
