/* SVN FILE: $Id: FakeApp.as 224 2008-11-11 17:40:42Z gwoo.cakephp $ */
package com.<?php echo $app;?>

{
	import com.fake.utils.Router;
	import com.<?php echo $app;?>.config.Environment;
	import com.<?php echo $app;?>.config.Routes;
	
	import mx.core.<?php echo $application?>;	
	import mx.events.FlexEvent;

	public class FakeApp extends <?php echo $application?>
	
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
			Router.instance.start({title: "<?php echo $app?>"});
		}
	}
}