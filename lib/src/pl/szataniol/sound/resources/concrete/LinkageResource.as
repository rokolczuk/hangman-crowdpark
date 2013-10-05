package pl.szataniol.sound.resources.concrete {

	import pl.szataniol.sound.resources.AbstractSoundResource;
	import pl.szataniol.sound.resources.SoundResourceType;

	import flash.media.Sound;
	import flash.utils.getDefinitionByName;


	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class LinkageResource extends AbstractSoundResource {

		private var _linkage : String;
		
		public function LinkageResource(linkage : String) {

			super(SoundResourceType.LINKAGE);
			_linkage = linkage;
		}

		public function get linkage() : String {
			
			return _linkage;
		}

		override protected function createSoundInstance() : void {
			
			_sound = Sound( new (getDefinitionByName(_linkage)as Class));
		}

	}
}
