/* SVN FILE: $Id: Parser.as 18 2008-09-10 16:34:34Z xpoint%playerb.net $ */
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
 * @version			$Revision: 18 $
 * @modifiedby		$LastChangedBy: xpoint%playerb.net $
 * @lastmodified	$Date: 2008-09-10 09:34:34 -0700 (Wed, 10 Sep 2008) $
 * @license			Commercial
 */
package com.DeComposer.utils
{
	import com.darronschall.serialization.ObjectTranslator;
	import com.degrafa.*;
	import com.degrafa.core.*;
	import com.degrafa.geometry.*;
	import com.degrafa.paint.*;
	import com.fake.utils.*;
	
	import flash.events.*;
	import flash.net.*;
	import flash.utils.describeType;
	import flash.xml.XMLDocument;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	public class Parser
	{
		public var decorators:Object = {};
		public var preGeometryObjArray:Array = [];
		
		public var decoder:SimpleXMLDecoder = new SimpleXMLDecoder();
		
		private static var _instance:Parser = new Parser();
		
		public static function get instance():Parser {
			return _instance;
		}
		
		public function Parser()
		{
		}
		
		public function get fillMap():Object {
			return objectMap.findMap(IGraphicsFill);
		}
		
		public function get strokeMap():Object {
			return objectMap.findMap(IGraphicsStroke);
		}
		
		public function get geometryMap():Object {
			return objectMap.findMap(Geometry);
		}
		
		public function get objectMap():ObjectMap {
			return ObjectMap.instance;
		}
		
		/**
		 * Used if there are multiple nodes with no root node. Adds a top level node.
		 */		
		public function parseRootXML(source:String):void
		{
			var root:XML = new XML("<x>"+source+"</x>");
			
			for each(var node:XML in root.children())
			{
				parseChildXML(node);
			}
		}
		
		public function parseChildXML(node:XML, container:Array = null):void
		{
			var cXML:XML = new XML("<"+node.localName()+"/>");
				
			for each(var attr:XML in node.attributes()) {
				cXML[attr.name()] = attr;
			}
			
			var base:Object = decode(cXML);
			
			scanBase(base[cXML.localName()]);
			
			var typed:Object = ObjectTranslator.objectToInstance(base[cXML.localName()], ReferenceUtil.bigSwitch(cXML.localName()))
			
			objectMap.add(typed);
			
			if(container) {
				container.push(typed);
			}
			
			var nextContainer:Array = null;
			
			// GeometryCompositions have to be handle differently.
			if(typed is GeometryComposition) {
				parseGeometryComposition(node, typed as GeometryComposition);
				return;
			}
			
			// parses the children of this node if any.
			for each(var child:XML in node.children())
			{
				if(typed is Geometry)
					nextContainer = Geometry(typed).geometryCollection.items;
				if(typed is GradientFillBase || typed is GradientStrokeBase)
					nextContainer = typed.gradientStopsCollection.items;
					
				parseChildXML(child, nextContainer);
			}
		}
		
		/**
		 * GeometryComposition are special types of Geometry that
		 * need to be parsed differently. They have multiple types of child arrays.
		 * Fill, Stroke and Geometry collections.
		 */		
		public function parseGeometryComposition(node:XML, typed:GeometryComposition):void
		{
			var desc:XML = describeType(typed);
			
			for each(var child:XML in desc..accessor)
			{
				// if the child atrribute (fills, strokes or geometry) have children,
				// parsed by attribute and use its array.
				if(node.child(child.@name).children().length() != 0)
				{
					for each(var subChild:XML in node.child(child.@name).children()) {
						parseChildXML(subChild, Object(typed)[child.@name]);
					}
				}
			}
		}
		
		/**
		 * Creates a Object from the given XML. This has the attributes
		 * converted into properties. It is recursive.
		 */		
		public function decode(value:XML):Object {
			return decoder.decodeXML(new XMLDocument(value.toXMLString()));
		}
		
		/**
		 * Checks to see if the given object is property contains a MXML style id string id="{someID}".
		 * If it is, it replaces it with the proper reference from the ObjectMap.
		 */		
		public function scanBase(base:Object):void
		{
			for(var key:String in base)
			{
				var baseValue:String = base[key];
				
				if(baseValue.indexOf("{") == 0)
					baseValue = baseValue.slice(1,-1);
					
				if(objectMap.idMap[baseValue])
					base[key] = objectMap.findByID(baseValue);
			}
		}
		
		/**
		 * Returns a MXML formated string off all instances that are given to it.
		 */		
		public function renderMXML(value:Object):String
		{
			var desc:XML = describeType(value);
			var className:String = String(desc.@name).split("::")[1];
			var mxml:String = "";
			var singleTag:Boolean = true;
			var childTags:String = "";
			
			mxml += " id=\"" + value["id"] + "\"";
			
			var xmlList:XMLListCollection = new XMLListCollection(desc..accessor);
			
			for each(var node:XML in desc..variable) {
				xmlList.addItem(node)
			}
			
			var sort:Sort = new Sort();
			sort.fields = [new SortField("@name",true)];
			xmlList.sort = sort;
			xmlList.refresh();
			
			for each(node in xmlList)
			{
				if(node.@name == "id") {
					continue;
				}
				
				if(node.@name == "gradientStops")
				{
					for each(var stop:Object in value["gradientStops"]) {
						childTags += "\n\t" + renderMXML(stop); 
					}
					
					singleTag = false;
					
					continue;
				}
				
				if((node.localName() == "variable") || (node.localName() == "accessor" && node.@access == "readwrite"))
				{
					if(value[node.@name] != "null" && value[node.@name] != null && value[node.@name] != "" && value[node.@name].toString() != "NaN")
					{
						if(node.@name == "fill" || node.@name == "stroke") {
							mxml += " " + node.@name + "=\"{" + value[node.@name]["id"] + "}\"";
						}
						else if(allowAbleType(node.@type) || node.@name == "color") {
							mxml += " " + node.@name + "=\"" + value[node.@name] + "\"";
						}
					}
				}
			}
			
			if(singleTag) {
				return "<" + className + mxml + "/>";
			}
			else {
				return "<" + className + mxml + ">" + childTags + "\n</" + className + ">";
			}
		}
		
		/**
		 * Checks to see if the the type is a value type and not a reference type.
		 */		
		public function allowAbleType(type:String):Boolean
		{
			return (type == "int" || type == "uint" || type == "Number" || type == "String");
		}	
	}
}