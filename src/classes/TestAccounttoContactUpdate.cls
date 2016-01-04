@isTest(SeeAllData=true) 
public class TestAccounttoContactUpdate
{

 // Class:AccounttoContactUpdate(Swathi Karkala)
 
 //Test Method for OwnerUpdate on Contact

    private static testMethod void TestOwnerUpdate()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
               acc.Manual_Override__c= false;
               acc.OwnerId = usr.ID;
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
               con.Contact_Status__c='Working';
               con.OwnerId= usr.ID;
               insert con;

               con.OwnerId=acc.OwnerId;
               update con;
               
               Test.stopTest();
            }   
            
    } 
    
 //Test Method

    private static testMethod void TestAccounttoContactUpdate()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
               con.Contact_Status__c='Working';
               insert con;

               acc.Account_Status__c= 'Signed Agreement';
               con.Contact_Status__c='Unqualified';
               con.Contact_Status__c = 'Signed Agreement';
               update acc;
               
               acc.Account_Status__c= 'Active Customer';
               con.Contact_Status__c='Working';
               con.Contact_Status__c = 'Active Customer';
               update acc;
               
               
               Test.stopTest();
            }   
            
    } 
    
 //Test Method
 
    private static testMethod void TestAccounttoContactUpdate1()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
               con.Contact_Status__c='Working';
               insert con;
               
               acc.Account_Status__c = 'Recycle';
               con.Contact_Status__c = 'Recycle';
               update acc;
               
               acc.Account_Status__c = 'Qualified Account';
               con.Contact_Status__c='Working';
               con.Contact_Status__c = 'Qualified Account';
               update acc;
               
               
               Test.stopTest();
            }   
            
    } 
    //Test Method

    private static testMethod void TestAccounttoContactUpdate2()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
              
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
              
               con.Contact_Status__c='Working';
               insert con;
               

               acc.Account_Status__c = 'Sales Nurture';
               con.Contact_Status__c='Working';
               con.Contact_Status__c = 'Sales Nurture';
               update acc;
               
               acc.Account_Status__c = 'Not Engaged';
               con.Contact_Status__c='Working';
               con.Contact_Status__c = 'Not Engaged';
               update acc;
                              
               Test.stopTest();
            }   
            
    } 
    
    //Test Method

    private static testMethod void TestAccounttoContactUpdate3()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
              
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
               
               con.Contact_Status__c='Working';
               insert con;

               
               acc.Contract_Signed__c =true;
               con.NDA__c = acc.Contract_Signed__c;
               update acc;
               
               Test.stopTest();
            }   
            
    } 
    //Test Method

    private static testMethod void TestAccounttoContactUpdate4()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               
                Test.startTest();
                 
               //Create an Account
               account acc = new account();
               acc.Name ='testing34782394723';
               acc.Account_Status__c ='Working';
               acc.Contract_Signed__c =true;
               insert acc;
               
               //Create an Contact
               Contact con = new Contact();
               con.LastName='testing35253';
               con.Contact_Status__c='Working';
               insert con;

               acc.Account_Status__c= 'Actively Selling';
               con.Contact_Status__c='Unqualified';
               con.Contact_Status__c = 'Actively Selling';
               update acc;
               
               acc.Account_Status__c= 'Recycle';
               con.Contact_Status__c='Working';
               con.Contact_Status__c = 'Recycle';
               update acc;
               
               
               Test.stopTest();
            }   
            
    } 
    
    
    
}