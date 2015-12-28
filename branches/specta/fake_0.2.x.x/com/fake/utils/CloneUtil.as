/* SVN FILE: $Id: CloneUtil.as 218 2008-10-06 13:26:37Z xpointsh $ */
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
 * @version			$Revision: 218 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-06 20:26:37 +0700 (Mon, 06 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.utils.ByteArray;

	/**
	* A helper utility class for cloning objects.
	**/
	public class CloneUtil
	{
		public static function clone(source:Object):*
		{
			try
			{
				return _clone(source);
			}
			catch(e:*)
			{
				return source;
			}
		}
		
		public static function strongType(source:Object, type:String):*
		{
			try
			{
				var clazz:Object = DescribeUtil.classReference(type);
				
				DescribeUtil.registerClass(clazz);
				
				var objectByteArray:ByteArray = new ByteArray();
			    objectByteArray.writeObject(source);
			    objectByteArray.position = 0;
			    
			    return objectByteArray.readObject();
		 	} 
		 	catch(e:*)
		 	{
		 		return source;
		 	}
		} 
		
		private static function _clone(source:Object):*
		{
			DescribeUtil.registerClass(source);
			
		    var objectByteArray:ByteArray = new ByteArray();
		    objectByteArray.writeObject(source);
		    objectByteArray.position = 0;
		    
		    var output:Object = objectByteArray.readObject();
		    var props:Array = DescribeUtil.instance.propertyNameList(output);
		    
		    for each(var key:String in props)
		    {
		    	var value:* = source[key];
		    	
		    	if(value is Array)
		    	{
		    		output[key] = [];
		    		
		    		for each(var child:Object in value) 
		    		{ 
		    			output[key].push(_clone(child));
		    		}
		    	}
		    	else if(value is Object)
		    	{
		    		output[key] = _clone(value);
		    	}
		    }
		    
		    return output;
		}
	}
}