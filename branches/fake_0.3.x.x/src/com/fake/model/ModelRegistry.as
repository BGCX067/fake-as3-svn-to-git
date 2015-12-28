/* SVN FILE: $Id: ModelRegistry.as 191 2008-09-16 15:09:38Z gwoo.cakephp $ */
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
 * @subpackage		com.fake.model
 * @since			2008-03-06
 * @version			$Revision: 191 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-16 22:09:38 +0700 (Tue, 16 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.utils.Inflector;

	/**
	 * Registry for storing and retrieving model instances
	 *
	 *
	 */
	public class ModelRegistry
	{
		/**
		 * holds current Models
		 */
		private static var __modelHash:Object = {};

	    /**
	     * Returns a new instance of the model
	     * @param name
	     * @param value
	     * @return Model instance
	     *
	     */
	    public static function fresh(name:String, value:Object = null):*
	    {
	    	var model:Model = Model.construct(name, value);
	    	return model;
	    }

	    /**
	     * Retrieves a Model from the registry
	     * @param name
	     * @param value
	     * @return Model instance
	     *
	     */
	    public static function fetch(name:String, value:Object = null):*
	    {
	    	var className:String = Inflector.camelize(name);
	    	if(__modelHash[className] == null)
			{
				__modelHash[className] = Model.construct(className, value);
			} 
			else if (value)
			{
				ModelRegistry.update(name, value);
			}
			var model:Model = __modelHash[className];
			return model;
	    }

	    /**
	     * Updates a Model
	     * @param name
	     * @param value
	     * @return Model instance
	     *
	     */
	    public static function update(name:String, value:Object = null):*
	    {
	    	var model:Model = ModelRegistry.fetch(name);
	    	model.ro = value;
	    	return model;
	    }

		/**
	     * Adds a Model
	     * @param model
	     *
	     */
	    public static function add(model:Model):void
	    {
	    	var className:String = model.className;
	    	if(__modelHash[className])
	    	{
	    		__modelHash[className] = model;
	    	}
	    }
	    /**
	     * Removes a Model
	     * @param name
	     *
	     */
	    public static function remove(name:String):void
	    {
	    	var className:String = Inflector.camelize(name);
	    	if(__modelHash[className])
	    	{
	    		delete __modelHash[className];
	    	}
	    }

	    /**
	     * Clears all Models from the registry
	     *
	     */
	    public static function flush():void
	    {
	    	__modelHash = {};
	    }
	}
}