<?php
class AppController extends Controller {
     var $components=array('Session','Bauth');

    function beforeFilter() {
        $this->Bauth->logintrue=array(1=>'home/user_type1/',2=> '/home/user_type2/');
        $thiss->Bauth->loginfalse="users/login_error";
    }
}
