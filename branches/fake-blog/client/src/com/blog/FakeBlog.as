package com.blog
{
	import com.blog.config.AppEnvironment;
	import com.blog.config.AppRoutes;
	import com.blog.model.User;
	import com.fake.Fake;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.Router;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;

	public class FakeBlog extends Fake
	{
		public function FakeBlog()
		{
			super();
			
			// Classes not loaded in SWF
			var user:User;
			
			var environment:AppEnvironment = new AppEnvironment();
			var routes:AppRoutes = new AppRoutes();
			
			addEventListener(FlexEvent.PREINITIALIZE, onPreinitialize);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			Dispatcher.addEventListener('Config.loaded', onConfigLoad);
		}
		
    	override public function initialize():void
    	{
    		// do nothing unless Config is loaded
    	}
    	
    	public function onConfigLoad(event:Event):void
    	{
    		super.initialize();
    	}
		
		public function onPreinitialize(event:FlexEvent):void
		{
			
		}
		
		public function onCreationComplete(event:FlexEvent):void
		{
			Router.instance.start({title:"Fake Blog"});
		}
		
	}
}