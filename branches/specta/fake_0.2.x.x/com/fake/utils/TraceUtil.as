/* SVN FILE: $Id: TraceUtil.as 196 2008-09-16 20:40:41Z xpointsh $ */
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
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 196 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-17 03:40:41 +0700 (Wed, 17 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import com.fake.controller.utils.ControllerUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	
	public class TraceUtil
	{
		// Singleton instance
		private static const __instance:TraceUtil = new TraceUtil();
		
		// Reference to root application instance
		protected var _app:Object = Application.application;
		
		/**
		 * TraceUtil Singleton instance method.
		 */
		public static function get instance():TraceUtil{
			return __instance;
		}
		
		public function TraceUtil() {
			
		}
		
		/**
		 * Attaches a custom event handler to specified events. Event strings are given in an array.
		 *  
		 * @param dispatcher An object that is going to have event handlers attached to it.
		 * @param events A group of strings that are the event constants to be handled and traced out
		 */		
		public function addListeners(dispatcher:IEventDispatcher, events:Array):void
		{
			for each(var event:String in events)
			{
				dispatcher.addEventListener(event,traceHandler);
			}
		}
		
		/**
		 * Does custom the tracing. There are specific traces for 
		 * PropertyChangeEvents and UIComponents.
		 * 
		 * @param event 
		 */		
		private function traceHandler(event:Event):void
		{
			var item:Object = event.currentTarget;
			var output:String = "";
			
			if(event is PropertyChangeEvent)
			{
				// displays: time, event class name, event type, property name, old value, new value
				var e:PropertyChangeEvent = event as PropertyChangeEvent;
				output += time + DescribeUtil.localName(event) + " - \"" + event.type+"\"";
				output += "\tproperty: \""+e.property.toString()+"\"\tov: "+e.oldValue+"\tnv: "+e.newValue;
			}
			else if(item is UIComponent)
			{
				// displays: time, component id, component class name, event class name, event type
				output += time + "var " + item.id + ":" + DescribeUtil.localName(item);
				output += "\t" + DescribeUtil.localName(item) + " - \"" + event.type+"\"";	
			}
			else
			{
				// displays: time, event class name, event type
				output += time +DescribeUtil.localName(event) + " - \"" + event.type+"\"";
			}
	
			trace(output);
		}
		
		/** 
		 * Scans the entire application for UIComponents that have ids in their MXML and
		 * not their code behind controller. Then, traces the variable declarations to be
		 * pasted into the code behind file.
		 */		
		public function codeBehindVariables():void
		{
			var app:Object = Application.application;
			
			// get all ui components in the application
			var uiComponents:Array = ControllerUtil.findByType([UIComponent], DisplayObjectContainer(app));
			
			for each(var currentComponent:UIComponent in uiComponents)
			{	
				// get the description
				var baseDescription:XML = DescribeUtil.instance.describe(currentComponent);
				
				// get the type of the first super class
				var superType:String = baseDescription.extendsClass[0].@type;
				
				// if the first super class is not a controller, skip this component
				if(superType.indexOf("Ctrl") == -1)
					continue;
				
				// trace out the local name of the class
				
				trace(DescribeUtil.localName(currentComponent));
				
				// get the list of property names of the super class
				var superProperties:Array = DescribeUtil.instance.propertyNameList(DescribeUtil.instance.definition(superType) as Object);
				// get all of the of the current component
				var currentChildren:Array = ControllerUtil.findByType([UIComponent], currentComponent);
				
				for each(var childComponent:UIComponent in currentChildren)
				{
					// if the child component is not a property of super class 
					// the child component has an id and the id does not start with an underscore (local only)
					// trace out the code to be pasted into the code behind controller
					if(superProperties.indexOf(childComponent.id) == -1 && childComponent.id && childComponent.id.charAt(0) != "_")
					{
						trace("\t\tpublic var "+ childComponent.id + ":"+ DescribeUtil.localName(childComponent) +";");
					}
				}
				// trace out all of the properties of the super class, line break
				trace(superProperties);
				trace("\n");
			}
		}
		
		/**
		 * Utility function to format the date.
		 */		
		private function get time():String{
			var date:Date = new Date();
			return date.hours + ":" + date.minutes + ":" + date.seconds + ":" + date.milliseconds + "\t";
		}
	}
}