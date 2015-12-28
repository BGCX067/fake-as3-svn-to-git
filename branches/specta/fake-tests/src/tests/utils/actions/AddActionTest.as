/* SVN FILE: $Id: AddActionTest.as 209 2008-09-30 03:42:59Z xpointsh $ */
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

	public class AddActionTest extends TestCase
	{
		public function AddActionTest(methodName:String=null)
		{
			super(methodName);
		}
		
		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
   			
   			ts.addTest(new AddActionTest( "testAddRemove" ));
   			
   			return ts;
   		}
   		
   		public function testAddRemove():void
   		{
   			var vbox:VBox = new VBox();
   			var collection:ArrayCollection = new ArrayCollection();
   			collection.addItem({});
   			var array:Array = [];
   			var button:Button = new Button();
   			
   			// Add
   			
   			AddAction.start("vbox", vbox, button);
   			vbox.addChild(button);
   			AddAction.end("vbox");
   			
   			assertEquals("1. vbox.getChildren() == 1", 1, vbox.getChildren().length);
   			
   			ActionDirector.undoAction();
   			assertEquals("2. undo: vbox.getChildren() == 0", 0, vbox.getChildren().length);
   			
   			ActionDirector.redoAction();
   			assertEquals("3. redo: vbox.getChildren() == 1", 1, vbox.getChildren().length);
   			
   			AddAction.start("collection", collection, button);
   			collection.addItem(button);
   			AddAction.end("collection");
   			
   			assertEquals("4. collection.length == 2", 2, collection.length);
   			
   			ActionDirector.undoAction();
   			assertEquals("5. undo: collection.length == 1", 1, collection.length);
   			
   			ActionDirector.redoAction();
   			assertEquals("6. redo: collection.length == 2", 2, collection.length);
   			
   			AddAction.start("array", array, button);
   			array.push(button);
   			AddAction.end("array");
   			
   			assertEquals("7. array.length == 1", 1, array.length);
   			
   			ActionDirector.undoAction();
   			assertEquals("8. undo: array.length == 0", 0, array.length);
   			
   			ActionDirector.redoAction();
   			assertEquals("9. redo: array.length == 1", 1, array.length);
   			
   			// Remove
   			
   			RemoveAction.start("vbox", vbox, button);
   			vbox.removeChild(button);
   			RemoveAction.end("vbox");
   			
   			assertEquals("10. vbox.getChildren() == 0", 0, vbox.getChildren().length);
   			
   			ActionDirector.undoAction();
   			assertEquals("11. undo: vbox.getChildren() == 1", 1, vbox.getChildren().length);
   			
   			ActionDirector.redoAction();
   			assertEquals("12. redo: vbox.getChildren() == 0", 0, vbox.getChildren().length);
   			
   			RemoveAction.start("collection", collection, button);
   			collection.removeItemAt(1);
   			RemoveAction.end("collection");
   			
   			assertEquals("13. collection.length == 1", 1, collection.length);
   			
   			ActionDirector.undoAction();
   			assertEquals("14. undo: collection.length == 2", 2, collection.length);
   			
   			ActionDirector.redoAction();
   			assertEquals("15. redo: collection.length == 1", 1, collection.length);
   			
   			RemoveAction.start("array", array, button);
   			array.shift();
   			RemoveAction.end("array");
   			
   			assertEquals("16. array.length == 0", 0, array.length);
   			
   			ActionDirector.undoAction();
   			assertEquals("17. undo: array.length == 1", 1, array.length);
   			
   			ActionDirector.redoAction();
   			assertEquals("18. redo: array.length == 0", 0, array.length);
   			
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
