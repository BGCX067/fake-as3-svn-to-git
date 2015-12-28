/* SVN FILE: $Id: AddAction.as 192 2008-09-16 19:05:46Z xpointsh $ */
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
 * @version			$Revision: 192 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-16 12:05:46 -0700 (Tue, 16 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils.actions
{
	public dynamic class DelegateAction extends Action
	{
		/**
		 * Convenience storage for the most recently started action. 
		 */		
		public static var currentAction:DelegateAction;
		
		public var undoDelegate:Function;
		public var redoDelegate:Function;
		
		 /**
		 * @inheritDoc
		 */
		public function DelegateAction(id:String=null, targets:Array=null)
		{
			super(id, targets);
		}
		
		/**
		 * Initializer for this action. It creates the action instance, adds it to the actionMap, and
		 * makes it the current action. 
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param targets Used by the custom delegates.
		 * @return Created action.
		 */
		public static function start(id:String, undoDelegate:Function = null, redoDelegate:Function = null, ... targets):DelegateAction
		{
			var action:DelegateAction = new DelegateAction(id, targets);
			
			action.undoDelegate = undoDelegate;
			action.redoDelegate = redoDelegate;
			
			actionMap[action.id] = action;
			currentAction = action;
			
			return action;
		}
		
		override public function start():void {
			DelegateAction.start(id, undoDelegate, redoDelegate, targets);
		}
		
		/**
		 * Inserts the action into the ActionDirector if it is not in a group.
		 * 
		 * @param id Used to find the action in the actionMap. If the parameter is empty, the currentAction will be used.
		 * @return Ended Action.
		 */		
		public static function end(id:String = ""):DelegateAction
		{
			var action:DelegateAction = (id == "") ? currentAction : actionMap[id];

			if(!action.inGroup)
				ActionDirector.insertAction(action);
				
			return action;
		}
		
		override public function end():void {
			DelegateAction.end(id);
		}
		
		/**
		 * Executes the undoDelegate function if it is not null. Otherwise, it will execute the undoDelegateCustom function.
		 */		
		override public function undo():void
		{
			undoDelegate(this);
		}
		
		/**
		 * Executes the redoDelegate function if it is not null. Otherwise, it will execute the undoDelegateCustom function.
		 */	
		override public function redo():void
		{
			redoDelegate(this);
		}
		
		/**
		 * Helper function to add start/end on the dispatch of two given events.
		 * 
		 * @param dispatcher Same signature as IEventListener. The startEvent and endEvents are added to this Object.
		 * @param startEvent Constant of the event.
		 * @param endEvent Constant of the event.
		 * @param targets Used by the custom delegates.
		 * @return Created action.
		 */		
		public static function eventHelper(dispatcher:Object, startEvent:String, endEvent:String, undoDelegate:Function = null, redoDelegate:Function = null, ... targets):DelegateAction
		{
			if(targets.length == 0)
				targets = [dispatcher];
			else
				targets = Action.restFormat(targets);
				
			var uid:String = Action.uid
				
			dispatcher.addEventListener(startEvent, function ():void 
			{
				DelegateAction.start(uid, undoDelegate, redoDelegate, targets);
			});
			
			dispatcher.addEventListener(endEvent, function ():void 
			{
				DelegateAction.end(uid);
			});
			
			return currentAction;
		}
		
		/**
		 * @inheritDoc
		 */	
		override public function clone(id:String = "", newID:String = "uid"):Action
		{
			var action:DelegateAction = (id == "") ? currentAction : actionMap[id];
			
			return DelegateAction.start(newID, action.undoDelegate, action.redoDelegate, action.targets);
		}
	}
}