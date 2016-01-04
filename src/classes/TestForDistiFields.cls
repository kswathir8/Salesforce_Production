@isTest(seeAllData=true)
class TestForDistiFields {
    // This Method creates Account and Contact Objects
   /* static testMethod void testMethodForCodeCoverage(){
     
     
     
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        
        List<RecordType> recordID1 = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
        
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Test.starttest();
        Product2 prd1 = new Product2 (Name='HP Product',Description='HP Product',productCode = 'HP 1', isActive = true,Product_Type__c='HW');
        insert prd1;

        Product2 prd2 = new Product2 (Name='HP Product 2',Description='HP Product2',productCode = 'HP 2', isActive = true, Product_Type__c='HW');
        insert prd2;
        
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe1;

        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=50, isActive=true);
        insert pbe2;


        Account acc = new Account(Name = 'Account Test Class 1', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner', HC_01__c =2 , HC_02__c ='Prepaid' , HC_03__c= 2, HC_04__c ='4' , HC_05__c = 4 , HC_06__c = 5 , HC_07A__c = 3 , HC_07B__c = 2 , HC_08__c = 3 , HC_09__c = 3 );
        insert acc;
        
        Account acc1 = new Account(Name = 'Account Test Class Distic', RecordTypeId = recordID[0].Id, 
        Partner_Agreement_Signed__c = 'yes',Primary_Disti__c = acc.Id, Disti_Account_Number__c = '1213123',
        Partner_Membership_Level__c='Partner', HC_01__c =2 , HC_02__c ='Prepaid' );
        insert acc1;
                
        Account accec = new Account(Name = 'Account Test Class 2', RecordTypeId = recordID1[0].Id,Primary_Disti__c = acc1.Id, Disti_Account_Number__c ='45625');
        insert accec;
        
        Account accec2 = new Account(Name = 'Account Test Class 3', RecordTypeId = recordID1[0].Id );
        insert accec2;
        
        Contact con = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc1.Id, Email ='pl@axcient.com', Hardware_Fulfillment_Contact__c = TRUE);  
        insert con;

        Contact con2 = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc1.Id,Email ='pl2@axcient.com',Hardware_Fulfillment_Contact__c = TRUE );  
        insert con2;


        Contact con3 = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc1.Id,Email ='pl3@axcient.com', Hardware_Fulfillment_Contact__c = TRUE );  
        insert con3;
        
        
        Opportunity opp1 = new Opportunity(Name = 'OppTest 1', CloseDate = System.today(), StageName = 'Live Discussion', AccountId = acc.Id,Status__c = 'Active',QuotePaymentMode__c ='Credit Card', End_Customer__c = accec.Id , Displaced_Backup_Solutions__c ='Acronis', Ship_Appliance_To__c = 'Partner' , Service_Level__c ='Business Backup');
        insert opp1;
        
        Opportunity opp2 = new Opportunity(Name = 'OppTest NFR 1', CloseDate = System.today(), StageName = 'Live Discussion', AccountId = accec.Id,Status__c = 'Active',QuotePaymentMode__c ='Credit Card',  Displaced_Backup_Solutions__c='Acronis', Ship_Appliance_To__c = 'Partner' , Service_Level__c ='Business Backup' )  ;
        insert opp2;
        
        Opportunity opp3 = new Opportunity(Name = 'OppTest NFR 2', 
        CloseDate = System.today(), 
        StageName = 'Closed Won', 
        AccountId = acc1.Id,
        End_Customer__c = accec2.Id,
        Status__c = 'Active',
        QuotePaymentMode__c ='Credit Card',  
        Displaced_Backup_Solutions__c='Acronis', 
        Ship_Appliance_To__c = 'Partner' , 
        Service_Level__c ='Business Backup' )  ;
        insert opp3;
        
    OpportunityLineItem oli = new OpportunityLineItem (
    OpportunityId=opp3.Id,
    UnitPrice = 22,
    PriceBookEntryId= pbe1.id,
    Payable_to_Reseller__c = 5,
    Quantity =1
    
    );
    insert oli;
    Test.stoptest();

    OpportunityLineItem oli2 = new OpportunityLineItem (
    OpportunityId=opp3.Id,
    UnitPrice = 22,
    PriceBookEntryId= pbe2.id,
    Payable_to_Reseller__c = 5,
    Quantity =1
    );
    insert oli2;        

       
        opp1.Disti_Deal__c = TRUE;
        opp3.Disti_Deal__c = TRUE;
        opp3.Disti__c = acc1.Id ;
        opp3.Disti_Account_Number__c = '1232312';
        opp3.Status__c = 'Inactive';
        update opp3 ;
        opp3.Status__c = 'Active';
        update opp3 ;
        
        try
        {
        update opp1 ;
        }
        
        catch(Exception ex)
        {
        System.debug(ex);
        }
        
        opp2.Disti_Deal__c = TRUE ;
        update opp2 ;
        
           
        
        }
        */
        
  }