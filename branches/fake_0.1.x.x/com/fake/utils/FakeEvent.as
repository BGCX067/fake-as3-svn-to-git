/* SVN FILE: $Id: FakeEvent.as 111 2008-05-05 19:21:34Z xpointsh $ */
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
 * @version			$Revision: 111 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-05-06 02:21:34 +0700 (Tue, 06 May 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	// Big Ups to Jacob Bullock aka Jacobot

	import flash.events.Event;

	public class FakeEvent extends Event
	{
		public var data:Object;
		public var parent:Object;

		public function FakeEvent(sType:String, data:Object = null, parent:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(sType, bubbles, cancelable);

			this.data = data;
		}
	}
}