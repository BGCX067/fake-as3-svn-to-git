<?php 
/* SVN FILE: $Id: schema.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
/* App schema generated on: 2008-08-27 07:08:30 : 1219846050*/
class AppSchema extends CakeSchema {
	var $name = 'App';

	function before($event = array()) {
		return true;
	}

	function after($event = array()) {
	}

	var $users = array(
			'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
			'email' => array('type' => 'string', 'null' => false, 'length' => 200),
			'password' => array('type' => 'string', 'null' => false, 'length' => 200),
			'created' => array('type' => 'datetime', 'null' => true, 'default' => NULL),
			'modified' => array('type' => 'datetime', 'null' => true, 'default' => NULL),
			'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
		);
}
?>