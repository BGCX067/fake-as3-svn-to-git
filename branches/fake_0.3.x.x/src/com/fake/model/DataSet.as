/* SVN FILE: $Id: DataSet.as 283 2009-06-21 15:38:15Z rafael.costa.santos $ */
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
 * @subpackage		com.fake.model
 * @since			2008-03-06
 * @version			$Revision: 283 $
 * @modifiedby		$LastChangedBy: rafael.costa.santos $
 * @lastmodified	$Date: 2009-06-21 22:38:15 +0700 (Sun, 21 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.FakeObject;
	import com.fake.utils.FakeCursor;

	import mx.collections.CursorBookmark;

	public dynamic class DataSet extends FakeObject
	{
		/**
		* Contains model objects
		*/
		public var data:Object;

		public var list:FakeCursor;

		/**
		 * Serves as an advanced ArrayCollection with that
		 * takes in the raw data returned by service calls and
		 * converts into typed model objects.
		 *
		 * @param source
		 *
		 */
		public function DataSet(source:*)
		{
			if (source is Array)
			{
				list = new FakeCursor(source);
				data = list.nextObject;
			}
			else
			{
				list = new FakeCursor([]);
				data = source;
			}
		}

		/**
		 * add a model to the dataSet
		 * @param key
		 * @param vo
		 *
		 */
		public function insert(key:*, value:Object):void
		{
			if (key is Number)
			{
				list.source.push(value);
			}
			else
			{
				data[key] = value;
			}
		}

		/**
		 * Wrapper for the cursor.moveNext method.
		 *
		 * @return true if still in the list, false if the current value initially was or now is afterLast.
		 *
		 */
		public function moveNext():Boolean
		{
			return list.moveNext();
		}

		/**
		 * Reset the dataset to the start
		 *
		 */
		public function moveFirst():void
		{
			list.moveFirst();
		}

		/**
		 * Get the current object of the dataset
		 * @return Object
		 *
		 */
		public function get current():Object
		{
			if (list.current)
			{
				return list.current;
			}
			return data;
		}

		/**
		 * Find point in the collection
		 * @param bookmark
		 * @param offset
		 *
		 */
		public function seek(bookmark:CursorBookmark, offset:int=0):void
		{
			list.seek(bookmark, offset);
		}

		/**
		 * get number in the dataSet
		 * @return
		 *
		 */
		public function get length():int
		{
			return list.source.length;
		}

		/**
		 * handles magic properties
		 * @param name
		 * @return
		 *
		 */
		override protected function overloadGetProperty(name:*):*
	    {
	    	if (current && current.hasOwnProperty(name))
	    	{
	    		return current[name];
	    	}
	    	else if (data && data.hasOwnProperty(name))
	    	{
	    		return data[name];
	    	}
	    	return null;
	    }
	}
}