/* SVN FILE: $Id: Environment.as 147 2008-08-27 14:22:45Z gwoo.cakephp $*/
package com.faker.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;

	public class Environment
	{
		public function Environment()
		{
			ConfigManager.instance.app = "faker";

			ConfigManager.instance.load("assets/config.xml");
			Dispatcher.addEventListener('Config.loaded', this.loaded);

		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'local':
					ConnectionManager.instance.create('default',
						{endpoint: "http://fake.local:61604/faker/app/", datasource: "Amf"}
					);
				break;

				case 'dev':
					ConnectionManager.instance.create('default',
						{endpoint: "http://faker/", datasource: "Amf"}
					);
				break;

				case 'beta':
					ConnectionManager.instance.create('default',
						{endpoint: "http://faker/", datasource: "Amf"}
					);
				break;

				case 'www':
					ConnectionManager.instance.create('default',
						{endpoint: "http://faker/", datasource: "Amf"}
					);
				break;
			}

		}
	}
}