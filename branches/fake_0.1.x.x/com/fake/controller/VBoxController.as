/* SVN FILE: $Id: VBoxController.as 144 2008-08-26 03:27:49Z xpointsh $ */
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
 * @version			$Revision: 144 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-08-26 10:27:49 +0700 (Tue, 26 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.controller
{
	import flash.display.DisplayObjectContainer;
	
	import mx.containers.VBox;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import com.fake.controller.utils.ControllerUtil;

	public class VBoxController extends VBox implements IController
	{
		public function VBoxController()
		{
			super();
			
			addEventListener(FlexEvent.INITIALIZE, initalize);
		}
		
		public function initalize(event:FlexEvent):void
		{
			this.horizontalScrollPolicy = "false";
			this.verticalScrollPolicy = "false";
		}
		
		public function get component():UIComponent {
			return this;
		}
		
		public function get ctrl():Controller {
			return Controller.instance;
		}
	}
}