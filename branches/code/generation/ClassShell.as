package generation
{
	import generation.reserved.*;
	import generation.utils.CodeUtil;
	
	public class ClassShell extends CodeObject
	{
		public var interfaces:Array;
		public var constructor:Method;
		
		private var _extend:Type;
		
		public function ClassShell(name:String, constructor:Method = null, extend:* = null, interfaces:Array = null):void
		{
			super(name);
			
			this.extend = extend;
			this.interfaces = interfaces;
			
			// use the given constructor or make one.
			if(constructor)
				this.constructor = constructor;
			else
				this.constructor = new Method(name, Type.BLANK);
			
			// automatically adds the super function call.
			this.constructor.useSuper = true;
			
			addCode(this.constructor);
		}
		
		public function get extend():Type { return _extend; }
		public function set extend(value:*):void 
		{ 
			//if()
			if(!value)
				_extend = Type.BLANK
			else
				_extend = Type.getType(value);
		}
		
		/**
		 * Writes: public class (name) extends (extend.name) implements (interfaces)
		 * Adds extend and implements if there are respective values.
		 */		
		protected function headerString():String
		{
			return AttributeKeyword.PUBLIC + " " + DefinitionKeyword.CLASS + " " + name + 
			(extend.name != Type.BLANK.name ? " " + DefinitionKeyword.EXTENDS + " " + extend.name : "") + 
			(interfaces ? " " + DefinitionKeyword.IMPLEMENTS + " " + interfaces.join(", ") : "");
		}
		
		/**
		 *  Writes out all Variables and Methods with surrounding curly braces.
		 */		
		protected function bodyString(style:String = "next line", endNewLine:Boolean = true):String
		{
			var output:String = "";
			var hasStatic:Boolean = false;
			
			// Loop through all the static variables. Add their class formatted strings to the output. Add newline at the end.
			for(var i:int = 0; i < variables.length; i++)
			{
				if(Variable(variables[i]).isStatic)
					output += Variable(variables[i]).toClassCodeString().value + (i < variables.length-1 ? "\n" : "");
				
				hasStatic = true;
			}
			
			// If there are static variables, add extra newline characters.
			if(hasStatic)
				output += "\n";
			
			// Loop through all the variables. Add their class formatted strings to the output. Add newline at the end.
			for(i = 0; i < variables.length; i++)
			{
				if(!Variable(variables[i]).isStatic)
					output += Variable(variables[i]).toClassCodeString().value + (i < variables.length-1 ? "\n" : "");
			}
			
			// If there are variables and methods, add extra newline characters.
			if(variables.length > 0 && methods.length > 0)
				output += "\n\n";
			
			// Loop through all the methods. Add their strings to the output. Add newline at the end.
			for(i = 0; i < methods.length; i++)
			{
				output += Method(methods[i]).toCodeString().value + (i < methods.length-1 ? "\n" : "");
			}
			
			// pretty up the output
			return CodeUtil.braceWrap(output);
		}
		
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
			
			return output.sort();
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
		 * Shortcut for creating classes. The params are directly inserted into
		 * children Array 
		 */		
		public static function quickClass(className:String, ... params):ClassShell
		{
			var shell:ClassShell = new ClassShell(className);
			
			shell.children = CodeUtil.restFormat(params);
			
			return shell;
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
		 * Returns the CodeString value. 
		 */
		public function toString():String
		{
			return toCodeString().value;
		}
	}
}