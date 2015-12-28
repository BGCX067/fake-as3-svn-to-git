package com.fake.controller
{
	public class Action
	{
		/**
		 * 
		 */
		public var name:String;
		
		/**
		 * 
		 */
		public var params:Array;
		
		/**
		 * 
		 */
		public var data:*;
		
		/**
		 * 
		 */
		//public var url:String;
		
		/**
		 * 
		 */
		public var requestHandler:Function;
		
		/**
		 * 
		 */
		public var resultHandler:Function;
		
		public function Action(action:String=null,handler:Function=null)
		{
			name = action;
			resultHandler = handler;
			
			params = new Array;
		}

	}
}