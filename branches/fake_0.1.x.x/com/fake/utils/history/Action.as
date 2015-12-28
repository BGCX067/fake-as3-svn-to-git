package com.fake.utils.history
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class Action
	{
		public var id:String; 
		public var type:String;
		
		public var inGroup:Boolean = false;
		
		protected static var _actionMap:Object = {};
		
		protected var _targets:Array = [];
		protected var _properties:Object = {};
		
		public function Action(id:String = null, type:String = null, targets:Array = null, properties:Object = null)
		{
			this.id = id;
			this.type = type;			

			if(targets)
				this.targets = targets;
			if(properties)
				this.properties = properties;
		}
		
		public function execute(kind:String):void
		{
			this[kind]();  // "undo" or "redo"
		}
		
		public function undo():void {
			
		}
		
		public function redo():void {
			
		}
		
		public static function get actionMap():Object {
			return _actionMap;
		}
		public static function set actionMap(value:Object):void {
			_actionMap = value;
		}
		
		public function get targets():Array {
			return _targets;
		}
		public function set targets(value:Array):void {
			_targets = value;
		}
		
		public function get properties():Object {
			return _properties;
		}
		public function set properties(value:Object):void {
			_properties = value;
		}
		
		public static var ADD:String = "add";
		public static var REMOVE:String = "remove";
		public static var MOVE:String = "move";
		public static var PROPERTY_CHANGE:String = "propertyChange";
		public static var GROUP:String = "group";
	}
}