package generation.reserved
{
	public class ExpressionKeyword
	{
		public static var FALSE:String = "false";
		public static var NULL:String = "null";
		public static var THIS:String = "this";
		public static var TRUE:String = "true";
		
		private static var words:Array = [FALSE, NULL, THIS, TRUE];
		
		public static function isExpressionKeyword(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}