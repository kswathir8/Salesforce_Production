public with sharing class PartnerForgotPassword {

	public String username {get; set;}
       
    public PartnerForgotPassword() {}
	
  	public PageReference forgotPassword() {
  		Boolean success = Site.forgotPassword(username);
  		
  		PageReference pr = new PageReference('/PartnerForgotPasswordConfirm');
  		pr.setRedirect(true);
  		
  		if(success) {  			
  			return pr;
  		}

  		return null;
  	}
}