/* SVN FILE: $Id: CloneUtil.as 268 2009-06-16 22:17:36Z gwoo.cakephp $ */
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
 * @version			$Revision: 268 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 05:17:36 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;

	/**
	* A helper utility class for cloning objects.
	**/
	public class CloneUtil
	{
		public static function clone(source:Object, deepClone:Boolean = false):*
		{
			try
			{
				return _clone(source, deepClone);
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
				var classRef:Object = DescribeUtil.classReference(type);
				
				DescribeUtil.registerClass(classRef);
				
				return _clone(source, true);
			} 
			catch(e:*)
			{
				return source;
			}
		} 
		
		private static function _clone(source:Object, deepClone:Boolean):*
		{
			DescribeUtil.registerClass(source);
			
			var output:Object = ObjectUtil.copy(source);
			var props:Array = DescribeUtil.instance.propertyNameList(output);
			
			for each(var key:String in props)
			{
				var value:* = source[key];
			
				if(value is Array)
				{
					output[key] = [];
			
					for each(var child:Object in value) 
					{ 
						output[key].push(_clone(child, deepClone));
					}
				}
				else if(value is Object)
				{
					output[key] = _clone(value, deepClone);
				}
			}
			
			return output;
		}
	}
}