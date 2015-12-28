package generation.reserved
{
	public class DefinitionKeyword
	{
		public static var CLASS:String = "class";
		public static var CONST:String = "const";
		public static var EXTENDS:String = "extends";
		public static var FUNCTION:String = "function";
		public static var GET:String = "get";
		public static var IMPLEMENTS:String = "implements";
		public static var INTERFACE:String = "interface";
		public static var NAMESPACE:String = "namespace";
		public static var PACKAGE:String = "package";
		public static var SET:String = "set";
		public static var VAR:String = "var";
		
		public static var REST:String = "...";
		
		private static var words:Array = [CLASS, CONST, EXTENDS, FUNCTION, GET, IMPLEMENTS, INTERFACE, NAMESPACE, PACKAGE, REST, SET, VAR];
		
		public static function isDefinitionKeyword(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}