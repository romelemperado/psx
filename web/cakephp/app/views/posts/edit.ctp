<h2>Edit Post</h2>
<div id=con><a href=/psx/web/cakephp/posts/index>Back</a></div>
<div id=PostAddForm>
<?php
echo $form->create('Post', array('action'=>'edit'));
echo $form->input('title');
echo $form->input('body');
echo $form->input('id', array('type'=>'hidden'));
echo $form->end('Edit Post');
?>
</div>
