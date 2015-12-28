/* SVN FILE: $Id: LoaderDataSource.as 135 2008-06-23 18:52:28Z gwoo.cakephp $ */
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
 * @version			$Revision: 135 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-24 01:52:28 +0700 (Tue, 24 Jun 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model.datasources
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class LoaderDataSource extends DataSource
	{
		private var __request:URLRequest
		private var __loader:URLLoader

		public function LoaderDataSource(configuration:Object)
		{
			super(configuration);

			__loader.addEventListener(Event.COMPLETE, onResult);

			if (!config.hasOwnProperty("debug") || (config.hasOwnProperty("debug") && config.debug !== true))
			{
				setupErrorHandling();
			}
		}

		/**
		 * Set some config
		 * @return
		 *
		 */
		override public function set config(data:Object):void
		{
			super.config = data;

			if (!__loader) {
				__loader = new URLLoader();
			}

			if (data.hasOwnProperty("dataFormat"))
			{
				__loader.dataFormat = data.dataFormat;
			}
		}
		/**
		 * Return UrlRequest
		 * @return
		 *
		 */
		override public function get source():*
		{
			if (!__request) {
				__request = new URLRequest();
			}
			return __request;
		}
		/**
		 * A call is made with the service and args pulled from the
		 * object at the top of the call queue. onSuccess and onFail
		 * are used in the responder.
		 */
		protected override function executeCall():void
		{
			var callObj:Object = _callQueue[_callQueue.length-1];

			__request.url = config.endpoint + callObj.service;

			if (callObj.args is String)
			{
				__request.data = callObj.args;
			}
			else
			{
				__request.data = new URLVariables();
				for (var prop:* in callObj.args)
				{
					__request.data[prop] = callObj.args[prop];
				}
			}

			__loader.load(__request);
		}

		/**
		 * Handle Success
		 * @param event Event
		 */
		protected function onResult(event:Event):void
		{
			onSuccess(event.target.data);
		}

		/**
		 * Handle Fault
		 * @param event Event
		 */
		protected function onFault(event:Event):void
		{
			onFail(null);
		}

		/**
		 * Adds event handlers for all net related errors.
		 */
		protected override function setupErrorHandling():void
		{
			__loader.addEventListener(IOErrorEvent.IO_ERROR, onFault);
		}
	}
}