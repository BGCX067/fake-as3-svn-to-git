package generation.reserved
{
	public class AttributeKeyword
	{
		public static var DYNAMIC:String = "dynamic";
		public static var FINAL:String = "final";
		public static var INTERNAL:String = "internal";
		public static var NATIVE:String = "native";
		public static var OVERRIDE:String = "override";
		public static var PRIVATE:String = "private";
		public static var PROTECTED:String = "protected";
		public static var PUBLIC:String = "public";
		public static var STATIC:String = "static";
		
		private static var words:Array = [DYNAMIC, FINAL, INTERNAL, NATIVE, OVERRIDE, PRIVATE, PROTECTED, PUBLIC, STATIC];
	
		public static function isAttributeKeyword(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}