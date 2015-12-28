/* SVN FILE: $Id: ModelForResultSet.as 267 2009-06-16 21:09:20Z gwoo.cakephp $ */
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
 * @version			$Revision: 267 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 04:09:20 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.utils.FakeEvent;

	import mx.utils.UIDUtil;

	public class ModelForResultSet extends TestModel
	{
		public function ModelForResultSet()
		{
			super();
		}

		override public function call(service:String, args:Object=null, listener:Function=null):void
		{
			if (args is Function)
			{
				listener = args as Function;
			}
			var correlationId:String = UIDUtil.createUID();

			_listenerHash[service] = listener;

			var testObject:Object = {service: service, listener: listener, args: args};
			var event:FakeEvent = new FakeEvent(service);
			event.data = testObject;
			onResult(event);
		}
	}
}