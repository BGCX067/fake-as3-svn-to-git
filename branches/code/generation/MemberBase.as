package generation 
{
	import generation.reserved.AttributeKeyword;
	
	public class MemberBase extends CodeObject
	{
		public var type:Type;
		public var isStatic:Boolean;
		public var availability:String = AttributeKeyword.PUBLIC;
		
		public function MemberBase(name:String, type:* = null, isStatic:Boolean = false) 
		{
			super(name);

			this.type = Type.getType(type);
			this.isStatic = isStatic;
		}
		
		/**
		 * Returns the name. 
		 */
		public function toString():String
		{
			return name;
		}
	}
}