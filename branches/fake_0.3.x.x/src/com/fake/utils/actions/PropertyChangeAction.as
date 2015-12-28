/* SVN FILE: $Id: PropertyChangeAction.as 216 2008-10-06 13:21:02Z xpointsh $ */
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
	
	public class PropertyChangeAction extends Action
	{
		/**
		 * Convenience storage for the most recently started action. 
		 */		
		public static var currentAction:PropertyChangeAction;
		
		/**
		 * @inheritDoc
		 */
		public function PropertyChangeAction(id:String = null, targets:Array=null)
		{
			super(id, targets);
		}
		
		/**
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param propertyNames All the properties that are to be watched.
		 * @param targets Objects to have their properties watched.
		 * @return Created action.
		 */		
		public static function start(id:String, propertyNames:Array, ... targets):PropertyChangeAction
		{
			var action:PropertyChangeAction = new PropertyChangeAction(id, targets);
			
			action.properties["propertyNames"] = propertyNames;
			
			for each( var property:String in propertyNames)
			{
				action.properties[property + "_old"] = action.target[property];
			}
			
			actionMap[action.id] = action;
			currentAction = action;
			
			return action;
		}
		
		override public function start():void {
			PropertyChangeAction.start(id, propertyNames, targets);
		}
		
		/**
		 * Inserts the action into the ActionDirector if it is not in a group. Captures
		 * the current values of all of the properties.
		 * 
		 * @param id Used to find the action in the actionMap. If the parameter is empty, the currentAction will be used.
		 * @return Ended Action.
		 */	
		public static function end(id:String = ""):PropertyChangeAction
		{
			var action:PropertyChangeAction = (id == "") ? currentAction : actionMap[id];
			
			for each( var property:String in action.propertyNames)
			{
				action.properties[property + "_new"] = action.target[property];
			}
			
			if(!action.inGroup)
				ActionDirector.insertAction(action);
			
			return action;
		}
		
		override public function end():void {
			PropertyChangeAction.end(id);
		}
		
		/**
		 * Resets the all of the properties to their initial values.
		 */		
		override public function undo():void
		{
			for each(var target:Object in targets) 
			{
				for each(var property:String in propertyNames)
				{
					target[property] = properties[property + "_old"];
				}
			}
		}
		
		/**
		 * Sets the all of the properties to their final values.
		 */	
		override public function redo():void
		{
			for each(var target:Object in targets) 
			{
				for each(var property:String in propertyNames)
				{
					target[property] = properties[property + "_new"];
				}
			}
		}
		
		/**
		 * Helper function to add start/end on the dispatch of two given events.
		 * 
		 * @param dispatcher Same signature as IEventListener. The startEvent and endEvents are added to this Object.
		 * @param startEvent Constant of the event.
		 * @param endEvent Constant of the event.
		 * @param propertyNames All the properties that are to be watched.
		 * @param targets Objects to have their properties watched.
		 * @return Created action.
		 */
		public static function eventHelper(dispatcher:Object, startEvent:String, endEvent:String, propertyNames:Array, ... targets):PropertyChangeAction
		{
			if(targets.length == 0)
				targets = [dispatcher];
			else
				targets = Action.restFormat(targets);
				
			var uid:String = Action.uid;
				
			dispatcher.addEventListener(startEvent, function ():void 
			{
				PropertyChangeAction.start(uid, propertyNames, targets);
			});
			
			dispatcher.addEventListener(endEvent, function ():void 
			{
				PropertyChangeAction.end(uid);
			});
			
			return currentAction;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function clone(id:String = "", newID:String = "uid"):Action
		{
			var action:PropertyChangeAction = (id == "") ? currentAction : actionMap[id];
			
			return PropertyChangeAction.start(newID, action.propertyNames, action.targets);
		}
		
		public function get propertyNames():Array {
			return properties.propertyNames;
		}
	}
}