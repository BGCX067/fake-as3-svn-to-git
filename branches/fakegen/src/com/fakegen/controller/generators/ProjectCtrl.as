/* SVN FILE: $Id: ProjectCtrl.as 142 2008-08-20 04:48:12Z xpointsh $ */
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
 * @version			$Revision: 142 $
 * @modifiedby		$LastChangedBy: xpointsh $
 * @lastmodified	$Date: 2008-08-20 11:48:12 +0700 (Wed, 20 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.fakegen.controller.generators
{
	import com.fake.controller.CanvasController;
	import com.fakegen.model.DirectoryMO;
	
	import flash.events.Event;
	import flash.filesystem.File;
	
	import mx.controls.TextInput;
	public class ProjectCtrl extends CanvasController
	{
		public var dirMO:DirectoryMO = new DirectoryMO();
		
		public var txti_path:TextInput;
		public var txti_name:TextInput;
		
		public function ProjectCtrl()
		{
			super();
		}
		
		public function browse():void
		{
			var directory:File = File.documentsDirectory;

			try
			{
			    directory.browseForDirectory("Select Directory");
			    directory.addEventListener(Event.SELECT, 
			    	function (event:Event):void 
			    	{
				    	directory = event.target as File;
				    	txti_path.text = directory.nativePath;
					}
				);
			}
			catch (error:Error)
			{
			    trace("Failed:", error.message)
			}
		}
		
		public function submit():void 
		{
			dirMO.path = txti_path.text + "/" + txti_name.text;
			dirMO.create();
		}
	}
}
