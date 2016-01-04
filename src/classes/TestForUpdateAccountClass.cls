@isTest
class TestForUpdateAccountClass {
    // This Method creates Account and Contact Objects
    static testMethod void testMethodForCodeCoverage(){
     
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        
        List<RecordType> recordID1 = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];

        Account acc = new Account(Name = 'Account Test Class 1', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner', HC_01__c =2 , HC_02__c ='Prepaid' , HC_03__c= 2, HC_04__c ='4' , HC_05__c = 4 , HC_06__c = 5 , HC_07A__c = 3 , HC_07B__c = 2 , HC_08__c = 3 , HC_09__c = 3 );
        insert acc;
        
        Account accec = new Account(Name = 'Account Test Class 2', RecordTypeId = recordID1[0].Id );
        insert accec;
        
        Contact cont1 = new Contact(AccountId = acc.Id, LastName = 'Jolinou1',ACE_Cert_Date__c = System.today(),ACE_Certified__c='YES',Email = 'p1@gmail.com');
        insert cont1;

        Contact cont2 = new Contact(AccountId = acc.Id, LastName = 'Jolinou2',ACE_Cert_Date__c = System.today(),ACE_Certified__c='YES',Email = 'p2@gmail.com');
        insert cont2;
        
        Contact cont3 = new Contact(AccountId = acc.Id, LastName = 'Jolinou3',ACE_Cert_Date__c = System.today(),ACE_Certified__c='YES',Email = 'p3@gmail.com');
        insert cont3;
        
        Contact cont4 = new Contact(AccountId = acc.Id, LastName = 'Jolinou4',ACE_Cert_Date__c = System.today(),ACE_Certified__c='YES',Email = 'p4@gmail.com');
        insert cont4;        
        
        Opportunity opp1 = new Opportunity(Name = 'OppTest 1', CloseDate = System.today(), StageName = 'Closed Won', AccountId = acc.Id,Status__c = 'Active',QuotePaymentMode__c ='Credit Card', End_Customer__c = accec.Id , Ship_To_Contact__c = cont1.Id, Displaced_Backup_Solutions__c ='Acronis', Ship_Appliance_To__c = 'Partner' , Service_Level__c ='Business Backup'   );
        insert opp1;
        
        Opportunity opp2 = new Opportunity(Name = 'OppTest NFR 1', CloseDate = System.today(), StageName = 'Closed Won', AccountId = acc.Id,Status__c = 'Active',QuotePaymentMode__c ='Credit Card', End_Customer__c = accec.Id,Ship_To_Contact__c = cont2.Id, Displaced_Backup_Solutions__c='Acronis', Ship_Appliance_To__c = 'Partner' , Service_Level__c ='Business Backup' );
        insert opp2;
        
        Opportunity opp3 = new Opportunity(Name = 'OppTest 2', CloseDate = System.today() , StageName = 'Closed Won', AccountId = acc.Id,Status__c = 'Inactive - Cancelled',QuotePaymentMode__c ='Credit Card', End_Customer__c = accec.Id,Ship_To_Contact__c = cont3.Id, Displaced_Backup_Solutions__c ='Acronis', Ship_Appliance_To__c = 'Partner' , Service_Level__c ='Business Backup' );
        insert opp3;
        
        Opportunity opp4 = new Opportunity(Name = 'OppTest NFR 2', CloseDate = System.today(), StageName = 'Closed Won', AccountId = acc.Id,Status__c = 'Inactive - Cancelled',QuotePaymentMode__c ='Credit Card', End_Customer__c = accec.Id,Ship_To_Contact__c = cont4.Id, Displaced_Backup_Solutions__c ='Acronis', Ship_Appliance_To__c = 'Partner', Service_Level__c ='Business Backup' );
        insert opp4;
        
        
        Asset as1 = new Asset(Name = 'AA0211A0211200034',Asset_Tag__c ='2431',AccountId=acc.Id);
        insert as1;
        
        Asset as2 = new Asset(Name = 'AA0211A0211200035',Asset_Tag__c ='2432',AccountId=acc.Id);
        insert as2;
        
        Asset as3 = new Asset(Name = 'AA0211A0211200036',Asset_Tag__c ='2433',AccountId=acc.Id);
        insert as3;
        
        Asset as4 = new Asset(Name = 'AA0211A0211200037',Asset_Tag__c ='2434',AccountId=acc.Id);
        insert as4;
        
        Asset as5 = new Asset(Name = 'AA0211A0211200038',Asset_Tag__c ='2435',AccountId=acc.Id);
        insert as5;
        
      Account GetAccount = [select Id, Name,HC_01__c,HC_02__c,HC_03__c, HC_04__c, HC_05__c,       HC_06__c,       HC_07A__c,       HC_07B__c,       HC_08__c,       HC_09__c from Account where Account.Id =:acc.id ] ;
        
      Integer CaseCount = [select count() from Case where AccountID =:acc.Id and CreatedDate = LAST_N_DAYS:360  ];
      Integer AssetCount = [select count() from Asset where AccountID = :acc.Id ];
      
      if(AssetCount!=0)
      {    
      Decimal CalcValue = CaseCount/AssetCount;
      }
      
      
     Integer EmailCount = [select count() from Case where AccountID =:acc.Id and Time_in_Escalated_Bus_Hrs__c > 0] ; 
     
     Integer ContactCount = [select count() from Contact where AccountID = :acc.Id and ACE_Certified__c = 'Yes'];
         
     ApexPages.Standardcontroller stdcon1 = new ApexPages.Standardcontroller(acc);
     updateaccount con1 = new updateaccount(stdcon1);
     PageReference pageRef = Page.accountpage;
     pageRef.getParameters().put('id', String.valueOf(acc.Id));
     Test.setCurrentPage(pageRef);
     con1.updateaccounts();

         
        
        
        
        }
        
   }