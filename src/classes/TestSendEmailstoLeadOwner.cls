@isTest(SeeAllData=true) 
public class TestSendEmailstoLeadOwner
{

 // Class:SendMailtoLeadOwner(Swathi Karkala)
 //Test Method

    private static testMethod void TestSendMailtoLeadOwner()
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

               //Create a ChangeOwnerReason
               Change_Owner_Reason__c co= new change_owner_reason__c();
               co.Requestor_Reason__c='testing Axcient';
               co.lead__c= ld.Id;
               co.Approve_Reject__c= null;
               co.Approval_Reject_Reason__c='TESTING24241241241';
               insert co;

               Test.stopTest();
            }   
            
    } 
    
}