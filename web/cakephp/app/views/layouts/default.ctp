<?php echo $html->docType('xhtml-trans'); ?>
<html>
<head>
   <title><?php echo $title_for_layout; ?></title>
   <?php echo $html->css('styles'); ?>
</head>
<body>
<div id="container">
    <?php echo $session->flash(); ?>
    <?php echo $content_for_layout; ?>
</div>
</body>
</html>
