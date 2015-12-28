/* SVN FILE: $Id: ViewCtrl.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
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
 * @link			http://decomposr.com
 * @package			DeComposer
 * @subpackage		com.DeComposer.controller.code
 * @since			2008-03-06
 * @version			$Revision: 18 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-10 09:34:34 -0700 (Wed, 10 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.DeComposer.controller.code
{
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;

	import mx.containers.Canvas;

	public class ViewCtrl extends Canvas implements IController
	{
		public function ViewCtrl()
		{
			super();
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}
	}
}