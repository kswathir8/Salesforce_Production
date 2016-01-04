public class ContactController {

	public static boolean isRunning;
	
	// function for updating account with attended demo
	@future
	public static void rollUpAttendedDemo(Set<ID> contactIDsThatAttendedDemo){
		
		// check there are IDs
		if(contactIDsThatAttendedDemo.size() == 0) return;
		
		List<Contact> contacts = [Select id,AccountId,Attended_a_live_demo__c From Contact Where id IN :contactIDsThatAttendedDemo AND Attended_a_live_demo__c = true];
		
		// check contacts have clicked demo
		if(contacts.size() == 0 ) return;
		
		Set<ID> acctIds = new Set<ID>();
		for(Contact currentContact: contacts){
			if(currentContact.AccountId != null)	acctIds.add(currentContact.AccountId);
		}
		
		List<Account> acctsToUpdate = [Select id,Attended_a_live_demo__c From Account Where id IN :acctIds AND Attended_a_live_demo__c = false];
		
		// check there are accounts
		if(acctsToUpdate.size() == 0) return;
		
		for(Account currentAccount: acctsToUpdate) currentAccount.Attended_a_live_demo__c = true;
		
		update acctsToUpdate;
		
	}
	
	
	
	// function for transferring contact from original account to No Longer Employed account
	
	public static List<Contact> sortOutContactThatAreNoLongerEmployed(Map<ID,Contact> oldMap, Map<ID,Contact> newMap){
		
		Map<ID,Contact> returnMap = new Map<Id,Contact>();
		for(ID contactID: newMap.keySet()){
			if(newMap.get(contactID).No_Longer_With_Company__c)	returnMap.put(contactID,newMap.get(contactID));
		}
		return returnMap.values();
	}
	
	
	public static void updatenoLongerEmployedContacts(List<Contact> contactsToRemoveFromAccount){
		
		if(contactsToRemoveFromAccount.size() == 0 ) return;
		
		List<Account> noLongerEmployed = [Select id From account Where Name = 'No Longer Employed'];
		system.debug(noLongerEmployed);
		if(noLongerEmployed.size() == 0){
				noLongerEmployed.add( new Account(Name='No Longer Employed') );
				insert noLongerEmployed;
		}
		
		for(Contact currentContact: contactsToRemoveFromAccount){
			currentContact.Original_Account__c = currentContact.AccountId;
			currentContact.AccountID = noLongerEmployed.get(0).id;
		}
	}
	
	
	/*********************************
	*		Test Methods			 *
	*********************************/

	@isTest(seeAlldata=true)
	public static void testContactOnAccountChangedtoNoLongerEmployed(){
		
		Account newAccount = new Account(Name='Test Account');
		insert newAccount;
		
		Contact testContact = new Contact(AccountID=newAccount.id,firstName='Test',lastName='Guy',email='test@fake.com',No_Longer_With_Company__c=false);
		insert testContact;
		
		Test.startTest();
			testcontact.No_Longer_With_Company__c = true;
			update testcontact;
		Test.stopTest();
		
		testContact = [Select id,No_Longer_With_Company__c,AccountId,Original_Account__c From Contact Where id = :testContact.id];		
		System.assertNotEquals(newAccount.id,testContact.AccountID);
		
	}


	public static testMethod void testCheckContactWithUncheckedAccount(){
		Account firstAccount = new Account(Name='Test Account',Attended_a_live_demo__c=false);
		insert firstAccount;
		
		Contact testContact = new Contact(AccountID=firstAccount.id,firstName='Test',lastName='Guy',email='test@fake.com');
		insert testContact;
		
		Test.startTest();
		
			testContact.Attended_a_live_demo__c = true;
			update testContact;
		
		Test.stopTest();
		
		firstAccount = [Select id,Attended_a_live_demo__c From Account Where id = :firstAccount.id];
		System.assert(firstAccount.Attended_a_live_demo__c);
	}
	
	public static testMethod void testCheckContactWithcheckedAccount(){
		Account firstAccount = new Account(Name='Test Account',Attended_a_live_demo__c=true);
		insert firstAccount;
		
		Contact testContact = new Contact(AccountID=firstAccount.id,firstName='Test',lastName='Guy',email='test@fake.com');
		insert testContact;
		
		Test.startTest();
		
			testContact.Attended_a_live_demo__c = true;
			update testContact;
		
		Test.stopTest();
		
		firstAccount = [Select id,Attended_a_live_demo__c From Account Where id = :firstAccount.id];
		System.assert(firstAccount.Attended_a_live_demo__c);
	}
	
	public static testMethod void testCheckMultipleContactsWithcheckedAccount(){
		Account firstAccount = new Account(Name='Test Account',Attended_a_live_demo__c=true);
		insert firstAccount;
		
		Contact testContact = new Contact(AccountID=firstAccount.id,firstName='Test',lastName='Guy',email='test@fake.com');
		insert testContact;
		
		Contact testContact2 = new Contact(AccountID=firstAccount.id,firstName='Test',lastName='Guy',email='test@fake1.com');
		insert testContact2;
		
		Contact testContact3 = new Contact(AccountID=firstAccount.id,firstName='Test',lastName='Guy',email='test@fake2.com');
		insert testContact3;
		
		Test.startTest();
		
			testContact.Attended_a_live_demo__c = true;
			update testContact;
		
		Test.stopTest();
		
		firstAccount = [Select id,Attended_a_live_demo__c From Account Where id = :firstAccount.id];
		System.assert(firstAccount.Attended_a_live_demo__c);
	}
	
	
}