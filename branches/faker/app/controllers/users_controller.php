<?php
class UsersController extends AppController {

	var $name = 'Users';
	
	//var $scaffold;
	
	function beforeFilter() {
		parent::beforeFilter();
		$this->Auth->allow('add', 'index');
		$this->Auth->autoRedirect = false;
	}
	
	function login() {
		if ($user = $this->Auth->user()) {
			$this->set('user', $user);
		} else {
			$this->set('error', 'Not Logged in');
		}
	}
	
	function index() {
		$this->User->recursive = 0;
		$this->set('users', $this->paginate());
	}
}
?>