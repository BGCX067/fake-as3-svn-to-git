/* SVN FILE: $Id: GroupAction.as 216 2008-10-06 13:21:02Z xpointsh $ */
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
	import com.fake.utils.DescribeUtil;
	
	public class GroupAction extends Action
	{
		/**
		 * Convenience storage for the most recently started action. 
		 */		
		public static var currentAction:GroupAction;
		
		/**
		 * @inheritDoc
		 */
		public function GroupAction(id:String=null, targets:Array=null)
		{
			super(id, targets);
		}
		
		/**
		 * Initializer for this action. It creates the action instance, adds it to the actionMap, and
		 * makes it the current action. Sets inGroup to true on all of the child actions.
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param actions Children of this action.
		 * @return Created action.
		 */
		public static function start(id:String, ... actions):GroupAction
		{
			var action:GroupAction = new GroupAction(id, actions);
			
			actionMap[action.id] = action;
			currentAction = action;
			
			for each(var target:Action in action.targets) {
				target.inGroup = true;
			}
			
			return action as GroupAction;
		}
		
		override public function start():void {
			GroupAction.start(id, targets);
		}
		
		/**
		 * Calls end on all of the child actions. Then inserts itself into the ActionDirector.
		 * 
		 * @param id Used to find the action in the actionMap. If the parameter is empty, the currentAction will be used.
		 * @return Ended Action.
		 */		
		public static function end(key:String = ""):GroupAction
		{
			var groupAction:GroupAction = (key == "") ? currentAction : actionMap[key];
			
			for each(var action:Action in groupAction.targets) {
				action.end();
			}

			ActionDirector.insertAction(groupAction);
			
			return groupAction;
		}
		
		override public function end():void {
			GroupAction.end(id);
		}
		
		/**
		 * Calls undo on all of the child actions. 
		 */		
		override public function undo():void 
		{
			for each(var action:Action in targets) {
				action.undo();
			}
		}
		
		/**
		 * Calls redo on all of the child actions. 
		 */	
		override public function redo():void 
		{
			for each(var action:Action in targets) {
				action.redo();
			}
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function clone(id:String = "", newID:String = "uid"):Action
		{
			var action:GroupAction = (id == "") ? currentAction : actionMap[id];
			
			return GroupAction.start(newID, action.targets);
		}
	}
}