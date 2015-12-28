package generation.reserved
{
	public class SyntacticKeyword
	{
		public static var DYNAMIC:String = "dynamic";
		public static var EACH:String = "each";
		public static var FINAL:String = "final";
		public static var INCLUDE:String = "include";
		public static var GET:String = "get";
		public static var OVERRIDE:String = "override";
		public static var NAMESPACE:String = "namespace";
		public static var NATIVE:String = "native";
		public static var SET:String = "set";
		public static var STATIC:String = "static";
		
		private static var words:Array = [DYNAMIC, EACH, FINAL, GET, INCLUDE, NAMESPACE, NATIVE, OVERRIDE, NAMESPACE, NATIVE, SET, STATIC]
	
		public static function isSyntacticKeyword(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}