/* SVN FILE: $Id: HttpDataSource.as 262 2009-06-16 18:09:41Z gwoo.cakephp $ */
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
	import com.fake.utils.Inflector;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class HttpDataSource extends DataSource
	{
		private var __httpService:HTTPService

		public function HttpDataSource(configuration:Object)
		{
			super(configuration);

			__httpService.addEventListener(ResultEvent.RESULT, onResult);

			if (!config.hasOwnProperty("debug") || (config.hasOwnProperty("debug") && config.debug !== true))
			{
				setupErrorHandling();
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
		override public function service(className:String, method:String, args:Object = null):String
		{
			return Inflector.pluralize(Inflector.underscore(className)) + "/" + Inflector.underscore(method);	
		}
		
		/**
		 * Return HTTPService
		 * @return
		 *
		 */
		public override function get source():*
		{
			if (!__httpService) {
				__httpService = new HTTPService();
			}
			return __httpService;
		}
		/**
		 * A call is made with the service and args pulled from the
		 * object at the top of the call queue. onSuccess and onFail
		 * are used in the responder.
		 */
		protected override function executeCall():void
		{
			var callObj:Object = _callQueue[_callQueue.length-1];

			__httpService.url = config.endpoint + callObj.service;
			__httpService.send(callObj.args);
		}

		/**
		 * Handle Success
		 * @param event ResultEvent
		 */
		protected function onResult(event:ResultEvent):void
		{
			onSuccess(event.result);
		}

		/**
		 * Handle Fault
		 * @param event FaultEvent
		 */
		protected function onFault(event:FaultEvent):void
		{
			onFail(null);
		}

		/**
		 * Adds event handlers for all net related errors.
		 */
		protected override function setupErrorHandling():void
		{
			__httpService.addEventListener(FaultEvent.FAULT, onFault);
		}
	}
}