/* SVN FILE: $Id: ModelRegistry.as 157 2008-09-04 23:20:02Z gwoo.cakephp $ */
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
 * @version			$Revision: 157 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-09-05 06:20:02 +0700 (Fri, 05 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model
{
	import com.fake.FakeObject;
	import com.fake.utils.Inflector;
	
	public dynamic class ModelRegistry extends FakeObject
	{
		protected var __modelHash:Object = {};
		
		override protected function overloadGetProperty(name:*):*
		{
			var cName:String = Inflector.camelize(name);
			
			if(__modelHash[cName] == null)
			{
				__modelHash[cName] = Model.construct(cName);
			}
				
			return __modelHash[cName];
		}
		
		override protected function overloadSetProperty(name:*, value:*):void
	    {
	    	var cName:String = Inflector.camelize(cName);
	    	
	    	__modelHash[cName] = value;
	    }
	}
}