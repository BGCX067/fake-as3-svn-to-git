/* SVN FILE: $Id: ModelTest.as 149 2008-08-27 21:08:14Z gwoo.cakephp $ */
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
 * @subpackage		tests.model
 * @since			2008-03-06
 * @version			$Revision: 149 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-28 04:08:14 +0700 (Thu, 28 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model
{
	import com.app.model.TestModel;
	import com.app.model.User;
	import com.fake.model.Model;
	import com.fake.model.ResultSet;

	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class ModelTest extends TestCase
	{
		public function ModelTest(methodName:String=null)
		{
			super(methodName);
		}

		public static function suite():TestSuite {
   			var ts:TestSuite = new TestSuite();

   			ts.addTest(new ModelTest( "testConstructor" ));
   			ts.addTest(new ModelTest( "testClassRef" ));
   			ts.addTest(new ModelTest( "testOverloading" ));
   			ts.addTest(new ModelTest( "testMoreOverloading" ));


   			return ts;
   		}

   		public function testConstructor():void {
   			var model:Model = new Model();
   			assertEquals(model.className, 'Model');
   		}

   		public function testClassRef():void {
   			var model:Model = new Model();
   			assertEquals(model.ClassRef, Class(com.fake.model.Model));
   		}

   		public function testOverloading(testObject:Object = null):void {

   			if (testObject == null)
   			{
   				var model:Model = new TestModel();
   				model.someMethod(testOverloading, {arg1: 1, arg2: 2});
   			}
   			else
   			{
   				assertEquals(testObject.service, "TestModels.someMethod");
   				assertEquals(testObject.listener, testOverloading);
   				assertEquals(1, testObject.args.arg1);
   			}
   		}

   		public function testMoreOverloading():void {
   			var model:Model = new TestModel();
   			model.index({arg1: 1, arg2: 2}, function(testObject:Object):void {
   				assertEquals(testObject.service, "TestModels.index");
   				assertEquals(1, testObject.args.arg1);
   			});
   		}
	}
}