package com.fakegen.model
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