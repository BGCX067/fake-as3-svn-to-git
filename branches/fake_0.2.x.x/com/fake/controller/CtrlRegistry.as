/* SVN FILE: $Id: CtrlRegistry.as 196 2008-09-16 20:40:41Z xpointsh $ */
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
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 196 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-17 03:40:41 +0700 (Wed, 17 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.controller
{
	import flash.utils.getQualifiedClassName;
	
	public class CtrlRegistry
	{
		private static var __instance:CtrlRegistry = new CtrlRegistry();
		
		public var ctrlMap:Object = new Object();
		
		public function CtrlRegistry()
		{
		}
		
		/**
		 * Takes an instance of a Controller and sav
		 */		
		public function register(ctrl:IController, cls:Class):void
		{
			
			ctrlMap[getQualifiedClassName(cls)] = ctrl;
		}
		
		public function getCtrl(cls:Class):IController
		{
			return ctrlMap[getQualifiedClassName(cls)]; 
		}
		
		public static function get instance():CtrlRegistry {
			return __instance;
		}
	}
}