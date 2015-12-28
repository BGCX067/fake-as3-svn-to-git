package com.fake.utils
{
	import com.fake.view.helper.form.IField;
	
	/**
	 * FieldUtil
	 * 
	 * Verify Naming Conventions for Field.dataField 
	 * 
	 */	
	public class FieldUtil
	{
		/**
		 * Single Field verification
		 * Last part of dataField starts with lowercase (CakePHP's convention)
		 * 
		 * @param field
		 * @return 
		 * 
		 */
		public static function isSingleField(field:IField):Boolean
		{
			var steps:Array = field.dataField.split('.');
			var lastStep:String = steps[steps.length-1];
			if(lastStep.match('^[a-z]{1}')){
				return true;
			}
			return false;
		}
		
		/**
		 * HABTM Relation verification
		 * Starts with uppercase and is in the singular (CakePHP's convention)
		 * 
		 * @param field
		 * @return 
		 * 
		 */
		public static function isHABTMRelation(field:IField):Boolean
		{
			if(field.dataField.match('^[A-Z]{1}') && !field.dataField.match('[.]')){
				if(field.dataField == Inflector.singularize(field.dataField)){
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Multiple Records verification
		 * Starts with uppercase and is in the plural
		 * 
		 * @param field
		 * @return 
		 * 
		 */
		public static function isMultipleRecords(field:IField):Boolean
		{
			if(field.dataField.match('^[A-Z]{1}') && !field.dataField.match('[.]')){
				if(field.dataField == Inflector.pluralize(field.dataField)){
					return true;
				}
			}
			return false;
		}
		
	}
}