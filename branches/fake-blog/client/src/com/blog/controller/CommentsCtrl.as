package com.blog.controller
{
	import com.blog.model.Comment;
	import com.blog.view.form.CommentForm;
	import com.fake.controller.Action;
	import com.fake.controller.CakeController;
	import com.fake.model.ResultSet;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class CommentsCtrl extends CakeController
	{
		public var post_id:String;
		
		[Bindable] public var list:Object;
		
		public function CommentsCtrl()
		{
			super();
			model = new Comment;
			
			//Dispatcher.addEventListener('commentsClick',commentsClick);
		}
		
		public function index():void
		{
			var action:Action = new Action('index',onIndex);
			action.params.push(post_id);
			call(action);
		}
		
		public function onIndex(result:ResultSet):void
		{
			list = result.Comment.list;
		}
		
		private var popup:TitleWindow;
		public function addClick():void
		{
			var action:Action = new Action('add',onAdd);
			
			var form:CommentForm = new CommentForm;
			form.action = action;
			form.dataName = model.className;
			form.controller = this;
			form.post_id = post_id;
			
			popup = new TitleWindow;
			popup.title = 'Add Comment';
			popup.addChild(form);
			popup.showCloseButton = true;
			popup.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(popup, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function onAdd(result:ResultSet):void
		{
			index();
			close(null);
			
			Alert.show('Comment added.');
		}
		
		private function close(event:CloseEvent):void
		{
			PopUpManager.removePopUp(popup);
			popup.removeEventListener(CloseEvent.CLOSE, close);
		}
		
		/*
		public function commentsClick(event:FakeEvent):void
		{
			var action:Action = new Action('index',onCommentsClick);
			action.params.push(event.data);
			call(action);
		}
		
		public function onCommentsClick(result:ResultSet):void
		{
			// USAR POPUPUTIL
		}
		*/
	}
}