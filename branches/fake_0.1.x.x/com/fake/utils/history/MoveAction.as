package com.fake.utils.history
{
	public class MoveAction extends Action
	{
		public function MoveAction(id:String = null, type:String=null, targets:Array=null, properties:Object=null)
		{
			super(id, type, targets, properties);
		}
		
		public static function start(id:String, targets:Array):MoveAction
		{
			var props:Object = {x: targets[0].x, y: targets[0].y, x1: -1, y1: -1};
			
			var action:MoveAction = new MoveAction(id, Action.MOVE, targets, props);
			
			actionMap[id] = action;
			
			return actionMap[id] as MoveAction;
		}
		
		public static function end(id:String):MoveAction
		{
			var action:MoveAction = actionMap[id] as MoveAction;
			action.properties.x1 = action.targets[0].x;
			action.properties.y1 = action.targets[0].y;
			
			if(!action.inGroup)
				HistoryManager.insertAction(action);
			
			return action as MoveAction;
		}
		
		override public function undo():void
		{
			for each(var target:Object in targets)
			{
				target.x = properties.x;
				target.y = properties.y;
			}
		}
		
		override public function redo():void
		{
			for each(var target:Object in targets)
			{
				target.x = properties.x1;
				target.y = properties.y1;
			}
		}
	}
}