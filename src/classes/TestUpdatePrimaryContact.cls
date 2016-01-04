@istest
Public class TestUpdatePrimaryContact
{
    /**********************************
    *       Test Methods              *
    **********************************/
   public static testMethod void testGetSetMethods()
   {
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today());
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        Test.startTest();
            updated.getContactJSON();
            updated.getContactsEmpty();
        Test.stopTest();
   }
   
   public static testMethod void testOpportunityWithNoContactRolesAndAccountWithNoContacts(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today());
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        Test.startTest();
            updated.firstName = 'Test';
            updated.lastName = 'Guy';
            updated.email = 'Test.guy@test.com';
            updated.phone = '4155555555';
            updated.updateContact();
        Test.stopTest();
        
       List<OpportunityContactRole> roles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :testOpportunity.id];
       System.assertEquals(updated.contactroles.size(),roles.size());
       System.assertEquals(1,roles.size());
       
       List<Contact> newContact = [Select id,firstName,lastName,Email,phone,fax from Contact];
       System.assertEquals(1,newcontact.size());
   }
   
   public static testMethod void testOpportunityWithPrimaryContactAndAccountWithNoOtherContacts(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact primeContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@adress.com',fax='415563435454',phone='4155553554');
        insert primeContact;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today(),Primary_Contact__c=primeContact.id);
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        Test.startTest();
            updated.firstName = 'Test';
            updated.lastName = 'Guy';
            updated.email = 'wrong@adress.com';
            updated.phone = '4155555555';
            updated.updateContact();
        Test.stopTest();
        
       List<OpportunityContactRole> roles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :testOpportunity.id];
       System.assertEquals(updated.contactroles.size(),roles.size());
       System.assertEquals(1,roles.size());
       
       List<Contact> newContact = [Select id,firstName,lastName,Email,phone,fax from Contact];
       System.assertEquals(1,newcontact.size());
       System.assertEquals(newContact.get(0).id,primeContact.id);
   }
   
   public static testMethod void testOpportunityWithPrimaryContactAndAccountWithOtherContacts(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact primeContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@adress.com',fax='415563435454',phone='4155553554');
        insert primeContact;
        
        Contact otherContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@test.com',fax='415563435454',phone='4155553554');
        insert otherContact;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today(),Primary_Contact__c=primeContact.id);
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        Test.startTest();
            updated.firstName = 'Test';
            updated.lastName = 'Guy';
            updated.email = 'wrong@test.com';
            updated.phone = '4155555555';
            updated.updateContact();
        Test.stopTest();
        
       List<OpportunityContactRole> roles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :testOpportunity.id];
       System.assertEquals(updated.contactroles.size(),roles.size());
       System.assertEquals(2,roles.size());
       
       List<Contact> newContact = [Select id,firstName,lastName,Email,phone,fax from Contact];
       System.assertEquals(2,newcontact.size());
       //System.assertEquals(otherContact.id,updated.oppty.Primary_Contact__c);
       
   }
   
   public static testMethod void unitTestMatchingContact(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact primeContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@adress.com',fax='415563435454',phone='4155553554');
        insert primeContact;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today(),Primary_Contact__c=primeContact.id);
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        ID matchingID;
    
        Test.startTest();
            matchingID = updated.matchContact('wrong@adress.com');
        Test.stopTest();
        
        System.assertEquals(matchingID,primeContact.id);

   }
   
   public static testMethod void unitTestMatchingContactWithNonPrimaryContact(){
    
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        Contact primeContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@adress.com',fax='415563435454',phone='4155553554');
        insert primeContact;
        
        Contact otherContact = new Contact(AccountID=testAccount.id,firstName='Test',lastName='Guy',email='wrong@test.com',fax='415563435454',phone='4155553554');
        insert otherContact;
        
        Opportunity testOpportunity = new Opportunity(AccountId=testAccount.id,NAme='Test Op',stageName='Closed Won',closeDate=Date.Today(),Primary_Contact__c=primeContact.id);
        insert testOpportunity;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testOpportunity);
        UpdatePrimaryContact updated = new UpdatePrimaryContact(stdController);
    
        //System.assert(updated.contacts.containskey(otherContact.id));
    
        ID matchingID;
    
        Test.startTest();
            updated.email = 'wrong@test.com';
            matchingID = updated.matchContact('wrong@test.com');
        Test.stopTest();
        
        System.debug(primeContact);
        System.debug(otherContact);
        System.assertEquals(otherContact.id,matchingID);

   }
}