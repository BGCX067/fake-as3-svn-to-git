/* SVN FILE: $Id: MoveActionTest.as 209 2008-09-30 03:42:59Z xpointsh $ */
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
 * @version			$Revision: 209 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-30 10:42:59 +0700 (Tue, 30 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package tests.utils.actions
{
	import com.fake.utils.FakeCursor;
	import com.fake.utils.ObjectMap;
	import com.fake.utils.actions.*;
	
	import flexunit.framework.TestCase;
	import flexunit.framework.TestSuite;
	
	import mx.controls.Button;

	public class MoveActionTest extends TestCase
	{
		public function MoveActionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new MoveActionTest( "testSingleMove" ));
   			ts.addTest(new MoveActionTest( "testMultipleMoves" ));
   			
   			return ts;
   		}
   		
   		public function testSingleMove():void
   		{
   			var testButtonOne:Button = new Button();
   			var testButtonTwo:Button = new Button();
   			
   			var action:MoveAction = MoveAction.start("guid", testButtonOne, testButtonTwo);
   			
   			testButtonOne.x = testButtonOne.y = 50;
   			testButtonTwo.x = testButtonTwo.y = 50;
   			
   			MoveAction.end();
   			
   			assertEquals("current x+y == 100", 100, testButtonOne.x + testButtonOne.y);
   			
   			ActionDirector.undoAction();
   			
   			assertEquals("undone x+y == 0", 0, testButtonOne.x + testButtonOne.y);
   			
   			ActionDirector.redoAction();
  			
  			assertEquals("redone x+y == 100", 100, testButtonOne.x + testButtonOne.y);
  			
  			actionCursor.clear();
   		}
   		
   		public function testMultipleMoves():void
   		{
   			var testButtonOne:Button = new Button();
   			var testButtonTwo:Button = new Button();
   			var testButtonThree:Button = new Button();
   			
   			var buttonArray:Array = [testButtonOne, testButtonTwo, testButtonThree];
   			
   			MoveAction.start("moveOne", buttonArray);
   			
   			modifyObjects(buttonArray, "x", 25);
   			modifyObjects(buttonArray, "y", 15);
   			
   			MoveAction.end("moveOne");
   			
   			MoveAction.start("moveTwo", buttonArray);
   			
   			modifyObjects(buttonArray, "x", 40);
   			modifyObjects(buttonArray, "y", 20);
   			
   			MoveAction.end("moveTwo");
   			
   			MoveAction.start("moveThree", buttonArray);
   			
   			modifyObjects(buttonArray, "x", 5);
   			modifyObjects(buttonArray, "y", 5);
   			
   			MoveAction.end("moveThree");
   			
   			ActionDirector.undoAction();
   			arrayAssert(buttonArray, "x", 40, "1. undo action from 5 to 40");
   			
   			ActionDirector.undoAction();
   			arrayAssert(buttonArray, "x", 25, "2. undo action from 40 to 25");
   			
   			ActionDirector.undoAction();
   			arrayAssert(buttonArray, "x", 0, "3. undo action from 25 to 0");
   			
   			assertEquals("4. actionCursor.current == moveOne", actionCursor.current.id, "moveOne");
   			
   			ActionDirector.redoAction(2);
   			
   			arrayAssert(buttonArray, "x", 5, "5. 3 redos, so x == 5");
   			
   			assertEquals("6. actionCursor.current == null (end of cursor)", actionCursor.current, null);
   			
   			actionCursor.clear();
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
