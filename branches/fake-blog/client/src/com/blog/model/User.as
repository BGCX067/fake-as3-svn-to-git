package com.blog.model
{
	import com.fake.model.Model;

	public class User extends Model
	{
		public var id:uint;				// serial NOT NULL,
		public var username:String;		// character varying(50) NOT NULL,
		public var password:String;		// character varying(50) NOT NULL,
		public var email:String;		// character varying(200) NOT NULL,
		public var admin:String;		// character varying(200) NOT NULL,
		
		[Transient] [Bindable] public static var logged_user:User = null;
		[Transient] [Bindable] public static var logged_id:uint = 0;
		
		public function User()
		{
			super();
		}
		
	}
}