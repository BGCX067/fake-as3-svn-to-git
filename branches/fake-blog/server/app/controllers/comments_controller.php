<?php
class CommentsController extends AppController {

	var $name = 'Comments';
	var $helpers = array('Html', 'Form');

	function beforeFilter() {
		$this->Auth->allow('index');
	}
	
	function index($post_id) {
		$this->Comment->recursive = 0;
		$conditions = array('post_id'=>$post_id);
		$this->set('comments', $this->Comment->find('all',array('conditions'=>$conditions)));
	}

	function view($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid Comment.', true));
			$this->redirect(array('action'=>'index'));
		}
		$this->set('comment', $this->Comment->read(null, $id));
	}

	function add() {
		if (!empty($this->data)) {
			$this->Comment->create();
			if ($this->Comment->save($this->data)) {
				$this->Session->setFlash(__('The Comment has been saved', true));
				//$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The Comment could not be saved. Please, try again.', true));
			}
		}
	}

	function edit($id = null) {
		if (!$id && empty($this->data)) {
			$this->Session->setFlash(__('Invalid Comment', true));
			$this->redirect(array('action'=>'index'));
		}
		if (!empty($this->data)) {
			if ($this->Comment->save($this->data)) {
				$this->Session->setFlash(__('The Comment has been saved', true));
				$this->redirect(array('action'=>'index'));
			} else {
				$this->Session->setFlash(__('The Comment could not be saved. Please, try again.', true));
			}
		}
		if (empty($this->data)) {
			$this->data = $this->Comment->read(null, $id);
		}
		$posts = $this->Comment->Post->find('list');
		$users = $this->Comment->User->find('list');
		$this->set(compact('posts','users'));
	}

	function delete($id = null) {
		if (!$id) {
			$this->Session->setFlash(__('Invalid id for Comment', true));
			$this->redirect(array('action'=>'index'));
		}
		if ($this->Comment->del($id)) {
			$this->Session->setFlash(__('Comment deleted', true));
			$this->redirect(array('action'=>'index'));
		}
	}

}
?>