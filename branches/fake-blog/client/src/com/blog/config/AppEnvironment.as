package com.blog.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;
	import com.fake.utils.HTTPUtil;
	
	import flash.events.Event;

	public class AppEnvironment
	{
		public function AppEnvironment()
		{
			ConfigManager.instance.packages = [
				"com.blog"
			];
			
			ConfigManager.instance.load("assets/config.xml");
			Dispatcher.addEventListener('Config.loaded', onConfigLoad);
			
			//I18n.instance.url = HTTPUtil.getProtocol()+"//"+HTTPUtil.getHostName()+"/locale/";
			
			super();

		}

		protected function onConfigLoad(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				// Local presentation
				case 'local':
					ConnectionManager.instance.create('default',
						{endpoint: HTTPUtil.getProtocol()+"//"+HTTPUtil.getHostName()+"/server/", datasource: "Amf"}
					);
				break;

				// Local development
				case 'dev':
					ConnectionManager.instance.create('default',
						{endpoint: HTTPUtil.getProtocol()+"//"+HTTPUtil.getHostName()+"/server/", datasource: "Amf", debug: true}
					);
				break;

				// Production
				case 'prod':
					ConnectionManager.instance.create('default',
						{endpoint: HTTPUtil.getProtocol()+"//"+HTTPUtil.getHostName()+"/server/", datasource: "Amf"}
					);
				break;

				// Website demonstration
				case 'demo':
					ConnectionManager.instance.create('default',
						{endpoint: HTTPUtil.getProtocol()+"//"+HTTPUtil.getHostName()+"/server/", datasource: "Amf"}
					);
				break;
			}
			
			Dispatcher.dispatchEvent(new Event('Connection.stablished'));
		}
	}
}