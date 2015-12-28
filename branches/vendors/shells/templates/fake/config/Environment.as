/* SVN FILE: $Id: Environment.as 224 2008-11-11 17:40:42Z gwoo.cakephp $*/
package com.<?php echo $app?>.config
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;

	public class Environment
	{
		public function Environment()
		{
			ConfigManager.instance.app = "<?php echo $app?>";

<?php if ($application == "WindowedApplication"):?>
			ConfigManager.instance.environment = "local";
			this.loaded(null);
<?php else:?>
			ConfigManager.instance.load("bin/assets/config.xml");
			Dispatcher.addEventListener('Config.loaded', this.loaded);
<?php endif;?>

		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'local':
					ConnectionManager.instance.create('default',
						{endpoint: "http://<?php echo $app?>/", datasource: "Amf"}
					);
				break;

				case 'dev':
					ConnectionManager.instance.create('default',
						{endpoint: "http://<?php echo $app?>/", datasource: "Amf"}
					);
				break;

				case 'beta':
					ConnectionManager.instance.create('default',
						{endpoint: "http://<?php echo $app?>/", datasource: "Amf"}
					);
				break;

				case 'www':
					ConnectionManager.instance.create('default',
						{endpoint: "http://<?php echo $app?>/", datasource: "Amf"}
					);
				break;
			}

		}
	}
}