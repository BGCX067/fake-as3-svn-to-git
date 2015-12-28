package com.blog.model
{
	import com.fake.model.Model;

	public class Comment extends Model
	{
		public var id:uint;			// serial NOT NULL,
		public var post_id:uint;	// integer NOT NULL,
		public var user_id:uint;	// integer NOT NULL,
		public var body:String;		// text NOT NULL,
		
		public function Comment()
		{
			super();
		}
		
	}
}