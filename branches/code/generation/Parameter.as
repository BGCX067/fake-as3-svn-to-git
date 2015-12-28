package generation 
{
	
	public class Parameter extends CodeObject
	{
		public var type:Type;
		public var isOptional:Boolean;
		
		public function Parameter(name:String, type:* = null, isOptional:Boolean = true) 
		{
			super(name);
			
			this.type = Type.getType(type);
			this.isOptional = isOptional;
		}
		
		public function toString():String
		{
			return name + ":" + type.name + (isOptional ? " = null" : "");
		}
	}
}