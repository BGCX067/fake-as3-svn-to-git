/* SVN FILE: $Id: StrokePanelCtrl.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
/**
 * Description
 *
 * DeComposer
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Commercial License
 * Redistributions of files prohibited
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @package			DeComposer
 * @subpackage		com.DeComposer.controller.panels
 * @since			2008-03-06
 * @version			$Revision: 18 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-10 09:34:34 -0700 (Wed, 10 Sep 2008) $
 * @license			Commercial
 */
package com.DeComposer.controller.panels
{
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class StrokePanelCtrl extends Canvas implements IController
	{
		public function StrokePanelCtrl()
		{
			super();

			ctrl.register(this, StrokePanelCtrl);

			addEventListener(FlexEvent.INITIALIZE, initalize);
		}

		public function initalize(event:FlexEvent):void
		{
			this.horizontalScrollPolicy = "false";
			this.verticalScrollPolicy = "false";
		}

		public function add(type:String):void
		{
			switch(type)
			{
				default:
				case "Solid":

				break;
				case "RadialGradient":

				break;
				case "LinearGradient":

				break;
			}
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}

		public static function get instance():StrokePanelCtrl
		{
			return CtrlRegistry.instance.getCtrl(StrokePanelCtrl) as StrokePanelCtrl;
		}
	}
}