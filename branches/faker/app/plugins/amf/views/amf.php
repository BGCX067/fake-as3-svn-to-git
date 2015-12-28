<?php
/* SVN FILE: $Id: amf.php 147 2008-08-27 14:22:45Z gwoo.cakephp $ */
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
 * @version			$Revision: 147 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-08-27 21:22:45 +0700 (Wed, 27 Aug 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
/**
 * AMF view class
 *
 * @package			amf
 * @subpackage		amf.views
 */
class AmfView extends View {
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $viewVars = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $compress = false;
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $stream = '';
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $binaryType = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $binaryLength = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $bigEndian = false;
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $references = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $stored = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $types = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $encoding = null;
/**
 * holds total number of body parts
 *
 * @var string
 **/
	var $requests = 0;
/**
 * holds the current body part $i
 *
 * @var string
 **/
	var $request = 0;
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $header = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $body = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $__hasRendered = false;
/**
 * undocumented function
 *
 * @return void
 *
 **/
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
	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function render($action = null, $layout = null, $file = null) {
		if(!function_exists('amf_encode')) {
			echo('Doh, you need the AMFEXT. http://pecl.php.net/package/amfext');
			return;
		}
		if($this->__hasRendered) {
			return;
		}
		if ($this->request === 1) {
			header('Content-type: application/x-amf');
			$this->_render($this->encoding, 'int');

			$headers = array();
			if (!empty($this->viewVars['headers'])) {
				$headers = array_merge((array)$this->header, $this->viewVars['headers']);
				unset($this->viewVars['headers']);
			}

			$this->_render(count($headers), 'int');
			if (!empty($headers)) {
				foreach ($headers as $header => $value) {
					$this->_render($header, 'utf');
					$this->_render(0, 'bool');
					$data = $this->__encodeHeader($value);
					$this->_render(strlen($data), 'long');
					$this->_render($data);
				}
			}
			$this->_render($this->requests, 'int');
		}

		if (!empty($this->body)) {
			$response = 'onResult';
			if (!empty($this->viewVars['Error'])) {
				$response = 'onStatus';
			}
			$this->_render($this->body['response'] . '/' . $response, 'utf');
			$this->_render('null', 'utf');
			$data = $this->__encodeBody($this->viewVars);
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

			AmfStream::output();

			if($this->compress) {
				ob_end_flush();
				header("Content-length: " . ob_get_length());
				ob_end_flush();
			}
			$this->__hasRendered = true;
		}
	}

/**
 * undocumented function
 *
 * @return void
 *
 **/
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

		AmfStream::write($data);

		if(isset($utf)) {
			AmfStream::write($utf);
		}
	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function __encodeBody($value) {
		if (!class_exists('AmfCallback')) {
			App::import('Vendor', 'Amf.AmfCallback');
		}

		$AmfCallback =& new AmfCallback($this);

		if (!empty($value['Error'])) {
			if (!is_array($value['Error'])) {
				$error = array('string' => $value['Error']);
			}
			unset($value['Error']);

			$data = array('Error' => array_merge(array('body' => $value), $error));
		} else {
			$data = array('ResultSet' => $value);
		}
		$result = amf_encode(Set::map($data), 1, array($AmfCallback, "encode"));
		return $result;
	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function __encodeHeader($value) {
		$result = amf_encode($value, 1);
		return $result;
	}
}
/**
 * Singleton class used for AMF stream management.
 *
 * @package default
 */
class AmfStream {
	/**
	 * AMF Stream contents
	 *
	 * @var string
	 */
	var $__stream = '';

	/**
	 * Returns the AmfStream singleton instance. (Don't cross the streams)
	 *
	 * @return object AmfStream
	 */
	function &getInstance() {
		static $instance = array();
		if(!$instance) {
			$instance[0] =& new AmfStream();
		}
		return $instance[0];
	}

	/**
	 * Writes (concatenates by default) to the stream
	 *
	 * @param string $data
	 * @param string $append
	 * @return true
	 */
	function write($data, $append = true) {
		$_this =& AmfStream::getInstance();
		if($append) {
			$_this->__stream .= $data;
		} else {
			$_this->__stream = $data;
		}
		return true;
	}

	/**
	 * Returns the contents of the AMF stream.
	 *
	 * @return string stream
	 */
	function read() {
		$_this =& AmfStream::getInstance();
		return $_this->__stream;
	}

	/**
	 * Prints the AMF stream out to the buffer and resets the stream's contents.
	 *
	 * @return true
	 */
	function output() {
		$_this =& AmfStream::getInstance();
		print($_this->__stream);
		$_this->reset();
		return true;
	}

	/**
	 * Resets the stream contents.
	 *
	 * @return true
	 */
	function reset() {
		$_this =& AmfStream::getInstance();
		$_this->__stream = '';
		return true;
	}
}
?>