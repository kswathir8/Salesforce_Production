@isTest(SeeAllData=true) 
public class TestLeadTriggerHandler
{

 // Class:LeadTriggerHandler(Swathi Karkala)
 //Test Method

  /*  private static testMethod void TestTranferLeadUserName()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               //Create an lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient';         
               insert ld;
               
               ld.Transfer_Lead__c=true;
               update ld;
               
               ld.Transfer_Lead__c=false; 
               update ld;
                
               Test.stopTest();
            }   
            
    } */
    
}