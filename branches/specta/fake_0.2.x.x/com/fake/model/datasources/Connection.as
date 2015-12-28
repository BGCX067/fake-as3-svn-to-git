package com.fake.model.datasources
{
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	
	import mx.controls.Alert;
	import mx.managers.CursorManager;

	public class Connection extends NetConnection
	{
		public function Connection()
		{
			setupErrorHandling();
			/*
			addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			*/
			
			super();
		}
		
		protected function onFail(message:String):void
		{
			
		}
		
		/**
		 * Handles IO errors
		 * @param event IOErrorEvent
		 */
		protected function onNetStatus(event:NetStatusEvent):void
		{
			Alert.show("Sua conexao foi perdida. Por favor conecte-se ao sistema novamente");
			CursorManager.removeBusyCursor();
			//CursorManager.hideCursor();
			onFail(null);
		}
		/**
		 * Handles IO errors
		 * @param event IOErrorEvent
		 */
		protected function onIOError(event:IOErrorEvent):void
		{
			Alert.show("(3)Sua conexao foi perdida. Por favor conecte-se ao sistema novamente");
			CursorManager.removeBusyCursor();
			onFail(null);
		}

		/**
		 * Handles Async errors
		 * @param event AsyncErrorEvent
		 */
		protected function onAsyncError(event:AsyncErrorEvent):void
		{
			Alert.show("(4)Sua conexao foi perdida. Por favor conecte-se ao sistema novamente");
			CursorManager.removeBusyCursor();
			onFail(null);
		}

		/**
		 * Handles Security errors
		 * @param event SecurityErrorEvent
		 */
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			Alert.show("(5)Sua conexao foi perdida. Por favor conecte-se ao sistema novamente");
			CursorManager.removeBusyCursor();
			onFail(null);
		}

		/**
		 * Adds event handlers for all net related errors.
		 */
		protected function setupErrorHandling():void
		{
			addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncError);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
	}
}