/* SVN FILE: $Id: Action.as 216 2008-10-06 13:21:02Z xpointsh $ */
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
	public class Action
	{
		/**
		 * Unique identifier of the action. Used for storage in the static actionMap.
		 */		
		public var id:String;
		/**
		 * If true, this will prevent the action from being inserted to the actionCursor
		 * during the static end function. The insert will be done during the end function
		 * of the parent GroupAction.
		 */		
		public var inGroup:Boolean = false;
		/**
		 * Storage of all actions by id. 
		 */		
		protected static var _actionMap:Object = {};
		/**
		 * All objects that are to be affected by the action. 
		 */		
		protected var _targets:Array = [];
		/**
		 * General storage of variables. 
		 */		
		protected var _properties:Object = {};
		
		/**
		 * Instantiated within the static start function of each action class.
		 * 
		 * @param id Used for storage in the static actionMap. If the string is "uid", a dynamic id will be inserted.
		 * @param targets Objects that are to be affected by the action.
		 * @param properties General storage of variables. 
		 */
		public function Action(id:String = null, targets:Array = null)
		{
			if(id == "uid")
				this.id = uid;
			else
				this.id = id;
			
			if(targets)
				_targets = restFormat(targets);
		}
		
		/**
		 * Abstract function to be overriden. 
		 */	
		public function start():void {
			
		}
		
		/**
		 * Abstract function to be overriden. 
		 */	
		public function end():void {
			
		}
		
		/**
		 * Abstract function to be overriden. 
		 */		
		public function undo():void {
			
		}
		
		/**
		 * Abstract function to be overriden. 
		 */	
		public function redo():void {
			
		}
		
		/**
		 * 
		 * @return Copy of the current action. This is not a deep copy but shares references.
		 */		
		public function clone(id:String = "", newID:String = "uid"):Action
		{
			return null;
		}
		
		/**
		 * Helper function to allow for both rest array parameter or one array parameter.
		 */		
		public static function restFormat(restArray:Array):Array
		{
			if(restArray[0] is Array)
				restArray = restArray[0];
			
			return restArray;
		}
		
		/**
		 * The first object in the targets array. 
		 */		
		public function get target():Object {
			return targets[0];
		}
		
		/**
		 * Creates a string of random numbers to be used as the id for actions.
		 */		
		public static function get uid():String {
			return String(Math.random() * 1000000000);
		}
		
		public static function get actionMap():Object {
			return _actionMap;
		}
		public static function set actionMap(value:Object):void {
			_actionMap = value;
		}
		
		public function get targets():Array {
			return _targets;
		}
		public function set targets(value:Array):void {
			_targets = value;
		}
		
		public function get properties():Object {
			return _properties;
		}
		public function set properties(value:Object):void {
			_properties = value;
		}
	}
}