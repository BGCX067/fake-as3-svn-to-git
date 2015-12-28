/* SVN FILE: $Id: FakeApp.as 29 2008-10-14 21:39:04Z xpoint%playerb.net $ */
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
 * @subpackage		com.DeComposer
 * @since			2008-03-06
 * @version			$Revision: 29 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-10-14 14:39:04 -0700 (Tue, 14 Oct 2008) $
 * @license			Commercial
 */
package com.DeComposer
{
	import com.DeComposer.model.FileMO;
	import com.DeComposer.utils.*;
	import com.degrafa.core.*;
	import com.degrafa.geometry.*;
	import com.degrafa.paint.*;
	import com.fake.controller.*;
	import com.fake.utils.*;
	
	import mx.controls.TextArea;
	import mx.core.UIComponent;
	import mx.core.WindowedApplication;
	import mx.events.FlexEvent;
	
	public class FakeApp extends WindowedApplication
	{
		private static var _instance:FakeApp;
		
		public var txtOutput:TextArea;
		public var txtSource:TextArea;
		
		public static function get instance():FakeApp {
			return _instance;
		}

		public function FakeApp()
		{
			super();
			_instance = this;

			addEventListener(FlexEvent.PREINITIALIZE, onPreinitialize);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}

		public function onPreinitialize(event:FlexEvent):void
		{
			//var environment:Environment = new Environment();
		}

		public function onCreationComplete(event:FlexEvent):void
		{

		}
		
		public function get parser():Parser {
			return Parser.instance;
		}
		
		public function render():void
		{
			clear();
			
			parser.parseRootXML(txtSource.text);
			
			for each(var geo:Geometry in objectMap.find(Geometry))
			{
				addUnit(geo);
			}
		}
		
		public function clear():void
		{
			objectMap.clear()
			
			for each(var uic:UIComponent in getChildren())
			{
				if(uic is GeoUnit)
					removeChild(uic);
			}
		}
		
		public function output():void
		{
			for each(var obj:Object in objectMap.find(IGraphicsFill))
			{
				txtOutput.text += Parser.instance.renderMXML(obj)+"\n";
			}
			for each(var gUnit:GeoUnit in objectMap.find(GeoUnit))
			{
				txtOutput.text += gUnit.toMXML()+"\n";
			}
		}
		
		public function addUnit(geo:Geometry):void
		{
			var gUnit:GeoUnit = new GeoUnit(geo, selectedFill, selectedStroke);
			addChild(gUnit);
			objectMap.add(gUnit);
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
			for each(var gUnit:GeoUnit in objectMap.selectedGeometry)
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
			return objectMap.selectedFill as IGraphicsFill;
		}

		public function get selectedStroke():IGraphicsStroke {
			return objectMap.selectedFill as IGraphicsStroke;
		}

		public function get ctrl():CtrlRegistry
		{
			return CtrlRegistry.instance;
		}
		
		public function get objectMap():ObjectMap {
			return ObjectMap.instance;
		}
	}
}