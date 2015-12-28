package template
{
	import generation.*;
	import generation.reserved.Statement;
	import generation.utils.CodeUtil;
	
	import flash.utils.describeType;
	
	public class UnitTestGenerator extends Generator
	{
		public var classToTest:Class;
		public var description:XML;
		
		public var testConstructor:Method;
		
		public var suite:Method;
		public var testSuite:Variable;
		
		public var methodList:XMLList;
		
		public var TestSuite:* = CodeUtil.classReference("flexunit.framework.TestSuite");
		public var TestCase:* = CodeUtil.classReference("flexunit.framework.TestCase");
		
		public function UnitTestGenerator(classToTest:Class, packagePath:String = "test.utils")
		{
			super(packagePath, CodeUtil.localName(classToTest) + "Test");
			
			this.classToTest = classToTest;
			
			description = describeType(classToTest);
			methodList = description..method;
			
			generateClass();
		}
		
		override public function generateClass():void
		{
			var testConstructor:Method = new Method(className, Type.BLANK, [new Parameter("methodName", Type.STRING)]);
		
			classShell = new ClassShell(className, testConstructor);
			classShell.extend = TestCase;
			
			generateSuiteMethod();
			generateTestMethods();
			
			super.generateClass();
		}
		
		public function generateSuiteMethod():void
		{
			suite = new Method("suite", TestSuite)
			suite.isStatic = true;
			
			testSuite = new Variable("testSuite", TestSuite);
			
			suite.addCode(testSuite.toBodyCodeString(true));
			suite.addCode(CodeString.SPACER);
			
			for each(var methodXML:XML in methodList)
			{
				suite.addCode(testSuite.name + ".addTest(new " + className + "(\"" + methodXML.@name + "Test\"));");
			}
			
			suite.addCode(CodeString.SPACER, Statement.RETURN + " " + testSuite.name + ";");
		
			classShell.addCode(suite);
		}
		
		public function generateTestMethods():void
		{
			for each(var methodXML:XML in methodList)
			{
				classShell.addCode(new Method(methodXML.@name + "Test"));
			}
		}
	}
}