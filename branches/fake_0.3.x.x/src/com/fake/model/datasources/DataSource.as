/* SVN FILE: $Id: DataSource.as 262 2009-06-16 18:09:41Z gwoo.cakephp $ */
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
 * @subpackage		com.fake.model.datasources
 * @since			2008-03-06
 * @version			$Revision: 262 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 01:09:41 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model.datasources
{
	import com.fake.utils.FakeEvent;
	import com.fake.utils.Inflector;
	
	import flash.events.EventDispatcher;
	
	import mx.managers.CursorManager;

	/**
	 * This class is a Singleton. contains netconnection, calls are stored
	 */
	public class DataSource extends EventDispatcher
	{
		/**
		 * We may want this later for authentication or some other
		 * datasource specific settings
		 *
		 */
		protected var _config:Object = {};

		/**
		* A queue is used to prevent calls from returning out of order.
		* Objects in the call queue contain the name of the service and
		* the arguments to be passed to the service
		*/
		protected var _callQueue:Array;

		/**
		 * Construcotor for base DataSource
		 * @param configuration
		 */
		public function DataSource(configuration:Object)
		{
			super();

			config = configuration;

			_callQueue = [];
		}

		/**
		 * Get current config
		 * @return
		 *
		 */
		public function get config():Object
		{
			return _config;
		}

		/**
		 * Set some config
		 * @return
		 *
		 */
		public function set config(data:Object):void
		{
			var dataSource:Object = Object(source);

			for(var prop:String in data)
			{
				_config[prop] = data[prop];
				if(dataSource.hasOwnProperty(prop))
				{
					dataSource[prop] = data[prop];
				}
			}
		}
		/**
		 * The service string and args object are wrapped into an object
		 *
		 * @param string className name of the model
		 * @param string method the action to be called
		 * @param args the arguments can be used to change the service
		 * @return string
		 */
		public function service(className:String, method:String, args:Object = null):String
		{
			return Inflector.pluralize(className) + "." + method;	
		}
		
		/**
		 * The service string and args object are wrapped into an object
		 * and pushed into the call queue. excuteCall is then invoked.
		 *
		 * @param service name of the service to be called
		 * @param args the arguments to be sent with the call
		 *
		 */
		public function call(correlationId:String, service:String, args:Object = null):void
		{
			_callQueue.push({correlationId: correlationId, service: service, args: args});

			if (!config.hasOwnProperty("showCursor") || (config.hasOwnProperty("showCursor") && config.showCursor === true)) {
				config.showCursor = true;
				CursorManager.setBusyCursor();
			}

			executeCall();
		}

		/**
		 * Return the AS class for this dataSource
		 * NetConnction for AMF, HTTPService, etc
		 * @return
		 *
		 */
		public function get source():*
		{
		}

		/**
		 * A call is made with the service and args pulled from the
		 * object at the top of the call queue. onSuccess and onFail
		 * are used in the responder.
		 */
		protected function executeCall():void
		{
		}

		/**
		 * A FakeEvent gets dispatched with the data parameter
		 * containing the result of the call. The type parameter
		 * is filled with the service string from the object at the
		 * top of the call queue. The object is then shifted off of
		 * the queue.
		 *
		 * The call queue is checked for any calls pending. If there
		 * are calls pending excecuteCall is called. It is called reDundAnt()
		 *
		 * @param result data object returned from the net call
		 */
		protected function onSuccess(result:Object):void
		{
			var type:String = shift().correlationId
			var event:FakeEvent = new FakeEvent(type, result);

			dispatchEvent(event);

			if(_callQueue.length > 0)
			{
				//executeCall();
			}

			if (config.showCursor === true) {
				CursorManager.removeBusyCursor();
			}
		}

		/**
		 * All fails go through onSuccess and return null
		 * to access the exact failure listen to events on the datasource
		 */
		protected function onFail(result:Object):void
		{
			onSuccess(null);
		}

		/**
		 * shifts and returnds current current call
		 */
		protected function shift():Object
		{
			var q:Object = _callQueue.shift();

			if (q != null) return q;

			return {service: "Fake", args: []};
		}

		/**
		 * Adds event handlers for all net related errors.
		 */
		protected function setupErrorHandling():void
		{
		}
	}
}