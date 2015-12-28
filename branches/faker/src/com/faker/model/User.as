/* SVN FILE: $Id: User.as 148 2008-08-27 21:07:45Z gwoo.cakephp $ */
package com.faker.model
{
	import com.fake.model.Model;

	public dynamic class User extends Model
	{
		public var id:int;
		public var email:String;
		public var password:String;
		public var created:String;
		public var modified:String;

		public function User()
		{

		}
	}
}
