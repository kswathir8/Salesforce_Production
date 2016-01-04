public with sharing class PartnerTemplate {

	public PartnerTemplate() {}

	public List<PermissionSetAssignment> psas {
		get {
			if(psas == null) {
				psas = [select 
					Id, 
					PermissionSet.Name,
					PermissionSet.Label
					from PermissionSetAssignment 
					where 
					AssigneeId = :UserInfo.getUserId()
				];
			}
			return psas;
		}
		set;
	}

	public Boolean isEndUser {
		get {
			for(PermissionSetAssignment psa : psas) {
				if(psa.PermissionSet.Label == 'Partner Community End User (Global)') {
					return true;
				}
			}
			return false;
		}
	}

	public PageReference redirectGuestToLogin() {
		if(UserInfo.getUserType() == 'Guest') {
			return new PageReference('/PartnerLogin');
		} else {
			return null;
		}
	}

	// navigates to litmos lms, provisions a user if needed on the way
	public PageReference gotoLitmos() {

		String litmosUrl = null;

		List<String> searchTerms = new List<String> {
			UserInfo.getUserName(), 
			'ax-' + UserInfo.getUserName(), 
			UserInfo.getUserEmail(), 
			'ax-' + UserInfo.getUserEmail()
		};

		litmosUrl = LitmosSSO.getLitmosSSOUrl(searchTerms);

		if(litmosUrl == null) {
			
			// try to provision user
			User u = new User(
	                Username = UserInfo.getUserName(),
	                FirstName = UserInfo.getFirstName(),
	                LastName = UserInfo.getLastName(),
	                Email = UserInfo.getUserEmail()
	        );

	        HttpResponse httpResponse = LitmosSSO.provisionUser(u);
	        if(httpResponse.getStatusCode() == 201) {
	        	Dom.Document xml = httpResponse.getBodyDocument();
	            Dom.XMLNode user = xml.getRootElement();
	            litmosUrl = user.getChildElement('LoginKey', null).getText();	
	        }

		}

		if(litmosUrl == null) return null;

		return new PageReference(litmosUrl);

	}

}