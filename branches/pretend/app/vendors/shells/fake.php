<?php
/* SVN FILE: $Id: fake.php 81 2008-04-09 23:45:11Z gwoo.cakephp $ */
/**
 * Description
 *
 * Pretend
 * Copyright 2008, Sean Chatman and Garrett Woodworth
 *
 * Licensed under The MIT License
 * Redistributions of files must retain the above copyright notice.
 *
 * @filesource
 * @copyright		Copyright 2008, Sean Chatman and Garrett Woodworth
 * @link			http://code.google.com/p/fake-as3/
 * @package			pretend
 * @subpackage		app.vendors.shells
 * @since			2008-03-06
 * @version			$Revision: 81 $
 * @modifiedby		$LastChangedBy: gwoo.cakephp $
 * @lastmodified	$Date: 2008-04-10 06:45:11 +0700 (Thu, 10 Apr 2008) $
 * @license			http://www.opensource.org/licenses/mit-license.php The MIT License
 */
class FakeShell extends Shell {

	var $connection = 'default';

	var $paths = array('model' => 'com.app.model', 'controller' => 'com.app.controller', 'view' => 'com.app.view');

	var $models = array();

	function initialize(){}

	function startup() {
		$appPaths = array_diff(Configure::read('modelPaths'), Configure::corePaths('model'));
		$this->models = Configure::listObjects('model', $appPaths, false);

		if (empty($this->params['src'])) {
			$this->params['src'] = ROOT . DS . 'src';
		}
	}

	function main() {

		if (empty($this->args)) {
			$this->help();
		}

		if (isset($this->args[0])) {
			$model = Inflector::classify($this->args[0]);
			if (in_array($model, $this->models)) {
				if ($this->bakeModel($model)) {
					$this->out($model . ' was generated');
				} else {
					$this->err($model . 'was NOT generated');
				}
			}
		}
	}

	function all() {
		foreach ($this->models as $model) {
			if ($this->bakeModel($model)) {
				$this->out($model . ' was generated');
			} else {
				$this->err($model . 'was NOT generated');
			}
		}
		if ($this->bakeSchemaLoader($this->models)) {
			$this->out('SchemaLoader was generated');
		} else {
			$this->err('SchemaLoader was NOT generated');
		}
	}

	function schema() {
		if ($this->bakeSchemaLoader($this->models)) {
			$this->out('SchemaLoader was generated');
		} else {
			$this->err('SchemaLoader was NOT generated');
		}
	}

	function dataset() {
		if (isset($this->args[0])) {
			$model = Inflector::classify($this->args[0]);
			if (in_array($model, $this->models)) {
				if ($this->bakeDataSet($model)) {
					$this->out($model . ' was generated');
				} else {
					$this->err($model . 'was NOT generated');
				}
			}
		}
	}

	function view() {
		if (isset($this->args[0])) {
			$view = $this->args[0];
		} else {
			$view = $this->in("What is the name of the view? Use '.' to place the view in a deeper namespace. Enter 'n' to quit.");
		}

		if (low($view) != 'n') {

			$names = array();
			if (strpos($view, '.') !== false) {
				$names = explode('.', $view);
				$view = array_pop($names);
			}

			$view = Inflector::camelize($view);
			$verify = $this->in($view . ".mxml will be created in " . join(DS, explode('.', $this->paths['view'])) . DS . join(DS, $names), array('y', 'n'), 'y');

			if (low($verify) != 'n') {

				$controller = $this->in("Would you like to create a controller? Enter the name of the controller or 'n' to skip.", null, $view . 'Ctrl');

				if (low($controller) != 'n') {
					$controller = Inflector::camelize($controller);

					$out = "/* SVN FILE: \$Id\$ */\n";
					$out .= "package " . $this->paths['controller'] . "." . join('.', $names) . "\n{\n";
					$out .= "\timport com.fake.controller.Controller\n\n";
					$out .= "\tpublic class ". $controller . " extends Controller\n";
					$out .= "\t{\n";
					$out .= "\n\t\tpublic function " . $controller . "()\n";
					$out .= "\t\t{\n\t\t\tsuper();\n\t\t}\n";
					$out .= "\t}\n";
					$out .= "}\n";

					$path = rtrim($this->params['src'], DS) . DS . join(DS, explode('.', $this->paths['controller'])) . DS . join(DS, $names) . DS . $controller .'.as';
					if ($this->createFile($path, $out)) {
						$this->out($controller . ' was generated');
					} else {
						$this->err($controller . 'was NOT generated');
					}
				} else {
					$controller = null;
				}

				$out = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n";
				$out .= "<!--/* SVN FILE: \$Id\$ */-->\n";

				if ($controller) {
					$out .= '<' . $controller . ' xmlns="'.join('.', explode('.', $this->paths['controller'])) . '.' . join('.', $names) .'.*" xmlns:mx="http://www.adobe.com/2006/mxml">';
					$out .= "\n\n";
					$out .= '</' . $controller . '>';
				} else {
					$out .= '<mx:Canvas xmlns:mx="http://www.adobe.com/2006/mxml">';
					$out .= "\n\n";
					$out .= '</mx:Canvas>';
				}

				$path = rtrim($this->params['src'], DS) . DS . join(DS, explode('.', $this->paths['view'])) . DS . join(DS, $names) . DS . $view .'.mxml';
				if ($this->createFile($path, $out)) {
					$this->out($view . ' was generated');
				} else {
					$this->err($view . 'was NOT generated');
				}
			}
		}
	}

	function bakeModel($model) {
		if (App::import('Model', $model)) {
			$object = new $model();
		} else {
			App::import('Model', 'App');
			$object = new AppModel(array('name' => $model));
		}

		$fields = $object->schema();
		$out = "/* SVN FILE: \$Id\$ */\n";
		$out .= "package " . $this->paths['model'] . "\n{\n";
		$out .= "\timport com.fake.model.Model\n\n";
		$out .= "\tpublic class ". $model . " extends Model\n";
		$out .= "\t{\n";
		if (!empty($fields)) {
			foreach ($fields as $field => $options) {
				$out .= "\t\tpublic var ". $field . ":" . $this->__type($options['type']) . ";\n";
			}
		}
		$out .= "\n\t\tpublic function " . $model . "()\n";
		$out .= "\t\t{\n\n\t\t}\n";
		$out .= "\t}\n";
		$out .= "}\n";

		$path = rtrim($this->params['src'], DS) . DS . join(DS, explode('.', $this->paths['model'])) . DS . $model .'.as';
		return $this->createFile($path, $out);
	}

	function bakeDataSet($model) {
		if (App::import('Model', $model)) {
			$object = new $model;
		} else {
			App::import('Model', 'App');
			$object = new AppModel(array('name' => $model));
		}

		$out = "/* SVN FILE: \$Id\$ */\n";
		$out .= "package " . $this->paths['model'] . ".datasets\n{\n";
		$out .= "\timport com.fake.model.DataSet\n\n";
		$out .= "\tpublic class ". $model . " extends Model\n";
		$out .= "\t{\n";
		if (!empty($fields)) {
			foreach ($fields as $field => $options) {
				$out .= "\t\tpublic var ". $field . ":" . $this->__type($options['type']) . ";\n";
			}
		}
		$out .= "\n\t\tpublic function " . $model . "()\n";
		$out .= "\t\t{\n\n\t\t}\n";
		$out .= "\t}\n";
		$out .= "}\n";

		$path = rtrim($this->params['src'], DS) . DS . join(DS, explode('.', $this->paths['model'])) . DS . $model .'.as';
		return $this->createFile($path, $out);
	}

	function bakeSchemaLoader($models) {
		$out = null;
		if (!empty($models)) {
			$out = "package " . $this->paths['model'] . "\n{\n";
			$out .= "\tpublic class SchemaLoader \n{\n";
			foreach ($models as $model) {
				$out .= "\t\tpublic static const " . Inflector::variable($model) . ":" . $model . " = new " . $model . "();\n";
			}
			$out .= "\t}\n";
			$out .= "}";
		}
		$path = rtrim($this->params['src'], DS) . DS . join(DS, explode('.', $this->paths['model'])) . DS . 'SchemaLoader.as';
		return $this->createFile($path, $out);
	}

	function __type($type) {
		switch ($type) {
			case 'integer':
				return 'int';
			break;
			case 'text':
			case 'datetime':
			case 'date':
			case 'time':
				return 'String';
			break;
			case 'float':
				return 'Number';
			break;
			default:
				return ucwords($type);
			break;
		}
	}
/**
 * Show help screen.
 *
 * @access public
 */
	function help() {
		$head  = __("Usage: cake fake <model>...", true) . "\n";
		$head .= "-----------------------------------------------\n";
		$head .= __("Commands:", true) . "\n";

		$commands = array(
			'all' => 	"\tall\n" .
						"\t\t" . __("Create all the models and SchemaLoader.", true) . "\n",
			'schema' => 	"\tschema\n" .
						"\t\t" . __("Create the SchemaLoader.", true) . "\n",
			'view' => 	"\tview\n" .
						"\t\t" . __("Create a View and Controller.", true) . "\n",
			'<name>' => 	"\t<name>\n" .
							"\t\t" . __("Pass the fake model to create.", true) . "\n",

			'help' => 	"\thelp [<command>]\n" .
						"\t\t" . __("Displays this help message, or a message on a specific command.", true) . "\n"
		);

		$this->out($head);
		if (!isset($this->args[0])) {
			foreach ($commands as $cmd) {
				$this->out("{$cmd}\n");
			}
		} elseif (isset($commands[low($this->args[0])])) {
			$this->out($commands[low($this->args[0])] . "\n");
		} else {
			$this->out(sprintf(__("Command '%s' not found", true), $this->args[0]));
		}
	}

}