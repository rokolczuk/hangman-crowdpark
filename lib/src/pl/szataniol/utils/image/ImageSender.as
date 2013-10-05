package pl.szataniol.utils.image {

	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	/**
	 * @author Andrzej Korolczuk (http://blog.szataniol.pl)
	 */
	public class ImageSender extends EventDispatcher {

		private var loader : URLLoader = new URLLoader();
		private var _data : String;

		public function ImageSender() {
		}

		public function send(endpointURL : String, image : ByteArray) : void {

			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var request : URLRequest = new URLRequest(endpointURL);

			request.requestHeaders.push(header);
			request.method = URLRequestMethod.POST;
			request.data = image;

			loader.addEventListener(Event.COMPLETE, imageSavedHandler);
			loader.load(request);
		}

		private function imageSavedHandler(e : Event) : void {
			// trace the image file name
			trace(loader.data);
			_data = loader.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get data() : String {
			return _data;
		}
	}
}

/**
 * 
 * PHP endpoint:
 * 
 * if (isset($GLOBALS["HTTP_RAW_POST_DATA"])) {

    $path = "rw/";
    $file_name = md5(uniqid()) . '.jpg';
    $file_path = $path.$file_name;
    
    $data = $GLOBALS["HTTP_RAW_POST_DATA"];

     $result = file_put_contents($file_path, $data);

    if ($result) {

        echo $file_path;
    } else {
        echo "error".$result."   ".$file_path;
    }
}
 * 
 * 
 */
