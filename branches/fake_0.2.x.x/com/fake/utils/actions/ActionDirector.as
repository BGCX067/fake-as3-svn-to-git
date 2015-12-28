/* SVN FILE: $Id: ActionDirector.as 216 2008-10-06 13:21:02Z xpointsh $ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 216 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-06 20:21:02 +0700 (Mon, 06 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils.actions
{
	import com.fake.utils.FakeCursor;
	
	[Bindable]
	public class ActionDirector
	{
		/**
		 * Contains all of the Actions for the ActionDirector. 
		 */		
		public static var actionCursor:FakeCursor = new FakeCursor();
		/**
		 * Limit of Actions allowable. Any actions that are added after this limit has been
		 * reached will remove the Action at the bottom of the cursor.
		 */		
		public static var maxActions:int = 5;
		
		public function ActionDirector() {
		}
		
		/**
		 * Adds the action to the cursor at the current index. All actions that are above
		 * this action are removed from the cursor. The cursor is then moved to the last
		 * position.
		 * 
		 * @param action Placed at the top of the cursor.
		 */		
		public static function insertAction(action:Action):void
		{
			actionCursor.insert(action);
			
			if(!actionCursor.beforeFirst && actionCursor.currentIndex < actionCursor.length-1)
			{
				actionCursor.source.length = actionCursor.currentIndex + 1;
			}
			
			actionCursor.moveLast();
		}
		
		/**
		 * Executes the undo function of the action below the current index position.
		 * 
		 * @param times Number of times that undo will be executed.
		 */				
		public static function undoAction(times:int = 0):void
		{
			if(actionCursor.currentIndex == 0)
				return;
				
			actionCursor.movePrevious()
			
			var action:Action = Action(actionCursor.current);
			action.undo();
			
			if(times > 0) {
				undoAction(times-1);
			}
		}
		
		/**
		 * Executes the redo function of the action at the current index position.
		 * Moves the cursor ahead once the redo has been executed.
		 * 
		 * @param times Number of times that redo will be executed.
		 */	
		public static function redoAction(times:int = 0):void
		{
			if(actionCursor.current)
			{
				var action:Action = Action(actionCursor.current);
				action.redo();
			}
			
			actionCursor.moveNext();
			
			if(times > 0) {
				redoAction(times-1);
			}
		}
		
		/**
		 * Removes all of the actions in the cursor.
		 */		
		public static function clear():void {
			actionCursor.clear()
		}
		/**
		 * Total number of actions in the cursor.
		 */		
		public static function get length():int {
			return actionCursor.length;
		}
	}
}