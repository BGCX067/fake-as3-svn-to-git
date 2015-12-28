/* SVN FILE: $Id: LoginCtrl.as 246 2009-05-29 23:02:36Z gwoo.cakephp $ */
package com.faker.controller.users
{
	import com.fake.model.ResultSet;
	import com.faker.model.User;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.TextInput;
	public class LoginCtrl extends Canvas
	{
		public var User_email:TextInput;
		public var User_password:TextInput;

		public function LoginCtrl()
		{
			super();
		}

		public function submit():void
		{
			var user:User = new User();
			
			user.login(onLogin, {
				User: {email: User_email.text, password: User_password.text}
			});
		}

		public function onLogin(result:ResultSet):void
		{
			if (result.data !== null)
			{
				Alert.show('Login Successful');
			}
			else
			{
				Alert.show('Invalid Login');
			}
		}
	}
}
