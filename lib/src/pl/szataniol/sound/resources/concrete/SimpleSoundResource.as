/**
 * Created with IntelliJ IDEA.
 * User: rokolczuk
 * Date: 10/5/13
 * Time: 5:03 PM
 * To change this template use File | Settings | File Templates.
 */
package pl.szataniol.sound.resources.concrete {
import flash.media.Sound;

import pl.szataniol.sound.resources.AbstractSoundResource;
import pl.szataniol.sound.resources.SoundResourceType;

public class SimpleSoundResource extends AbstractSoundResource {

    public function SimpleSoundResource(sound:Sound) {

        super(SoundResourceType.SIMPLE);
        _sound = sound;
    }

    override protected function createSoundInstance():void {
    }
}
}
