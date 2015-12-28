<?php
/**
 * Short description for class.
 *
 * Long description for class..
 *
 * @package		TBD
 * @subpackage	TBD.controllers.components
 */
class AmfCallback extends Object {
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $bodies = array();
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $Caller = null;
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $type = null;
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
	var $step = 0;
/**
 * undocumented class variable
 *
 * @var string
 **/
	var $stop = null;
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function __construct(&$caller) {
		$this->Caller = $caller;
		$this->type = null;
	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function encode($value) {

		if ($this->stop === true) {
			return;
		}

		$className = get_class($value);

		if ($className === 'AcknowledgeMessage') {
			return array($value, 3, $value->_type);
		}

		if ($className == 'CommandMessage') {
			$obj = new AcknowledgeMessage($value);
			$type = $obj->_type;
			unset($obj->_type);
			return array($obj, 3, $type);
		}

		if ($className == 'RemotingMessage') {
			$obj = new AcknowledgeMessage($value);
			$type = $obj->_type;
			unset($obj->_type);
			return array($obj, 3, $type);
		}

		if ($className == 'stdClass') {

			$type = 'Object';

			if(isset($value->_name_)) {
				$type = Inflector::camelize($value->_name_);
				unset($value->_name_);

				if ($type == 'Error') {
					$type = null;
					$value = new ErrorMessage($value);
				}
			} else {
				if (empty($this->types)) {
					$this->types = array_keys(get_object_vars($value));

					if (empty($this->types)) {
						return array($value, 3, $type);
					}

					$type = $this->types[0];
					if (count($this->types) <= 1) {
						$val = $value->{$type};
						if (!is_array($val)) {
							$types = array_keys(get_object_vars($val));
							if (count($types) <= 1) {
								$value = $val;
								if(isset($value->_name_)) {
									$type = Inflector::camelize($value->_name_);
									unset($value->_name_);
								}
							}
						}
					} else {
						$type = 'Array';
						$this->step--;
					}
				} else if (isset($this->types[$this->step])) {
					$type = $this->types[$this->step++];
				} else {
					$type = 'Array';
				}

				if (isset($value->{$type})) {
					$value = Set::map(Set::reverse($value));
					if(isset($value->_name_)) {
						$type = Inflector::camelize($value->_name_);
						unset($value->_name_);
					}
				}
			}

			if (isset($type)) {
				if (ClassRegistry::isKeySet($type)) {
					$typedClass =& ClassRegistry::getObject($type);
					if(isset($typedClass->_remoteAlias)) {
						$type = $typedClass->_remoteAlias;
						unset($typedClass->_remoteAlias);
					}
				}
				/* @todo add support for date fields
				if(isset($value->created)) {
					$value->created = number_format(strtotime($value->created) * 1000, 0, '.', '');
				}
				if(isset($value->modified)) {
					$value->modified = number_format(strtotime($value->modified) * 1000, 0, '.', '');
				}
				*/
			}
		}

		if (isset($value->_type)) {
			$type = $value->_type;
			unset($value->_type);
		}

		if (empty($type)) {
			$type = Inflector::camelize(gettype($value));
		}

		return array($value, 3, $type);
	}

	function __type() {

	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function decode($event, $arg) {
		switch($event) {
			case '1':
			   return $this->__map($arg);
			break;
			case '2':
				if(method_exists($arg, 'init')) {
					$arg->init();
				}
				return $arg;
			break;
			case '3':
				return $arg;
			break;
			case '4':
				if(in_array($arg, array('flex.messaging.io.ArrayCollection', 'flex.messaging.io.ObjectProxy'))) {
					return;
				}
			   trigger_error("Unable to read externalizable data type " . $arg, E_USER_ERROR);
			   return "error";
			break;
			case '5':
				return new ByteArray($arg);
			break;
			default:
				return "error";
			break;
		}
	}
/**
 * undocumented function
 *
 * @return void
 *
 **/
	function __map($type) {
		if(!$type) {
			return null;
		}

		$class = null;
		switch ($type) {
			case 'flex.messaging.messages.CommandMessage':
				return new CommandMessage();

				return new AcknowledgeMessage();
			break;
			case 'flex.messaging.messages.RemotingMessage':
				return new RemotingMessage($this->Caller);
			break;
		}

		return new AcknowledgeMessage();

		if (strpos($type, 'com.app.model') !== false) {
			return new AcknowledgeMessage();
			$class = str_replace('com.app.model.', '', $type);
			App::import('Model', $class);
			return new $class();
		}

		return $class;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class ByteArray extends Object {

	var $data;

	function __construct($data) {
		unset($this->_log);
		$this->data = $data;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class AsyncToken extends Object {

	var $message;

	var $responders;

	var $result;

	var $_type = 'mx.rpc.AsyncToken';

	function __construct($data) {
		unset($this->_log);
		parent::__construct();
		$this->result = $data;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class AbstractEvent extends Object {

	var $bubbles = false;

	var $cancelable = false;

	var $currentTarget;

	var $eventPhase;

	var $message;

	var $target;

	var $token;

	var $type;

	var $_type = 'mx.rpc.events.AbstractEvent';

	function __construct() {
		unset($this->_log);
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class ResultEvent extends AbstractEvent {

	var $result;

	var $_type = 'mx.rpc.events.ResultEvent';

	function __construct($data) {
		parent::__construct();
		$this->result = $data;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class RecordSet extends Object {

	var $data;

	function __construct($data) {
		unset($this->_log);
		$this->data = $data;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class PageableRecordSet extends Object  {

	var $data;

	var $limit;

	function __construct($data, $limit = 15) {
		unset($this->_log);
		$this->data = $data;
		$this->limit = $limit;
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class RemotingMessage extends AmfMessage {

	var $operation;

	var $source;

	var $_type = 'flex.messaging.messages.RemotingMessage';

	function __construct($caller = null) {
		parent::__construct();
		//$caller->dispatch($params['url']['url'], $params);
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class AsyncMessage extends AmfMessage {

	var $correlationId;

	var $_type = 'flex.messaging.messages.AsyncMessage';

	function __construct($message = null) {
		parent::__construct($message);

		$this->correlationId = $this->messageId;

		if (isset($message->messageId)) {
			$this->correlationId = $message->messageId;
		}
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class AcknowledgeMessage extends AsyncMessage {

	var $_type = 'flex.messaging.messages.AcknowledgeMessage';

}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class CommandMessage extends AsyncMessage {

	var $operation;

	var $_type = 'flex.messaging.messages.CommandMessage';
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class ErrorMessage extends AsyncMessage {

	var $extendedData;

	var $faultCode = "Server.Call.Failed";

	var $faultDetail;

	var $faultString;

	var $rootCause;

	var $_type = 'flex.messaging.messages.ErrorMessage';

	function __construct($message = null) {
		parent::__construct($message);

		if (is_object($message)) {
			foreach (get_object_vars($message) as $prop => $value) {
				if (strpos($prop, 'fault') === false && in_array($prop, array('string', 'code', 'detail'))) {
					$prop = 'fault' . ucwords($prop);
				}
				if (in_array($prop, get_object_vars($this))) {
					$this->{$prop} = $value;
				}
			}
		} else {
			$this->faultString = $message;
		}
	}
}
/**
 * undocumented class
 *
 * @package default
 *
 **/
class AmfMessage extends Object {

	var $body;

	var $clientId;

	var $destination;

	var $headers;

	var $messageId;

	var $timestamp;

	var $timeToLive;

	var $_type;

	function __construct($message = null) {
		if(!class_exists('String')) {
			App::import('Core', 'String');
		}

		$this->messageId = String::uuid();
		$this->clientId = String::uuid();
		$this->timeToLive = 0;
		$this->timestamp = time() . '00';
		$this->headers = new stdClass();
		unset($this->_log);
	}
}
?>