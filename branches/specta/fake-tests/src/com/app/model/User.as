/* SVN FILE: $Id: User.as 149 2008-08-27 21:08:14Z gwoo.cakephp $ */
/**
 * Description
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
 * @subpackage		com.app.model
 * @since			2008-03-06
 * @version			$Revision: 149 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-28 04:08:14 +0700 (Thu, 28 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.model.Model;

	public dynamic class User extends Model
	{
		public var id:int;
		public var username:String;
		public var password:String;
		public var email:String;
		public var created:String;
		public var modified:String;

		public function User()
		{

		}
	}
}
