/* SVN FILE: $Id: ConfigManager.as 129 2008-06-11 19:38:19Z gwoo.cakephp $ */
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
 * @version			$Revision: 129 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-12 02:38:19 +0700 (Thu, 12 Jun 2008) $
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
	}
}