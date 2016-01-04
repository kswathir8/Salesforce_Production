@isTest(SeeAllData=true) 
public class TestChangeLeadOwner
{

 // Class:TestChangeLeadOwner(Swathi Karkala)
 //Test Method

  /*  private static testMethod void TestingChangeLeadOwner()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               
               //Create a Lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient'; 
               ld.OwnerID='00580000003w3Sk';  
               insert ld;
               
               //Create an Change Owner Reason
               Change_Owner_Reason__c co = new Change_Owner_Reason__c(); 
               co.Requestor_Reason__c='afsgsdgs';  
               insert co;
               
               co.Approve_Reject__c='Approve';
               co.Approval_Reject_Reason__c='Testing198745667';
               co.ownerid=ld.ownerid;
               update co;


               Test.stopTest();
            }   
            
    } */
    
}