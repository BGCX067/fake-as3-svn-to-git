/* SVN FILE: $Id: AmfDataSource.as 134 2008-06-23 09:31:23Z gwoo.cakephp $ */
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
 * @version			$Revision: 134 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-23 16:31:23 +0700 (Mon, 23 Jun 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model.datasources
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;

	/**
	 * AmfDataSource to connection to AMF endpoints
	 *
	 */
	public class AmfDataSource extends DataSource
	{
		/**
		 * Holds instance of the net connecition
		 */
		private var __netConn:NetConnection;

		/**
		 * Constructor for AmfDatSource
		 * @param configuration Object
		 */
		public function AmfDataSource(configuration:Object)
		{
			super(configuration);

			__netConn.connect(config.endpoint);

			if (!config.hasOwnProperty("debug") || (config.hasOwnProperty("debug") && config.debug !== true))
			{
				setupErrorHandling();
			}
		}

		/**
		 * Return NetConnection
		 * @return
		 *
		 */
		public override function get source():*
		{
			if (!__netConn) {
				__netConn = new NetConnection();
			}
			return __netConn;
		}
		/**
		 * A call is made with the service and args pulled from the
		 * object at the top of the call queue. onSuccess and onFail
		 * are used in the responder.
		 */
		protected override function executeCall():void
		{
			var responder:Responder = new Responder(onSuccess, onFail);
			var callObj:Object = _callQueue[_callQueue.length-1];

			__netConn.call(callObj.service, responder, callObj.args);
		}

		/**
		 * Handles IO errors
		 * @param event IOErrorEvent
		 */
		protected function onNetStatus(event:NetStatusEvent):void
		{
			onFail(null);
		}
		/**
		 * Handles IO errors
		 * @param event IOErrorEvent
		 */
		protected function onIOError(event:IOErrorEvent):void
		{
			onFail(null);
		}

		/**
		 * Handles Async errors
		 * @param event AsyncErrorEvent
		 */
		protected function onAsyncError(event:AsyncErrorEvent):void
		{
			onFail(null);
		}

		/**
		 * Handles Security errors
		 * @param event SecurityErrorEvent
		 */
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			onFail(null);
		}

		/**
		 * Adds event handlers for all net related errors.
		 */
		protected override function setupErrorHandling():void
		{
			__netConn.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			__netConn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			__netConn.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			__netConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
	}
}