/* SVN FILE: $Id: FileMO.as 6 2008-08-27 23:38:28Z gwoo%s45853.gridserver.com $ */
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
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileMO
	{
		private var _path:String;

		public var file:File = File.documentsDirectory;
		public var fileStream:FileStream = new FileStream();

		public function FileMO(path:String = "", data:String = "")
		{
			if(path != "")
				this.path = path;
			if(data != "")
				this.data = data;

			super();
		}

		/**
		 * Returns a string of all the data in the file.
		 */
		public function get data():String {
			fileStream.open(file, FileMode.READ);
			return fileStream.readUTFBytes(fileStream.bytesAvailable);
		}
		/**
		 * Writes a string to the file.
		 */
		public function set data(value:String):void {
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(value);
			fileStream.close();
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