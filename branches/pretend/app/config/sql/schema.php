<?php 
/* SVN FILE: $Id: schema.php 30 2008-03-15 22:59:05Z gwoo.cakephp $ */
/* App schema generated on: 2008-03-15 13:03:48 : 1205611428*/
class AppSchema extends CakeSchema {
	var $name = 'App';

	function before($event = array()) {
		return true;
	}

	function after($event = array()) {
	}

	var $posts = array(
			'id' => array('type'=>'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
			'title' => array('type'=>'string', 'null' => false),
			'body' => array('type'=>'string', 'null' => false),
			'modified' => array('type'=>'datetime', 'null' => false),
			'created' => array('type'=>'datetime', 'null' => false),
			'user_id' => array('type'=>'integer', 'null' => false),
			'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
		);
	var $users = array(
			'id' => array('type'=>'integer', 'null' => false, 'default' => NULL, 'key' => 'primary'),
			'username' => array('type'=>'string', 'null' => true, 'default' => NULL, 'length' => 50),
			'password' => array('type'=>'string', 'null' => true, 'default' => NULL, 'length' => 50),
			'email' => array('type'=>'string', 'null' => true, 'default' => NULL),
			'created' => array('type'=>'datetime', 'null' => true, 'default' => NULL),
			'modified' => array('type'=>'datetime', 'null' => true, 'default' => NULL),
			'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
		);
}
?>