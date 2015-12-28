package template
{
	import generation.*;
	import generation.utils.CodeUtil;
	
	import flash.utils.describeType;
	//import flash.utils.describeType;
	
	public class ProxyGenerator extends Generator
	{
		public var classToProxy:Class;
		public var varsToProxy:Array;
		
		public var description:XML;
		public var accessors:Array = [];
		
		public var sendUpdates:Boolean = false;
		
		public var valueObject:Object = {};
		
		public function ProxyGenerator(packagePath:String, className:String, classToProxy:Class = null, ... varsToProxy)
		{
			super(packagePath, className);
			
			this.classToProxy = classToProxy;
			this.varsToProxy = varsToProxy;
			
			if(classToProxy)
				generateVarsFromClass();
			
			generateClass();
		}
		
		public function generateVarsFromClass():void
		{
			description = describeType(classToProxy);
			
			for each(var varXML:XML in description.factory.variable)
			{
				var type:Type = new Type(CodeUtil.classReference(String(varXML.@type)))
				
				varsToProxy.push(new Variable(varXML.@name, type));
			}
			
		}
		
		public function generateAccessors():void
		{
			for each(var value:* in varsToProxy)
			{
				var variable:Variable;
				
				if(value is Array)
					variable = new Variable(value[0], value[1])
				else
					variable = value;
					
				var acc:Accessor = new Accessor(variable.name, variable.type);
				
				if(sendUpdates)
				{
					var staticVar:Variable = new Variable(String(acc.name).toUpperCase() + "_UPDATE", String, true, String(acc.name).toUpperCase() + "_UPDATE");
					
					children.push(staticVar);
					
					acc.setMethod.addCode(CodeString.SPACER, "sendNotification(" + staticVar.name + ");")
					acc.setMethod.style = CodeUtil.NEXT_LINE;
				}
				
				if(!valueObject)
					children.push(acc.privateVar);
					
				children.push(acc.getMethod, acc.setMethod);
			}
		}
		
		override public function generateClass():void
		{
			var constructor:Method;
			
			if(valueObject)
			{
				constructor = new Method(className, Type.BLANK, [new Parameter("valueObject", Type.getType(classToProxy))]);
			}
			
			classShell = new ClassShell(className, constructor);
			classShell.extend = CodeUtil.classReference("org.puremvc.as3.multicore.patterns.proxy.Proxy");
			
			generateAccessors();
			
			classShell.children = classShell.children.concat(children);
			
			super.generateClass();
		}
	}
}