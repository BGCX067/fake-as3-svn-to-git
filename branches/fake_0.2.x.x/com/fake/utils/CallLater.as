package com.fake.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CallLater
	{
		protected static var methodQueue:Array = [];
		protected static var argumentQueue:Array = [];
		protected static var thisArgQueue:Array = [];
		
		public static var timer:Timer = new Timer(1);
		protected static var adding:Boolean = false;
		
		public function CallLater()
		{
		}
		
		public static function add(method:Function, args:* = null, delay:int = 1, thisArg:* = null):void
		{
			timer.delay = delay;
			
			if(!(args is Array))
			{
				args = [args];
			}
			
			methodQueue.push(method);
			argumentQueue.push(args);
			thisArgQueue.push(thisArg);
			
			if(!adding)
			{
				timer.addEventListener(TimerEvent.TIMER, onTimer);
				timer.start();
				adding = true;
			}
		}
		
		protected static function onTimer(event:TimerEvent):void
		{
			for(var i:int = 0; i < methodQueue.length; i++)
			{
				var method:Function = methodQueue[i];
				
				method.apply(thisArgQueue[i], argumentQueue[i]);
			}
			
			methodQueue = [];
			argumentQueue = [];
			
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer.stop();
			
			adding = false;
		}
	}
}