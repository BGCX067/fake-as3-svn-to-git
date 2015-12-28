package generation
{
	import generation.reserved.DefinitionKeyword;
	import generation.reserved.Directive;
	import generation.utils.CodeUtil;
	
	public class PackageShell extends CodeObject
	{
		public var classShell:ClassShell;
		public var imports:Array;
		
		public function PackageShell(name:String, classShell:ClassShell)
		{
			super(name);
			
			this.classShell = classShell;
		}
		
		protected function headerString():String
		{
			return DefinitionKeyword.PACKAGE + " " + name;
		}
		
		protected function bodyString():String
		{
			var output:String = "";
			
			output = getImports();
				
			output += classShell.toCodeString().toString();
			
			return CodeUtil.braceWrap(output);
		}
		
		/**
		 * Creates the string of all the classes that need to be imported. 
		 */		
		protected function getImports():String
		{
			var outputArray:Array = [];
			
			if(classShell.extend.name != Type.BLANK.name)
				outputArray.push(Directive.IMPORT + " " + CodeUtil.classPath(classShell.extend.classRef));
			
			// get the import strings of all of the types in the children Array.
			for each(var child:Object in classShell.children)
			{
				if(child.hasOwnProperty("type") && !CodeUtil.isSimpleType(child.type.classRef))
				{
					var imp:String = Directive.IMPORT + " " + CodeUtil.classPath(child.type.classRef);
					
					// make sure each import is added once.
					if(outputArray.indexOf(imp) == -1)
						outputArray.push(imp);
				}
			}
			
			// checks the imports Array and inserts the import string.
			for each(var value:Object in imports)
			{
				if(value is Type)
					imp = Directive.IMPORT + " " + CodeUtil.classPath(value.classRef);
				else
					imp = Directive.IMPORT + " " + CodeUtil.classPath(value);
				
				// make sure each import is added once.	
				if(outputArray.indexOf(imp) == -1)
					outputArray.push(imp);
			}
			
			// alphabetize the imports and output them with newlines in between			
			outputArray = outputArray.sort();
			
			var output:String = outputArray.join("\n");
			
			// if there are any imports, add some newline characters.
			if(output != "")
				output += "\n\n";
			
			return output;
		}
		
		/**
		 * Creates a package based on the given properties. 
		 */		
		public static function quickPackage(packageName:String, classParam:*, ... params):PackageShell
		{
			var classShell:ClassShell;
			
			// if classParam is a String then create the ClassShell and pass it all of the params.
			if(classParam is String)
				classShell = ClassShell.quickClass(classParam, CodeUtil.restFormat(params));
			else
				classShell = classParam;
			
			var pack:PackageShell = new PackageShell(packageName, classShell);
			
			return pack;
		}
		
		/**
		 * Creates a CodeString from the header and body strings. Indents everything.
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