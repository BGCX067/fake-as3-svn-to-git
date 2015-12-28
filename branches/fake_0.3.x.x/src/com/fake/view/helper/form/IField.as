package com.fake.view.helper.form
{
	import com.fake.view.helper.IForm;
	
	public interface IField
	{
		/**
		 * Associated form's instance for further use.
		 * 
		 * @param value form
		 */
		function set form(value:IForm):void;
		
		/**
		 * Recovers the form instance
		 * 
		 * @return IForm form that uses this field
		 */
		function get form():IForm;
		
		/**
		 * Sets dataField name
		 * 
		 * @param value fied name
		 */
		function set dataField(value:String):void;
		
		/**
		 * Gets field name
		 * 
		 * @return String field name 
		 */
		function get dataField():String;
		
		/**
		 * Sets default value
		 * 
		 * @param value default value
		 */
		function set defaultValue(value:String):void;
		
		/**
		 * Gets default value
		 * 
		 * @return String default value
		 */
		function get defaultValue():String;
		
		/**
		 * If true, specifies that a missing or empty value causes a validation error.  
		 * 
		 * @param value
		 */
		function set required(value:Boolean):void;

		/**
		 * Check if the field is required
		 * 
		 * @return Boolean
		 */
		function get required():Boolean;

		/**
		 * Displays error message
		 * 
		 * @param value message
		 */
		function set errorString(value:String):void;
		
		/**
		 * Access form and load field's data 
		 */
		function load():void;
		
		/**
		 * Default field validation
		 * 
		 * @return String error message 
		 */
		function validate():String;
		
		/**
		 * Extracts field's data
		 * 
		 * @return * data
		 */
		function capture():*;
		
		/**
		 * Reset field 
		 */
		function reset():void;
	}
}