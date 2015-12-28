/* SVN FILE: $Id:FormAdapter.as 95 2008-04-21 23:34:12Z xpointsh $ */
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
 * @version			$Revision:95 $
 * @modifiedby		$LastChangedBy:xpointsh $
 * @lastmodified	$Date:2008-04-21 16:34:12 -0700 (Mon, 21 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.controller.adapters
{
	import com.fake.FakeObject;
	import com.fake.controller.IController;

	public class FormAdapter
	{
		protected var _controller:IController;
		
		public var prompt:Object = new Object();
		
		public function FormAdapter(value:IController)
		{
			_controller = value;
		}
		
		public function blackList(value:Object, list:Array):Boolean
		{
			if(list.indexOf(value) != -1)
				return true;
			else
				return false;
		}
		
		public function get controller():IController
		{
			return _controller;
		}
		
		public function set controller(value:IController):void
		{
			_controller = value;
		}
	}
}