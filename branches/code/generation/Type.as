package generation
{
	import generation.utils.CodeUtil;
	
	public class Type extends CodeObject
	{
		/**
		 * Contains the reference to the Type's Class 
		 */		
		public var classRef:Class;
		
		/**
		 * Sets up the Type based on a String or Class. If it is a String,
		 * the name of the class will be the value parameter and the reference
		 * will be Object. If it is a Class, the local name of the class becomes the
		 * name and the value is the Class reference. 
		 */		
		public function Type(value:*)
		{
			if(value is String)
			{
				name = value;
				classRef = Object;
			}
			else if(value is Class)
			{
				name = CodeUtil.typeOf(value);
				classRef = value;
			}
		}
		
		/**
		 * Utility function getting Type instances. If the value is null, an Object Type
		 * is returned. If the value is already a Type, it is just returned. Any other
		 * values are the source of a new Type object. 
		 */		
		public static function getType(value:*):Type
		{
			if(!value)
				return Type.OBJECT;
			else if(value is Type)
				return Type(value);
			else
				return new Type(value);
		}
		
		/**
		 * Creates a Object Type. 
		 */		
		public static function get OBJECT():Type
		{
			return new Type("Object");
		}
		
		/**
		 * Creates a String Type. 
		 */		
		public static function get STRING():Type
		{
			return new Type("String");
		}
		
		/**
		 * Creates a XML Type. 
		 */		
		public static function get XML():Type
		{
			return new Type(XML);
		}
		
		/**
		 * Creates a Null Type. 
		 */		
		public static function get NULL():Type
		{
			return new Type("null");
		} 
		
		/**
		 * Creates a Void Type. 
		 */		
		public static function get VOID():Type
		{
			return new Type("void");
		} 
		
		/**
		 * Creates a new Untyped Type. (Paradox)
		 */		
		public static function get UNTYPED():Type
		{
			return new Type("*");
		}  
		
		/**
		 * Creates a new Blank Type. This allows constructors to have no
		 * return type.
		 */		
		public static function get BLANK():Type
		{
			return new Type("");
		} 
	}
}