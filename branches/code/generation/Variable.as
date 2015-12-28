package generation 
{
	import generation.reserved.AttributeKeyword;
	import generation.reserved.DefinitionKeyword;
	
	
	public class Variable extends MemberBase 
	{
		public var defaultString:String = "";
		public var newInstance:Boolean;
		
		public function Variable(name:String, type:* = null, isStatic:Boolean = false, newInstance:* = false) 
		{
			if(newInstance is String)
			{
				defaultString = newInstance;
				this.newInstance = true;
			}
			else
				this.newInstance = Boolean(newInstance);
			
			super(name, type, isStatic);
		}
		
		/**
		 * Returns a statement for declaring a variable within a class. Creates a default instance if newInstance is true.
		 */		
		public function toClassCodeString():CodeString
		{
			return new CodeString(availability + " " + 
			(isStatic ? AttributeKeyword.STATIC + " " : "") + 
			DefinitionKeyword.VAR + " " + name + ":" + type.name + (newInstance ? newInst : ";"));
		}
		
		/**
		 * Returns a statement for declaring a variable within a function. Creates a default instance if newInstance is true.
		 */		
		public function toBodyCodeString():CodeString
		{
			return new CodeString(DefinitionKeyword.VAR + " " + name + ":" + type.name + (newInstance ? newInst : ";"));
		}
		
		/**
		 * Returns the variable name and class name with a colon in the middle. 
		 */		
		public function toShortString():String
		{
			return name + ":" + type.name;
		}
		
		/**
		 * Returns the code to create an instance of the current type.
		 **/		
		public function get newInst():String 
		{
			if(defaultString != "")
				return " = \"" + defaultString + "\";";
			else	
				return " = new " + type.name + "();";
		}
	}
	
}