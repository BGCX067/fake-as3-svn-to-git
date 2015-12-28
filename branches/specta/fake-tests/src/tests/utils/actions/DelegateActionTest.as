/* SVN FILE: $Id: DelegateActionTest.as 220 2008-10-06 13:27:50Z xpointsh $ */
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
package tests.utils.actions
{
	import com.fake.utils.FakeCursor;
	import com.fake.utils.ObjectMap;
	import com.fake.utils.actions.*;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;

	public class DelegateActionTest extends TestCase
	{
		public function DelegateActionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new DelegateActionTest( "testDelegate" ));
   			
   			return ts;
   		}
   		
   		public var touched:Boolean = false;
   		
   		public function testDelegate():void
   		{
   			var action:DelegateAction = DelegateAction.start("uid", 
   			function (actionParam:*):void 
   			{
   				touched = true;
   				assertNotNull(actionParam);
   			},
   			function (actionParam:*):void 
   			{
   				touched = false;
   				assertNotNull(actionParam);
   			}, 
   			touched);
   			
   			DelegateAction.end();

			ActionDirector.undoAction();
			
			assertTrue("1. undoDelegate called", touched);
			
			ActionDirector.redoAction();
			
			assertFalse("2. redoDelegate called", touched);
   		}
   		
   		public function arrayAssert(targets:Array, property:String, checkValue:Object, message:String = ""):void
   		{
   			for each(var target:Object in targets)
   			{
   				assertEquals(message, checkValue, target[property]);
   			}
   		}
   		
   		public function modifyObjects(targets:Array, property:String, value:Object):void
   		{
   			for each(var target:Object in targets)
   			{
   				target[property] = value;
   			}
   		}
   		
   		public function get actionCursor():FakeCursor {
   			return ActionDirector.actionCursor;
   		}
   		
   		public function get objectMap():ObjectMap {
   			return ObjectMap.instance;
   		}
	}
}
