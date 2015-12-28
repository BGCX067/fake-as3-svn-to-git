<?php
/* SVN FILE: $Id: amf.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
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
 * @version			$Revision: 147 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-27 21:22:45 +0700 (Wed, 27 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * AMF Component for enabling some automagic
 *
 * @package		amf
 * @subpackage	amf.controllers.components
 */
class AmfComponent extends Object {
/**
 * Components
 *
 * @return void
 */
	var $components = array('Session');

/**
 * Will handle redirects through dispatcher
 *
 * @var boolean
 **/
	var $autoRedirect = false;

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

			if (!empty($data)) {
				if (is_object($data)) {
					$controller->data = Set::reverse($data);
				} elseif(Set::countDim($data) == 1) {
					$controller->data = array_pop($data);
				} else {
					$controller->data = $data;
				}
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
		if ($controller->isAmf && $this->autoRedirect) {

			if (is_array($url)) {
				$url = Router::url($url);
			}

			$Dispatcher = new Dispatcher();
			$Dispatcher->dispatch($url);
			if($exit) {
				exit();
			}
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
				$controller->viewVars[Inflector::camelize($key)] = $value;
			}
			$flash = $this->Session->read('Message.flash');
			if (!empty($flash)) {
				$controller->viewVars['Message'] = $flash['message'];
			}
		}
	}
}
?>