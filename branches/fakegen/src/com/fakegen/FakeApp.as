/* SVN FILE: $Id: FakeApp.as 139 2008-08-20 00:59:50Z gwoo.cakephp $ */
package com.fakegen
{
	import mx.core.WindowedApplication;

	public class FakeApp extends WindowedApplication
	{
		private static var _instance:FakeApp;
		public static function get instance():FakeApp {
			return _instance;
		}

		public function FakeApp()
		{
			super();
			_instance = this;
		}
	}
}