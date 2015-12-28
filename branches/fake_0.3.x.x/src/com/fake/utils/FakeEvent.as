/* SVN FILE: $Id: FakeEvent.as 218 2008-10-06 13:26:37Z xpointsh $ */
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
 * @version			$Revision: 218 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-10-06 20:26:37 +0700 (Mon, 06 Oct 2008) $
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

		public function FakeEvent(sType:String = "", data:Object = null, parent:Object = null, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(sType, bubbles, cancelable);

			this.data = data;
		}
	}
}