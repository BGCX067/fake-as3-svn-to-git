/* SVN FILE: $Id: RemoveAction.as 216 2008-10-06 13:21:02Z xpointsh $ */
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
	public class RemoveAction extends Action
	{
		/**
		 * Convenience storage for the most recently started action. 
		 */		
		public static var currentAction:RemoveAction;
		
		/**
		 * @inheritDoc
		 */
		public function RemoveAction(id:String=null, targets:Array=null)
		{
			super(id, targets);
		}
		
		/**
		 * Initializer for this action. It creates the action instance, adds it to the actionMap, and
		 * makes it the current action. 
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param container Objects that have addChild/removeChild, addItem/removeItem or behave like Arrays.
		 * @param targets Objects that are to be added/removed from the container.
		 * @return Created action.
		 */	
		public static function start(id:String, container:Object, ... targets):RemoveAction
		{
			var action:RemoveAction = new RemoveAction(id, targets);
			
			action.properties.container = container;
			
			action.properties.index = getIndex(action.container, action.target);
			
			actionMap[action.id] = action;
			currentAction = action;
			
			return action;
		}
		
		override public function start():void {
			RemoveAction.start(id, container, targets);
		}
		
		/**
		 * Inserts the action into the ActionDirector if it is not in a group.
		 * 
		 * @param id Used to find the action in the actionMap. If the parameter is empty, the currentAction will be used.
		 * @return Ended Action.
		 */	
		public static function end(id:String = ""):RemoveAction
		{
			var action:RemoveAction = (id == "") ? currentAction : actionMap[id];
			
			if(!action.inGroup)
				ActionDirector.insertAction(action);
				
			return action;
		}
		
		override public function end():void {
			RemoveAction.end(id);
		}
		
		/**
		 * Adds all targets from the container property.
		 */	
		override public function undo():void
		{
			if(container.hasOwnProperty("addChild"))
			{
				container.addChildAt(target, index);
			}
			else if(container.hasOwnProperty("addItem"))
			{
				container.addItemAt(target, index);
			}
			else
			{
				container.splice(index,0,target);
			}
		}
		
		/**
		 * Removes all targets from the container property.
		 */	
		override public function redo():void
		{
			if(container.hasOwnProperty("removeChild"))
			{
				container.removeChild(target);
			}
			else if(container.hasOwnProperty("removeItemAt"))
			{
				var i:int = container.getItemIndex(target);
				container.removeItemAt(i);
			}
			else
			{
				container.splice(container.indexOf(target), 1);
			}
		}
		
		/**
		 * Helper function to add start/end on the dispatch of two given events.
		 * 
		 * @param dispatcher Same signature as IEventListener. The startEvent and endEvents are added to this Object.
		 * @param startEvent Constant of the event.
		 * @param endEvent Constant of the event.
		 * @param container Objects that have addChild/removeChild, addItem/removeItem or behave like Arrays.
		 * @param targets Objects that are to be added/removed from the container.
		 * @return Created action.
		 */	
		public static function eventHelper(dispatcher:Object, startEvent:String, endEvent:String, container:Object, ... targets):void
		{
			if(targets.length == 0)
				targets = [dispatcher];
			else
				targets = Action.restFormat(targets);
				
			var uuid:String = Action.uid
				
			dispatcher.addEventListener(startEvent, function ():void 
			{
				RemoveAction.start(uid, container, targets);
			});
			
			dispatcher.addEventListener(endEvent, function ():void 
			{
				RemoveAction.end(uid);
			});
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function clone(id:String = "", newID:String = "uid"):Action
		{
			var action:RemoveAction = (id == "") ? currentAction : actionMap[id];
			
			return RemoveAction.start(newID, action.container, action.targets);
		}
		
		private static function getIndex(container:Object, target:Object):int
		{
			if(container.hasOwnProperty("addChild"))
			{
				return container.getChildIndex(target) as int;
			}
			else if(container.hasOwnProperty("addItem"))
			{
				return container.getItemIndex(target) as int;
			}
			else
			{
				return container.indexOf(target) as int;
			}
		}
		
		public function get container():Object {
			return properties.container;
		}
		
		public function get index():Object {
			return properties.index;
		}
	}
}