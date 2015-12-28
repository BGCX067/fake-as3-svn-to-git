<?php /* SVN FILE: $Id: add.ctp 12 2008-03-11 01:42:39Z gwoo.cakephp $ */?>
<div class="users form">
<?php echo $form->create('User');?>
	<fieldset>
 		<legend><?php __('Add User');?></legend>
	<?php
		echo $form->input('approved');
		echo $form->input('dob');
		echo $form->input('last_name');
		echo $form->input('first_name');
		echo $form->input('username');
		echo $form->input('email');
		echo $form->input('psword');
		echo $form->input('temppassword');
		echo $form->input('tos');
		echo $form->input('email_authenticated');
		echo $form->input('email_token');
		echo $form->input('email_token_expires');
	?>
	</fieldset>
<?php echo $form->end('Submit');?>
</div>
<div class="actions">
	<ul>
		<li><?php echo $html->link(__('List Users', true), array('action'=>'index'));?></li>
	</ul>
</div>
