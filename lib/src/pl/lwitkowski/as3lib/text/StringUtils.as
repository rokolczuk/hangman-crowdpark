package pl.lwitkowski.as3lib.text 
{
	/**
	 * @one2tribe
	 * @author Lukasz Witkowski, code@lukaszwitkowski.com, http://lukaszwitkowski.com
	 * @version 1.0
	 */
	public class StringUtils 
	{
		
		// mke clickable linkds
		public static function makeClickableLinks(input:String, linkCSSClassName:String):String {
			if (input == null || input.length == 0) return "";
			
			var output:String = input + " ";
			
			var links:Array = extractLinks(output);
			while (links.length > 0) {
				var displayLink:String = String(links.pop());
				var link:String = (displayLink.indexOf("http://") == 0) ? displayLink : ("http://" + displayLink);
				if(linkCSSClassName) {
					output = output.split(displayLink + " ").join("<span class=\""+linkCSSClassName+"\"><a href=\"" + link + "\" target=\"_blank\">" + displayLink + "</a></span> ");
				} else {
					output = output.split(displayLink + " ").join("<a href=\"" + link + "\" target=\"_blank\">" + displayLink + "</a> ");
				}
			}
			
			return output;
		}
		
		// zwraca listę linków
		public static function extractLinks(input:String):Array {
			var links:Array = [];
			var patterns:Array = [
				["http://", " "],
				["www.", " "]
			];
			
			for (var i:Number = 0; i < patterns.length; ++i) {
				var patternData:Array = patterns[i];
				links = links.concat(extractLinksUsingPatterns(input, patternData[0], patternData[1]));	
			}
			
			return links;
		}
		
		// 
		public static function extractLinksUsingPatterns(input:String, startString:String, endString:String):Array {
			var results:Array = [];
			var startIndex:Number = -1;
			var endIndex:Number = -1;
			
			while((startIndex = input.indexOf(startString, startIndex + 1)) >= 0) {
				endIndex = input.indexOf(endString, startIndex);
				if (endIndex < 0) endIndex = input.length;
				var link:String = input.substring(startIndex, endIndex);
				results.push(link);
			}
			return results;
		}
			
		
		/**
		 * Zastepuje znaki <> na ich odpowiedniki w kodach html
		 */
		public static function stripHtml(input:String):String {
			if (input == null) return null;
			
			var output:String = input.split("<").join("&#60;");
			output = output.split(">").join("&#62;");
			return output || "";
		}
		
		/**
		* zamienia na małe litety, spacje na podkreslenie i zamienia polskie znaki na angielskie odpowiedniki (ą -> a, ę -> e)
		*/
		public static function makeValidFilename(input:String):String {
			return swapPolishCharacters( input.toLowerCase().split(' ').join('_') );
		}
		
		/**
		* usuwa z napisu polskie znaki
		*/
		public static function swapPolishCharacters(input:String):String {
			input = input.split('ę').join('e');
			input = input.split('ó').join('o');
			input = input.split('ą').join('a');
			input = input.split('ś').join('s');
			input = input.split('ł').join('l');
			input = input.split('ż').join('z');
			input = input.split('ź').join('z');
			input = input.split('ć').join('c');
			input = input.split('ń').join('n');
			
			input = input.split('Ę').join('E');
			input = input.split('Ó').join('O');
			input = input.split('Ą').join('A');
			input = input.split('Ś').join('S');
			input = input.split('Ł').join('L');
			input = input.split('Ż').join('Z');
			input = input.split('Ź').join('Z');
			input = input.split('Ć').join('C');
			input = input.split('Ń').join('N');
			
			return input;
		}
		
		public static function breakLines(input:String, p_charsPerLine:Number):String {
			var str:String = '';
			
			var lineLength:Number = 0;
			var words:Array = input.split(' ');
			for(var i:Number = 0; i<words.length; ++i) {
				lineLength += words[i].length;
				if(lineLength > p_charsPerLine) {
					lineLength = 0;
					str += '\n';
				}
				
				str += words[i] + ' ';
			}
			
			return str;		
		}
		
		
		public static function setFirstLettersSize(input:String, upperCaseFontSize:int = 0):String {
			if(input == null) return "";
			
			var output:String = "";
			var template:String = (upperCaseFontSize > 0) ? ("<font size=\""+String(upperCaseFontSize)+"\">") : "";
						
			var len:int = input.length;
			var prevUpper:Boolean = false;
			for(var kurw:int = 0; kurw < len; ++kurw) {
				var char:String = input.charAt(kurw); 
				if(isUpperCase(char)) {
					if(!prevUpper) {
						output += template;
						prevUpper = true;
					}
				} else {
					if(prevUpper) {
						output += "</font>";
						prevUpper = false;
					}
				}
				output += char;
			}
			
			return output;
		}
		
		public static function isLowerCase(char:String):Boolean {
			var charCode:int = char.charCodeAt(0);
			return (charCode > 96 && charCode < 123);
		}
		
		private static const POLISH_UPPERCASE:Array = [280, 211, 260, 346, 321, 379, 377, 262, 323];
		public static function isUpperCase(char:String):Boolean {
			var charCode:int = char.charCodeAt(0);
			return (charCode > 64 && charCode < 91) || (POLISH_UPPERCASE.indexOf(charCode) >= 0);
		}
	}
} 
