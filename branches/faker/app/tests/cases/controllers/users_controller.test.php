<?php 
/* SVN FILE: $Id: users_controller.test.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
/* UsersController Test cases generated on: 2008-08-27 06:08:45 : 1219843065*/
App::import('Controller', 'Users');

class TestUsers extends UsersController {
	var $autoRender = false;
}

class UsersControllerTest extends CakeTestCase {
	var $Users = null;

	function setUp() {
		$this->Users = new TestUsers();
		$this->Users->constructClasses();
	}

	function testUsersControllerInstance() {
		$this->assertTrue(is_a($this->Users, 'UsersController'));
	}

	function tearDown() {
		unset($this->Users);
	}
}
?>