<?php 
/* SVN FILE: $Id: user_fixture.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
/* User Fixture generated on: 2008-08-27 06:08:32 : 1219842392*/

class UserFixture extends CakeTestFixture {
	var $name = 'User';
	var $fields = array(
			'id' => array('type'=>'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
			'email' => array('type'=>'string', 'null' => false, 'length' => 200),
			'password' => array('type'=>'string', 'null' => false, 'length' => 200),
			'created' => array('type'=>'datetime', 'null' => true, 'default' => NULL),
			'modifed' => array('type'=>'datetime', 'null' => true, 'default' => NULL),
			'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
			);
	var $records = array(array(
			'id'  => 1,
			'email'  => 'Lorem ipsum dolor sit amet',
			'password'  => 'Lorem ipsum dolor sit amet',
			'created'  => '2008-08-27 06:06:32',
			'modifed'  => '2008-08-27 06:06:32'
			));
}
?>