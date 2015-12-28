<?php
/* SVN FILE: $Id: amf.php 12 2008-03-11 01:42:39Z gwoo.cakephp $ */
/**
 * A custom view class for outputting data in AMF format
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
 * @subpackage		amf.views
 * @since			2007-05-27
 * @version			$Revision: 12 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-03-11 07:42:39 +0600 (Tue, 11 Mar 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
/**
 * AMF view class
 *
 * @package			amf
 * @subpackage		amf.views
 */
class AmfView extends View {
	var $viewVars = array();
	var $compress = false;
	var $stream = '';

	var $binaryType = array();
	var $binaryLength = array();
	var $bigEndian = false;
	var $references = array();
	var $stored = array();
	var $types = array();
	var $encoding = null;
	// holds total number of body parts
	var $requests = 0;
	// holds the current body part $i
	var $request = 0;
	var $header = array();
	var $body = array();

	var $__hasRendered = false;

	function __construct(&$controller) {
		if(is_object($controller)) {
			$this->viewVars = $controller->viewVars;
			if(isset($controller->compress)) {
				$this->compress = $controller->compress;
			}
			if($this->compress === true) {
				$this->compress = 30100;
			}
			$dispatcher = AmfDispatcher::getInstance();

			$vars = array('binaryType', 'binaryLength', 'bigEndian', 'references', 'stored',
							'types', 'requests', 'request', 'header', 'body', 'encoding'
						);
			foreach($vars as $var) {
				$this->{$var} = $dispatcher->{$var};
			}
		}
		if (ClassRegistry::isKeySet('amfview')) {
			$amf = ClassRegistry::getObject('amfview');
			$this->stream = $amf->stream;
			$this->__hasRendered = $amf->__hasRendered;
		}
		ClassRegistry::addObject('amfview', $this);
	}

	function render($action = null, $layout = null, $file = null) {
		if($this->__hasRendered) {
			return;
		}
		if ($this->request === 1) {
			header('Content-type: application/x-amf');
			$this->_render(0, 'byte');
			$this->_render($this->encoding, 'byte');

			$this->_render(0, 'int');

			if (!empty($this->header)) {
				$this->_render($this->request, 'int');
				$this->_render(0, 'byte');

				$this->_render('cake', 'utf');
				$this->_render(0, 'byte');
				$tmp = $this->stream;
				$this->stream = '';
				$data = $this->__encode('cool');
				$this->stream = $tmp;
				$this->_render(strlen($data), 'long');
				$this->_render($data);
			}
			$this->_render($this->requests, 'int');
		}

		if (!empty($this->body)) {
			$this->_render($this->body['response'].'/onResult', 'utf');
			$this->_render("null", 'utf');
			$tmp = $this->stream;
			$this->stream = '';
			$data = $this->__encode($this->viewVars);
			$this->stream = $tmp;
			$this->_render(strlen($data), 'long');
			$this->_render($data);
		}

		if($this->request === $this->requests) {
			$ob = @ini_get("zlib.output_compression") && extension_loaded("zlib") && (strpos(env('HTTP_ACCEPT_ENCODING'), 'gzip') !== false);
			$length = strlen($this->stream);

			if($ob && $this->compress && $length > $this->compress) {
				ob_start();
				ob_start('ob_gzhandler');
			} else {
				header("Content-length: " . $length);
				$this->compress = false;
			}

			print($this->stream);

			if($this->compress) {
				ob_end_flush();
				header("Content-length: " . ob_get_length());
				ob_end_flush();
			}
			$this->__hasRendered = true;
		}
	}
	function _render($data, $fmt = null) {
		if ($fmt == null) {
			$fmt = 'str';
			if(is_bool($data)) {
				$fmt = 'bool';
			} else if (is_float($data)) {
				$fmt = 'float';
			} else if (is_int($data)) {
				$fmt = 'int';
			} else if(is_array($data)) {
				$fmt = 'long';
			} else if(is_object($data)){
				$fmt = 'long';
			}
		}

		if ($fmt == 'utf') {
			$utf = utf8_encode($data);
			$data = strlen($utf);
			$fmt = 'int';
		}

		if ($this->binaryType[$fmt] != null) {
			$data = pack($this->binaryType[$fmt], $data);
		}

		if ($this->binaryType[$fmt] == 'float' && $this->bigEndian) {
			$data = strrev($data);
		}

		$this->stream .= $data;

		if(isset($utf)) {
			$this->stream .= $utf;
		}

	}

	function __encode($value) {
		if(function_exists('amf_encode')) {
			return amf_encode($value, 1);
		}
		if(is_object($value)) {
			return 'doh, encoding not done. get AMFEXT';
		}
		return $value;
	}
}
?>