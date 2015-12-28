/* SVN FILE: $Id: Model.as 267 2009-06-16 21:09:20Z gwoo.cakephp $ */
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
 * @version			$Revision: 267 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 04:09:20 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.FakeObject;
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.model.datasources.DataSource;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.DescribeUtil;
	import com.fake.utils.FakeCursor;
	import com.fake.utils.FakeEvent;

	import mx.controls.Alert;
	import mx.utils.UIDUtil;

	/**
	 * Acts as a bridge between the caller and the
	 * data source. It assigns the connection to the data source. The
	 * after filter gets called on the returned data object.
	 */
	public dynamic class Model extends FakeObject
	{
		/**
		* String representing the id of the connection from setup in the Environment
		*/
		[Transient] public var connection:String;

		/**
		* String representing the primary key
		*/
		[Transient] public var primaryKey:String;

		/**
		 * the list of multiple models
		 */
		[Transient] public var list:Array;

		/**
		 * the name of the ResultSet Class
		 */
		[Transient] protected var _resultSet:String;

		/**
		* Holds the callback listner function for all calls.
		* The objects are keyed by the name of the service call.
		* This means that one callback will be stored by name at a time.
		* Multiple calls to the same named service while pending
		* need to be handled in a custom manner.
		*/
		[Transient] protected var _listenerHash:Object;

		/**
		 * the cursor for making list work easier
		 */
		private var __cursor:FakeCursor;

		/**
		 * Constructor creates the listenerHash and sets the data source.
		 */
		public function Model()
		{
			super();

			_listenerHash = new Object();
			list = new Array();

			if (!primaryKey)
			{
				primaryKey = 'id';
			}
		}

		/**
		 * The call first stores the callback listener function.
		 *
		 * The data source then has an event listener attached to it.
		 * The type parameter of the addEventListner is the service parameter
		 * The listener parameter of the addEventListner is the onResult function
		 * of this class.
		 *
		 * The call function is called with the service and arg parameters given
		 * to it.
		 *
		 * @param service The name of the service call.
		 * Used as the key for the callback listener function
		 * @param listener The callback listener function.
		 * @param args The arguments passed to the service call.
		 */
		public function call(service:String, args:Object = null, listener:Function = null):void
		{
			var _ds:DataSource = ConnectionManager.instance.getDataSource(connection);

			if (_ds)
			{
				if (args is Function)
				{
					listener = args as Function;
				}

				var correlationId:String = UIDUtil.createUID();

				_listenerHash[correlationId] = listener;

				_ds.addEventListener(correlationId, onResult);

				_ds.call(correlationId, service, args);
			}
			else if (connection !== false)
			{
				Alert.show("The DataSource connection is not available. Provide a valid connection or set connection to false", "Model Error");
			}
		}

		/**
		 * Set some config on the datasource
		 * @return
		 *
		 */
		public function set config(data:Object):void
		{
			var _ds:DataSource = ConnectionManager.instance.getDataSource(connection);
			_ds.config = data;
		}

		/**
		 * The onResult function is what is given to the data source.
		 * The event data is run through the afterFilter then returned
		 * as the parameter of the callback function.
		 *
		 * @param event The type of the event is the service name and data the
		 * raw object(s) returned by the call.
		 */
		public function onResult(event:FakeEvent):void
		{
			var _ds:DataSource = ConnectionManager.instance.getDataSource(connection);
			_ds.removeEventListener(event.type, onResult);

			var resultSet:ResultSet = new ResultSet(event.data);

			if (this._resultSet) {
				var packages:Array = ConfigManager.instance.packages;
				for each(var _package:String in packages)
				{
					var ClassRef:Class = DescribeUtil.instance.definition(_package + ".model." + _resultSet);
					if (ClassRef)
					{
						resultSet = new ClassRef(event.data);
						break;
					}
				}
			}

			if (_listenerHash[event.type])
			{
				var listener:Function = _listenerHash[event.type];
				listener(resultSet);
			}
		}

		/**
		 * Returns a value object for the current model.
		 * @return Object
		 *
		 */
		public function get vo():Object
		{
			return DescribeUtil.instance.properties(this);
		}

		/**
		 * Converts vo to URL encoded string
		 * @return String
		 *
		 */
		public function get uv():String
		{
			var str:String = "";
			var value:Object = vo;

			for(var prop:String in value)
			{
				var po:Object = value[prop]

				if(po != null)
				{
					str += prop +"="+ escape(po.toString()) +"&";
				}
			}
			str = str.substring(0,str.length-1);

			return str;
		}

		/**
		 * Assigns values to this object from the parameter object
		 *
		 * @param value
		 *
		 */
		public function set ro(value:Object):void
		{
			var objThis:Object = Object(this);

			for(var prop:String in value)
			{
				if(objThis.hasOwnProperty(prop))
				{
					objThis[prop] = value[prop];
				}
			}
		}

		/**
		 * Get a instance of the model specified by className
		 * @param className
		 * @return
		 *
		 */
		public static function construct(name:String, vo:Object = null):Model
		{
			var model:Model;

			for each(var _package:String in ConfigManager.instance.packages)
			{
				var ClassRef:Class = DescribeUtil.instance.definition(_package + ".model." + name);
				if (ClassRef)
				{
					model = new ClassRef();
					break;
				}
			}

			if (model)
			{
				if(vo)
				{
					model.ro = vo;
				}
				return model;
			}

			return null;
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
		 * fill the list and current model vo
		 * @param array
		 *
		 */
		public function fill(array:Array):void
		{
			list = array;
			if (!vo[primaryKey] && array.length > 0)
			{
				ro = array[0];
			}
		}

		/**
		 * fill the list and current model vo
		 * @param array
		 *
		 */
		public function moveNext():Boolean
		{
			var c:Boolean = cursor.moveNext();
			ro = cursor.current;
			return c;
		}

		/**
		 * handles magic properties
		 * @param name
		 * @return
		 *
		 */
		override protected function overloadGetProperty(name:*):*
	    {
	    	if (cursor.hasOwnProperty(name))
	    	{
	    		return cursor[name];
	    	}
	    	return null;
	    }

		/**
		 * Handles method calls to the datasource
		 *
		 * @param method
		 * @param args
		 */
		protected override function overload(method:*, args:Array):*
		{
			if (cursor.hasOwnProperty(method))
	    	{
	    		return cursor[method].apply(method, args);
	    	}

			var listener:Function = args.filter(function (element:*, index:int, arr:Array):Boolean {
				if (element is Function) {
					delete arr[index];
					return true;
				}
				return false;
			}).shift() as Function;

			args.sort();

			var service:String = _service(method, args);
			if (service)
			{
				call(service, args.shift(), listener);
			}
		}

		/**
		 * Allows simple overriding to create service calls
		 * @param method
		 * @return
		 *
		 */
		protected function _service(method:String, args:Object = null):String
		{
			var _ds:DataSource = ConnectionManager.instance.getDataSource(connection);
			return _ds.service(className, method, args);
		}
	}
}