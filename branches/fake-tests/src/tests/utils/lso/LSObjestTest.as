/* SVN FILE: $Id: LSObjestTest.as 273 2009-06-17 22:41:12Z gwoo.cakephp $ */
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
 * @version			$Revision: 273 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-18 05:41:12 +0700 (Thu, 18 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils.lso
{
	import com.app.objects.TestInnerObjectAfterConstruct;
	import com.app.objects.TestObject;
	import com.fake.utils.actions.*;
	import com.fake.utils.lso.LSObject;

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class LSObjestTest extends TestCase
	{
		public function LSObjestTest(methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new LSObjestTest( "testFirstRun" ));
   			ts.addTest(new LSObjestTest( "testAdd" ));
   			ts.addTest(new LSObjestTest( "testRemove" ));
   			ts.addTest(new LSObjestTest( "testInternalObjectsCreatedAfterConstructor" ));

   			return ts;
   		}
   		
   		override public function setUp():void {
   			clear();
   		}

   		public function testFirstRun():void
   		{
   			assertTrue("1. firstRun == true", LSObject.firstRun);

   			assertFalse("2. firstRun == false", LSObject.firstRun);
   		}

   		public function testAdd():void
   		{
   			var objectOne:Action = new Action("test1");
   			var objectTwo:Action = new Action("test2");

   			lsObject.add("objectOne", objectOne);

   			assertNotNull("1. lsObject.getObject('objectOne') not null", lsObject.getObject("objectOne"));
   			assertNotNull("2. lsObject.objectOne not null", lsObject.objectOne);
   			assertNotNull("3. lsObject.sharedObject.data.objectOne not null", lsObject.sharedObject.data.objectOne);
   			assertNotNull("4. lsObject.sharedObject.data['objectOne'] not null", lsObject.sharedObject.data["objectOne"]);

   			lsObject.testObjectTwo = objectTwo;

   			assertNotNull("5. lsObject.getObject('testObjectTwo') not null", lsObject.getObject("testObjectTwo"));
   			assertNotNull("6. lsObject.testObjectTwo not null", lsObject.testObjectTwo);
   			assertNotNull("7. lsObject.sharedObject.data.testObjectTwo not null", lsObject.sharedObject.data.testObjectTwo);
   			assertNotNull("8. lsObject.sharedObject.data['testObjectTwo'] not null", lsObject.sharedObject.data["testObjectTwo"]);

   			assertTrue("9. lsObject.testObjectTwo is Action", lsObject.testObjectTwo is Action);
   		}

   		public function testRemove():void
   		{
   			var objectOne:Object = {id: "idOne", label: "labelOne"};
   			var objectTwo:Object = {id: "idTwo", label: "labelTwo"};

   			lsObject.objectOne = objectOne;
   			lsObject.objectTwo = objectTwo;

   			lsObject.remove("objectOne");

   			assertNull("1. lsObject.objectOne is null", lsObject.objectOne);

   			lsObject.objectTwo = null;

   			assertNull("2. lsObject.objectTwo is null", lsObject.objectTwo);

   			lsObject.objectOne = objectOne;
   			lsObject.objectTwo = objectTwo;

   			clear();

   			assertNull("3. lsObject.objectOne is null", lsObject.objectOne);
   			assertNull("4. lsObject.objectTwo is null", lsObject.objectTwo);
   		}

   		public function testInternalObjectsCreatedAfterConstructor():void 
   		{
   			var foo:TestInnerObjectAfterConstruct = new TestInnerObjectAfterConstruct();
   			foo.addExtraObject(4);
   			lsObject.add("FOOVAR", foo);

   			var foo2:TestInnerObjectAfterConstruct = lsObject.getObject('FOOVAR');
   			assertEquals(foo2.extraInternalVar.testVar, 4);
   		}

   		public function clear():void
   		{
   			lsObject.clear();
   		}

   		public function get lsObject():LSObject
   		{
   			return LSObject.instance;
   		}
	}
}
