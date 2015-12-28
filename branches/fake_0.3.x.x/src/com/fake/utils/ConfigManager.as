/* SVN FILE: $Id: ConfigManager.as 284 2009-06-21 15:42:20Z rafael.costa.santos $ */
/**
 * Description
 *
 * Fake
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake
 * @subpackage		com.fake.utils
 * @since			2008-03-06
 * @version			$Revision: 284 $
 * @modifiedby		$LastChangedBy: rafael.costa.santos $
 * @lastmodified	$Date: 2009-06-21 22:42:20 +0700 (Sun, 21 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *  Configuration Management Class
	 *
	 */
	dynamic public class ConfigManager
	{
	 	/**
	 	 * Holds the current app name
	 	 */
	 	public var app:String = "app";

	 	/**
	 	 * Holds the current environment
	 	 */
	 	public var environment:String = "development";

		/**
		 * holds xml configuration object
		 */
		private static var __settings:XML;

		/**
	 	 * Holds the current pacakges name
	 	 */
	 	private var __packages:Array = [];

		/**
	 	 * Singeleton instance
	 	 */
	 	private static const __instance:ConfigManager = new ConfigManager();

		/**
		 * Constructor
		 */
		public function ConfigManager()
		{

		}

		/**
		 * Get instance of ConfigManager
		 * @return
		 */
		public static function get instance():ConfigManager
		{
			return __instance;
		}

		/**
		 * Loads xml configuration file
		 *
		 */
	 	public function load(path:String):void
	    {
	    	if (path == "")
	    	{
	    		path = 'assets/config.xml';
	    	}
	    	var req:URLRequest = new URLRequest(path);
			var loader:URLLoader = new URLLoader();
			loader.load(req);
			loader.addEventListener(Event.COMPLETE, onLoad);
	    }

	    /**
	     * callback for load
	     * @param event
	     */
	    private function onLoad(event:Event):void
	    {
	    	__settings = XML(event.target.data);
	    	environment = __settings..environment.@id;
	    	Dispatcher.run('Config.loaded', {loaded:true});
	    }

		/**
		 * Returns XML configuraiton from load path
		 * @return
		 */
		public function get settings():XML
		{
			return __settings;
		}

		/**
		 * Set XML configuraiton from load path
		 * @return
		 */
		public function set settings(settings:XML):void
		{
			if(!__settings) __settings = new XML();

			for each(var prop:Object in settings){
				__settings.appendChild(prop);
			}
		}
		/**
		 * Get all the current packages
		 * @return Array
		 *
		 */
		public function get packages():Array
		{
			if (__packages.length == 0)
			{
				if (app.length == 0)
				{
					__packages.push('com.app');
				}
				else
				{
					__packages.push('com.' + app);
				}
			}

			return __packages;
		}
		/**
		 * Add packages
		 * @param name String or Array
		 *
		 */
		public function set packages(name:*):void
		{
			if (name is Array)
			{
				for each(var _package:String in name)
				{
					if (__packages.indexOf(_package) === -1)
					{
						__packages.push(_package);
					}
				}
			}
			else if (name is String && __packages.indexOf(name) === -1)
			{
				__packages.push(name);
			}
		}
	}
}