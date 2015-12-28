/* SVN FILE: $Id: ObjectMapTest.as 220 2008-10-06 13:27:50Z xpointsh $ */
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
 * @version			$Revision: 220 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-06 20:27:50 +0700 (Mon, 06 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils
{
	import com.fake.utils.DescribeUtil;
	import com.fake.utils.ObjectMap;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.controls.Button;
	import mx.core.UIComponent;

	public class ObjectMapTest extends TestCase
	{
		public function ObjectMapTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new ObjectMapTest( "testAdd" ));
   			ts.addTest(new ObjectMapTest( "testFind" ));
   			ts.addTest(new ObjectMapTest( "testFindMap" ));
   			ts.addTest(new ObjectMapTest( "testFindByID" ));
   			ts.addTest(new ObjectMapTest( "testRemove" ));
   					
   			return ts;
   		}
   		
   		public function testAdd():void
   		{
   			var btn:Button = new Button();
   			var btn2:Button = new Button();
   			
   			btn.id = "testButton";
   			btn2.id = "testButton2";
   			
   			objectMap.add(btn);
   			objectMap.add(btn2);
   			
   			assertNotNull("1. objectMap.idMap['testButton'] not null", objectMap.idMap["testButton"]);
   			assertNotNull("2. objectMap.idMap['testButton2'] not null", objectMap.idMap["testButton2"]);
   			
   			assertNotNull("3. objectMap.testButton not null", objectMap.testButton);
   			assertNotNull("4. objectMap.testButton2 not null", objectMap.testButton2);
   		
   			assertEquals("5. 2 Buttons in rootMap", 2, objectMap.rootMap[DescribeUtil.localName(btn)].length);
   			assertEquals("6. 2 UIComponents in objectMap.UIComponent", 2, objectMap.UIComponent.length);
   			
   			clear();
   		}
   		
   		public function testFind():void
   		{
   			var btn:Button = new Button();
   			var btn2:Button = new Button();
   			
   			btn.id = "testButton";
   			btn2.id = "testButton2";
   			
   			objectMap.add(btn);
   			objectMap.add(btn2);
   			
   			assertEquals("1. objectMap.find(objectMap.testButton).length == 2", 2, objectMap.find(objectMap.testButton).length);
   			assertEquals("2. objectMap.find(UIComponent).length == 2", 2, objectMap.find(UIComponent).length);
   		
   			clear();
   		}
   		
   		public function testFindMap():void
   		{
   			var btn:Button = new Button();
   			var btn2:Button = new Button();
   			
   			btn.id = "testButton";
   			btn2.id = "testButton2";
   			
   			objectMap.add(btn);
   			objectMap.add(btn2);
   			
   			var buttonMap:Object = objectMap.findMap(Button);
   			
   			assertEquals("1. objectMap.testButton == buttonMap['testButton']", objectMap.testButton, buttonMap["testButton"]);
   			assertTrue("2. buttonMap.hasOwnProperty('testButton2')", buttonMap.hasOwnProperty("testButton2"));
   		
   			clear();
   		}
   		
   		public function testFindByID():void
   		{
   			objectMap.testButton = new Button();
   			
   			assertEquals("1. objectMap.testButton == objectMap.findByID('testButton')", objectMap.testButton, objectMap.findByID("testButton"));
   		
   			clear();
   		}
   		
   		public function testRemove():void
   		{
   			var btn:Button = new Button();
   			
   			btn.id = "testButton";
   			
   			objectMap.add(btn);
   			
   			objectMap.remove(objectMap.testButton);
   			
   			assertNull("1. objectMap.testButton == null", objectMap.testButton);
   			assertNull("2. objectMap.idMap['testButton'] == null", objectMap.idMap["testButton"]);
   			assertFalse("3. objectMap.rootMap.hasOwnProperty(DescribeUtil.localName(Button)) == false", 
   							objectMap.rootMap.hasOwnProperty(DescribeUtil.localName(Button)));
   		
   			clear();
   		}
   		
   		public function clear():void
   		{
   			objectMap.clear();
   		}
   		
   		public function get objectMap():ObjectMap {
   			return ObjectMap.instance;
   		}
	}
}