<?php
/* SVN FILE: $Id: amf.php 12 2008-03-11 01:42:39Z gwoo.cakephp $ */
/**
 * A custom component for automagically handling some AMF setup
 *
 * CakeAMF
 * Copyright 2007, Cake Software Foundation, Inc.
 *					1785 E. Sahara Avenue, Suite 490-204
 *					Las Vegas, Nevada 89104
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2007, Cake Software Foundation, Inc.
 * @link			http://trac.cakefoundation.org/amf CakeAMF
 * @package			amf
 * @subpackage		amf.controllers.components
 * @since			2007-05-27
 * @version			$Revision: 12 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-11 07:42:39 +0600 (Tue, 11 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * AMF Component for enabling some automagic
 *
 * @package		amf
 * @subpackage	amf.controllers.components
 */
class AmfComponent extends Object {
	
	var $components = array('Session');
/**
 * Startup
 *
 * @param object $controller
 * @return void
 */
	function initialize(&$controller) {
		$controller->isAmf = false;
		if (class_exists('amfdispatcher') && AmfDispatcher::active()) {
			$controller->isAmf = true;
			$controller->disableCache();
			$controller->view = 'Amf.Amf';
			$data = AmfDispatcher::data();
			if(is_array($data) || is_object($data)) {
				$controller->data = $data;
			}
		}
	}
/**
 * Intercept redirect and render amf response
 *
 * @param object $controller
 * @return void
 */
	function beforeRedirect(&$controller, $url, $status = null, $exit = true) {
		if ($controller->isAmf) {
			
			if (is_array($url)) {
				$url = Router::url($url);
			}
			
			$Dispatcher = new Dispatcher();
			$Dispatcher->dispatch($url);
			if($exit) {
				exit();
			}
			
			/*
			$controller->viewVars = am($controller->viewVars, array('Result'=> true));
			$controller->render();
			if($exit) {
				exit();
			}
			*/
		}
	}
/**
 * Override Controller::beforeRender() for Amf
 *
 * @return void
 */
	function beforeRender(&$controller) {
		if ($controller->isAmf) {
			Configure::write('debug', 0);
			foreach($controller->viewVars as $key => $value) {
				unset($controller->viewVars[$key]);
				$controller->viewVars[Inflector::classify($key)] = $value;
			}
			$flash = $this->Session->read('Message.flash');
			if (!empty($flash)) {
				$controller->viewVars['Message'] = $flash['message'];
			}
		}
	}
/**
 * Get the passed id from amf, url, or form post
 *
 * @param $id
 * @return valid id or exit with error
 */
	function _id($id = null) {
		if (!empty($this->data->id)) {
			$id = $this->data->id;
		} elseif (!empty($this->data[$this->modelClass]['id'])) {
			$id = $this->data[$this->modelClass]['id'];
		} elseif (!empty($this->params['id'])) {
			$id = $this->params['id'];
		}
		if(!$id) {
			$this->set('error', true);
			exit();
		}
		return $id;
	}	
}
?>