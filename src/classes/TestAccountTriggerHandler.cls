@isTest(SeeAllData=true) 
public class TestAccountTriggerHandler
{

 // Class:AccountTriggerHandler(Swathi Karkala)
 //Test Method

   /* private static testMethod void TestTranferAccountUserName()
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
               Account acc = new Account(); 
               acc.Name='TestAcc12';      
               insert acc;
               
               acc.Transfer_Account__c=true;
               update acc;
               
               Test.stopTest();
            }   
            
    } */
    
}