/* SVN FILE: $Id: PropertyChangeActionTest.as 209 2008-09-30 03:42:59Z xpointsh $ */
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

	public class PropertyChangeActionTest extends TestCase
	{
		public function PropertyChangeActionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new PropertyChangeActionTest( "testPropertyChange" ));
   			
   			return ts;
   		}
   		
   		public function testPropertyChange():void
   		{
   			var buttonArray:Array = [new Button(), new Button(), new Button()];
   			
   			PropertyChangeAction.start("uid", ["width","height"], buttonArray);
   			
   			modifyObjects(buttonArray, "width", 100);
   			modifyObjects(buttonArray, "height", 75);
   			
   			PropertyChangeAction.end();
   			
   			PropertyChangeAction.start("uid", ["width","height"], buttonArray);
   			
   			modifyObjects(buttonArray, "width", 50);
   			modifyObjects(buttonArray, "height", 25);
   			
   			PropertyChangeAction.end();
   			
   			ActionDirector.undoAction();
   			
   			arrayAssert(buttonArray, "width", 100, "1. undo, width from 50 to 100");
   			arrayAssert(buttonArray, "height", 75, "2. undo, height from 25 to 75");
   			
   			ActionDirector.undoAction();
   			
   			arrayAssert(buttonArray, "width", 0, "3. undo, width from 100 to 0");
   			arrayAssert(buttonArray, "height", 0, "4. height, width from 75 to 0");
   			
   			ActionDirector.redoAction(1);
   			
   			arrayAssert(buttonArray, "width", 50, "5. two redos, 0 to 100 to 50");
   			arrayAssert(buttonArray, "height", 25, "6. two redos, 0 to 75 to 25");
   			
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
