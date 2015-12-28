package com.fake.utils.history
{
	public class GroupAction extends Action
	{
		public function GroupAction(id:String=null, type:String=null, targets:Array=null, properties:Object=null)
		{
			super(id, Action.GROUP, targets, properties);
			
			actionMap[id] = this;
		}
		
		public static function add(id:String, actions:Array):GroupAction
		{
			var action:GroupAction = new GroupAction(id);
			
			for each(var target:Action in actions) {
				target.inGroup = true;
				action.targets.push(target);
			}
			
			return action;
		}
		
		public static function end(id:String):GroupAction
		{
			var groupAction:GroupAction = actionMap[id];
			
			for each(var action:Action in groupAction.targets)
			{
				if(action is MoveAction)
					MoveAction.end(action.id);
				else if(action is PropertyChangeAction)
					PropertyChangeAction.end(action.id);
				else if(action is AddAction)
					AddAction.end(action.id);
				else if(action is RemoveAction)
					RemoveAction.end(action.id);
			}

			HistoryManager.insertAction(groupAction);
			
			return groupAction as GroupAction;
		}
		
		override public function undo():void 
		{
			for each(var action:Action in targets)
			{
				action.undo();
			}
		}
		
		override public function redo():void 
		{
			for each(var action:Action in targets)
			{
				action.redo();
			}
		}
	}
}