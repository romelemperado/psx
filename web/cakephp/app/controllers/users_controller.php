<?php
class UsersController extends AppController {

	var $name = 'Users';
	var $helpers = array('Html', 'Form');

        function home() {
        }

        function index() {
        }
	
	function login() {	
	  //If the form has been submitted then authenticate users
		if($this->data) {
		  //The component will handle authentication and redirection automatically.
			$this->Bauth->login($this->data);
		}
		else {
		  //If there was no data submitted, simply render the login form
			$this->render('login');
		}
	}
		
	function logout() {
		$this->Bauth->logoutPage = '/';  //Sets the page where the user will be redirected when logging out
		$this->Bauth->logout();  //Actually logs out the user, destroying session information 
	}
}
