/* SVN FILE: $Id: DirectoryMO.as 6 2008-08-27 23:38:28Z gwoo%s45853.gridserver.com $ */
/**
 * Description
 *
 * DeComposer
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Commercial License
 * Redistributions of files prohibited
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @package			DeComposer
 * @subpackage		com.DeComposer.model
 * @since			2008-03-06
 * @version			$Revision: 6 $
 * @modifiedby		$LastChangedBy: gwoo%s45853.gridserver.com $
 * @lastmodified	$Date: 2008-08-27 16:38:28 -0700 (Wed, 27 Aug 2008) $
 * @license			Commercial
 */
package com.DeComposer.model
{
	import flash.filesystem.File;

	public class DirectoryMO
	{
		private var _path:String;

		public var file:File = File.documentsDirectory;

		public function DirectoryMO()
		{
		}

		/**
		 * Creates directory at current path position if no array given. An array of paths will
		 * create multiple directories
		 */
		public function create(directories:Array = null):void
		{
			if(directories)
			{
				for each(var dPath:String in directories)
				{
					path = dPath;
					file.createDirectory();
				}
			}
			else
				file.createDirectory();
		}

		/**
		 * Returns the path.
		 */
		public function get path():String {
			return _path;
		}
		/**
		 * Creates the File object and stores the path string.
		 */
		public function set path(value:String):void {
			_path = value;

			file = file.resolvePath(_path);
		}
	}
}