package generation
{
	import generation.reserved.AttributeKeyword;
	
	public class CodeObject
	{
		public var name:String;
		
		protected var _children:Array = [];
		
		public function CodeObject(name:String = "")
		{
			this.name = name;
		}
		
		/**
		 * Adds CodeObjects to the children array. Strings are also allowed 
		 * and are converted into CodeStrings.
		 */		
		public function addCode(... params):void
		{
			for each(var value:Object in params)
			{
				if(value is String)
					children.push(new CodeString(String(value)));	
				else
					children.push(value);
			}
		}
		
		/**
		* Access to the children Array.
		**/
		public function get children():Array { return _children; }
		public function set children(value:Array):void 
		{
			if(value && _children.length > 0)
				_children = _children.concat(value);
			else
				_children = value; 
		}
	}
}