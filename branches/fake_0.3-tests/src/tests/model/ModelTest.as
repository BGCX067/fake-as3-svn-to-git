/* SVN FILE: $Id: ModelTest.as 267 2009-06-16 21:09:20Z gwoo.cakephp $ */
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
 * @version			$Revision: 267 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 04:09:20 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.model
{
	import com.app.model.CustomResultSet;
	import com.app.model.ModelForCustomResultSet;
	import com.app.model.ModelForHttp;
	import com.app.model.ModelForResultSet;
	import com.app.model.TestModel;
	import com.fake.model.Model;
	import com.fake.model.ResultSet;
	import com.fake.model.datasources.ConnectionManager;

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
   			ts.addTest(new ModelTest( "testResultSet" ));
   			ts.addTest(new ModelTest( "testCustomResultSet" ));
   			ts.addTest(new ModelTest( "testAmfService" ));
   			ts.addTest(new ModelTest( "testHttpService" ));

   			return ts;
   		}

   		override public function setUp():void {
   			ConnectionManager.instance.create('default', {endpoint: "http://faker.localhost", datasource: "Amf"});
   			ConnectionManager.instance.create('test_http', {endpoint: "http://faker.localhost", datasource: "Http"});
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

   		public function testAmfService():void {
   			var model:Model = new TestModel();

			model.index({arg1: 1, arg2: 2}, function(testObject:Object):void {
   				assertEquals(testObject.service, "TestModels.index");
   				assertEquals(1, testObject.args.arg1);
   			});
   		}

		public function testHttpService():void {
   			var model:Model = new ModelForHttp();

			model.index({arg1: 1, arg2: 2}, function(testObject:Object):void {
   				assertEquals(testObject.service, "model_for_https/index");
   				assertEquals(1, testObject.args.arg1);
   			});
   		}
   		public function testResultSet():void {
   			var model:Model = new ModelForResultSet();

			model.index({arg1: 1, arg2: 2}, function(result:ResultSet):void {
   				assertEquals(result.className, "ResultSet");
   			});
   		}

   		public function testCustomResultSet():void {
   			var model:Model = new ModelForCustomResultSet();

			model.index({arg1: 1, arg2: 2}, function(result:CustomResultSet):void {
   				assertEquals(result.className, "CustomResultSet");
   			});
   		}
	}
}