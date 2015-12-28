package com.fake.view.helper
{
	import com.fake.controller.IController;
	
	public interface IHelper
	{
		/**
		 * Associated controller's instance for further use.
		 * 
		 * @param value controller that will be using the component
		 */
		function set controller(value:IController):void;
		
		/**
		 * Recovers the controller instance
		 * 
		 * @return IController controller that uses this component
		 */
		function get controller():IController;
	}
}