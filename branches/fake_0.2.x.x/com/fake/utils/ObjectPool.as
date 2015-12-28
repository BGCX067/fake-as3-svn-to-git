package com.fake.utils
{
	import flash.system.System;
	import flash.utils.Dictionary;
	
	public class ObjectPool
	{
		protected var dictionary:Dictionary = new Dictionary(true);
		
		protected var pool:Array = [];
		
		public var totalObjects:int = 0;
		
		public function ObjectPool()
		{
			super();
		}
		
		public function addObject(objectReference:Object, usePush:Boolean = true):void
		{
			if(usePush)
				pool.push(objectReference);
			else
				pool.unshift(objectReference);
				
			dictionary[objectReference] = objectReference;
		
			totalObjects++;
		}
		
		public function getObject(useShift:Boolean = true):Object
		{
			if(useShift)
				return pool.shift();
			else
				return pool.pop();
		}
		
		public function releaseObject(objectReference:Object, usePush:Boolean = true):void
		{
			if(usePush)
				pool.push(objectReference);
			else
				pool.unshift(objectReference);
		}
		
		public function clearPool():void
		{
			for(var key:* in dictionary)
				delete dictionary[key];
			
			dictionary = new Dictionary(true);
			
			pool = null;
			pool = [];
			
			System.gc();
			
			totalObjects = 0;
		}
		
		public function get freeObjects():int { return pool.length; }
		
		public function get takenObjects():int { return totalObjects - pool.length; }
	}
	
}
