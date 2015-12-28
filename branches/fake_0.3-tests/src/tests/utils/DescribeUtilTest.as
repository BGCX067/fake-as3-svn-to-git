/* SVN FILE: $Id: DescribeUtilTest.as 222 2008-10-14 19:52:44Z gwoo.cakephp $ */
/**
 * Description
 *
 * Fake Tests
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake-tests
 * @subpackage		tests.utils
 * @since			2008-03-06
 * @version			$Revision: 222 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-10-15 02:52:44 +0700 (Wed, 15 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.model.datasources.AmfDataSource;
	import com.fake.utils.DescribeUtil;
	
	import flash.net.getClassByAlias;
	import flash.utils.getQualifiedClassName;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.controls.Button;

	public class DescribeUtilTest extends TestCase
	{
		public function DescribeUtilTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite 
		{
   			var ts:TestSuite = new TestSuite();
   			   			
   			ts.addTest(new DescribeUtilTest( "testDescribe" ));
   			ts.addTest(new DescribeUtilTest( "testDefinition" ));
   			ts.addTest(new DescribeUtilTest( "testProperties" ));
   			ts.addTest(new DescribeUtilTest( "testPropertyNameList" ));
   			ts.addTest(new DescribeUtilTest( "testLocalName" ));
   			ts.addTest(new DescribeUtilTest( "testClassName" ));
   			ts.addTest(new DescribeUtilTest( "testClassPath" ));
   			ts.addTest(new DescribeUtilTest( "testClassReference" ));
   			   			
   			return ts;
   		}
		
		public function testDescribe():void
		{
			var button:Button = new Button();
			var data:XML = describeUtil.describe(button);
			
			assertNotNull("1. describeUtil.definition(button) != null", data);
			
			assertNotNull("2. describeUtil.describeMap[DescribeUtil.className(button)] != null", 
							  describeUtil.describeMap[DescribeUtil.className(button)]);
		
			clear();
		}
		
		public function testDefinition():void
		{
			var button:Button = new Button();
			
			assertEquals("1. definition(value) == Button", Button, describeUtil.definition(button));
		
			var datasource:AmfDataSource;
			assertEquals("1. definition(value) == AmfDataSource", AmfDataSource, describeUtil.definition('com.fake.model.datasources.AmfDataSource'));
			
			clear();
		}
		
		public function testProperties():void
		{
			var button:Button = new Button();
			
			var desc:XML = describeUtil.describe(button);
			var name:String = DescribeUtil.className(button);
			var result:Array = describeUtil.propertyNameList(button);
			
			assertTrue("1. result.indexOf('id') > -1", result.indexOf("id") > -1);
			
			assertNotNull("2. propertyNameMap[name] != null", describeUtil.propertyNameMap[name]);
		
			clear();
		}
		
		public function testPropertyNameList():void
		{
			var button:Button = new Button();
			var result:Array = describeUtil.propertyNameList(button);
			
			assertTrue("1. result.indexOf('id') > -1", result.indexOf("id") > -1);
		
			clear();
		}
		
		public function testLocalName():void
		{
			var button:Button = new Button();
			
			var localName:String = DescribeUtil.localName(button);
			
			assertEquals("localName == DescribeUtil.localName(button)", localName, DescribeUtil.localName(button));
		
			clear();
		}
		
		public function testClassName():void
		{
			var button:Button = new Button();
			
			assertEquals("getQualifiedClassName(button) == DescribeUtil.className(button)", getQualifiedClassName(button), DescribeUtil.className(button));
		
			clear();
		}
		
		public function testClassPath():void
		{
			var button:Button = new Button();
			
			assertEquals("classPath(button) == DescribeUtil.classPath(button)", DescribeUtil.className(button).replace( "::", "." ), DescribeUtil.classPath(button));
		
			clear();
		}
		
		public function testClassReference():void
		{
			var button:Button = new Button();
			
			DescribeUtil.registerClass(button);
			
			assertEquals("DescribeUtil.classReference == DescribeUtil.classReference(button)", getClassByAlias(DescribeUtil.classPath(button)), DescribeUtil.classReference(button));
		
			clear();
		}
		
		public function clear():void {
			describeUtil.clear();
		}
		
		public function get describeUtil():DescribeUtil {
			return DescribeUtil.instance;
		}
	}
}