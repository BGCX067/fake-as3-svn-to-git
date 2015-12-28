/* SVN FILE: $Id: AppCtrl.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
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
 * @subpackage		com.DeComposer.controller
 * @since			2008-03-06
 * @version			$Revision: 18 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-10 09:34:34 -0700 (Wed, 10 Sep 2008) $
 * @license			Commercial
 */
package com.DeComposer.controller
{
	import com.DeComposer.model.FileMO;
	import com.DeComposer.utils.GeoUnit;
	import com.DeComposer.utils.Parser;
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Geometry;
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.ObjectMap;
	
	import mx.collections.ArrayCollection;
	import mx.core.WindowedApplication;

	public class AppCtrl extends WindowedApplication implements IController
	{
		public var selectedFillKey:String = "lightblue";
		public var selectedStrokeKey:String = "black";

		[Bindable] public var selectedGeometry:ArrayCollection = new ArrayCollection();

		public function AppCtrl()
		{
			super();

			ctrl.register(this, AppCtrl);
		}

		public function addUnit(geo:Geometry):void
		{
			addChild(new GeoUnit(geo, selectedFill, selectedStroke))
		}

		public function renderAll():String
		{
			var output:String = "";

			// render fills
			for(var fillId:String in fillMap)
			{
				output += Parser.instance.renderMXML(fillMap[fillId]) + "\n";
			}
			// render strokes
			for(var strokeId:String in strokeMap)
			{
				output += Parser.instance.renderMXML(strokeMap[strokeId]) + "\n";
			}
			// render geometry
			for each(var gUnit:GeoUnit in selectedGeometry)
			{
				output += gUnit.toMXML() + "\n";
			}

			new FileMO("assets/test.txt",output);
			
			return output;
		}

		public function rand():void
		{
			//geometryMap["Circle334"].fill.color = "red";

			Object(selectedFill).color = uint(10000000*Math.random());
			Dispatcher.run("REFRESH");
		}

		public function get geometryMap():Object {
			return Parser.instance.geometryMap;
		}

		public function get fillMap():Object {
			return Parser.instance.fillMap;
		}

		public function get strokeMap():Object {
			return Parser.instance.strokeMap;
		}

		public function get selectedFill():IGraphicsFill {
			return fillMap[selectedFillKey] as IGraphicsFill;
		}

		public function get selectedStroke():IGraphicsStroke {
			return strokeMap[selectedStrokeKey] as IGraphicsStroke;
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}
		
		public function get objectMap():ObjectMap {
			return ObjectMap.instance;
		}

		public static function get instance():AppCtrl
		{
			return CtrlRegistry.instance.getCtrl(AppCtrl) as AppCtrl;
		}
	}
}