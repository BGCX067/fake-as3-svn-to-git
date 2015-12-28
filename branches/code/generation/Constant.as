package generation 
{

	public class Constant extends MemberBase 
	{
		
		public function Constant(name:String, type:* = null, isStatic:Boolean = false)
		{
			super(name, type, isStatic);
		}
		
		public function toClassStatement(newInstance:Boolean = false):CodeString
		{
			return new CodeString(availability + " " + (isStatic ? "static " : "") + "const " + name + ":" + name + (newInstance ? newInst : ";"));
		}
		
		public function toBodyStatemant(newInstance:Boolean = false):CodeString
		{
			return new CodeString("const " + name + ":" + type + (newInstance ? newInst : ";"));
		}
		
		public function toShortString():String
		{
			return name + ":" + type;
		}
		
		public function get newInst():String {
			return " = new " + type + "();";
		}
	}
}