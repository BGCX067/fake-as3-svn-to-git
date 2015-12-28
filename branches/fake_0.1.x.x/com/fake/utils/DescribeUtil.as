/* SVN FILE: $Id: DescribeUtil.as 136 2008-07-17 00:18:41Z xpointsh $ */
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
 * @version			$Revision: 136 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-07-17 07:18:41 +0700 (Thu, 17 Jul 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class DescribeUtil
	{
		/**
		 * hash of currently defined classes
		 */
		private var __definitionHash:Object = {};
		/**
		 * hash of currently described class
		 */
		private var __describeHash:Object = {};
		/**
		 * hash of object properties
		 */
		private var __propertyNameHash:Object = {};

		/**
		 * hold the instance of the class
		 */
		private static const __instance:DescribeUtil = new DescribeUtil();
		/**
		 * Constructor
		 *
		 */
		public function DescribeUtil()
		{
		}

		/**
		 * Get the instance of the class
		 * @return
		 *
		 */
		public static function get instance():DescribeUtil
		{
			return __instance;
		}

		/**
		 * Get the xml description for the class and add it to the hash table
		 * @param value
		 * @return
		 *
		 */
		public function describe(value:Object):XML
		{
			var classPath:String = getQualifiedClassName(value);
			var ar:Array = classPath.split("::");
			var className:String = ar[1];

			if(__describeHash[className] == null)
			{
				__describeHash[className] = describeType(value);
			}

			return XML(__describeHash[className]);
		}

		/**
		 * Get the definition by name and return class reference
		 * @param value
		 * @return
		 *
		 */
		public function definition(name:String):Class
		{
			if(__definitionHash[name] == null)
			{
				__definitionHash[name] = getDefinitionByName(name);
			}

			return Class(__definitionHash[name]);
		}
		
		/**
		 * Get a hash object containing all variables and get/set accessors.
		 * @param value
		 * @return 
		 * 
		 */		
		public function properties(value:Object):Object
		{
			var props:Object = {};
			
			for each(var prop:String in propertyNameList(value))
			{
				props[prop] = value[prop];
			}

			return props;
		}
		
		/**
		 * Get a list of property name strings. Includes both variables and get/set accessors.
		 * 
		 * @param value
		 * @return
		 * 
		 */		
		public function propertyNameList(value:Object):Array
		{
			var desc:XML = DescribeUtil.instance.describe(value);
			var classPath:String = getQualifiedClassName(value);
			var ar:Array = classPath.split("::");
			var className:String = ar[1];
			var propArray:Array = [];

			if(__propertyNameHash[className] == null)
			{
				for each(var node:XML in desc..variable)
				{
					if(node.metadata == null || node.metadata.@name == "Bindable" || node.metadata.@name != "Transient")
					{
						propArray.push(node.@name.toString());
					}
				}
		
				for each(node in desc..accessor)
				{
					if(node.@access == 'readwrite')
					{
						propArray.push(node.@name.toString());
					}
				}
				
				__propertyNameHash[className] = propArray;
			}
			
			return __propertyNameHash[className];
		}
	}
}