@isTest(SeeAllData=true) 
public class TestTerritoryManager
{

 // Class:TestTerritoryManager(Swathi Karkala)
  
 //Test Method for leads

  private static testMethod void TestTerritoryManagerLeads()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               //Record Type 'Partner' && State 
               
                 //Create an Account
               account acc = new account();
               acc.Name='tesfdsnfdh';
               acc.Billingcountry = 'Australia';
               acc.Billingstate = 'NY';
               acc.Manual_override__c =false;
               acc.Transfer_Account__c = true;
               acc.OwnerId = usr.Id;
               insert acc;
               
               //Create a Lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient'; 
               ld.manual_override__c = false;
               insert ld;
              
              //Create a Axcitory
               axcitory__c ax = new axcitory__c();
               ax.Name = 'South232';
               ax.RecordTypeID = '01280000000UJ1y';
               ax.Partner_Recruiter__c = usr.ID;
               //ax.recordtypeID ='Partner';
               ax.OwnerID = usr.ID;
               ax.TSM__c = usr.ID;
               insert ax;
               
               //Create a Range
               Zip_Code_Range__c rg = new Zip_Code_Range__c();
               rg.Name = 'test32467';
               rg.RecordTypeID = '01280000000UIOm';
               rg.Type__c ='End Customer';
               rg.State__c = 'NY';
               rg.state__c = ld.state;
               rg.zip_code_start__c='00008';
               rg.zip_code_stop__c='94876';
               insert rg;

               
               ld.MQL2__c = true;
               ld.state = rg.state__c;
               ld.ownerid = ax.ownerid;
               update ld;
               
              
               ld.Transfer_Lead__c = true;
               ld.MQL2__c = false;
               ax.OwnerID = usr.ID;
               update ld;
               
               Test.stopTest();
            }   
            
    } 
     
    
    //Test Method for Australia leads

    private static testMethod void TestTerritoryManagerLeadsAus()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               /*****Record Type 'partner' && State ******/
               
                 //Create an Account
               account acc = new account();
               acc.Name='tesfdsnfdh';
               acc.Billingcountry = 'Australia';
               acc.Transfer_Account__c = true;
               acc.OwnerId = usr.Id;
               insert acc;
               
               //Create a Lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient';
               ld.manual_override__c = false; 
               insert ld;
              
              //Create a Axcitory
               axcitory__c ax = new axcitory__c();
               ax.Name = 'South232';
               ax.RecordTypeID = '01280000000UJ1y';
               ax.Partner_Recruiter__c = usr.ID;
               ax.OwnerID = usr.ID;
               ax.TSM__c = usr.ID;
               insert ax;
               
               //Create a Range
               Zip_Code_Range__c rg = new Zip_Code_Range__c();
               rg.Name = 'test32467';
               rg.RecordTypeID = '01280000000UIOm';
               rg.Type__c = 'Partner';
               rg.State__c = 'NY';
               rg.state__c = ld.state;
               rg.zip_code_start__c='00008';
               rg.zip_code_stop__c='94876';
               insert rg;
               
               rg.Type__c ='VAR';
               ld.Country= 'Australia';
               ld.Transfer_lead__c= true;
               ld.ownerid= usr.id;
               //acc.Axcitory__c= ax.Name;
               update ld;
              
               Test.stopTest();
            }   
            
    } 
    //Test Method for Accounts

    private static testMethod void TestTerritoryManagerAccounts()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               /*****Record Type 'Partner' && State ******/
               
                 //Create an Account
               account acc = new account();
               acc.Name='tesfdsnfdh';
               acc.Billingcountry = 'Australia';
               acc.Transfer_Account__c = true;
               acc.OwnerId = usr.Id;
               insert acc;
               
               //Create a Lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient'; 
               ld.manual_override__c = false;
               insert ld;
              
              //Create a Axcitory
               axcitory__c ax = new axcitory__c();
               ax.Name = 'South232';
               ax.RecordTypeID = '01280000000UJ1y';
               ax.Partner_Recruiter__c = usr.ID;
               ax.OwnerID = usr.ID;
               ax.TSM__c = usr.ID;
               insert ax;
               
               //Create a Range
               Zip_Code_Range__c rg = new Zip_Code_Range__c();
               rg.Name = 'test32467';
               rg.RecordTypeID = '01280000000UIOm';
               rg.Type__c ='End Customer';
               rg.State__c = 'NY';
               rg.state__c = ld.state;
               rg.zip_code_start__c='00008';
               rg.zip_code_stop__c='94876';
               insert rg;

               acc.BillingState = 'NY';
               acc.BillingPostalcode='97890';
               acc.manual_override__c= false;
               //acc.Axcitory__c= ax.Name;
               update acc;
               
               acc.Transfer_Account__c = true;
               acc.Transfer_lead__c = true;
               ax.TSM__c = usr.Id;
               update acc;
               
               Test.stopTest();
            }   
            
    } 
    
    //Test Method for Accounts1

    private static testMethod void TestTerritoryManagerAccounts1()
    {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
                
               /*****Record Type 'Partner' && State ******/
               
                 //Create an Account
               account acc = new account();
               acc.Name='tesfdsnfdh';
               acc.Billingcountry = 'Australia';
               acc.Transfer_Account__c = true;
               acc.OwnerId = usr.Id;
               insert acc;
               
               //Create a Lead
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient'; 
               ld.manual_override__c = false;
               insert ld;
              
              //Create a Axcitory
               axcitory__c ax = new axcitory__c();
               ax.Name = 'South232';
               ax.RecordTypeID = '01280000000UJ1y';
               ax.Partner_Recruiter__c = usr.ID;
               ax.OwnerID = usr.ID;
               ax.TSM__c = usr.ID;
               insert ax;
               
               //Create a Range
               Zip_Code_Range__c rg = new Zip_Code_Range__c();
               rg.Name = 'test32467';
               rg.RecordTypeID = '01280000000UIOm';
               rg.Type__c = 'Partner';
               rg.State__c = 'NY';
               rg.state__c = ld.state;
               rg.zip_code_start__c='00008';
               rg.zip_code_stop__c='94876';
               insert rg;

               rg.Type__c = 'VAR';
               acc.Transfer_Account__c = false;
               acc.Transfer_lead__c = true;
               ax.TSM__c = usr.Id;
               update acc;
               
               rg.Type__c = 'VAR';
               acc.Transfer_Account__c = false;
               acc.Transfer_lead__c = false;
               ax.TSM__c = usr.Id;
               update acc;
                            
               Test.stopTest();
            }   
            
    } 
    
}