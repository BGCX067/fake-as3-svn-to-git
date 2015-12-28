package com.fake.utils.history
{
	import com.fake.utils.FakeCursor;
	
	public class HistoryManager
	{
		public static var actionCursor:FakeCursor = new FakeCursor();
		
		public static var maxActions:int = 25;
		
		public function HistoryManager()
		{
		}
		
		public static function insertAction(action:Action):void
		{
			trace("start insertAction currentIndex: "+actionCursor.currentIndex);
			
			actionCursor.insert(action);
			
			if(!actionCursor.beforeFirst && actionCursor.currentIndex < actionCursor.length-1)
			{
				actionCursor.source.length = actionCursor.currentIndex + 1;
			}
			
			actionCursor.moveLast();
			
			/* trace("insert:" + action.type);
			
			if(actionCursor.lastObject != action)
			{
				trace("lastObject:" + action.type);
				
				actionCursor.moveNext();
				
				trace("current:" + actionCursor.current.type);
				
				while(actionCursor.moveNext()) {
					trace("remove:" + actionCursor.current.type);
					//actionCursor.remove();
				}
				trace("previous:" + actionCursor.current.type);
				actionCursor.movePrevious()
			} */
			
			// if there are 25 commands in the array, remove the first item then move the cursor to the top of the array
			/* if(actionCursor.source.length == maxActions)
			{
				actionCursor.moveFirst();
				actionCursor.remove();
				actionCursor.moveLast();
			} */
			trace("end insertAction currentIndex: "+actionCursor.currentIndex);
		}
		
		public static function redoAction():void
		{
			trace("start redoAction currentIndex: "+actionCursor.currentIndex);
			
			if(actionCursor.current)
			{
				var action:Action = Action(actionCursor.current);
				action.execute("redo");
			}
			
			actionCursor.moveNext();
			
		/* 	if(actionCursor.current == null)
				return; */
			
			trace("end redoAction currentIndex: "+actionCursor.currentIndex);
		}
		
		public static function undoAction():void
		{
			trace("start undoAction currentIndex: "+actionCursor.currentIndex);
			
			if(actionCursor.currentIndex == 0)
				return;
				
			actionCursor.movePrevious()
			
			// cast the current item in the cursor and undo
			var action:Action = Action(actionCursor.current);
			action.execute("undo");
			
			
			
			trace("end undoAction currentIndex: "+actionCursor.currentIndex);
		}
	}
}