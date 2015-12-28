/* SVN FILE: $Id: User.as 21 2008-03-11 22:29:22Z gwoo.cakephp $ */
/**
 * Description
 *
 * Pretend
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			pretend
 * @subpackage		com.app.model
 * @since			2008-03-06
 * @version			$Revision: 21 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-12 04:29:22 +0600 (Wed, 12 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.app.model.dataset.UserDataSet;
	import com.fake.model.Model;
	
	public class User extends Model
	{
		public var id:int
		public var graftag:int
		public var icon:int
		public var approved:Boolean
		public var dob:String;
		public var display_name:String
		public var last_name:String
		public var first_name:String
		public var username:String
		public var email:String
		public var psword:String
		public var temppassword:String
		public var tos:Boolean
		public var email_authenticated:Boolean
		public var email_token:String
		public var email_token_expires:String
		public var views:int
		public var created:String
		public var modified:String;

		public function User()
		{
			DataSetClass = UserDataSet;
		}
	}
}
