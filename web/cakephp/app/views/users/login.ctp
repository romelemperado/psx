<h2>PelopsX Project</h2>
<br />
<div id=con>
<a href=/psx/web/cakephp>Back</a>
</div>
<div id=loginForm>
	<form id="frm_login" method="post">
		<?if(isset($loginerr)): ?>
			<div class="valError" style="text-align:center"><?=$loginerr;?></div>
		<?endif;?>
			<?=$form->create('User'); ?>
			<?=$form->input('email'); ?>
			<?=$form->input('password'); ?>
			<?= $form->end(__('Login', true)); ?>
	</form>
</div>
