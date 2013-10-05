package pl.lwitkowski.as3lib.math 
{
	/**
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	final public class ExtMath 
	{
		public static const PI:Number = Math.PI;		public static const DOUBLE_PI:Number = 2*Math.PI;
		public static const E:Number = Math.E;
		
		public static const _PI_DIV_180:Number = Math.PI / 180;
		public static const _180_DIV_PI:Number = 180 / Math.PI;
	
		// utis
		public static function getShortAngleRadians(angle0:Number, angle1:Number):Number {
			return angle0 + angleDifferenceRadians(angle0, angle1);	
		}
		
		public static function getShortAngleDegrees(angle0:Number, angle1:Number):Number {
			return getShortAngleRadians(angle0 * _PI_DIV_180, angle1 * _PI_DIV_180) * _180_DIV_PI;	
		}
		
		public static function angleDifferenceRadians(angle0:Number, angle1:Number):Number {
 			var diff:Number = (angle1 - angle0) % DOUBLE_PI;
		 	if (diff != diff % PI) {
		        diff = (diff < 0) ? (diff + DOUBLE_PI) : (diff - DOUBLE_PI);
		    }
		    return diff;
		}
		public static function angleDifferenceDegrees(angle0:Number, angle1:Number):Number {
 			return angleDifferenceRadians(angle0 * _PI_DIV_180, angle1 * _PI_DIV_180) * _180_DIV_PI;
 		}
		
			
		//trigonometry
		public static function sin(t:Number):Number {
			return Math.sin(t);
		}
		public static function cos(t:Number):Number {
			return Math.cos(t);
		}
		public static function tan(t:Number):Number {
			return Math.tan(t);
		}
		public static function asin(t:Number):Number {
			return Math.asin(t);
		}
		public static function acos(t:Number):Number {
			return Math.acos(t);
		}
		public static function atan(t:Number):Number {
			return Math.atan(t);
		}
		public static function csc(t:Number):Number {
			return 1 / Math.sin(t);
		}
		public static function sec(t:Number):Number {
			return 1 / Math.cos(t);
		}
		public static function cot(t:Number):Number {
			return 1 / Math.tan(t);
		}
		public static function acsc(t:Number):Number {
			return Math.asin(1 / t);
		}
		public static function asec(t:Number):Number {
			return Math.acos(1 / t);
		}
		public static function acot(t:Number):Number {
			if(t != 0) {
				return Math.atan(1 / t);
			} else {
				return PI / 2;
			}
		}
		//
		
		//logarithms/powers/exponentials
		public static function log(b:Number, a:Number):Number {
			return Math.log(a) / Math.log(b);
		}
		public static function ln(a:Number):Number {
			return Math.log(a);
		}
		public static function sqrt(n:Number):Number {
			return Math.sqrt(n);
		}
		public static function root(a:Number, b:Number):Number {
			return Math.pow(a, 1 / b);
		}
		public static function pow(a:Number, b:Number):Number {
			return Math.pow(a, b);
		}
		public static function exp(b:Number):Number {
			return Math.exp(b);
		}
		//
		
		//numerical
		public static function abs(n:Number):Number {
			return Math.abs(n);
		}
		public static function round(n:Number):Number {
			return Math.round(n);
		}
		public static function ceil(n:Number):Number {
			return Math.ceil(n);
		}
		public static function floor(n:Number):Number {
			return Math.floor(n);
		}
		public static function gcd(a:uint, b:uint):uint {
			var t:uint;
			while(b != 0) {
				t = b;
				b = a % b;
				a = t;
			}
			return a;
		}
		public static function lcm(a:uint, b:uint):uint {
			return a / gcd(a, b) * b;
		}
		//
		
		//probability
		public static function random(a:Number = 0, b:Number = 1):Number {
			return a + Math.random() * (b - a);
		}
		public static function factorial(n:uint):uint {
			var s:uint = 1;
			while(n > 0) {
				s *= n--;
			}
			return s;
		}
		public static function perm(n:uint, r:uint):uint {
			return factorial(n) / factorial(n - r);
		}
		public static function comb(n:uint, r:uint):uint {
			return perm(n, r) / factorial(r);
		}
	}
}