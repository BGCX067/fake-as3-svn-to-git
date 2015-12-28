package com.fake.utils
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class EventDispatcherMap extends EventDispatcher
	{
		/**
		 * Stores arrays of listeners keyed by the event type. 
		 */		
		public var typeMap:Dictionary = new Dictionary(true);
		
		public function EventDispatcherMap(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * Registers an event listener object with an EventDispatcher object so 
		 * that the listener receives notification of an event. Adds the listener
		 * to the typeMap.
		 */		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true) : void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			addListenerTypeMap(type, listener);
		}
		
		/**
		 * Stores the the listener in an array with other listeners of the same event type.
		 * Creates an array in the typeMap keyed off of the event type, if one does not
		 * already exist. 
		 */		
		protected function addListenerTypeMap(type:String, listener:Function):void
		{
			if(!typeMap[type])
				typeMap[type] = [];
				
			typeMap[type].push(listener);
		}
		
		/**
		 * Removes a listener from the EventDispatcher object. Removes the
		 * listener from the typeMap. 
		 */		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false) : void
		{
			super.removeEventListener(type, listener, useCapture);
			
			removeListenerTypeMap(type, listener);
		}
		
		/**
		 * Removes the listener from the typeMap array. If there are no other items in
		 * the type array, the array is removed. 
		 */		
		protected function removeListenerTypeMap(type:String, listener:Function):void
		{
			var arr:Array = typeMap[type];
			
			arr.splice(arr.indexOf(listener), 1);
			
			if(arr.length == 0) 
			{
				typeMap[type] = null;
				delete typeMap[type];
			}
		}
		
		/**
		 * Removes all listeners in the typeMap array of the matching type key.
		 * Removes the array from the typeMap.
		 */		
		public function removeAllListenersByType(type:String):void
		{
			var arr:Array = typeMap[type];
				
			for each(var listener:Function in arr)
			{
				super.removeEventListener(type, listener);
			}
			
			typeMap[type] = null;
			delete typeMap[type];
		}
		
		/**
		 * Removes all listeners in the typeMap array.
		 */	
		public function removeAllListeners(type:String):void
		{
			for(var typeKey:String in typeMap)
			{
				removeAllListenersByType(typeKey);
			}
			
			typeMap = null;
			typeMap = new Dictionary(true);
		}
		
		/**
		 * Total number of listeners for the given event type.
		 */		
		public function hasEventListenerCount(type:String):int
		{
			if(typeMap[type])
				return typeMap[type].length
			else
				return 0;
		}
		
		/**
		 * All of the event types registered. 
		 */		
		public function hasEventListenerTypes():Array
		{
			var output:Array = [];
			
			for(var typeKey:String in typeMap)
			{
				output.push(typeKey);
			}
			
			return output;
		}
	}
}