/* SVN FILE: $Id: ObjectMap.as 164 2008-09-10 12:28:36Z xpointsh $ */
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
 * @version			$Revision: 164 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-10 19:28:36 +0700 (Wed, 10 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.utils.flash_proxy;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectProxy;
	use namespace flash_proxy;
	
	[Bindable]
	public dynamic class ObjectMap extends ObjectProxy
	{
		public var rootMap:Object = {};
		
		public var idMap:Object = {};
		
		private static var _instance:ObjectMap = new ObjectMap();
		
		public static function get instance():ObjectMap {
			return _instance;
		}
		
		public function ObjectMap()
		{
		}
		
		/**
		 * Takes the given object and adds it to the rootMap arrays by its keys.
		 */		
		public function add(value:Object):void
		{
			var keys:Array = getKeys(value);
			
			for each(var key:String in keys)
			{
				if(!rootMap[key])
					rootMap[key] = [];
					
				rootMap[key].push(value);
			}
			
			if(value.hasOwnProperty("id"))
			{
				idMap[value.id] = value;
			}
		}
		
		/**
		 * Uses describeType to create a String array of all of the classes
		 * and interfaces connected to the given object.
		 */		
		private function getKeys(value:Object):Array
		{
			var keys:Array = [];
			
			var description:XML = DescribeUtil.instance.describe(value);
			
			keys.push(description.@name);
			
			for each(var ext:XML in description.extendsClass) {
				keys.push(ext.@type);
			}
			
			for each(var inter:XML in description.implementsInterface) {
				keys.push(inter.@type);
			}
			
			return keys;
		}
		
		/**
		 * Returns the rootMap array based on the given string or object class
		 */		
		public function find(value:Object):Array
		{
			if(value is String)
			{
				return rootMap[value];
			}
			else
			{
				return rootMap[getQualifiedClassName(value)];
			}
		}
		
		/**
		 * Returns an object map from the result of a find call. 
		 * The map is keyed by the given field property.
		 */		
		public function findMap(value:Object, field:String = "id"):Object
		{
			var findArray:Array = find(value);
			var resultMap:Object = {};
			
			for each(var obj:Object in findArray)
			{
				resultMap[obj[field]] = obj;
			}
			
			return resultMap;
		}
		
		/**
		 * Finds a single object by the given id.
		 */		
		public function findByID(value:String):Object
		{
			return idMap[value];
		}
		
		/**
		 * Deletes (splices) all references to the given object from the 
		 * containing arrays.
		 */		
		public function remove(value:Object):void
		{
			var keys:Array = getKeys(value);
			
			for each(var key:String in keys)
			{
				var arr:Array = rootMap[key];
				arr.splice(arr.indexOf(value),1);
				
				if(arr.length == 0)
					delete rootMap[key];
			}
			
			if(value.id)
				delete idMap[value.id];
		}
		
		public function toString():String
		{
			var output:String = "";
			
			output = "rootMap types:\n";
			
			for(var t:String in rootMap)
			{
				output += "count: " + rootMap[t].length + "\t";
				output += "type: " + t + "\n";
			}
			
			output += "\nidMap entries:\n";
			
			for(var i:String in idMap)
			{
				output += "id: " + i + "\n";
			}
			
			return output;
		} 
		
		override flash_proxy function callProperty(name:*, ... rest):* {
			return findByID(name);
	    }
	
	    override flash_proxy function getProperty(name:*):* {
	    	return findByID(name);
	    }
	
	    override flash_proxy function setProperty(name:*, value:*):void 
	    {
	        if(Object(value).hasOwnProperty("id") && value.id != name)
	        {
	        	value.id = name;
	        }
	        add(value);
	    }
	}
}