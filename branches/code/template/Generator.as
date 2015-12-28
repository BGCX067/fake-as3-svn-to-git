package template
{
	import generation.*;
	
	public class Generator extends CodeObject
	{
		public var packagePath:String;
		public var packageShell:PackageShell;
		
		public var className:String;
		public var classShell:ClassShell;
		
		public function Generator(packagePath:String, className:String)
		{
			this.packagePath = packagePath;
			this.className = className;
		}
		
		public function generateClass():void
		{
			packageShell = new PackageShell(packagePath, classShell);
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
		
		public function toString():String
		{
			return packageShell.toString();
		}
	}
}