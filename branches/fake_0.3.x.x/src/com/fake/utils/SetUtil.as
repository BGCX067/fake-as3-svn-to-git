/* SVN FILE: $Id: SetUtil.as 133 2008-06-22 23:21:16Z gwoo.cakephp $ */
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
 * @version			$Revision: 133 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-23 06:21:16 +0700 (Mon, 23 Jun 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import mx.utils.ObjectUtil;

	/**
	 * Utility class for working with Arrays and Objects
	 *
	 */
	public class SetUtil
	{
		/**
		 * return the difference of two objects using the first object as the baseline
		 * @param one
		 * @param two
		 * @return Object
		 *
		 */
		public static function diff(one:Object, two:Object):Object
		{
			var newObj:Object = {};
			for each (var prop:* in one)
			{
				if (!two.hasOwnProperty(prop))
				{
					newObj[prop] = one[prop];
				}
			}
			return newObj;
		}

		/**
		 * Check if a value exists in the array
		 * @param obj
		 * @param key
		 * @param value optional
		 * @return Boolean
		 *
		 */
		public static function exists(obj:Object, value:*, key:* = null):Boolean
		{
			for each (var prop:* in obj)
			{
				if (key == null)
				{
					if (prop == value || prop.hasOwnProperty(value))
					{
						return true;
					}

					if (prop is Object && value is Object && ObjectUtil.compare(prop, value) == 0)
					{
						return true;
					}
				}
				else
				{
					if (prop.hasOwnProperty(key) && prop[key] == value)
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * merge two objects using the first object as the baseline
		 * @param one
		 * @param two
		 * @return Object
		 *
		 */
		public static function merge(one:Object, two:Object):Object
		{
			var newObj:Object = {};
			for (var prop:* in one)
			{
				if (two.hasOwnProperty(prop) && one[prop] !== two[prop])
				{
					newObj[prop] = two[prop];
				}
				else
				{
					newObj[prop] = one[prop];
				}
			}
			
			for (prop in two)
			{
				if (!newObj.hasOwnProperty(prop))
				{
					newObj[prop] = two[prop];
				}
			}
			
			return newObj;
		}
	}
}