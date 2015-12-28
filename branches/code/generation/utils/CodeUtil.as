package generation.utils
{
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	public class CodeUtil
	{
		public static var tab:String = "\t";
		public static var tabDB:String = "\t\t";
		public static var nl:String = "\n";
		
		public static var NEXT_LINE:String = "next line";
		public static var SAME_LINE:String = "same line";
		public static var SINGLE_LINE:String = "single line";
		
		public function CodeUtil()
		{
			
		}
		
		/**
		 * Grabs the local name of a class from its instance or string representation.
		 * 
		 * @param value String or Class that is to have it's local name extracted.
		 * @param isInstance Instances have getQualifiedClassName called on them.
		 */		
		public static function localName(value:Object):String 
		{
			var name:String = className(value);
			
			if(name.split("::").length > 1)
				return name.split("::")[1];
			else
				return name;
		}
		
		/**
		 * Returns the qualified class name.
		 */		
		public static function className(value:Object):String
		{
			return getQualifiedClassName(value);
		}
		
		/**
		 * Converts QNames to class paths by replacing "::" with "."
		 */		
		public static function classPath(value:Object):String 
		{
			return className(value).replace( "::", "." );
		}
		
		/**
		 * Returns the Class references from a getClassByAlias call.
		 */		
		public static function classReference(value:Object):Class
		{
			if(!(value is String))
				value = classPath(value);
			
			return ApplicationDomain.currentDomain.getDefinition(String(value)) as Class;
		}
		
		/**
		 * Helper function to allow for both rest array parameter or one array parameter.
		 */		
		public static function restFormat(restArray:Array):Array
		{
			if(restArray[0] is Array)
				restArray = restArray[0];
			
			return restArray;
		}
		
		/**
		 * Advanced version of typeof. 
		 */		
		public static function typeOf(value:*):String
		{
			return localName(value);
		}
		
		/**
		 * Checks to see if the class path contains packages.
		 */		
		public static function isSimpleType(value:*):Boolean
		{
			return classPath(value).indexOf(".") == -1;
		}
		
		public static function braceWrap(value:String, style:String = "next line", endNewLine:Boolean = false):String
		{
			var output:String = "";
			var nl:String = "\n";
			
			if(style == NEXT_LINE)
			{
				output += nl + "{";
				output += nl + value + nl;
				output += "}";
			}
			else if(style == SAME_LINE)
			{
				output += " {"; 
				output += nl + value + nl;
				output += "}";
			}
			else if(style == SINGLE_LINE)
			{
				output += " { " + value + " }";
			}
			
			return output + (endNewLine ? nl : "");
		}
		
		public static function indentString(value:String, startDepth:int = 0):String
		{
			var depth:int = startDepth;
			var lines:Array = value.split(nl);
			var output:String = "";
			var firstBrace:int = -1;
			var lastBrace:int = -1;
			
			for(var i:int=0; i < lines.length; i++)
			{
				if(lines[i].indexOf("{") != -1)
				{
					firstBrace = i;
					break;
				}
			}
			
			for(i=0; i < lines.length; i++)
			{
				if(lines[i].indexOf("}") != -1)
				{
					lastBrace = i;
				}
			}
			
			for(i=0; i < lines.length; i++)
			{
				if(i == lastBrace)
					depth--;
					
				output += tabsPerIndent(depth) + lines[i] + nl;
				
				if(i == firstBrace)
					depth++;
			}
			
			return output;
		}
		
		public static function tabsPerIndent(indent:int):String
		{
			var result:String = "";
			
			for(var i:int=0; i < indent; i++)
				result += tab;
				
			return result;
		}
	}
}