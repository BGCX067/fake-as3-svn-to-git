/* SVN FILE: $Id: Environment.as 139 2008-08-20 00:59:50Z gwoo.cakephp $*/
package com.fakegen.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;

	public class Environment
	{
		public function Environment()
		{
			ConfigManager.instance.app = "fakegen";

			ConfigManager.instance.environment = "local";
			this.loaded(null);

		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{

			}

		}
	}
}