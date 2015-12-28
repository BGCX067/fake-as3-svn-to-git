package com.fake.view.helper
{
	import com.fake.controller.Action;
	import com.fake.controller.IController;
	import com.fake.view.helper.form.IField;
	
	public interface IForm
	{
		/*
		function set model(value:Model):void;
		
		function get model():Model;
		*/
		
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
		 * Assign an action for further use.
		 * 
		 * @param value action that will be used by the form
		 */
		function set action(value:Action):void;
		
		/**
		 * Recovers the action assigned
		 * 
		 * @return Action action used by this form
		 */
		function get action():Action;
		
		function set dataName(value:String):void;
		
		function get dataName():String;
		
		function set domain(value:String):void;
		
		function get domain():String;
		
		/**
		 * Register Field to be accessed later by the form.
		 * 
		 * @param field IField type 
		 */
		function register(field:IField):void;
		
		/**
		 * Resets every data entered by the user
		 */
		function reset():void;
		
		/**
		 * Submit data to the server
		 */
		function submit():void;
		
		/**
		 * Load initial form data
		 */
		function load():void;
		
		/**
		 * Gets form filled data
		 * 
		 * @return Object every useful data from the form
		 */
		function capture():Object;
	}
}