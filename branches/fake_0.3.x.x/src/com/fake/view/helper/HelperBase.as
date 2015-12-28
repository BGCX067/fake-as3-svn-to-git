package com.fake.view.helper
{
	import com.fake.controller.IController;
	
	public class HelperBase implements IHelper
	{
		private var _controller:IController;
		
		public function HelperBase()
		{
		}

		public function set controller(value:IController):void
		{
			_controller = value;
		}
		
		public function get controller():IController
		{
			return _controller;
		}
				
	}
}