@isTest(SeeAllData=true) 
public class TestOpportunitytoAssetUpdate
{

 // Class:OpportunitytoAssetUpdate(Swathi Karkala)
 //Test Method

    private static testMethod void TestOpportunitytoAssetUpdate()
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
               
               //Create an Opportunity
               Opportunity opp = new Opportunity();
               opp.Name = 'Testing34390';
               opp.AccountId = acc.Id;
               opp.CloseDate = date.today();
               opp.StageName = 'Closed Won';
               opp.Monthly_Serivce_Price__c = 20;
               opp.Additional_Ship_To_Email_Text__c='testgdg@gns343.com';
               opp.Additional_Ship_To_Contact_Text__c ='etgh hg';
               //opp.Additional_Ship_To_Contact_1__r.FirstName ='sbfdjfa';
               //opp.Additional_Ship_To_Contact_1__r.LastName='fjsjf';
              // opp.Additional_Ship_To_Contact_2__r.FirstName ='fdffassgd';
              // opp.Additional_Ship_To_Contact_2__r.LastName ='fdfbdsfsw';
               insert Opp;
               
               //Create an Contact
                Contact con = new Contact();
                con.FirstName ='Ja';
                con.LastName = 'Ta';
                con.AccountId = acc.Id;  
                insert con;
    
               //Create an Asset
                Asset as1 = new Asset();
                as1.Name = 'AA0211A0211200034';
                as1.Asset_Tag__c ='2431';
                as1.ContactId=con.Id;
                as1.Ship_to_Email_opp__c='ffssdFS@FDSJHFJASD.com';
                as1.ship_to_Name_opp__c='bdfkjs';
                as1.Additional_Ship_To_Email_Text__c='bfdsf@bfdjfbsfg.com';
                as1.Additional_Ship_To_Email_Notification_1__c='dbfjsf@hfushudf.com';
                as1.Additional_Ship_To_Email_Notification_2__c='dbsbfffndf@sjfdfh.com';
                as1.Additional_Ship_To_Contact_1__c='snbsfjf';
                as1.Additional_Ship_To_Contact_2__c='sbhbsjfsfh';
                insert as1;  
                 
                opp.Ship_To_Email__c = 'test4334@testingcompany.com';
                as1.Ship_To_Email_opp__c = 'test4334@testingcompany.com';
                Update as1;
               
               Test.stopTest();
            }   
            
    } 
    
 }