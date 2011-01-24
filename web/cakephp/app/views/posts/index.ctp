<h2>PelopsX Project</h2>
<p> This is a blog application using cakePHP.</p>
<div id=menu>
<a href=/psx/web/cakephp/users/home>Home</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=/psx/web/cakephp/pages/aboutus>About Us</a>&nbsp;&nbsp;&nbsp&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=>Posts</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=/psx/web/cakephp/pages/contactus>Contact Us</a>
</div>
<br />
<div id=submenu>
<?php echo $html->link('Add a Post', array('action'=>'add')); ?>
</div>
<table>
      <tr>
          <th>Title</th>
          <th>Body</th>
          <th>Actions</th>
      </tr>
      <?php foreach ($posts as $post): ?>
      <tr>
          <td><?php echo $html->link($post ['Post'] ['title'],
               array('action'=>'view', $post['Post'] ['id'])); ; ?></td>
          <td><?php echo $post ['Post'] ['body']; ?></td>
          <td>
               <?php echo $html->link('Edit', array('action'=>'edit', $post ['Post'] ['id'])); ?>
               <?php echo $html->link('Delete', array('action'=>'delete', $post ['Post'] ['id']), NULL, 'Are you sure you want to delete this post?'); ?>
          </td>
      </tr>
      <?php endforeach; ?>
</table>
