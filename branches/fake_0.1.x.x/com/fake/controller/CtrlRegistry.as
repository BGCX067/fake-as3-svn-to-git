package com.fake.controller
{
	import flash.utils.getQualifiedClassName;
	
	public class CtrlRegistry
	{
		private static var __instance:CtrlRegistry = new CtrlRegistry();
		
		public var ctrlMap:Object = new Object();
		
		public function CtrlRegistry()
		{
		}
		
		/**
		 * Takes an instance of a Controller and sav
		 */		
		public function register(ctrl:IController, cls:Class):void
		{
			
			ctrlMap[getQualifiedClassName(cls)] = ctrl;
		}
		
		public function getCtrl(cls:Class):IController
		{
			return ctrlMap[getQualifiedClassName(cls)]; 
		}
		
		public static function get instance():CtrlRegistry {
			return __instance;
		}
	}
}