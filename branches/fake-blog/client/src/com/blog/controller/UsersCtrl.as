package com.blog.controller
{
	import com.blog.model.User;
	import com.blog.view.form.LoginForm;
	import com.blog.view.form.RegisterForm;
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

	public class UsersCtrl extends CakeController
	{
		[Bindable]
		public var login:Action = new Action('login');
		
		private var popup:TitleWindow;
		
		public function UsersCtrl()
		{
			super();
			model = new User;
		}
		
		public function registerClick(event:Event):void
		{
			var registerForm:RegisterForm = new RegisterForm();
			registerForm.action = new Action('register',onRegister);
			registerForm.controller = this;
			registerForm.dataName = model.className;
			
			popup = new TitleWindow;
			popup.title = 'Register';
			popup.addChild(registerForm);
			popup.showCloseButton = true;
			popup.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(popup, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function onRegister(result:ResultSet):void
		{
			close();
			
			Alert.show('You are now registered, please login.');
		}
		
		public function loginClick(event:Event):void
		{
			call(new Action('logout'));
			
			var loginForm:LoginForm = new LoginForm();
			loginForm.action = new Action('login',onLogin);
			loginForm.controller = this;
			loginForm.dataName = model.className;
			
			popup = new TitleWindow;
			popup.title = 'Login';
			popup.addChild(loginForm);
			popup.showCloseButton = true;
			popup.addEventListener(CloseEvent.CLOSE,close);
			
			PopUpManager.addPopUp(popup, Application.application as DisplayObjectContainer, true);
			PopUpManager.centerPopUp(popup);
		}
		
		public function onLogin(result:ResultSet):void
		{
			close();
			
			if ( result.User )
			{
				Alert.show('Successful login.');
				
				User.logged_user = result.User;
				User.logged_id = result.User.id;
				
				Dispatcher.dispatchEvent(new Event('login'));
			}
			else
			{
				Alert.show('Username or Password invalid. Please try again.');
				
				User.logged_user = null;
				User.logged_id = 0;
				
				Dispatcher.dispatchEvent(new Event('logout'));
			}
		}
		
		public function logoutClick(event:Event):void
		{
			call(new Action('logout',onLogout));
		}
		
		public function onLogout(result:ResultSet):void
		{
			User.logged_user = null;
			User.logged_id = 0;
		}
		
		private function close(event:CloseEvent=null):void
		{
			popup.removeEventListener(CloseEvent.CLOSE, close);
			PopUpManager.removePopUp(popup);
		}
		
		public function index():void
		{
			
		}
		
		public function edit():void
		{
			
		}
	}
}