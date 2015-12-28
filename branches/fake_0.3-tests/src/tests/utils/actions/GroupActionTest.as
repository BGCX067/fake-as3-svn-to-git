/* SVN FILE: $Id: GroupActionTest.as 220 2008-10-06 13:27:50Z xpointsh $ */
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
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Button;

	public class GroupActionTest extends TestCase
	{
		public function GroupActionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new GroupActionTest( "testGroupAction" ));
   			
   			return ts;
   		}
   		
   		public function testGroupAction():void
   		{
   			var vbox:VBox = new VBox();
   			var button:Button = new Button();
   			var container:ArrayCollection = new ArrayCollection();
   			
   			GroupAction.start("group", 
   			MoveAction.start("move", vbox, button),
   			AddAction.start("add1", container, button),
   			AddAction.start("add2", container, vbox),
   			AddAction.start("add3", vbox, button),
   			PropertyChangeAction.start("propChange", ["width"], button))
   			
   			vbox.x = button.x = 50;
   			vbox.y = button.y = 50;
   			
   			container.addItem(button);
   			container.addItem(vbox);
   			
   			vbox.addChild(button);
   			
   			button.width = 100;
   			
   			GroupAction.end("group");
   			
   			assertEquals("1. vbox.x = button.x = 50", 100, vbox.x + button.x);
   			assertEquals("2. button index in container == 0", 0, container.getItemIndex(button));
   			assertEquals("3. vbox index in container == 1", 1, container.getItemIndex(vbox));
   			assertEquals("4. button.width == 100", 100, button.width);
   			
   			ActionDirector.undoAction();
   			
   			assertEquals("5. vbox.x = button.x = 0", 0, vbox.x + button.x);
   			assertEquals("6. container.source.length == 0", 0, container.source.length);
   			assertEquals("7. button.width == 0", 0, button.width);
   			
   			ActionDirector.redoAction();
   			
   			assertEquals("8. vbox.x = button.x = 50", 100, vbox.x + button.x);
   			assertEquals("9. button index in container == 0", 0, container.getItemIndex(button));
   			assertEquals("10. vbox index in container == 1", 1, container.getItemIndex(vbox));
   			assertEquals("11. button.width == 100", 100, button.width);
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
