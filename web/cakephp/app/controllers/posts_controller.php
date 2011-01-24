<?php

class PostsController extends AppController {

    var $name='Posts';

    function index() {
       $this->set('posts', $this->Post->find('all'));
       $this->set('title_for_layout', 'My World');
    }
 
   function view($id=NULL) {
       $this->set('post', $this->Post->read(NULL, $id));
    }

   function add()  {
        if(!empty($this->data))  {
             if($this->Post->save($this->data))  {
                    $this->Session->setFlash('The post was successfully added!');
                    $this->redirect(array('action'=>'index'));
            } else {
                $this->Session->setFlash('The post was not saved, please try again.');
             }
       }
       $this->set('title_for_layout', 'Add a Post');
    }

    function edit($id=NULL) {
           if(empty($this->data)) {
                  $this->data=$this->Post->read(NULL,$id);
           } else {
                 if($this->Post->save($this->data)) {
                     $this->Session->setFlash('The post has been updated');
                     $this->redirect(array('action'=>'view', $id));
                 }
           }
    }

    function delete($id=NUL)  {
        $this->Post->delete($id);
        $this->Session->setFlash('The post has been deleted');
        $this->redirect(array('action'=>'index'));
    } 

    function hello_world(){

   }
}
?>
