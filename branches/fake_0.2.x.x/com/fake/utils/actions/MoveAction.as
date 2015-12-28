/* SVN FILE: $Id: MoveAction.as 216 2008-10-06 13:21:02Z xpointsh $ */
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
	import flash.net.registerClassAlias;
	
	public class MoveAction extends Action
	{
		/**
		 * Convenience storage for the most recently started action. 
		 */	
		public static var currentAction:MoveAction;
		
		/**
		 * @inheritDoc
		 */		
		public function MoveAction(id:String = null, targets:Array=null)
		{
			super(id, targets);
		}
		
		/**
		 * Initializer for this action. It creates the action instance, adds it to the actionMap, and
		 * makes it the current action. Captures all of the x and y values of the targets.
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param targets Objects to have their x and y values watched.
		 * @return Created action.
		 */
		public static function start(id:String, ... targets):MoveAction
		{
			var action:MoveAction = new MoveAction(id, targets);
			
			for(var i:int = 0; i < action.targets.length; i++)
			{
				action.properties[i] = {x: action.targets[i].x, y: action.targets[i].y, x1: -1, y1: -1};
			}
			
			actionMap[action.id] = action;
			currentAction = action;
			
			return action;
		}
		
		override public function start():void {
			MoveAction.start(id, targets);
		}
		
		/**
		 * Inserts the action into the ActionDirector if it is not in a group. Captures
		 * the current x and y values of the targets.
		 * 
		 * @param id Used to find the action in the actionMap. If the parameter is empty, the currentAction will be used.
		 * @return Ended Action.
		 */		
		public static function end(id:String = ""):MoveAction
		{
			var action:MoveAction = (id == "") ? currentAction : actionMap[id];
			
			for(var i:int = 0; i < action.targets.length; i++)
			{
				action.properties[i].x1 = action.targets[i].x;
				action.properties[i].y1 = action.targets[i].y;
			}
			
			if(!action.inGroup)
				ActionDirector.insertAction(action);
			
			return action;
		}
		
		override public function end():void {
			MoveAction.end(id);
		}
		
		/**
		 * Moves the targets back to their initial position. 
		 */		
		override public function undo():void
		{
			for(var i:int = 0; i < targets.length; i++)
			{
				targets[i].x = properties[i].x;
				targets[i].y = properties[i].y;
			}
		}
		
		/**
		 * Moves the targets to their final position. 
		 */	
		override public function redo():void
		{
			for(var i:int = 0; i < targets.length; i++)
			{
				targets[i].x = properties[i].x1;
				targets[i].y = properties[i].y1;
			}
		}
		
		/**
		 * Helper function to add start/end on the dispatch of two given events.
		 * 
		 * @param dispatcher Same signature as IEventListener. The startEvent and endEvents are added to this Object.
		 * @param startEvent Constant of the event.
		 * @param endEvent Constant of the event.
		 * @param targets Objects to have their x and y values watched.
		 * @return Created action.
		 */
		public static function eventHelper(dispatcher:Object, startEvent:String, endEvent:String, ... targets):MoveAction
		{
			if(targets.length == 0)
				targets = [dispatcher];
			else
				targets = Action.restFormat(targets);
					
			var uid:String = Action.uid;
				
			dispatcher.addEventListener(startEvent, function ():void 
			{
				MoveAction.start(uid, targets);
			});
			
			dispatcher.addEventListener(endEvent, function ():void 
			{
				MoveAction.end(uid);
			});
			
			return currentAction;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function clone(id:String = "", newID:String = "uid"):Action
		{
			var action:MoveAction = (id == "") ? currentAction : actionMap[id];
			
			return MoveAction.start(newID, action.targets);
		}
	}
}