package generation.reserved
{
	public class Directive
	{
		public static var DEFAULT_XML_NAMESPACE:String = "default xml namespace";
		public static var IMPORT:String = "import";
		public static var INCLUDE:String = "include";
		public static var USE_NAMESPACE:String = "use namespace";
		
		private static var words:Array = [DEFAULT_XML_NAMESPACE, IMPORT, INCLUDE, USE_NAMESPACE];
	
		public static function isDirective(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}