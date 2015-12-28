/* SVN FILE: $Id: Post.as 63 2008-04-02 19:04:23Z gwoo.cakephp $ */
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
 * @version			$Revision: 63 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-03 02:04:23 +0700 (Thu, 03 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
package com.app.model
{
	import com.fake.model.Model

	public class Post extends Model
	{
		public var id:int;
		public var title:String;
		public var body:String;
		public var modified:String;
		public var created:String;
		public var user_id:int;

		public function Post()
		{

		}
	}
}
