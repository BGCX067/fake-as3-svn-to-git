package com.fake.utils.history
{
	public class PropertyChangeAction extends Action
	{
		public function PropertyChangeAction(id:String = null, type:String=null, targets:Array=null, properties:Object=null)
		{
			super(id, type, targets, properties);
		}
		
		public static function start(id:String, propertyName:String, targets:Array):PropertyChangeAction
		{
			var action:PropertyChangeAction = new PropertyChangeAction(id, Action.PROPERTY_CHANGE, targets);

			action.properties.propertyName = propertyName;
			action.properties[propertyName + "_old"] = targets[0][propertyName];
			
			actionMap[id] = action;
			
			return actionMap[id] as PropertyChangeAction;
		}
		
		public static function end(key:String):PropertyChangeAction
		{
			var action:PropertyChangeAction = actionMap[key];
			action.properties[action.properties.propertyName + "_new"] = action.targets[0][action.properties.propertyName];
			
			if(!action.inGroup)
				HistoryManager.insertAction(action);
			
			return action as PropertyChangeAction;
		}
		
		override public function undo():void
		{
			var propertyName:String = properties["propertyName"]
			
			for each(var target:Object in targets) {
				target[propertyName] = properties[propertyName + "_old"];
			}
		}
		
		override public function redo():void
		{
			var propertyName:String = properties["propertyName"]
			
			for each(var target:Object in targets) {
				target[propertyName] = properties[propertyName + "_new"];
			}
		}
	}
}