/* SVN FILE: $Id: Environment.as 3 2008-08-20 08:28:10Z gwoo%s45853.gridserver.com $*/
package com.DeComposer.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;

	public class Environment
	{
		public function Environment()
		{
			ConfigManager.instance.app = "DeComposer";

			ConfigManager.instance.environment = "local";
			this.loaded(null);
		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'local':
					ConnectionManager.instance.create('default',
						{endpoint: "http://DeComposer/", datasource: "Amf"}
					);
				break;

				case 'dev':
					ConnectionManager.instance.create('default',
						{endpoint: "http://DeComposer/", datasource: "Amf"}
					);
				break;

				case 'beta':
					ConnectionManager.instance.create('default',
						{endpoint: "http://DeComposer/", datasource: "Amf"}
					);
				break;

				case 'www':
					ConnectionManager.instance.create('default',
						{endpoint: "http://DeComposer/", datasource: "Amf"}
					);
				break;
			}

		}
	}
}