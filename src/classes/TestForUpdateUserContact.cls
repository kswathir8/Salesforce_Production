/************************************************
* Test Class Name: TestForOpenDASRequest        *       
* Created By     : Pranav Lal                   *                        
* This class tests UpdateAccount trigger.      *                                   

       
************************************************/

@isTest
class TestForUpdateUserContact {

    static testMethod void testMethodForCodeCoverageAccountUpdate(){
        
        //create account
        //make it partner enabled
        
        List<RecordType> recordID = [select Id from RecordType where name ='Partner' and sObjecttype = 'Account' limit 1];
        
        Account acc = new Account(Name = 'Account Test Class1234', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
        insert acc;
        
        Contact cont = new Contact(LastName = 'Test33',FirstName='Pranav33', AccountId = acc.Id,EMail='test232322@abc.com');
        insert cont;
        
        Contact cont2 = new Contact(LastName = 'Test285',FirstName='Pranav2', AccountId = acc.Id,EMail='test244222@abc.com');
        insert cont2;
        
        Contact cont3 = new Contact(LastName = 'Test3744',FirstName='Pranav34', AccountId = acc.Id,EMail='test34343@abc.com');
        insert cont3;
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];

        System.assertEquals(cont.Partner_Agreement_Signed__c, cont2.Partner_Agreement_Signed__c);      
    //      System.assertEquals(acc.Partner_Agreement_Signed__c, cont.Partner_Agreement_Signed__c);      
    //      System.assertEquals(acc.Partner_Agreement_Signed__c, cont2.Partner_Agreement_Signed__c);      
              
    //    Account accModified = [select Partner_Membership_Level__c from Account where id =:acc.Id];        
    //    accModified.Partner_Membership_Level__c = 'Elite';         
    
          
       
        Profile p = [select id from Profile where Name = 'Axcient Elite User'];
        
        
       /* User u1= new User(contactId = cont.Id,alias = 'standt',FirstName = cont.FirstName,LastName = cont.LastName,Email = cont.Email,Username= cont.Email,CommunityNickname = cont.FirstName+cont.LastName,
        profileId = p.Id,emailencodingkey = 'UTF-8',languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles'            
            );
        insert u1;*/
        
        User u2= new User(contactId = cont2.Id,alias = 'standt',FirstName = cont2.FirstName,LastName = cont2.LastName,Email = cont2.Email,Username= cont2.Email,CommunityNickname = cont2.FirstName+cont2.LastName,
        profileId = p.Id,emailencodingkey = 'UTF-8',languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles'            
            );
        insert u2;
        
        User testUser= new User(contactId = cont3.Id,alias = 'standt',FirstName = cont3.FirstName,LastName = cont3.LastName,Email = cont3.Email,Username= cont3.Email,CommunityNickname = cont3.FirstName+cont3.LastName,
        profileId = p.Id,emailencodingkey = 'UTF-8',languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles'            
            );
        insert testUser;
        
        System.runAs(thisUser) { // to avoid the DML exception error
        acc.Partner_Membership_Level__c = 'Elite';         
        update acc;
        
        //User TestUser = [select UserName, ProfileId, LastName,ProfileText__c from User where ContactId =:cont3.Id];      
        
        TestUser.ProfileText__c = '00e80000001OH1w';
        update TestUser;
        System.assertNotEquals(TestUser.ProfileText__c,TestUser.ProfileId);
        
        
        } 
        
                
       // User u3 = [select UserName, ProfileId, LastName,ProfileText__c from User where ContactId =:cont.Id];      
        User u4 = [select UserName, ProfileId, LastName,ProfileText__c from User where ContactId =:cont2.Id];      
        
        
           // System.assertEquals(u3.UserName, cont.EMail);
           // System.assertEquals(u3.ProfileId, p.Id);
           // System.assertEquals(u3.LastName, cont.LastName);
            //System.assertEquals(u3.ProfileId,u3.ProfileText__c);
            
            System.assertEquals(u4.UserName, cont2.EMail);
            System.assertEquals(u4.ProfileId, p.Id);
            System.assertEquals(u4.LastName, cont2.LastName);
            //System.assertEquals(u4.ProfileId,u4.ProfileText__c);
            
           // System.assertEquals(u3.ProfileId,u4.ProfileId);
           // System.assertEquals(u3.ProfileText__c,u4.ProfileText__c);
        
        }
        
 }