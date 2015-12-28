package generation 
{
	import generation.reserved.AttributeKeyword;
	import generation.reserved.DefinitionKeyword;
	import generation.utils.CodeUtil;
	
	public class Method extends CodeObject
	{
		public var isStatic:Boolean;
		public var parameters:Array = [];
		public var type:Type;
		public var availability:String = AttributeKeyword.PUBLIC;
		public var style:String = CodeUtil.NEXT_LINE;
		public var endNewLine:Boolean = false
		
		private var _useSuper:Boolean = false;
		
		public function Method(name:String, returnType:* = null, parameters:Array = null, ... children) 
		{
			this.name = name;
			
			if(parameters)
				this.parameters = parameters;
				
			if(children)
				this.children = children;
			
			if(returnType)
				this.returnType = returnType;
			else
				this.returnType = Type.VOID;
		}
		
		public function get returnType():Type { return type; }
		public function set returnType(value:*):void { type = Type.getType(value) }; 
		
		/**
		 * Writes: (public) function (name) (param1 = null) : (void)
		 */		
		protected function headerString():String
		{
			var pars:Array = [];
			
			for each(var param:Parameter in parameters) {
				pars.push(param.toString());
			}
			
			var header:String;
			var paramString:String = "(" + pars.toString().replace(",", ", ") + ")";
				
			header = 	availability + " " + 
					(isStatic ? AttributeKeyword.STATIC + " " : "") + 
					DefinitionKeyword.FUNCTION + " " + name + 
					paramString + (returnType.name != "" ? ":" : "") + (returnType ? returnType.name : "void"); 
			
			return header;
		}
		
		/**
		 *  Writes out all CodeStrings with surrounding curly braces.
		 */			
		protected function bodyString():String
		{
			var output:String = "";
			
			for(var i:int = 0; i < codeStrings.length; i++)
			{
				output += codeStrings[i].value + (i < codeStrings.length-1 ? "\n" : "");
			}
			
			return CodeUtil.braceWrap(output, style, endNewLine);
		}
		
		/**
		 * Adds the CodeString for the super function call. 
		 */		
		public function set useSuper(value:Boolean):void
		{
			if(value)
			{
				var paramStrings:Array = [];
			
				for each(var param:Parameter in parameters)
				{
					paramStrings.push(param.name);
				}
				
				addCode(new CodeString("super("+paramStrings.join(", ")+");"));
			}
		}
		
		public function get useSuper():Boolean { return _useSuper; }
		
		/**
		 * Returns an Array of all Variables contained within the children array. 
		 */	
		public function get variables():Array 
		{
			var output:Array = [];
			
			for each(var child:Object in children)
			{
				if(child is Variable)
					output.push(child);
			}
			
			return output;
		}
		
		/**
		 * Returns an Array of all Methods contained within the children array. 
		 */	
		public function get methods():Array 
		{
			var output:Array = [];
			
			for each(var child:Object in children)
			{
				if(child is Method)
					output.push(child);
			}
			
			return output;
		}
		
		/**
		 * Returns an Array of all CodeStrings contained within the children array. 
		 */		
		public function get codeStrings():Array 
		{
			var output:Array = [];
			
			for each(var child:Object in children)
			{
				if(child is CodeString)
					output.push(child);
			}
			
			return output;
		}
		
		/**
		 * Creates a CodeString from the header and body strings. 
		 */		
		public function toCodeString():CodeString
		{
			var output:String = headerString();
			output += bodyString();
			
			return new CodeString(CodeUtil.indentString(output));
		}
		
		/**
		 * Returns a CodeString for calling a variable within a function.
		 */		
		public function toBodyCodeString():CodeString
		{
			var output:String = "";
			var pars:Array = [];
			
			for each(var param:Parameter in parameters) {
				pars.push(param.name);
			}
			
			return new CodeString(name + "(" + pars.join(", ") + ");");
		}
		
		/**
		 * Returns the CodeString value. 
		 */
		public function toString():String
		{
			return toCodeString().value;
		}
	}
}