/* SVN FILE: $Id: ExternalInterfaceUtil.as 196 2008-09-16 20:40:41Z xpointsh $ */
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
 * @version			$Revision: 196 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-17 03:40:41 +0700 (Wed, 17 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.external.ExternalInterface;
	
	public class ExternalInterfaceUtil
	{	
		public function ExternalInterfaceUtil()
		{
		}
		
		/**
		 * This function calls the addCallback function of the ExternalInterface class on each method
		 * of the source Object. By default, all functions that are defined in the class are added.
		 * Functions can be excluded by using the exclude list. Functions from super classes are not added.
		 * They can be added with the include list. A "*" can be given as the parameter string of the
		 * excludeList. This will skip the default adding of functions.
		 * 
		 * Usage: Adding external interface callbacks to every property of a geometry instance
		 * ExternalInterfaceUtil.autoAddCallback(new Geometry());
		 * 
		 * @param sourceObject Reference to the object that will have its methods added.
		 * @param includeList Functions of super classes that are to be included in external binding.
		 * @param excludeList Functions of the class that are not going to be bound.
		 * 
		 */		
		static public function autoAddCallback(sourceObject:Object, includeList:String = "", excludeList:String = ""):void
		{
			var descriptionXML:XML = DescribeUtil.instance.describe(sourceObject);
			var className:String = descriptionXML.@name;
			
			var includeArray:Array = [];
			var excludeArray:Array = [];
			
			if(includeList != "")
				includeArray = includeList.split(",");
				
			if(excludeList != "")
				excludeArray = excludeList.split(",");
			
			for each(var includeName:String in includeArray)
			{
				ExternalInterface.addCallback(includeName, sourceObject[includeName]);
			}
			
			if(excludeList == "*")
				return;
			
			for each(var methodNode:XML in descriptionXML.method)
			{
				var excluded:Boolean = false;
				
				for each(var excludeName:String in excludeArray)
				{
					if(methodNode.@name == excludeName)
						excluded = true;				
				}
				
				if(methodNode.@declaredBy == className && !excluded)
				{
					ExternalInterface.addCallback(methodNode.@name, sourceObject[methodNode.@name]);
				}
			}
		}
	}
}