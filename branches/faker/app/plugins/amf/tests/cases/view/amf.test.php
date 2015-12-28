<?php
App::import('Vendor', 'Amf.AmfDispatcher');
App::import('View', 'Amf.Amf');
App::import('Controller', 'App');

class PostsController extends AppController {
	var $uses = array();
}

class AmfViewTest extends CakeTestCase {

	function start() {
		parent::start();
		$this->AmfView = new AmfView(new PostsController);
	}

	function endTest($method) {
		parent::endTest($method);
		ClassRegistry::flush();
	}

	function testCallbackInstance() {
		$this->assertTrue(is_a($this->AmfView, 'AmfView'));
	}

	function testRender() {
		$this->AmfView->request = 1;
		$this->AmfView->requests = 1;
		pr($this->AmfView->render());
	}
}