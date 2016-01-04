global with sharing class PartnerLoginController {

	global String username {get; set;}
	global String password {get; set;}

	global PartnerLoginController() {}

	global PageReference forwardToCustomAuthPage() {
		return new PageReference('/PartnerLogin');
	}

	global PageReference login() {
		return Site.login(username, password, System.currentPageReference().getParameters().get('startURL'));
	}
}