<?php

class FakeShell extends Shell {

	var $connection = 'default';

	var $paths = array('model' => 'com.app.model', 'controller' => 'com.app.controller', 'view' => 'com.app.view');

	function initialize(){
		$this->_welcome();
		$this->out('Fake it until you make it');
	}

	function startup() {
		if (empty($this->params['src'])) {
			$this->params['src'] = $this->params['working']. DS . 'src';
		}
		if (!empty($this->params['app'])) {
			foreach ($this->paths as $name => $path) {
				$this->paths[$name] = "com.{$this->params['app']}.{$name}";
			}
		}
	}

	function main() {

		if (empty($this->args)) {
			$this->help();
		}
	}

	function project($app = null) {
		if (!empty($this->args)) {
			$this->params['app'] = $this->args[0];
			$this->params['working'] = $this->params['working'] . DS . $this->params['app'];
		}
		
		if (!empty($this->params['app'])) {
			$app = $this->params['app'];
		}

		if ($app !== null) {
			$this->params['src'] = $this->params['working']. DS . 'src';
			$path  = $this->params['src'] . DS . 'com' . DS . $app;

			$air = (isset($this->params['air'])) ? 'Air ' : null;
			$this->out("Your New Fake {$air}Project");
			$this->out("Will be created in: {$path}");
			$this->hr();

			$looksGood = $this->in('Look okay?', array('y', 'n', 'q'), 'y');
			if ($looksGood == 'y') {
				$this->bakeProject($app);
				$this->out("{$app} created in {$path}");
			}
		}
	}

	function model() {
		if (!empty($this->args[0])) {
			$models = $this->__models();

			if ($this->args[0] === "all") {
				foreach ($models as $model) {
					if ($this->bakeModel($model)) {
						$this->out($model . ' was generated');
					} else {
						$this->err($model . 'was NOT generated');
					}
				}

				if ($this->bakeSchemaLoader($models)) {
					$this->out('SchemaLoader was generated');
				} else {
					$this->err('SchemaLoader was NOT generated');
				}
			} else {
				$model = Inflector::classify($this->args[0]);
				if ($this->bakeModel($model)) {
					$this->out($model . ' was generated');
				} else {
					$this->err($model . 'was NOT generated');
				}
			}
		}
	}

	function schema() {
		$models = $this->__models();
		if ($this->bakeSchemaLoader($models)) {
			$this->out('SchemaLoader was generated');
		} else {
			$this->err('SchemaLoader was NOT generated');
		}
	}

	function dataset() {
		if (isset($this->args[0])) {
			$models = $this->__models();
			$model = Inflector::classify($this->args[0]);
			if (in_array($model, $models)) {
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
					$space = null;
					if (is_array($names)) {
						$space = '.' . join('.', $names);
					}
					$out .= "package " . $this->paths['controller'] . $space . "\n{\n";
					$out .= "\timport com.fake.controller.CanvasController\n\n";
					$out .= "\tpublic class ". $controller . " extends CanvasController\n";
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
					$space = null;
					if (is_array($names)) {
						$space = '.' . join('.', $names);
					}
					$out .= '<' . $controller . ' xmlns="'.join('.', explode('.', $this->paths['controller'])) . $space .'.*" xmlns:mx="http://www.adobe.com/2006/mxml">';
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
			$fields = $object->schema();
		}

		$out = "/* SVN FILE: \$Id\$ */\n";
		$out .= "package " . $this->paths['model'] . "\n{\n";
		$out .= "\timport com.fake.model.Model;\n\n";
		$out .= "\tpublic dynamic class ". $model . " extends Model\n";
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

	function bakeProject($app) {
		App::import(array('File', 'Folder'));

		$dirs = array('controller', 'model', 'view');
		$Folder = new Folder($this->params['src'] . DS . 'com' . DS . $app, true);
		foreach($dirs as $dir) {
			$Folder->create($Folder->pwd() . DS . $dir);
		}

		$dirs = array('images', 'skins', 'fonts');
		$Folder = new Folder($this->params['src'] . DS . 'assets', true);
		foreach($dirs as $dir) {
			$Folder->create($Folder->pwd() . DS . $dir);
		}

		$main = '<?xml version="1.0" encoding="utf-8"?>'
			. '<!-- /* SVN FILE: $Id: fake.php 224 2008-11-11 17:40:42Z gwoo.cakephp $*/-->' . "\n"
			. '<FakeApp xmlns="com.' . $app . '.*" xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" horizontalScrollPolicy="off" verticalScrollPolicy="off">' . "\n"
			. "\n\t<mx:Style source=\"assets/styles/{$app}.css\" />\n\n"
			. "\n\t<mx:Text text=\"{$app} successfully created\" />\n\n"
			. '</FakeApp>';

		$this->createFile($this->params['src'] . DS . ucwords($app) . '.mxml', $main);

		$templates = array('FakeApp.as', 'config' . DS . 'Environment.as', 'config' . DS . 'Routes.as');
		foreach ($templates as $template) {
			$this->__createFromTemplate($app, $template, 'com' . DS . $app . DS . $template);
		}

		$this->createFile($this->params['src'] . DS . 'assets' . DS . 'styles' . DS . $app . '.css', null);

		$this->__createFromTemplate($app, 'assets' . DS . 'config.xml');
	}
/**
 * Show help screen.
 *
 * @access public
 */
	function help() {
		$head  = __("Usage: cake fake [command] [params]", true) . "\n";
		$head .= "-----------------------------------------------\n";
		$head .= __("Commands:", true) . "\n";

		$commands = array(
			'project' 	=> __("Create a new Fake Project.", true),
			'view' 		=> __("Create a View and Controller.", true),
			'schema' 	=> __("Create the SchemaLoader.", true),
			'model' 	=>
				array(
					'options' => "all or [name]",
					'message' => __("all: Create all the models and SchemaLoader.\n\t\t[name]: Create a fake model with [name].", true)
				),
			'help' 		=>
				array(
					'options' => "[command]",
					'message' => __("Displays this help message, or a message on a specific command.", true)
				)
		);

		$this->out($head);
		if (!isset($this->args[0])) {
			foreach ($commands as $cmd => $options) {
				$this->out("\t{$cmd}", false);
				if (is_array($options)) {
					$this->out("\t{$options['options']}");
					$this->out("\t\t{$options['message']}\n");
				} else {
					$this->out("\t{$options}\n");
				}
			}
		} elseif (isset($commands[low($this->args[0])])) {
			$options = $commands[low($this->args[0])];
			$this->out("\t{$this->args[0]}", false);
			if (is_array($options)) {
				$this->out("\t{$options['options']}");
				$this->out("\t\t{$options['message']}\n");
			} else {
				$this->out("\t{$options}\n");
			}
		} else {
			$this->out(sprintf(__("Command '%s' not found", true), $this->args[0]));
		}
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

	function __createFromTemplate($app, $from, $to = null) {

		if ($to == null) {
			$to = $from;
		}

		$application = "Application";
		if (isset($this->params['air'])) {
			$application = "WindowedApplication";
		}

		ob_start();
		include(dirname(__FILE__) . DS . 'templates' . DS . 'fake' . DS . $from);
		$out = ob_get_clean();
		$this->createFile($this->params['src'] . DS . $to, $out);
	}

	function __models() {
		$appPaths = array_diff(Configure::read('modelPaths'), Configure::corePaths('model'));
		$models = Configure::listObjects('model', $appPaths, false);
		return $models;
	}
}