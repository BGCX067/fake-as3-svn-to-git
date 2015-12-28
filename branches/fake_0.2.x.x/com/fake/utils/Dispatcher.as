/* SVN FILE: $Id: Dispatcher.as 171 2008-09-10 17:50:05Z xpointsh $ */
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
 * @version			$Revision: 171 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-09-11 00:50:05 +0700 (Thu, 11 Sep 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	// Big Ups to Jacob Bullock aka Jacobot

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	public class Dispatcher
	{
		static protected var __dispatcher:EventDispatcher;

		static public function addEventListener(eventName:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakRef:Boolean = false):void
		{
			if (__dispatcher == null)
				__dispatcher = new EventDispatcher();

			__dispatcher.addEventListener(eventName, listener, useCapture, priority, useWeakRef);
		}

		static public function removeEventListener(eventName:String, listener:Function, useCapture:Boolean = false):void
		{
			__dispatcher.removeEventListener(eventName, listener, useCapture);
		}

		static public function dispatchEvent(event:Event):Boolean
		{
			if (__dispatcher == null)
				__dispatcher = new EventDispatcher();
			
			return __dispatcher.dispatchEvent(event);
		}

		static public function run(eventName:String, data:Object = null):void
		{
			dispatchEvent(new FakeEvent(eventName, data));
		}
		
		static public function dispatchPropertyChange(bubbles:Boolean = false, 
		property:Object = null, oldValue:Object = null, 
		newValue:Object = null, source:Object = null):Boolean{
			
			return dispatchEvent(new PropertyChangeEvent("propertyChange",bubbles,false,PropertyChangeEventKind.UPDATE,property,oldValue,newValue,source));
		}
	}
}