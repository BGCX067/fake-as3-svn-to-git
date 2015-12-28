/* SVN FILE: $Id: GeoUnit.as 28 2008-10-06 13:29:15Z xpoint%playerb.net $ */
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
 * @subpackage		com.DeComposer.utils
 * @since			2008-03-06
 * @version			$Revision: 28 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-10-06 06:29:15 -0700 (Mon, 06 Oct 2008) $
 * @license			Commercial
 */
package com.DeComposer.utils
{
	import com.DeComposer.controller.AppCtrl;
	import com.degrafa.core.IGraphicsFill;
	import com.degrafa.core.IGraphicsStroke;
	import com.degrafa.geometry.Geometry;
	import com.fake.utils.actions.DelegateAction;
	import com.fake.utils.actions.GroupAction;
	import com.fake.utils.actions.PropertyChangeAction;
	import com.roguedevelopment.objecthandles.ObjectHandleEvent;
	import com.roguedevelopment.objecthandles.ObjectHandles;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;

	public class GeoUnit extends ObjectHandles
	{
		private var _geometry:Geometry;

		public function GeoUnit(geometry:Geometry = null, fill:IGraphicsFill = null, stroke:IGraphicsStroke = null)
		{
			super();
			
			pixelExactClick = true;

			initGeometry(geometry);

			if(fill != null)
				this.fill = fill;
			if(stroke != null)
				this.stroke = stroke;

			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownCool);
			addEventListener(MouseEvent.RIGHT_CLICK, function ():void {selected = false});
			addEventListener(ObjectHandleEvent.OBJECT_RESIZING_EVENT, onObjectResize);
			
			var g:* = this;
			
			addEventListener(MouseEvent.MOUSE_DOWN, function ():void {
				GroupAction.start("uid",
				PropertyChangeAction.start("uid",["x","y"],g), 		
				PropertyChangeAction.start("uid",["height","width"],g),
				DelegateAction.start("uid",delegate,delegate,g));
			});
			
			addEventListener(MouseEvent.MOUSE_UP, function ():void {
				GroupAction.end();
			});
			
		}
		
		public function delegate(action:DelegateAction):void {
			onObjectResize(null);
		}

		public function initGeometry(geometry:Geometry):void
		{
			if(geometry != null)
			{
				this.geometry = geometry;

				//geometryToUI();
				//zeroOutGeometry();

				redraw();
			}
		}

		public function get geometry():Geometry {
			return _geometry;
		}

		public function set geometry(value:Geometry):void 
		{
			_geometry = value;
			
			this.id = _geometry.id;
			
			var geoObject:Object = Object(_geometry);
			
			if(_geometry.hasOwnProperty("height"))
			{
				this.x = geoObject.x;
				this.y = geoObject.y;
				this.height = geoObject.height;
				this.width = geoObject.width;
			}
			else if(_geometry.hasOwnProperty("radius"))
			{
				this.x = geoObject.centerX;// + geoObject.radius;
				this.y = geoObject.centerY;// + geoObject.radius;
				this.height = this.width = geoObject.radius*2;
				geoObject.centerX = geoObject.centerY = this.height / 2;
			}
			
			redraw();
		}

		/**
		 * Get/Set wrapper for the fill property of the child geometry
		 */
		public function get fill():IGraphicsFill {
			return _geometry.fill;
		}
		public function set fill(value:IGraphicsFill):void {
			_geometry.fill = value;
			redraw();
		}

		/**
		 * Get/Set wrapper for the stroke property of the child geometry
		 */
		public function get stroke():IGraphicsStroke {
			return _geometry.stroke;
		}
		public function set stroke(value:IGraphicsStroke):void {
			_geometry.stroke = value;
			redraw();
		}


		private var _selected:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			if(_selected == value) return;

			_selected = value;

			if(value) {
				this.filters = [new GlowFilter()];
				AppCtrl.instance.selectedGeometry.addItem(this);
			}
			else {
				this.filters = [];
				AppCtrl.instance.selectedGeometry.removeItemAt(
				AppCtrl.instance.selectedGeometry.getItemIndex(this));
			}
		}
		
		public function onMouseDownCool(event:Event):void
		{
			//selected = true; 
			parent.setChildIndex( this, parent.numChildren -1 );
		}
		
		public function onObjectResize(event:ObjectHandleEvent):void
		{
			var geoObject:Object = Object(_geometry);
			
			if(_geometry.hasOwnProperty("height"))
			{
				Object(_geometry).height = this.height; 
				Object(_geometry).width = this.width;
			}
			else if(_geometry.hasOwnProperty("radius"))
			{
				var lower:int = this.height > this.width ? this.width : this.height;
				geoObject.radius = lower / 2;
				geoObject.centerX = geoObject.centerY = geoObject.radius
			}
			 
			redraw();
		}

		public function uiToGeometry():void
		{
			var geoObject:Object = Object(geometry);

			if(geometry.hasOwnProperty("centerX")) {
				geoObject.centerX = this.x;
				geoObject.centerY = this.y;
			}
			else if(geometry.hasOwnProperty("x")){
				geoObject.x = this.x;
				geoObject.y = this.y;
			}
		}

		public function geometryToUI():void
		{
			var geoObject:Object = Object(geometry);

			if(geometry.hasOwnProperty("centerX")) {
				this.x = geoObject.centerX;
				this.y = geoObject.centerY;
			}
			else if(geometry.hasOwnProperty("x")){
				this.x = geoObject.x;
				this.y = geoObject.y;
			}
		}

		public function zeroOutGeometry():void {
			moveGeometry(0, 0);
		}
		
		public function redraw():void
		{
			_geometry.graphicsTarget = [this];
			
			if(!_geometry.bounds) return;
			
			var rect:Rectangle = _geometry.bounds;
			
			if(rect.x < 0) {
				moveGeometry(rect.x * -1);
			}	
			if(rect.y < 0) {
				moveGeometry(NaN, rect.y * -1);
			}
				
			width = rect.width;
			height = rect.height;
			
			//getBitmapData();
		}
		
		public function moveGeometry(xValue:Number = NaN, yValue:Number = NaN):void
		{
			var geoObject:Object = Object(geometry);

			if(geometry.hasOwnProperty("centerX")) {
				if(xValue) geoObject.centerX = xValue;
				if(yValue) geoObject.centerY = yValue;
			}
			else if(geometry.hasOwnProperty("x")) {
				if(xValue) geoObject.x = xValue;
				if(yValue) geoObject.y = yValue;
			}
		}

		public function toMXML():String
		{
			var geoObject:Object = Object(geometry);
			var output:String = "";

			uiToGeometry();

			output = Parser.instance.renderMXML(geometry);

			zeroOutGeometry();

			return output;
		}
		
		public function getBitmapData():void
		{
			// Copy content of this Instance
			var rect:Rectangle = _geometry.bounds;
			trace("width: "+_geometry.bounds.width);
			copyData = new BitmapData(_geometry.bounds.width, _geometry.bounds.height, true, 0x00000000);
			copyData.draw(super);
		}
	}
}