/* SVN FILE: $Id: TestModel.as 149 2008-08-27 21:08:14Z gwoo.cakephp $ */
/**
 * Description
 *
 * Fake Tests
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake-tests
 * @subpackage		com.app.model
 * @since			2008-03-06
 * @version			$Revision: 149 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-28 04:08:14 +0700 (Thu, 28 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.model.Model;

	public class TestModel extends Model
	{
		public function TestModel()
		{
			super();
		}

		override public function call(service:String, args:Object=null, listener:Function=null):void
		{
			if (args is Function)
			{
				listener = args as Function;
			}
			var testObject:Object = {service: service, listener: listener, args: args};
			listener(testObject);
		}
	}
}