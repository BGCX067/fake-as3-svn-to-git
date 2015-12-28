package com.blog.model
{
	import com.fake.model.Model;

	public class Post extends Model
	{
		
		public var id:uint;			// serial NOT NULL,
		public var user_id:uint;	// integer NOT NULL,
		public var title:String;	// character varying(50) NOT NULL,
		public var body:String;		// text NOT NULL,
		//created timestamp without time zone,
		//modified timestamp without time zone,

		public function Post()
		{
			super();
		}
		
	}
}