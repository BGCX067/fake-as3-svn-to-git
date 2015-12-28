package generation.reserved
{
	public class Statement
	{
		public static var BREAK:String = "break";
		public static var CASE:String = "case";
		public static var CATCH:String = "catch";
		public static var CONTINUE:String = "continue";
		public static var DEFAULT:String = "default";
		public static var DO:String = "do";
		public static var ELSE:String = "else";
		public static var FINALLY:String = "finally";
		public static var FOR:String = "for";
		public static var FOR_EACH:String = "for each";
		public static var IF:String = "if";
		public static var IN:String = "in";
		public static var LABEL:String = "label";
		public static var RETURN:String = "return";
		public static var SUPER:String = "super";
		public static var SWITCH:String = "switch";
		public static var THROW:String = "throw";
		public static var TRY:String = "try";
		public static var WHILE:String = "while";
		public static var WITH:String = "with";
		
		private static var words:Array = [BREAK, CASE, CATCH, CONTINUE, DEFAULT, DO, ELSE, FINALLY, FOR, FOR_EACH, IF, IN, LABEL, RETURN, SUPER, SWITCH, THROW, TRY, WHILE, WITH];
		
		public static function isStatement(value:String):Boolean
		{
			return words.indexOf(value) > -1;
		}
	}
}