/************************************************
* Test Class Name: TestForCreateUserController  *     
* Created By     : Axcient                      *                        
* This class tests Create User scenario         *                                       
************************************************/

@isTest
class TestForCreateUserController {
    // This Method creates Account and Contact Objects
    static testMethod void testMethodForCodeCoverage(){
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc;
        Account accModified = [select BillingCity from Account where id =:acc.Id];        
        accModified.BillingCity = 'New York';         
        update accModified; 
        Contact cont = new Contact(LastName = 'Test Contact', AccountId = acc.Id, EMail='test@abc.com');
        insert cont;
        ///
        //testUser(cont);
        ///
    }
    // This Method creates Contact without email field
    static testMethod void testMethodWithoutEMail(){
        try {
            List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
            Account acc = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
            insert acc;
            Account accModified = [select BillingCity from Account where id =:acc.Id];        
            accModified.BillingCity = 'New York';         
            update accModified; 
            Contact cont = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
            insert cont;
            ///
            testUser(cont);
            ///
        }   
        catch(Exception e){
            e.getMessage();
        }
    }
    // This Method creates Account without enabling Partner     
    static testMethod void testMethodPartnerDisabled(){
        try {
            List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
            Account acc = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
            insert acc;
            Contact cont = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
            insert cont;
            ///
            testUser(cont);
            ///
        }    
        catch(Exception e){
            e.getMessage();
        }        
    }
    // This method creates user
    static void testUser(Contact cont){
        System.currentPagereference().getParameters().put('contactId', cont.Id); 
        CreateUserController obj = new CreateUserController();
        obj.doCreateUser(); 
        Profile p = [select id from Profile where Name = 'Axcient Partner User'];
        User u = [select UserName, ProfileId, LastName from User where ContactId =:cont.Id];
        if(u.UserName != null && u.ProfileId != null && u.LastName != null){
            System.assertEquals(u.UserName, 'ax-'+cont.EMail);
            System.assertEquals(u.ProfileId, p.Id);
            System.assertEquals(u.LastName, cont.LastName);
        }
        obj.cancel();
    }
    // This method tests User insert for bulk records
    /*static testMethod void testMethodForBulk(){
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc1 = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc1;
        Account acc2 = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc2;
        Account accModified1 = [select BillingCity from Account where id =:acc1.Id];        
        accModified1.BillingCity = 'New York';         
        update accModified1; 
        Account accModified2 = [select BillingCity from Account where id =:acc2.Id];        
        accModified2.BillingCity = 'Washington DC';         
        update accModified2; 
        Contact cont1 = new Contact(LastName = 'Test Contact', AccountId = acc1.Id, EMail='test@abc.com');
        Contact cont2 = new Contact(LastName = 'Test Contact', AccountId = acc1.Id, EMail='test@abc.com');
        Contact cont3 = new Contact(LastName = 'Test Contact', AccountId = acc2.Id, EMail='test@abc.com');
        List<Contact> contList = new List<Contact>();
        contList.add(cont1);
        contList.add(cont2);
        contList.add(cont3);
        insert contList;
        Profile p = [select id from Profile where Name = 'Axcient Gold Partner User'];
        User u1 = new User(contactId = cont1.Id,
        alias = 'standt',
        FirstName = 'Mr',
        LastName = 'First',
        Email = 'first@first.com',
        Username = 'first@f.com',
        CommunityNickname = 'abc',
        profileId = p.Id,emailencodingkey = 'UTF-8',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US', 
        timezonesidkey = 'America/Los_Angeles');            
        User u2 = new User(contactId = cont2.Id,
        alias = 'standt',
        FirstName = 'Mr',
        LastName = 'Second',
        Email = 'first@second.com',
        Username = 'second@s.com',
        CommunityNickname = 'xyz',
        profileId = p.Id,emailencodingkey = 'UTF-8',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US', 
        timezonesidkey = 'America/Los_Angeles');            
        User u3 = new User(contactId = cont3.Id,
        alias = 'standt',
        FirstName = 'Mr',
        LastName = 'Third',
        Email = 'first@third.com',
        Username = 'third@t.com',
        CommunityNickname = 'pqr',
        profileId = p.Id,emailencodingkey = 'UTF-8',
        languagelocalekey = 'en_US',
        localesidkey = 'en_US', 
        timezonesidkey = 'America/Los_Angeles');            
        List<User> users = new List<User>();
        users.add(u1);
        users.add(u2);
        users.add(u3);
        insert users;
    }*/
}