package com.fake.utils.history
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class AddAction extends Action
	{
		public function AddAction(id:String=null, type:String=null, targets:Array=null, properties:Object=null)
		{
			super(id, type, targets, properties);
		}
		
		public static function start(id:String, container:Object, targets:Array = null):AddAction
		{
			var action:AddAction = new AddAction(id, Action.ADD, targets, {container: container});
			
			actionMap[id] = action;
			
			return action;
		}
		
		public static function end(id:String):AddAction
		{
			var action:AddAction = actionMap[id] as AddAction;

			if(!action.inGroup)
				HistoryManager.insertAction(action);
				
			return action;
		}
		
		override public function undo():void
		{
			if(properties.container is DisplayObjectContainer)
			{
				for each(var target:Object in targets) {
					DisplayObjectContainer(properties.container).removeChild(DisplayObject(target));
				}
			}
			else
			{
				for each(target in targets) {
					properties.container = properties.container.splice(properties.container.indexOf(target), 1);
				}
			}
		}
		
		override public function redo():void
		{
			if(properties.container is DisplayObjectContainer)
			{
				for each(var target:Object in targets) {
					DisplayObjectContainer(properties.container).addChild(DisplayObject(target));
				}
			}
			else
			{
				for each(target in targets) {
					properties.container = properties.container.push(target);
				}
			}
		}
	}
}