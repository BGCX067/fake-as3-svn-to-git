/* SVN FILE: $Id: Book.as 231 2009-01-13 15:21:51Z rafael.costa.santos $ */
/**
 * Description
 *
 * Original BookVO
 * Copyright (c) 2006 Darron Schall <darron@darronschall.com>
 * 
 * Fake Tests
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			fake-tests
 * @subpackage		tests.utils
 * @since			2008-03-06
 * @version			$Revision: 231 $
 * @modifiedby		$LastChangedBy: rafael.costa.santos $
 * @lastmodified	$Date: 2009-01-13 21:21:51 +0600 (Tue, 13 Jan 2009) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.model.Model;
	
	/**
	 * Example ValueObject class representing a book
	 */
	public class Book extends Model
	{
		public var id:uint;
		
		public var title:String;
		
		public var pageCount:int;
		
		public var publishedDate:Date;
		
		public var inLibrary:Boolean;
		
		// Just for kicks...
		//public var random:*;
		
	} // end class
} // end package