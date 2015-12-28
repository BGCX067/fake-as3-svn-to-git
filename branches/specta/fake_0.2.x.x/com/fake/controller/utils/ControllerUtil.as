/* SVN FILE: $Id:ControllerUtil.as 95 2008-04-21 23:34:12Z xpointsh $ */
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
 * @subpackage		com.fake
 * @since			2008-03-06
 * @version			$Revision:95 $
 * @modifiedby		$LastChangedBy:xpointsh $
 * @lastmodified	$Date:2008-04-21 16:34:12 -0700 (Mon, 21 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.controller.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import mx.core.UIComponent;
	
	public class ControllerUtil
	{
		public function ControllerUtil()
		{
		}
		
		public static function findByType(types:Array, source:DisplayObjectContainer=null, results:Array=null):Array
		{
			return __findByType(types, source, results);
		}
		
		private static function __findByType(types:Array, source:DisplayObjectContainer, results:Array):Array
		{
			if(!results)
				results = [];
			
			for(var i:int=0; i<source.numChildren; i++)
			{
				var ui:DisplayObject = source.getChildAt(i);
				
				for each(var typeClass:Class in types)
				{
					if(ui is typeClass)
					{
						results.push(ui);
					}
				}
				
				if(ui is DisplayObjectContainer)
				{
					if(DisplayObjectContainer(ui).numChildren > 0)
						__findByType(types, DisplayObjectContainer(ui), results);
				}
			}
			
			return results;
		}
		
		public static function findByID(findID:String, source:DisplayObjectContainer=null):UIComponent
		{
			var results:Array = __findByID(findID, source, null);
			
			if(results.length > 0)
				return UIComponent(results[0]);
			else
				return null;
		}
		
		private static function __findByID(findID:String, source:DisplayObjectContainer, results:Array):Array
		{
			if(!results)
				results = [];
			
			for(var i:int=0; i<source.numChildren; i++)
			{
				var ui:DisplayObject = source.getChildAt(i);
				
				if(ui is UIComponent)
				{
					if(UIComponent(ui).id == findID)
						results.push(ui);
				}
				
				if(ui is DisplayObjectContainer)
				{
					if(DisplayObjectContainer(ui).numChildren > 0)
						__findByID(findID, DisplayObjectContainer(ui), results);
				}
			}
			
			return results;
		}
	}
}