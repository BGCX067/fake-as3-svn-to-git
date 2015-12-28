/* SVN FILE: $Id: ConnectionManager.as 262 2009-06-16 18:09:41Z gwoo.cakephp $ */
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
 * @subpackage		com.fake.model.datasources
 * @since			2008-03-06
 * @version			$Revision: 262 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2009-06-17 01:09:41 +0700 (Wed, 17 Jun 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model.datasources
{
	import com.fake.utils.ConfigManager;
	import com.fake.utils.DescribeUtil;

	/**
	 * Class for handling DataSouce connections
	 */
	public class ConnectionManager
	{

		/**
		 *  need datasource references for compiling
		 */
		private var __amfRef:AmfDataSource;
		private var __httpRef:HttpDataSource;
		private var __loaderRef:LoaderDataSource;

		/**
		 * Singleton instance
		 */
		private static const __instance:ConnectionManager = new ConnectionManager();

		/**
		 * holds all config setup for the environment set through create
		 */
		private var __config:Object = {};

		/**
		 * Hash object of all current connections
		 */
		private var __connections:Object = {};

		/**
		 * Constructor
		 * @param target
		 */
		public function ConnectionManager()
		{
			super();
		}

		/**
		 * Get instance of the ConnectionManager
		 * @return ConnectionManager
		 */
		public static function get instance():ConnectionManager
		{
			return __instance;
		}

		/**
		 * Returns a DataSource based on passed configuration id
		 *
		 * @param id node attribute from connection.xml
		 */
		public function getDataSource(name:String = 'default', options:Object = null):DataSource
		{
			if (!name)
			{
				name = 'default';
			}

			if (options)
			{
				this.create(name, options);
			}

			var conn:Object = config(name);

			if (conn == null)
			{
				return null;
			}

			if (__connections[name] && !options)
			{
				return __connections[name];
			}

			var dataSource:DataSource;
			var packages:Array = ConfigManager.instance.packages;
			packages.push('com.fake');

			for each(var _package:String in packages)
			{
				var ClassRef:Class = DescribeUtil.instance.definition(_package + ".model.datasources." + conn.datasource + "DataSource");
				if (ClassRef)
				{
					dataSource = new ClassRef(conn);
					break;
				}
			}
			__connections[name] = dataSource;

			return dataSource;
		}

		/**
		 * Creates a new connection configuration
		 *
		 * @param name
		 * @param properties
		 */
		public function create(name:String, properties:Object):void
		{
			__config[name] = properties;
		}
		/**
		 * Returns connection configuration object
		 *
		 * @param name
		 */
		public function config(name:String):Object
		{
			if (__config.hasOwnProperty(name))
			{
				return __config[name];
			}
			return null;
		}

	}
}