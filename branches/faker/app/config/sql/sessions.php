<?php
/* SVN FILE: $Id: sessions.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
/*Sessions schema generated on: 2007-11-25 07:11:54 : 1196004714*/
/**
 * This is Sessions Schema file
 *
 * Use it to configure database for Sessions
 *
 * PHP versions 4 and 5
 *
 * CakePHP(tm) :  Rapid Development Framework <http://www.cakephp.org/>
 * Copyright 2005-2008, Cake Software Foundation, Inc.
 *								1785 E. Sahara Avenue, Suite 490-204
 *								Las Vegas, Nevada 89104
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2005-2008, Cake Software Foundation, Inc.
 * @link				http://www.cakefoundation.org/projects/info/cakephp CakePHP(tm) Project
 * @package			cake
 * @subpackage		cake.app.config.sql
 * @since			CakePHP(tm) v 0.2.9
 * @version			$Revision: 147 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-27 21:22:45 +0700 (Wed, 27 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
/*
 *
 * Using the Schema command line utility
 * cake schema run create Sessions
 *
 */
class SessionsSchema extends CakeSchema {

	var $name = 'Sessions';

	function before($event = array()) {
		return true;
	}

	function after($event = array()) {
	}

	var $cake_sessions = array(
			'id' => array('type'=>'string', 'null' => false, 'key' => 'primary'),
			'data' => array('type'=>'text', 'null' => true, 'default' => NULL),
			'expires' => array('type'=>'integer', 'null' => true, 'default' => NULL),
			'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
		);

}
?>