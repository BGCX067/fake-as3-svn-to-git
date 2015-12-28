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

	var $bodies = array();

	var $Caller = null;

	function __construct(&$caller) {
		$this->Caller = $caller;
	}

	function encode($value) {
		if (get_class($value) == 'AcknowledgeMessage') {
			return array($value, 3, $value->_type);
		}

		if (get_class($value) == 'CommandMessage') {
			$obj = new AcknowledgeMessage($value);
			$type = $obj->_type;
			unset($obj->_type);
			return array($obj, 3, $type);
		}

		if (get_class($value) == 'RemotingMessage') {
			$obj = new AcknowledgeMessage($value);
			$type = $obj->_type;
			unset($obj->_type);
			return array($obj, 3, $type);
		}

		if (isset($value->_type)) {
			$type = $value->_type;
			unset($value->_type);
			return array($value, 3, $type);
		}
	}

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

class ByteArray {
	var $data;

	function ByteArray($data)
	{
		$this->data = $data;
	}
}

class RecordSet {
	var $data;

	function RecordSet($data)
	{
		$this->data = $data;
	}
}


class PageableRecordSet {
	var $data;
	var $limit;

	function PageableRecordSet($data, $limit = 15)
	{
		$this->data = $data;
		$this->limit = $limit;
	}
}

class AcknowledgeMessage extends AmfMessage {

	var $_type = 'flex.messaging.messages.AcknowledgeMessage';

	var $correlationId;

	function __construct($message = null) {
		parent::__construct();
		if (isset($message->messageId)) {
			$this->correlationId = $message->messageId;
		}
	}
}

class CommandMessage extends AmfMessage {

	var $_type = 'flex.messaging.messages.CommandMessage';

	var $messageRefType;
}

class RemotingMessage extends AmfMessage {

	var $_type = 'flex.messaging.messages.RemotingMessage';

	function __construct($caller = null) {
		parent::__construct();
		//pr($caller);
		// /$caller->dispatch($params['url']['url'], $params);
	}

}

class ErrorMessage extends AmfMessage  {

	var $correlationId;
	var $faultCode;
	var $faultDetail;
	var $faultString;

	function __construct($message = null) {
		parent::__construct();
		if (isset($message->messageId)) {
			$this->correlationId = $message->messageId;
		}
	}
}
class AmfMessage {

	var $source;

	var $operation;

	var $body;

	var $clientId;

	var $timestamp;

	var $destination;

	var $timeToLive;

	var $messageId;

	var $_type;

/**
 * A hack to support __construct() on PHP 4
 * Hint: descendant classes have no PHP4 class_name() constructors,
 * so this constructor gets called first and calls the top-layer __construct()
 * which (if present) should call parent::__construct()
 *
 * @return Object
 */
	function AmfMessage() {
		$args = func_get_args();
		if (method_exists($this, '__destruct')) {
			register_shutdown_function (array(&$this, '__destruct'));
		}
		call_user_func_array(array(&$this, '__construct'), $args);
	}
/**
 * Class constructor, overridden in descendant classes.
 */
	function __construct() {
		if(!class_exists('String')) {
			App::import('Core', 'String');
		}

		$this->messageId = String::uuid();
		$this->clientId = String::uuid();
		$this->timeToLive = 0;
		$this->timestamp = time() . '00';
		$this->headers = new stdClass();
	}
}
?>