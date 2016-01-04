/**
* @author: Anusha Surapaneni
* @date: 12/09/2013
* @description: Unit test class for QuoteLineItemTriggerHandler.
* @history:
    1.
*/
@isTest(SeeAllData=true)
    public class TestQuoteLineItemTriggerHandler{
    
     // Unit Test 1: All 3 discounts available
    static testMethod void updateDiscountOnQuoteLineItem1() {
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe3.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Pre-paid',Deal_Registration__C = true);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe3.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 3.00,Reason_for_Approval__c='testing');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   } 
   
     // Unit Test 2: Only Registered and Prepay Discount Available
    static testMethod void updateDiscountOnQuoteLineItem2() {
       
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe3.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Pre-paid',Deal_Registration__C = true);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe3.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 0.00);
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   } 
    // Unit Test 3: Only Discretionary Discount and Prepay Discounts are available
    static testMethod void updateDiscountOnQuoteLineItem3() {
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
         //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Monthly',Deal_Registration__C = false);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 0.00,Reason_for_Approval__c = 'Test');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   }   
   
    // Unit Test 4: Only Registered Discount and Discretionary Discounts are available
    static testMethod void updateDiscountOnQuoteLineItem4() {
        
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
         //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe3.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Monthly',Deal_Registration__C = false);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe3.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 2.00,Reason_for_Approval__c='test');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   }
   
    // Unit Test 5: Only Registered Discount is available
    static testMethod void updateDiscountOnQuoteLineItem5() {
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
         //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Monthly',Deal_Registration__C = false);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 0.00);
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   }
    // Unit Test 6: Only Discretionary Discount is available
    static testMethod void updateDiscountOnQuoteLineItem6() {
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End Customer').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
         //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Monthly',Deal_Registration__C = false);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 2.00,Reason_for_Approval__c='test');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
        
   }
   // Unit Test 7: Only Prepay Discount is available
    static testMethod void updateDiscountOnQuoteLineItem7() {
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
         //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
        Product2 prd4 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Spares', isActive = true);
        insert prd4;
        Product2 prd5 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Support', isActive = true);
        insert prd5;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
        PricebookEntry pbe3 = new PricebookEntry (Product2ID=prd3.id,Pricebook2ID=standardPb.id,UnitPrice=9999, isActive=true);
        insert pbe3;
        PricebookEntry pbe4 = new PricebookEntry (Product2ID=prd4.id,Pricebook2ID=standardPb.id,UnitPrice=0, isActive=true);
        insert pbe4;
        PricebookEntry pbe5 = new PricebookEntry (Product2ID=prd5.id,Pricebook2ID=standardPb.id,UnitPrice=399, isActive=true);
        insert pbe5;
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Pre-paid',Deal_Registration__C = false);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 2.00,Reason_for_Approval__c='test');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
        QuoteLineItem lineItem3 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe3.id,UnitPrice=pbe3.unitprice, quantity=1);
        insert lineItem3;
        QuoteLineItem lineItem4 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe4.id,UnitPrice=pbe4.unitprice, quantity=1);
        insert lineItem4;
        QuoteLineItem lineItem5 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe5.id,UnitPrice=pbe5.unitprice, quantity=1);
        insert lineItem5;
   }
     // Unit Test :
    static testMethod void updateDiscountOnQuoteLineItem() {
        
        Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
        
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        
        Product2 prd2 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Rental', isActive = true);
        insert prd2;
        
        Product2 prd3 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 2',productCode = 'DEF',Family='Services', isActive = true);
        insert prd3;
       
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry (Product2ID=prd2.id,Pricebook2ID=standardPb.id,UnitPrice=445, isActive=true);
        insert pbe2;
       
        
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Pre-paid',Deal_Registration__C = True);
        insert opp1;
        
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 8.00,Reason_for_Approval__c = 'Test');
        insert q;
        
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
        
        QuoteLineItem lineItem2 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe2.id,UnitPrice=pbe2.unitprice, quantity=1);
        insert lineItem2;
      
   }        
}