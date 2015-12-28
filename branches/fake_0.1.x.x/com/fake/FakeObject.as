/* SVN FILE: $Id: FakeObject.as 121 2008-05-08 22:02:11Z gwoo.cakephp $ */
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
 * @subpackage		com.fake
 * @since			2008-03-06
 * @version			$Revision: 121 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-05-09 05:02:11 +0700 (Fri, 09 May 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake
{
	import com.fake.utils.DescribeUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.*;

	/**
	 * FakeObject is the root object for all classes
	 * in Fake. It contains a reference to the class name
	 * and class object. These are obtained by using the
	 * reflection classes in flash.utils.
	 */
	public dynamic class FakeObject extends Proxy implements IEventDispatcher
	{
		/**
		* The name of the top level subclass
		*/
		[Transient] public var className:String;
		/**
		* A reference to the top level subclass
		*/
		[Transient] public var ClassRef:Class;
		
		private var __item:Array;
		private var __dispatcher:EventDispatcher;

		public function FakeObject()
		{
			getClassInfo();
			__item = new Array();
		}

		/**
		 * This method is called by the constructor. Populates the className and ClassRef using
		 * getQualifiedClassName and getDefinitionByName
		 */
		private function getClassInfo():void
		{
			var qcName:Array = getQualifiedClassName(this).split("::");
			className = qcName[1];

			var classPath:String = getQualifiedClassName(this).replace( "::", "." );
			ClassRef = getDefinitionByName(classPath) as Class;
		}
		
		/**
		 * Override the callProperty of the flash_proxy 
		 * @param method
		 * @param args
		 * @return 
		 * 
		 */
		override flash_proxy function callProperty(method: *, ...args):*
		{
			try
			{
				return ClassRef.prototype[method].apply(method, args);
			}
			catch (e:Error)
			{
				return overload(method, args);
			}
		}
		
		/**
		 * To be overriden by subclasses. Allows calling any method on any object that extends FakeOject 
		 * @param method
		 * @param args
		 * 
		 */
		protected function overload(method:*, args:Array):*
		{
			return null;
		}
		
		/**
		 * get a property on the object 
		 * @param name
		 * @return 
		 * 
		 */
		override flash_proxy function getProperty(name:*):* 
		{
       	 	return overloadGetProperty(name);
	    }
	    
	    protected function overloadGetProperty(name:*):*
	    {
	    	return __item[name];
	    }
	
	    /**
	     * Set a property on the object 
	     * @param name
	     * @param value
	     * 
	     */
	    override flash_proxy function setProperty(name:*, value:*):void 
	    {
	        overloadSetProperty(name, value)
	    }
	    
	    protected function overloadSetProperty(name:*, value:*):void
	    {
	    	__item[name] = value;
	    }
	    
	   	/**
	     * Check if the property exits
	     * @param name
	     * @param value
	     * 
	     */
	    override flash_proxy function hasProperty(name:*):Boolean 
	    {
	    	if (__item[name])
	    	{
	    		return true;
	    	}
	    	return false;
	    }
	    
		protected var _item:Array; // array of object's properties
		override flash_proxy function nextNameIndex (index:int):int 
		{
			if(!_item)
				_item = DescribeUtil.instance.propertyNameList(this);
		 
			if (index < _item.length) {
				return index + 1;
			} else {
				return 0;
			}
		}
		
		override flash_proxy function nextName(index:int):String 
		{
			return _item[index - 1];
		}
		
		override flash_proxy function nextValue(index:int):* 
		{
			if(!_item)
				_item = DescribeUtil.instance.propertyNameList(this);
				
            var obj:Object = Object(this);
            var prop:String = _item[index - 1];
            return obj[prop];
        }
	    
	    private function get dispatcher():EventDispatcher {
			if(!__dispatcher)
				__dispatcher = new EventDispatcher();
			return __dispatcher;
	    }
		
		public function dispatchEvent(event:Event):Boolean {
			return dispatcher.dispatchEvent(event);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function hasEventListener(type:String):Boolean {
			return dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return dispatcher.willTrigger(type);
		}
	}
}