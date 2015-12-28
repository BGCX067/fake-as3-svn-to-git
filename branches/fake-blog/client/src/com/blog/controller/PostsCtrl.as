package com.blog.controller
{
	import com.blog.model.Post;
	import com.blog.view.Comments;
	import com.blog.view.form.PostForm;
	import com.fake.controller.Action;
	import com.fake.controller.CakeController;
	import com.fake.model.ResultSet;
	import com.fake.utils.Dispatcher;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import mx.containers.TitleWindow;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;

	public class PostsCtrl extends CakeController
	{
		[Bindable] public var list:Object;
		
		public var popup:TitleWindow;
		
		public function PostsCtrl()
		{
			super();
			model = new Post;
			
			Dispatcher.addEventListener('login',index);
			Dispatcher.addEventListener('logout',index);
			Dispatcher.addEventListener('Post.updated',index);
		}
		
		public function index(event:Event=null):void
		{
			call(new Action('index',onIndex));
		}
		
		public function onIndex(result:ResultSet):void
		{
			list = result.Post.list;
		}
		
		public function editClick(post_id:String):void
		{
			var action:Action = new Action('edit',onEdit);
			action.params.push(post_id);
			edit(action);
		}
		
		public function edit(action:Action):void
		{
			if (!action){
				var action:Action = new Action('edit',onEdit);
			}
			
			var form:PostForm = new PostForm;
			form.action = action;
			form.dataName = model.className;
			form.controller = this;
			
			popup = new TitleWindow;
			popup.title = 'Edit Post';
			popup.addChild(form);
			popup.showCloseButton = true;
			popup.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(popup, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function onEdit(result:ResultSet):void
		{
			popup.removeEventListener(CloseEvent.CLOSE, close);
			PopUpManager.removePopUp(popup);
				
			Alert.show('Post updated.');
			
			index();
		}
		
		public function addClick():void
		{
			add(new Action('add',onAdd));
		}
			
		public function add(action:Action):void
		{
			if (!action){
				action = new Action('add',onAdd);
			}
			
			var form:PostForm = new PostForm;
			form.action = action;
			form.dataName = model.className;
			form.controller = this;
			
			popup = new TitleWindow;
			popup.title = 'Add Post';
			popup.addChild(form);
			popup.showCloseButton = true;
			popup.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(popup, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function onAdd(result:ResultSet):void
		{
			popup.removeEventListener(CloseEvent.CLOSE, close);
			PopUpManager.removePopUp(popup);
				
			Alert.show('Post added.');
			
			index();
		}
		
		public function commentsClick(post_id:String):void
		{
			var comments:Comments = new Comments;
			//comments.post_id = event.currentTarget.parent.label;
			comments.post_id = post_id;
			comments.index();
			
			var commentsWindow:TitleWindow = new TitleWindow;
			commentsWindow.title = 'Comments';
			commentsWindow.addChild(comments);
			commentsWindow.showCloseButton = true;
			commentsWindow.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(commentsWindow, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(commentsWindow);
		}
		
		private function close(event:CloseEvent):void
		{
			PopUpManager.removePopUp(event.currentTarget as IFlexDisplayObject);
			
			event.currentTarget.removeEventListener(CloseEvent.CLOSE, close);
		}
		
	}
}