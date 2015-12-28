<?php 
/* SVN FILE: $Id: user.test.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
/* User Test cases generated on: 2008-08-27 06:08:32 : 1219842392*/
App::import('Model', 'User');

class TestUser extends User {
	var $cacheSources = false;
	var $useDbConfig  = 'test_suite';
}

class UserTestCase extends CakeTestCase {
	var $User = null;
	var $fixtures = array('app.user');

	function start() {
		parent::start();
		$this->User = new TestUser();
	}

	function testUserInstance() {
		$this->assertTrue(is_a($this->User, 'User'));
	}

	function testUserFind() {
		$this->User->recursive = -1;
		$results = $this->User->find('first');
		$this->assertTrue(!empty($results));

		$expected = array('User' => array(
			'id'  => 1,
			'email'  => 'Lorem ipsum dolor sit amet',
			'password'  => 'Lorem ipsum dolor sit amet',
			'created'  => '2008-08-27 06:06:32',
			'modifed'  => '2008-08-27 06:06:32'
			));
		$this->assertEqual($results, $expected);
	}
}
?>