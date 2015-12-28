/* SVN FILE: $Id: DescribeUtil.as 222 2008-10-14 19:52:44Z gwoo.cakephp $ */
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
 * @version			$Revision: 222 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-10-14 12:52:44 -0700 (Tue, 14 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils.lso
{
	import flash.net.SharedObject;
	import flash.utils.flash_proxy;
	use namespace flash_proxy;
	
	import mx.utils.ObjectProxy;
	import com.fake.utils.DescribeUtil;
	import flash.utils.ByteArray;
	import flash.system.ApplicationDomain;
	import com.fake.utils.CloneUtil;
	

	public dynamic class LSObject extends ObjectProxy
	{
		private var _sharedObject:SharedObject;
		
		private static var _instance:LSObject = new LSObject();
		
		public static function get instance():LSObject 
		{
			return _instance;
		}
		
		public function LSObject()
		{
			super();
			
			_sharedObject = SharedObject.getLocal("LSO");
		}
		
		public static function get firstRun():Boolean
		{
			if(instance.getObject("firstRun") == null)
			{
				instance.add("firstRun", false);
				
				return true;
			}
			else
				return false;
		}
		
		/**
		 * Adds the named property to the shared object's data. It then flushes immediately.
		 */		
		public function add(name:String, value:Object):void
		{
			if(value == null) {
				remove(name);
				return;
			}
	        	
			var lsoItem:LSOItem = new LSOItem(DescribeUtil.className(value), value);
			
			sharedObject.data[name] = lsoItem;
			
			sharedObject.flush();
		}
		
		public function getObject(name:String):*
		{
			if(sharedObject.data[name] != null)
			{
				return CloneUtil.strongType(sharedObject.data[name].source, sharedObject.data[name].type);
	  		}
	    	else
	    		return null;
		}
		
		/**
		 * Deletes the named property from the shared object's data. Properties are not removed when set to null.
		 */		
		public function remove(name:String):void
		{
			delete sharedObject.data[name];
			
			sharedObject.flush();
		}
		
		/**
		 * Deletes everything from the shared object's data.
		 */		
		public function clear():void
		{
			for(var name:String in sharedObject.data) {
				delete sharedObject.data[name];	
			}
			
			sharedObject.flush();
		}
		
		/**
		 * Returns a string of all the user defined properties in the shared object's data.
		 */		
		public function toString():String
		{
			var output:String = "";
			output = "LSO Properties:";
			
			for(var name:String in sharedObject.data) {
				output += name + "\n";
			}
			
			return output;
		}
		
		/**
		* Allows you to get values from the data property of the shared object.
		*/		
	    override flash_proxy function getProperty(name:*):* 
	    {
	    	return getObject(name);
	    }
	
		/**
	     * Allows you to set values to the data property of the shared object.
	     */	
	    override flash_proxy function setProperty(name:*, value:*):void 
	    {
	    	add(name, value);
	    }
		
		public function get sharedObject():Object {
			return _sharedObject;
		}
	}
}