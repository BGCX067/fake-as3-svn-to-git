/* SVN FILE: $Id: ConnectionManager.as 132 2008-06-22 03:13:58Z gwoo.cakephp $ */
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
 * @version			$Revision: 132 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-06-22 10:13:58 +0700 (Sun, 22 Jun 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fake.model.datasources
{
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
		public function getDataSource(name:String, options:Object = null):DataSource
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

			var DataSourceClass:Class = DescribeUtil.instance.definition("com.fake.model.datasources." + conn.datasource + "DataSource");
			var dataSource:DataSource = new DataSourceClass(conn);
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