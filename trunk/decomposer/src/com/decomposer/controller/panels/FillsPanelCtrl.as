/* SVN FILE: $Id: FillsPanelCtrl.as 19 2008-09-12 17:29:04Z xpoint%playerb.net $ */
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
 * @version			$Revision: 19 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-12 10:29:04 -0700 (Fri, 12 Sep 2008) $
 * @license			Commercial
 */
package com.DeComposer.controller.panels
{
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.paint.GradientStop;
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class FillsPanelCtrl extends Canvas implements IController
	{
		public function FillsPanelCtrl()
		{
			super();

			ctrl.register(this, FillsPanelCtrl);

			addEventListener(FlexEvent.INITIALIZE, initalize);
		}

		public function initalize(event:FlexEvent):void
		{
			this.horizontalScrollPolicy = "false";
			this.verticalScrollPolicy = "false";
		}
		
		public static function createGradientFill(clazz:Class, colors:Array,  alphas:Array, ratios:Array, angle:int = 0):IGraphicsFill
		{
			var fill:Object = new clazz();
			
			fill.angle = angle;
			
			for(var i:int = 0; i < colors.length; i++)
			{
				var stop:GradientStop = new GradientStop(colors[i],alphas[i],ratios[i]);
				fill.gradientStops.push(stop);
			}
			
			return fill as IGraphicsFill;
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
				case "Bitmap":

				break;
				case "Complex":

				break;
			}
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}

		public static function get instance():FillsPanelCtrl
		{
			return CtrlRegistry.instance.getCtrl(FillsPanelCtrl) as FillsPanelCtrl;
		}
	}
}