package generation
{
	public class CodeString extends CodeObject
	{
		/**
		 * Text of the CodeString. 
		 */		
		public var value:String = "";
		
		public function CodeString(value:String = "", name:String = "")
		{
			super(name);
			
			this.value = value;
		}
		
		/**
		 * Adds a line of text with a new line charatcter at the ends.
		 */		
		public function push(line:String):void
		{
			value += line + "\n";
		}
		
		/**
		 * Creates an Array of all the ${dollarVars}.
		 */		
		public static function findDollarVars(source:String):Array
		{
			var matches:Array = [];
			
			var findReg:RegExp = /\${\w+}/g
			
			for each(var match:String in source.match(findReg))
			{
				if(matches.indexOf(match) == -1)
					matches.push(match);
			}
			
			return matches;
		}
		
		/**
		 * Creates a ${dollar} Regex. 
		 */		
		public static function generateDollarRegex(value:String):RegExp 
		{
			return new RegExp("\\${" + value + "}");
		}
		
		/**
		 * Replaces all ${dollarVar} text with the replaceWith String.
		 */		
		public static function replaceRegex(source:String, dollarVar:String, replaceWith:String):String
		{
			var regex:RegExp = generateDollarRegex(dollarVar);
			
			while(source != source.replace(regex, replaceWith))
			{
				source = source.replace(regex, replaceWith)
			}
			
			return source;
		}
		
		/**
		 * Creates an empty CodeString. 
		 */		
		public static function get SPACER():CodeString 
		{ 
			return new CodeString(); 
		}
		
		/**
		 * Creates a CodeString containing a newline character. 
		 */	
		public static function get NEWLINE():CodeString 
		{
			return new CodeString("\n"); 
		}
		
		/**
		 * Returns the value. 
		 */		
		public function toString():String
		{
			return value;
		}
	}
}