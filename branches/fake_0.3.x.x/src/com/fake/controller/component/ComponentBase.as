package com.fake.controller.component
{
	import com.fake.controller.Action;
	import com.fake.controller.IController;
	import com.fake.model.ResultSet;

	public class ComponentBase implements IComponent
	{
		private var _controller:IController;
		
		private var _actions:Array = new Array;
		
		public function applyTo(value:*):void
		{
			if (value is String){
				_actions.push(value);
			} else if (value is Array){
				var action:String;
				for each (action in value){
					_actions.push(action);
				}
			}
		}
		
		public function isApplicable(value:String):Boolean
		{
			var action:String;
			for each (action in _actions){
				if (action == value){
					return true;
				}
			}
			
			return false;
		}
		
		public function ComponentBase()
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
		
		public function initialize(action:Action):void
		{
		}
		
		public function startup(action:Action):void
		{
		}
		
		public function beforeRender(action:Action, result:ResultSet):void
		{
		}
		
		public function shutdown(action:Action, result:ResultSet):void
		{
		}
		
	}
}