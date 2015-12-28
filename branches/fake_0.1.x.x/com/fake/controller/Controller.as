package com.fake.controller
{
	import flash.utils.getQualifiedClassName;
	
	public class Controller
	{
		private static var __instance:Controller = new Controller();
		
		public var ctrlMap:Object = new Object();
		
		public function Controller()
		{
		}
		
		public function register(ctrl:IController, cls:Class):void
		{
			ctrlMap[getQualifiedClassName(cls)] = ctrl;
		}
		
		public function getCtrl(cls:Class):IController
		{
			return ctrlMap[getQualifiedClassName(cls)]; 
		}
		
		public static function get instance():Controller {
			return __instance;
		}
	}
}