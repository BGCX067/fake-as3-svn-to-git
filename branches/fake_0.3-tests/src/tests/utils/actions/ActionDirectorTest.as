/* SVN FILE: $Id: ActionDirectorTest.as 209 2008-09-30 03:42:59Z xpointsh $ */
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
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Button;

	public class ActionDirectorTest extends TestCase
	{
		public function ActionDirectorTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new ActionDirectorTest( "testInsertNewActions" ));
   			
   			return ts;
   		}
   		
		public function testInsertNewActions():void
   		{
   			var actionOne:Action = new Action("ADD",[new Button()]);
   			var actionTwo:Action = new Action("MOVE",[new Button()]);
   			var actionThree:Action = new Action("PROPERTY_CHANGE",[new Button()]);
   			var actionFour:Action = new Action("REMOVE",[new Button()]);
   			
   			ActionDirector.insertAction(actionOne);
   			ActionDirector.insertAction(actionTwo);
   			ActionDirector.insertAction(actionThree);
   			
   			ActionDirector.undoAction(1);
   			
   			assertEquals("1. actionTwo == ActionDirector.actionCursor.current", actionTwo.id, ActionDirector.actionCursor.current.id);
   			
   			ActionDirector.insertAction(actionFour);
   			
   			assertEquals("2. ActionDirector.actionCursor.source.count == 2", 2, ActionDirector.actionCursor.source.length);
   			
   			ActionDirector.undoAction();
   			
   			assertEquals("3. actionFour == ActionDirector.actionCursor.current", actionFour.id, ActionDirector.actionCursor.current.id);
   			
   			assertEquals("4. actionCursor.length == 2", 2, ActionDirector.actionCursor.length);
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