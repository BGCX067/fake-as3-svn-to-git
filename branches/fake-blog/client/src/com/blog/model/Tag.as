package com.blog.model
{
	import com.fake.model.Model;

	public class Tag extends Model
	{
		public var id:uint;			// serial NOT NULL,
		public var name:String;		// character varying(20) NOT NULL,
		
		public function Tag()
		{
			super();
		}
		
	}
}