/* SVN FILE: $Id: GeometryPanelCtrl.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
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
	import com.DeComposer.controller.pad.MainPadCtrl;
	import com.degrafa.geometry.*;
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;
	
	import mx.containers.Canvas;

	public class GeometryPanelCtrl extends Canvas implements IController
	{
		public function GeometryPanelCtrl()
		{
			super();
			ctrl.register(this, GeometryPanelCtrl);
		}

		public function add(type:String):void
		{
			switch(type)
			{
				case 'Circle':
					MainPadCtrl.instance.addUnit(new Circle(0,0,50));
				break;
				case 'Ellipse':
					MainPadCtrl.instance.addUnit(new Ellipse(0,0,50,25));
				break;
				default:
				case 'Rectangle':
					MainPadCtrl.instance.addUnit(new RegularRectangle(0,0,50,25));
				break;
				case 'RoundedRectangle':
					MainPadCtrl.instance.addUnit(new RoundedRectangle(0,0,50,25,8));
				break;
				case 'RoundedComplexRectangle':
					MainPadCtrl.instance.addUnit(new RoundedRectangleComplex(0,0,50,25,5,7,8,10));
				break;
				case 'EllipticalArc':
					MainPadCtrl.instance.addUnit(new EllipticalArc(0,0,50,25,0,180,'pie'));
				break;
			}
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}

		public static function get instance():GeometryPanelCtrl
		{
			return CtrlRegistry.instance.getCtrl(GeometryPanelCtrl) as GeometryPanelCtrl;
		}
	}
}