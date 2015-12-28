/* SVN FILE: $Id: RouterTest.as 222 2008-10-14 19:52:44Z gwoo.cakephp $ */
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
	import com.app.controller.SomeCtrl;
	import com.fake.utils.Router;
	
	import flexunit.framework.TestSuite;
	
	import lib.FakeTestCase;

	public class RouterTest extends FakeTestCase
	{
		private var router:Router;

		public function RouterTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new RouterTest( "testConstructor" ));
   			ts.addTest(new RouterTest( "testInit" ));
   			ts.addTest(new RouterTest( "testReverseRouting" ));
   			ts.addTest(new RouterTest( "testMatching" ));
   			
   			return ts;
   		}

		override public function setUp():void
		{
   			router = Router.instance;
			router.reset();
		}

   		public function testConstructor():void {
   			var router:Router = Router.instance;
   			assertEquals(Router, Class(com.fake.utils.Router));
   		}

   		public function testInit():void {
   			var someCtrl:SomeCtrl = new SomeCtrl();

   			router.connect("SomeCtrl", [
					{name: "home", path: "/", listener: "list", options:{title: "Scaffold Index"}},
					{name: "Some.list", path: "/some/list/:named1/:named2", defaults: {named1: 1, named2: 2},
						params: {named1: "[0-2]", named2: "[0-2]"}, options:{title: "Some Test Index"}
					},
			]);

   			router.init(someCtrl);

   			var expected:Array = [
   				{name: "SomeCtrl.home", controller: "SomeCtrl", path: "/", listener: "list", options:{title: "Scaffold Index"}, params: [], regex:"^[\\/]*$"},
				{name: "Some.list", controller: "SomeCtrl", listener: "list", path: "/some/list/", defaults: {named1: 1, named2: 2},
					params: {0: "named1", 1: "named2"}, options:{title: "Some Test Index"},
					regex: "^/some/list(?:/([0-2]+))?(?:/([0-2]+))?[\\/]*$"
				},
   			];

   			this.addToResult("testInit.result", router.routes);
   			this.addToResult("testInit.expected", expected);

   			assertObjectEquals(router.routes[0], expected[0]);
   			assertObjectEquals(router.routes[1], expected[1]);
   		}

   		public function testReverseRouting():void
   		{
   			var someCtrl:SomeCtrl = new SomeCtrl();

   			router.connect("SomeCtrl", [
					{name: "Some.list", path: "/some/list/:named1/:named2", defaults: {named1: 1, named2: 2},
						params: {named1: "[0-2]", named2: "[0-2]"}, options:{title: "Some List"}
					},
			]);

   			router.init(someCtrl);
   			router.call("Some.list", {named1: 1, named2: 2});

   			this.addToResult("testReverseRouting.current", router.current);
   			
   			assertEquals(router.current.path, '/some/list/1/2/');
   			
   			assertObjectEquals({named1: 1, named2: 2}, someCtrl.testParams);
   			
   		}
   		
   		public function testMatching():void
   		{
   			var someCtrl:SomeCtrl = new SomeCtrl();

   			router.connect("SomeCtrl", [
					{name: "Some.list", path: "/some/list/:named1/:named2", defaults: {named1: 1, named2: 2},
						params: {named1: "[0-2]", named2: "[0-2]"}, options:{title: "Some List"}
					},
			]);

   			router.init(someCtrl);
   			router.call("Some.list", {named1: 1, named2: 2});

   			this.addToResult("testReverseRouting.current", router.current);
   			
   			assertEquals(router.current.path, '/some/list/1/2/');
   			
   			assertObjectEquals({named1: 1, named2: 2}, someCtrl.testParams);
   			
   			
   		}

	}
}