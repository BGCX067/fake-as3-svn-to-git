package com.fake.controller.component
{
	import com.fake.controller.Action;
	import com.fake.controller.IController;
	import com.fake.model.ResultSet;
	
	public interface IComponent
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
		
		/**
		 * The initialize method is called before the controller's beforeFilter method.
		 * 
		 * @param action action details
		 */
		function initialize(action:Action):void;
		
		/**
		 * The startup method is called after the controller's beforeFilter method but before the controller executes the current action handler.
		 * 
		 * @param action action details
		 */
		function startup(action:Action):void;
		
		/**
		 * The beforeRender method is called after the controller's beforeRender method but before the controller's renders views and layout.
		 * 
		 * @param action action details
		 * @param result formatted result returned from server
		 */
		function beforeRender(action:Action,result:ResultSet):void;
		
		/**
		 * The shutdown method is called before output is sent to browser.
		 * 
		 * @param action action details
		 * @param result formatted result returned from server
		 */
		function shutdown(action:Action,result:ResultSet):void;
	}
}