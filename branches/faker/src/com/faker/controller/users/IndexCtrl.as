/* SVN FILE: $Id: IndexCtrl.as 246 2009-05-29 23:02:36Z gwoo.cakephp $ */
package com.faker.controller.users
{
	import com.fake.model.ResultSet;
	import com.faker.model.User;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	public class IndexCtrl extends Canvas
	{
		public var grid:DataGrid;
		
		public function IndexCtrl()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, index);
		}
		
		public function index(event:FlexEvent):void
		{
			var user:User = new User();
			user.index(onIndex);
		}
		
		private function onIndex(result:ResultSet):void
		{
			grid.dataProvider = result.User.list;
		}
	}
}
