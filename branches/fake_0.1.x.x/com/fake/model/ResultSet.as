/* SVN FILE: $Id: ResultSet.as 221 2008-10-08 20:58:14Z gwoo.cakephp $ */
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
 * @version			$Revision: 221 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-10-09 03:58:14 +0700 (Thu, 09 Oct 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.FakeObject;
	import com.fake.utils.FakeCursor;
	import com.fake.utils.Inflector;

	public dynamic class ResultSet extends FakeObject
	{
		/**
		* Contains extra result objects not specifc to the dataSet
		*/
		public var data:Object = {};

		/**
		 * Contains extra result arrays not specifc to the dataSet
		 */
		public var list:Array = [];

		/**
		 * holds all the model objects
		 */
		public var dataSet:DataSet;

		/**
		 * private cursor
		 */
		private var __cursor:FakeCursor;

		public function ResultSet(source:Object)
		{
			if (source == null)
			{
				data = null;
			}
			else if (source is XML || source is String)
			{
				data = source;
			}
			else
			{
				format(source);
			}
		}

		/**
		 * This method goes through all of the results from the service call
		 * Uses reflection to determine what class that needs to be cast.
		 * results not belonging in the dataSet are placed in params
		 *
		 * @param source The objects that are taken from the service call
		 */
		public function format(source:Object):void
		{
			dataSet = new DataSet(_format(source));
		}

		/**
		 * Recursive function to extract values from source object
		 * results not found in the dataSet are placed in data
		 * @param source
		 *
		 */
		protected function _format(source:Object, prevKey:* = null):*
		{
			var obj:Object = {};
			var array:Array = [];
			for (var key:* in source)
			{
				var value:* = source[key];

				if (value is Boolean || value is String)
				{
					data[key] = value;
				}
				else if (value is Array && value.length > 0)
				{
					if (prevKey == null)
					{
						var newKey:String = Inflector.singularize(key);
						var model:Model = Model.construct(newKey);
						if (model)
						{
							model.fill(_format(value, newKey));
							obj[newKey] = model;
						}
						else
						{
							array = _format(value, key);
						}
					}
					else
					{
						model = Model.construct(key);
						if (model)
						{
							model.fill(_format(value, key));
							obj[key] = model;
						}
						else
						{
							obj[key] = _format(value, key);
						}
					}
				}
				else if (key is Number)
				{
					if (prevKey)
					{
						newKey = Inflector.singularize(prevKey);
					}
					if (value.hasOwnProperty(newKey))
					{
						if (newKey === prevKey)
						{
							model = Model.construct(newKey, value[newKey]);
							if (model)
							{
								array.push(model);
							}
							else
							{
								list.push(value);
							}
						}
						else
						{
							array.push(_format(value, newKey));
						}
					}
					else
					{
						model = Model.construct(newKey, value);
						if (model)
						{
							array.push(model);
						}
						else
						{
							list.push(value);
						}
					}
				}
				else
				{
					if (value && value.hasOwnProperty(key) && key !== prevKey)
					{
						obj = _format(value, key);
					}
					else
					{
						model = Model.construct(key, value);
						if (model)
						{
							obj[key] = model;
						}
						else
						{
							data[key] = value;
						}
					}
				}
			}
			if (array.length > 0)
			{
				return array;
			}
			return obj;
		}

		/**
		 * get a nice and tidy cursor
		 * @return
		 *
		 */
		public function get cursor():FakeCursor
		{
			if (!__cursor)
			{
				__cursor = new FakeCursor(list);
			}
			return __cursor;
		}

		/**
		 * handles magic properties
		 * @param name
		 * @return
		 *
		 */
		override protected function overloadGetProperty(name:*):*
	    {
	    	if (dataSet.current.hasOwnProperty(name))
	    	{
	    		return dataSet.current[name];
	    	}
	    	else if (data.hasOwnProperty(name))
	    	{
	    		return data[name];
	    	}
	    	else if (cursor.hasOwnProperty(name))
	    	{
	    		return cursor[name];
	    	}
	    	return null;
	    }

	   	/**
		 * Handles magic methods on the list
		 *
		 * @param method
		 * @param args
		 */
		protected override function overload(method:*, arg:Array):*
		{
			if (dataSet.hasOwnProperty(method))
	    	{
	    		return dataSet[method].apply(method, arg);
	    	}
	    	else if (cursor.hasOwnProperty(method))
	    	{
	    		return cursor[method].apply(method, arg);
	    	}
	    	return null;
		}

	}
}