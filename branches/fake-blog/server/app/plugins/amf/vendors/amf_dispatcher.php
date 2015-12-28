<?php
/* SVN FILE: $Id$ */
/**
 * A custom dispatcher for handling AMD requests
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
 * @subpackage		amf.vendors
 * @since			2007-05-27
 * @version			$Revision$
 * @modifiedby		$LastChangedBy$
 * @lastmodified	$Date$
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
App::import('Core', 'Dispatcher');
/**
 * Amf Dispatcher class
 *
 * @package			amf
 * @subpackage		amf.vendors
 */
class AmfDispatcher extends Object {
/**
 * Raw AMF input data
 *
 * @var mixed
 */
	var $input = null;
/**
 * Current input buffer offset
 *
 * @var integer
 */
	var $offset = 0;
/**
 * Holds current class name for remote object
 *
 * @var integer
 */
	var $class = null;
/**
 * Binary type mappings
 *
 * @var array
 */
	var $binaryType = array('byte' => 'c', 'int' => 'n', 'float' => 'd', 'long' => 'N', 'str' => null);
/**
 * Binary variable length mappings
 *
 * @var array
 */
	var $binaryLength = array('byte' => 1, 'int' => 2, 'float' => 8, 'long' => 4, 'str' => null);
/**
 * Whether the current encoding is big endian or little endian
 *
 * @var boolean
 */
	var $bigEndian = false;
/**
 * Enter description here...
 *
 * @var unknown_type
 */
	var $references = array();
/**
 * Stored object references
 *
 * @var array
 */
	var $stored = array();
/**
 * Variable type signatures
 *
 * @var array
 */
	var $types = array(
		array('float' => 0x00, 'byte' => 0x01, 'str' => 0x02, 'object' => 0x03, 'movie_clip' => 0x04, 'null' => 0x05,
			'undefined' => 0x06, 'reference' => 0x07, 'mixed_array' => 0x08, 'object_term' => 0x09, 'array' => 0x0a,
			'date' => 0x0b, 'long_string' => 0x0c, 'unsupported' => 0x0e, 'xml' => 0x0f, 'typed_object' => 0x10, 'amf3' => 0x11),
		array('undefined' => 0x00, 'null' => 0x01, 'bool_false' => 0x02, 'bool_true' => 0x03, 'integer' => 0x04,
			'number' => 0x05, 'str' => 0x06, 'xml' => 0x07, 'date' => 0x08, 'array' => 0x09, 'object' => 0x0A,
			'xml_string' => 0x0B, 'obj_inline' => 0x01, 'class_inline' => 0x02, 'prop_def' => 0x04, 'prop_serial' => 0x08));
/**
 * AMF request headers
 *
 * @var array
 */
	var $headers = array();
/**
 * AMF request bodies
 *
 * @var array
 */
	var $bodies = array();
/**
 * AMF encoding; either 0 or 3
 *
 * @var integer
 */
	var $encoding = 3;
/**
 * Total requests for call
 *
 * @var array
 */
	var $requests = 0;
/**
 * Current request count
 *
 * @var array
 */
	var $request = 0;

/**
 * Current request header
 *
 * @var array
 */
	var $header = array();
/**
 * Current request body
 *
 * @var array
 */
	var $body = array();

/**
 * Enter description here...
 *
 * @return unknown
 */
	function &getInstance() {
		static $instance = array();
		if (!isset($instance[0]) || !$instance[0]) {
			$instance[0] =& new AmfDispatcher();
		}
		return $instance[0];
	}
/**
 * Enter description here...
 *
 * @param unknown_type $input
 * @return unknown
 */
	function parse($input = null) {
		$_this =& AmfDispatcher::getInstance();
		if ($input) {
			$_this->input = $input;
		}

		if ($_this->input === null) {
			$_this->input = file_get_contents('php://input');
		}
		if (empty($_this->input)) {
			return;
		}

		@list($tmp0, $tmp) = unpack('C*', pack('S*', 256));

		$_this->bigEndian = !($tmp == 1);
		@list($first, $clientType) = array($_this->read('byte'), $_this->read('byte'));

		if (!($first == 0 || $first == 3)) {
			trigger_error("Malformed AMF message, connection may have dropped");
			exit();
		}
		$headerSize = $_this->read('int');

		for($i = 0; $i < $headerSize; $i++) {
			$header = array('name' => $_this->__find('str'), 'required' => $_this->read('byte') == true);
			$header['type'] = $_this->__next();
			$current = $_this->read('long');
			$header['data'] = $_this->__decode($header['type']);
			$_this->headers[] = $header;
		}

		$bodySize = $_this->read('int');

		for($i = 0; $i < $bodySize; $i++) {
			$target = $_this->__find('str');

			if (!$target) {
				return false;
			}

			$body = array('target' => $target, 'response' => $_this->__find('str'),
						'length' => $_this->read('long'), 'type' => $_this->__next()
						);

			$hasData = $_this->read('long');

			if (!$hasData) {
				$body['data'] = null;
			} else {
				$body['data'] = $_this->__decode($body['type']);
			}

			$_this->bodies[] = $body;
		}

		$_this->input = true;
	}
/**
 * Enter description here...
 *
 * @return unknown
 */
	function forward() {
		$_this =& AmfDispatcher::getInstance();
		$_this->parse();

		if ($_this->input !== null) {

			$target = null;

			$Inflector =& Inflector::getInstance();

			$_this->requests = count($_this->bodies);

			for($i = 0; $i < $_this->requests; $i++) {
				$_this->request++;

				if (isset($_this->headers[$i])) {
					$_this->header = $_this->headers[$i];
				}

				$_this->body = $_this->bodies[$i];
				unset($_this->bodies[$i]);

				if (isset($_this->body['target'])) {
					$target = $_this->body['target'];
				}

				$_this->__dispatch($target);
			}
			exit();
		}
		return false;
	}
/*
 *	Dispatch the methods
 */
	function __dispatch($target) {
		$_this =& AmfDispatcher::getInstance();

		if ($target !== "null" && $target !== "createStream") {
			$url = $target;
			if (strpos($target, '/') === false) {
				$target = explode('.', $target);
				$target[0] = Inflector::underscore($target[0]);
				$url = join('/',  $target);
			}
			$Dispatcher = new Dispatcher();
			$Dispatcher->dispatch($url);
		} else {
			App::import('view', 'Amf.amf');
			$controller = null;
			$View = new AmfView($controller);
			$message = $_this->body['data'];

			if ($target === 'createStream') {
				$View->viewVars = 10;
			}

			if (get_class($message) == 'RemotingMessage') {
				$View->viewVars = $message;
			} else {
				$View->viewVars = $message;
			}
			$View->render();
		}
		return true;
	}
/**
 * Enter description here...
 *
 * @param unknown_type $type
 * @return unknown
 */
	function active() {
		$_this =& AmfDispatcher::getInstance();
		if ($_this->input) {
			return true;
		}
		return false;
	}


/**
 * Enter description here...
 *
 * @param integer $body the numeric key of the body
 * @return unknown
 */
	function &data() {
		$_this =& AmfDispatcher::getInstance();
		return $_this->body['data'];
	}

/**
 * Enter description here...
 *
 * @param unknown_type $type
 * @return unknown
 */
	function __find($type = null) {
		$_this =& AmfDispatcher::getInstance();

		if ($type == null) {
			$type = $_this->__next();
		}

		switch($type) {
			case 'float': case 'byte':
				return $_this->read($type);
			case 'null':
			case 'undefined':
			case 'unsupported':
				return null;
			case 'str': case 'string':
				return $_this->read($_this->read('int'), 'str');
			case 'long_string': case 'longString':
				return $_this->read($_this->read('long'), 'str');
			break;
		}
	}
/**
 * Gets a reference to a stored object by object ID
 *
 * @param int $id Object ID
 * @return array An array containing the object ID, and a copy of the referenced
 *               object.
 */
	function __ref($id = null) {
		$_this =& AmfDispatcher::getInstance();

		if ($id === null) {
			$id = $_this->read('int');
		}

		if (($id & 0x01) == 0) {
			$id = $id >> 1;

			if ($id >= count($_this->stored)) {
				$object = false;
			} else {
				$object = $_this->stored[$id];
			}
		} else {
			$object = null;
		}
		return array($id, $object);
	}
/**
 * Determines the datatype of the next variable in the stream
 *
 * @param int $verison AMF encoding version
 * @return string Data type name
 */
	function __next($version = 0) {
		$_this =& AmfDispatcher::getInstance();
		$typeConv = array_combine(array_values($_this->types[$version]), array_keys($_this->types[$version]));
		return $typeConv[$_this->read('byte')];
	}
/**
 * Reads binary data from the AMF input stream
 *
 * @param mixed $length Number of bytes to read.  If a string, will be interpreted
 *                      as $type.
 * @param string $type  Data type of the variable to be read.  In most cases, can
 *                      be used in place of $length.
 * @return mixed Binary AMF data
 */
	function read($length, $type = null) {
		$_this =& AmfDispatcher::getInstance();
		if (!is_numeric($length) && !in_array($length, array_keys($_this->binaryLength)) && $type != 'str') {
			return false;
		} elseif (!is_numeric($length) && $type == null) {
			$type = $length;
			$length = $_this->binaryLength[$type];
		} elseif (!in_array($length, $_this->binaryLength) && $type == null) {
			$type = 'str';
			$length = $_this->binaryLength[$type];
		} elseif ($type == null) {
			$types = array_combine(array_values($_this->binaryLength), array_keys($_this->binaryLength));
			$type = $types[$length];
		}

		if (strlen($_this->input) < $_this->offset + $length) {
			return false;
		}

		$data = substr($_this->input, $_this->offset, $length);
		$_this->offset += $length;

		if (isset($types[$length]) && $types[$length] == 'float' && $_this->bigEndian) {
			$data = strrev($data);
		}

		if (!empty($_this->binaryType[$type])) {
			@list($tmp, $data) = unpack($_this->binaryType[$type], $data);
		}

		if (isset($types[$length]) && $types[$length] == 'byte' && intval($data) < 0) {
			$data = intval($data) + 256;
		}
		return $data;
	}

/**
 * Enter description here...
 *
 * @param unknown_type $type
 * @return unknown
 */
	function __decode($type = null) {
		$_this =& AmfDispatcher::getInstance();

		if (function_exists('amf_decode')) {
			if (!class_exists('AmfCallback')) {
				App::import('Vendor', 'Amf.AmfCallback');
			}
			$AmfCallback =& new AmfCallback($this);
			return amf_decode($_this->input, $_this->bigEndian, $_this->offset, array($AmfCallback, "decode"));
		} else {

			if ($type == null) {
				$type = $_this->__next();
			}
			switch($type) {
				case 'date':
					$stamp = floor($_this->read('float') / 1000);
					$offset = $_this->read('int');
					if ($offset > 720) {
						$offset = (65536 - $offset);
					}
					return $stamp + (($offset * 60) - date('Z'));
				case 'reference':
					$id = $_this->read('int');
					if (!isset($_this->references[$id])) {
						return false;
					}
					return $_this->references[$id];
				case 'array':
					$data = array();
					$length = $_this->read('long');
					while($length--) {
						$data[] = $_this->__decode();
					}
					return $data;
				case 'mixed_array':
					$length = $_this->read('long');
					return $_this->__decode('object');
				case 'object':
				case 'typed_object':
					$data = array();

					if ($type == 'typed_object') {
						$class = $_this->__find('str');
					}

					while(1) {
						$key = $_this->__find('str');
						$type = $_this->read('byte');

						if ($type == $_this->types[0]['object_term']) {
							break;
						}
						$data[$key] = $_this->__find($type);
					}
					if ($type == 'typed_object') {
						// eventually use the actual class name here:
						$class = 'stdObject';
						$data = Set::map($data, $class);
					}
					$_this->references[] = $data;
					return $data;
				case 'amf3':
					return new AMF3Data($_this->__decode3());
				break;
			}
		}

		return $data;
	}

/**
 * Gets data of the given $type from an AMF3-encoded data stream
 *
 * @param string $type
 * @return unknown
 */
	function __decode3($type = null) {
		$_this =& AmfDispatcher::getInstance();

		if ($type == null) {
			$type = $_this->__next(1);
		}

		switch ($type) {
			case 'undefined':
			case 'null':
				return null;
			case 'bool_false':
				return false;
			case 'bool_true':
				return true;
			case 'integer':
				$count = 1;
				$int = 0;
				$byte = $_this->read('byte');

				while((($byte & 0x80) != 0) && $count < 4) {
					$int <<= 7;
					$int |= ($byte & 0x7f);
					$byte = $_this->read('byte');
					$count++;
				}

				if ($count < 4) {
					$int <<= 7;
					$int |= $byte;
				} else {
					$int <<= 8;
					$int |= $byte;

					if (($int & 0x10000000) != 0) {
						$int |= 0xe0000000;
					}
				}
				return $int;
			case 'number':
				return $_this->read('float');
			case 'str':
			case 'xml':
				return $_this->__find('str');
			case 'date':
				$ref = $_this->read('int');
				if (($ref & 0x01) == 0) {
					$ref = $ref >> 1;
					if ($ref >= count($_this->stored)) {
						return false;
					}
					return $_this->stored[$ref];
				}
				//$timeOffset = ($dateref >> 1) * 6000 * -1;
				$date = $_this->read('float');
				//$date -= $timeOffset;

				$_this->stored[] = $date;
				return $date;
			case 'array':
				list($id, $data) = $_this->__ref();
				if ($data === false) {
					return false;
				} elseif ($data === null) {

					$id = $id >> 1;
					$data = array();
					$_this->read('byte');

					for($i = 0; $i < $id; $i++) {
						$data[] = $_this->__decode3();
					}

					$_this->stored[] = $data;
					return $data;
				} else {
					return $data;
				}
			case 'object':
				list($id, $object) = $_this->__ref();

				if ($object === false) {
					return false;
				} elseif ($object === null) {
					$classRef = $id >> 1;
					$type = ($classRef >> 1) & 0x03;
					list($classRef, $classTemplate) = $_this->__ref($classRef);

					if ($classTemplate === false) {
						return false;
					} elseif ($classTemplate != null) {
						if (is_a($classTemplate, 'itypedobject') || is_a($classTemplate, 'ITypedObject')) {
							$className = 'CakeClass';
						} else {
							$className = false;
						}
					} else {
						$className = $_this->__decode3('str');
						$classTemplate = false;
					}
					// Create the values array and store it in $stored
					// before reading the properties.
					$values = array();
					$isMapped = false;

					if ($className) {
						if ($localClass == $className) {
							$obj = new $localClass();
							$isMapped = true;
						} else {
							$obj = Set::map($values);
						}
					} else {
						$obj = &$values;
					}
					$_this->stored[] = $obj;

					// Check to see the encoding type
					switch ($objType) {
						case 2:
							if ($classTemplate) {
								$propertyNames = array_keys($classTemplate->__decode());

								for($i = 0; $i < count($propertyNames); $i++) {
									$values[$propertyNames[$i]] = $_this->__decode3();
								}
							} else {
								// Property-value pairs
								do {
									$propertyName = $_this->read('str');
									if ($propertyName!='' && !is_null($propertyName)) {
										$propValue = $_this->__decode3();
										$values[$propertyName] = $propValue;
									}
								} while($propertyName != '');
							}
						break;
						case 1:
							// One single value, no propertyname. Not sure what to do with this, so following ServiceCapture's example and naming the property 'source'
							$values["source"] = $_this->__decode3();
						break;
						case 0:
							$propertyCount = $classref >> 3;
							$propertyNames = array();
							// First read all the propertynames, then the values
							for($i=0;$i<$propertyCount;$i++) {
								$propertyName = $_this->__decode3('str');
								$propertyNames[] = $propertyName;
							}

							foreach($propertyNames as $pn) {
								$values[$pn] = $_this->__decode3();
							}
						break;
					}

					if ($isMapped) {
						foreach($values as $k => $v) {
							$obj->{$k} = $v;
						}
					} else if (is_a($obj) && method_exists($obj, 'setAMFData')) {
						$obj->setAMFData($values);
					}
					return $obj;
				}

				case 'xml_string':
					$length = $_this->read('int') >> 1;
					return $_this->read($length, 'str');
				break;
		}
	}
}
/**
 * Short description for class.
 *
 * Long description for class..
 *
 * @package		TBD
 * @subpackage	TBD.controllers.components
 */
class AMF3Data extends Object {
/**
 * Enter description here...
 *
 * @var unknown_type
 */
	var $data = null;
/**
 * Enter description here...
 *
 * @param unknown_type $data
 */
	function __construct($data) {
		parent::__construct();
		$this->data = $data;
	}
}

$request = env('CONTENT_TYPE');
if ($request == 'application/x-amf') {
	if(class_exists('Debugger')) {
		Debugger::output('txt');
	}

	if (AmfDispatcher::forward() === false) {
		trigger_error("Unable to forward AMF request");
		exit();
	}

	exit();
}
?>