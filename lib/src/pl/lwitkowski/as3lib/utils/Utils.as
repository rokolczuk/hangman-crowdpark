package pl.lwitkowski.as3lib.utils 
{
	import flash.utils.ByteArray;
	import com.greensock.TweenLite;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class Utils 
	{
		protected static var _effectsData:Dictionary;		
		
		public static function addEffectOnRollOver(target:DisplayObject, property:String, 
				value:*, animationDuration:Number = 0.3):void 
		{
			if(!_effectsData) _effectsData = new Dictionary();
			
			_effectsData[target] = {
				up : target[property],
				over : value 
			};			
			
			target.addEventListener(
				MouseEvent.ROLL_OVER,
				function(e:MouseEvent):void {
					var params:Object = {};
					params[property] = _effectsData[target].over;
					TweenLite.to(target, animationDuration || 0.3, params);
			});
			
			target.addEventListener(
				MouseEvent.ROLL_OUT,
				function(e:MouseEvent):void {
					var params:Object = {};
					params[property] = _effectsData[target].up;
					TweenLite.to(target, animationDuration || 0.3, params);
			});
		}
		
		public static function copyObject(obj:Object):Object {
			if(obj) {
				var ba:ByteArray = new ByteArray();
				ba.writeObject(obj);
				ba.position = 0;
				return ba.readObject();
			} else {
				return null;
			}
		}
		
		public static function mergeObjects(obj1:Object, obj2:Object, overrideValues:Boolean = true):Object {
			var obj:Object = copyObject(obj1);
			for(var key:String in obj2) {
				if(!obj.hasOwnProperty(key) || overrideValues) {
					obj[key] = obj2[key];
				}
			}
			return obj;
		}

		public static function vector2array(input:Vector):Array {
			var arr:Array = [];
			for each(var value:* in input) {
				arr.push(value);
			}
			return arr;
		}
		
		public static function stringifyByteArray(input:ByteArray):String {
			var outputArr:Array = [];
			input.position = 0;
			for(var i:int = 0; i < input.length; ++i) {
				var str:String = input.readUnsignedByte().toString(2);
				while(str.length < 8) str = "0" + str;
				outputArr.push(str);
			}
			return outputArr.join(" ");
		}
	}
} 
