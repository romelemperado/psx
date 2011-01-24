<h2>Add a Post</h2>
<div id=con><a href=index>Back</a></div>
<div id=PostAddForm>
<?php
echo $form->create('Post', array('action'=>'add'));
echo $form->input('title');
echo $form->input('body');
echo $form->end('Create a Post');
?>
</div>
