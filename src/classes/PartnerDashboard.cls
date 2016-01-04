public with sharing class PartnerDashboard {

	public Account account {
		get {
			if(account == null) {
				List<Account> accounts = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone, Owner.Name, Owner.Email FROM Account WHERE Id = :u.AccountId limit 1];
				if(accounts.size() == 1) account = accounts[0];
			}
			return account;
		} 
		set;
	}

	private User u {
		get {
			if(u == null) {
				List<User> users = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId() limit 1];
				if(users.size() == 1) u = users[0];
			}
			return u;
		} 
		set;
	}

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

	public PartnerDashboard() {
		//User u = [SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId()];
		//account = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone, Owner.Name, Owner.Email FROM Account WHERE Id = :u.AccountId];
	}

	/* RS 9/21/15
		This feature is not currently being used but is being left here for the time being in case it is needed in the future
	*/
	//@RemoteAction
	//public static String editAccount(Id accountId, String street, String city, String state, String postalCode, String phone) {
	//	try {
	//		Account account = [SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode, Phone FROM Account WHERE Id = :accountId];

	//		account.BillingStreet = street;
	//		account.BillingCity = city;
	//		account.BillingState = state;
	//		account.BillingPostalCode = postalCode;
	//		account.Phone = phone;

	//		update account;
	//	} catch(Exception e) {
	//		return('Error: ' + e.getMessage());
	//	}

	//	return ('SUCCESS');
	//}
}