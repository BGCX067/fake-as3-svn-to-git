/* SVN FILE: $Id: Environment.as 74 2008-04-03 18:03:56Z gwoo.cakephp $ */
/**
 * Description
 *
 * Pretend
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			pretend
 * @subpackage		com.app
 * @since			2008-03-06
 * @version			$Revision: 74 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-04 01:03:56 +0700 (Fri, 04 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app
{
	import com.fake.model.datasources.ConnectionManager;
	import com.fake.utils.ConfigManager;
	import com.fake.utils.Dispatcher;
	import com.fake.utils.FakeEvent;

	/**
	 * Configure the enviroments to be used
	 *
	 */
	public class Environment
	{
		public function Environment()
		{
			Dispatcher.addEventListener('Config.loaded', this.loaded);
			ConfigManager.instance.load("assets/config.xml");
		}

		protected function loaded(event:FakeEvent):void
		{
			switch(ConfigManager.instance.environment)
			{
				case 'development':
					ConnectionManager.instance.create('default',
						{endpoint: "http://fake.local:61604/pretend/", datasource: "Amf"}
					);
					ConnectionManager.instance.create('users',
						{endpoint: "http://localhost:56000/pretend/", datasource: "Amf"}
					);
				break;

				case 'staging':
					ConnectionManager.instance.create('default',
						{endpoint: "http://fake.local:61604/pretend"}
					);
				break;

				case 'production':
					ConnectionManager.instance.create('default',
						{endpoint: "http://fake.local:61604/pretend"}
					);
				break;
			}
		}
	}
}