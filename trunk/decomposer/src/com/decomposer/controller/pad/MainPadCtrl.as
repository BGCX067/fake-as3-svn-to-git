/* SVN FILE: $Id: MainPadCtrl.as 28 2008-10-06 13:29:15Z xpoint%playerb.net $ */
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
 * @subpackage		com.DeComposer.controller.pad
 * @since			2008-03-06
 * @version			$Revision: 28 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-10-06 06:29:15 -0700 (Mon, 06 Oct 2008) $
 * @license			Commercial
 */
package com.DeComposer.controller.pad
{
	import com.DeComposer.utils.GeoUnit;
	import com.DeComposer.utils.Parser;
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Geometry;
	import com.fake.controller.CtrlRegistry;
	import com.fake.controller.IController;
	import com.fake.utils.ObjectMap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;

	public class MainPadCtrl extends Canvas implements IController
	{
		public var selectedFillKey:String = "lightblue";
		public var selectedStrokeKey:String = "black";

		public function MainPadCtrl()
		{
			super();
			ctrl.register(this, MainPadCtrl);

			addEventListener(FlexEvent.INITIALIZE, initalize);
		}

		public function initalize(event:FlexEvent):void
		{
			this.horizontalScrollPolicy = "false";
			this.verticalScrollPolicy = "false";
		}
		
		public function addUnit(geo:Geometry):void
		{
			var gUnit:GeoUnit = new GeoUnit(geo, selectedFill, selectedStroke);
			trace(gUnit.geometry.id);
			addChild(gUnit);
			
			ObjectMap.instance.add(gUnit.geometry);
			
			gUnit.addEventListener(MouseEvent.RIGHT_CLICK, removeUnit);
		}
		
		public function removeUnit(event:Event):void
		{
			var gUnit:GeoUnit = GeoUnit(event.currentTarget);
			
			removeChild(gUnit);
			ObjectMap.instance.remove(gUnit.geometry);
		}

		public function get selectedFill():IGraphicsFill {
			return objectMap.selectedFill as IGraphicsFill;
		}

		public function get selectedStroke():IGraphicsStroke {
			return objectMap.selectedStroke as IGraphicsStroke;
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}
		
		public function get objectMap():ObjectMap {
			return ObjectMap.instance;
		}

		public static function get instance():MainPadCtrl
		{
			return CtrlRegistry.instance.getCtrl(MainPadCtrl) as MainPadCtrl;
		}
	}
}