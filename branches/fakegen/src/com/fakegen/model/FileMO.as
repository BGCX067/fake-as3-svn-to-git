/* SVN FILE: $Id: FileMO.as 138 2008-08-20 00:35:41Z xpointsh $ */
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
 * @subpackage		com.fake
 * @since			2008-03-06
 * @version			$Revision: 138 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-08-20 07:35:41 +0700 (Wed, 20 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fakegen.model
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