package com.fake.events
{
	import flash.events.Event;

	public class FormEvent extends Event
	{
		public static const CLOSE:String = "close";
		public static const UPDATED:String = "updated";
		public static const LOADED:String = "loaded";
		public static const VALIDATION_ERROR:String = "validationError";
		
		public var data:*;
		
		public function FormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}