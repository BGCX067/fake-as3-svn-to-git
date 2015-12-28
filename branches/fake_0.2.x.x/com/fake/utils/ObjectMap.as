/* SVN FILE: $Id: ObjectMap.as 308 2009-06-30 09:47:45Z xpointsh $ */
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
 * @version			$Revision: 308 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2009-06-30 16:47:45 +0700 (Tue, 30 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.utils.flash_proxy;
	
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;
	use namespace flash_proxy;
	
	[Bindable]
	public dynamic class ObjectMap extends ObjectProxy
	{
		/**
		 * Storage for all arrays containing items by key (Class name or meta label) 
		 */		
		private var _rootMap:Object = {};
		/**
		 * Storage for individual items by id.
		 */
		private var _idMap:Object = {};
		/**
		 * Removes the PropertyChangeEvent dispatching on an add or remove call.
		 */		
		public var disableCustomDispatching:Boolean = false;
		
		private static var _instance:ObjectMap = new ObjectMap();
		
		public static function get instance():ObjectMap {
			return _instance;
		}
		
		public function ObjectMap()
		{
		}
		
		/**
		 * Takes the given object and adds it to the rootMap arrays by its keys. If it has
		 * an id property, it is added to the idMap.
		 */		
		public function add(value:Object, ... metaKeys):void
		{
			var keys:Array = getKeys(value);
			
			keys = keys.concat(DescribeUtil.restFormat(metaKeys));
			
			for each(var key:String in keys)
			{
				if(!rootMap[key])
					rootMap[key] = [];
				
				if(rootMap[key].indexOf(value) == -1)
					rootMap[key].push(value);
			}
			
			if(value.hasOwnProperty("id")) {
				idMap[value.id] = value;
			}
			
			dispatchPropertyChange();
		}
		
		/**
		 * Uses DescribeUtil to create an array of string all of the local names of 
		 * the classes and interfaces of the given object.
		 */		
		public function getKeys(value:Object):Array
		{
			var keys:Array = [];
			
			var description:XML = DescribeUtil.instance.describe(value);
			
			keys.push(description.@name.toString());
			
			for each(var ext:XML in description.extendsClass) {
				keys.push(ext.@type.toString());
			}
			
			for each(var inter:XML in description.implementsInterface) {
				keys.push(inter.@type.toString());
			}
			
			for(var i:int = 0; i < keys.length; i++) {
				if(String(keys[i]).split("::")[1])
					keys[i] = String(keys[i]).split("::")[1];
			}
			
			return keys;
		}
		
		/**
		 * Returns the rootMap array based on the given string or class object
		 */		
		public function find(value:Object):Array
		{
			if(value is String) {
				return rootMap[value];
			}
			else {
				return rootMap[DescribeUtil.localName(value)];
			}
		}
		
		/**
		 * Returns an object map from the result of a find call. 
		 * The map is keyed by the key parameter.
		 */		
		public function findMap(value:Object, key:String = "id"):Object
		{
			var findArray:Array = find(value);
			var resultMap:Object = {};
			
			for each(var obj:Object in findArray)
			{
				resultMap[obj[key]] = obj;
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
		 * Deletes all references to the given object from the 
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
				{
					rootMap[key] = null;
					delete rootMap[key];
				}
			}
			
			if(value.hasOwnProperty("id"))
				delete idMap[value.id];
				
			dispatchPropertyChange();
		}
		
		/**
		 * Searches the ObjectMap for objects based on property matching. Key is the type
		 * or id of the objects that you want searched. The matchValue is checked on the property.
		 * If no propertyName is given, all properties will be searched.
		 */		
		public function queryMatchValue(key:*, matchValue:Object, propertyName:String = "*"):Array
		{
			var foundObjects:Array;
			var searchProps:Array = [];
			var results:Array = [];
			
			if(key is Class)
				foundObjects = find(DescribeUtil.localName(key));
			else
				foundObjects = find(key);	
			
			if(propertyName == "*")
				searchProps = DescribeUtil.instance.propertyNameList(foundObjects[0]);
			else
				searchProps.push(propertyName);
				
			for each(var foundObject:Object in foundObjects)
			{
				for each(var searchProp:Object in searchProps)
				{
					if(String(String(foundObject[searchProp]).toLowerCase()).indexOf(String(matchValue).toLowerCase()) != -1 && results.indexOf(foundObject) == -1)
						results.push(foundObject)
				}
			}
			
			return results;
		}
		
		/**
		 * Removes all references in the rootMap and idMap 
		 */		
		public function clear():void
		{
			_rootMap = _idMap = {};
		}
		
		/**
		 * The preferred way to change ids of objects. Remaps the object
		 * to the new id in the idMap.
		 * 
		 * @param value Item to have its id changed.
		 * @param id New value to be used in the idMap
		 */		
		public function changeID(value:Object, id:String):void
		{
			delete idMap[value.id];
			
			value.id = id;
			
			idMap[value.id] = id;
			
			dispatchPropertyChange();
		}
		
		/**
		 * Used to support databinding on rootMap and idMap keys
		 */		
		public function dispatchPropertyChange():void
		{
			if(disableCustomDispatching) return;
			
			var keys:Array = [];
			
			for(var key:String in rootMap) {
				keys.push(key);
			}
			
			for each(key in keys)
			{
				var event:PropertyChangeEvent =
                PropertyChangeEvent.createUpdateEvent(
                    this, key, null, rootMap[key]);
                    
                dispatcher.dispatchEvent(event);
			}
			
			for(key in idMap) {
				keys.push(key);
			}
			
			for each(key in keys)
			{
				event = PropertyChangeEvent.createUpdateEvent(
                    this, key, null, idMap[key]);
                    
                dispatcher.dispatchEvent(event);
			}
		}
		
		/**
		 * Displays all of the types contained within the rootMap (keys) and
		 * the ids of all the objects in the idMap.
		 */		
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
		
		public function get rootMap():Object {
			return _rootMap;
		}
		
		public function get idMap():Object {
			return _idMap;
		}
		
		public function get rootKeys():Array 
		{
			var keys:Array = [];
			
			for(var key:String in rootMap) { 
				keys.push(key);
			}
			
			return keys;
		}
		
	    /**
	     * Allows you to get objectMap.SomeClass or objectMap.someID 
	     */		
		override flash_proxy function getProperty(name:*):* 
		{
			if(idMap[name]) {
				return idMap[name];
			}
			else if(rootMap[name]) {
				return rootMap[name];
			}
	    	
			return null;
		}
	
		/**
	     * Allows you to set values to the idMap. You cannot do that with classes in the rootMap.
	     */	
	    override flash_proxy function setProperty(name:*, value:*):void 
	    {
	        idMap[name] = value;
	    }
	}
}