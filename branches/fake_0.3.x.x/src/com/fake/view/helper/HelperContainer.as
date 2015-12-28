package com.fake.view.helper
{
	import com.fake.controller.IController;
	
	import mx.containers.Canvas;
	import mx.events.FlexEvent;
	
	public class HelperContainer extends Canvas implements IHelper
	{
		private var _controller:IController;

		public function HelperContainer()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:FlexEvent):void
		{
			if ( !_controller ){
				controller = IController(parentDocument);
			}
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