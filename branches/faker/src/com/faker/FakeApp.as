/* SVN FILE: $Id: FakeApp.as 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
package com.faker
{
	import com.fake.utils.Router;
	import com.faker.config.Environment;
	import com.faker.config.Routes;
	
	import mx.core.Application;	
	import mx.events.FlexEvent;

	public class FakeApp extends Application	
	{
		private static var _instance:FakeApp;
		public static function get instance():FakeApp {
			return _instance;
		}

		public function FakeApp()
		{
			super();
			_instance = this;

			addEventListener(FlexEvent.PREINITIALIZE, onPreinitialize);
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function onPreinitialize(event:FlexEvent):void
		{
			var environment:Environment = new Environment();
			var routes:Routes = new Routes();
		}

		public function onCreationComplete(event:FlexEvent):void
		{
			Router.instance.start({title: "faker"});
		}
	}
}