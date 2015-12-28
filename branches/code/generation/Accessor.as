package generation 
{
	import generation.reserved.*;
	import generation.utils.CodeUtil;
	
	public class Accessor extends MemberBase 
	{
		public var access:String;
		public var valueVar:Parameter;
		public var getMethod:Method;
		public var setMethod:Method;
		
		public var privateVar:Variable;
		
		public static const READ_ONLY:String = "readonly";
		public static const WRITE_ONLY:String = "writeonly";
		public static const READ_WRITE:String = "readwrite";
		
		public function Accessor(name:String, type:* = null, isStatic:Boolean = false, access:String = "readwrite")
		{
			super(name, type, isStatic);
			
			this.access = access;
			
			privateVar = new Variable("_" + name, this.type, isStatic);
			privateVar.availability = AttributeKeyword.PRIVATE;
			
			valueVar = new Parameter("value", this.type, false);
			
			getMethod = new Method(DefinitionKeyword.GET + " " + name, this.type);
			getMethod.children.push(new CodeString(Statement.RETURN + " " + privateVar.name + ";"));
			getMethod.style = CodeUtil.SINGLE_LINE;
			
			setMethod = new Method(DefinitionKeyword.SET + " " + name, Type.VOID, [valueVar]);
			setMethod.children.push(new CodeString(privateVar.name + " = value;"));
			setMethod.style = CodeUtil.SINGLE_LINE;
		}
		
		public function get members():Array
		{
			return [privateVar, getMethod, setMethod];
		}
	}
}