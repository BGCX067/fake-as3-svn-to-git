/* SVN FILE: $Id: Book.as 45 2008-03-26 20:35:43Z gwoo.cakephp $ */
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
 * @version			$Revision: 45 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-27 02:35:43 +0600 (Thu, 27 Mar 2008) $
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
		
		public var title:String;
		
		public var pageCount:int;
		
		public var publishedDate:Date;
		
		public var inLibrary:Boolean;
		
		// Just for kicks...
		public var random:*;
		
	} // end class
} // end package