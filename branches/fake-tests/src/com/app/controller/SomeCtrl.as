/* SVN FILE: $Id: SomeCtrl.as 100 2008-04-23 23:16:49Z gwoo.cakephp $ */
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
 * @subpackage		fake-tests.examples.controller
 * @since			2008-03-06
 * @version			$Revision: 100 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-24 06:16:49 +0700 (Thu, 24 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.controller
{
	import com.fake.utils.FakeEvent;

	import mx.containers.Canvas;

	public class SomeCtrl extends Canvas
	{
		public var testParams:Object;

		public function SomeCtrl()
		{
			super();
		}

		public function list(event:FakeEvent):void
		{
			testParams = event.data;
		}

		public function submit():void
		{

		}
	}
}