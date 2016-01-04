/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CreateInvoiceInIntacct_Test {

    static testMethod void unitTest() {
        // TO DO: implement unit test
         
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;

        Opportunity opportunity = new Opportunity(Name = 'Opportunity Test',Shipping_Date__c = System.today(), End_Customer__c = account.Id, AccountID = account.id, CloseDate = System.today(), StageName = 'Evaluation' );
        insert opportunity;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(zkfedex__TotalNetCharge__c = 100, Opportunity__c = opportunity.id, zkfedex__ShipDate__c = Date.newInstance(2012,7,28) );
        insert shipment;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'Test Product code', isActive=true);
        insert product;
        
        PricebookEntry d = new PricebookEntry(Pricebook2Id = pb2Standard.id, Product2 = product, Product2Id=product.Id, UnitPrice=99, isActive=true); 
        insert d;
        
        Product2 product1 = new Product2(Name = 'Test Product', Product_Type__c = 'HW');
        insert product1;
        
        PricebookEntry d1 = new PricebookEntry(Pricebook2Id = pb2Standard.id, Product2 = product1, Product2Id=product1.Id, UnitPrice=99, isActive=true); 
        insert d1;

        PriceBook2 pb2 = [select Id from Pricebook2 where isStandard=true];
        
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=opportunity.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, Quantity=1);
        insert(item);
        OpportunityLineItem item1 = new OpportunityLineItem(OpportunityId=opportunity.Id, PriceBookEntry=d1, PriceBookEntryId=d1.Id, UnitPrice=d1.UnitPrice, Quantity=1);
        insert(item1);
       
        opportunity = [SELECT Id, Name, Amount, StageName, CloseDate, AccountId, Shipping_Date__c,
                       Account.Name, Account.IntacctID__c,Account.Credit_Terms__c, End_Customer__c, End_Customer__r.Name,
                       (SELECT ID, PriceBookEntry.Product2.ProductCode, Discount, PriceBookEntry.Product2.Name, Quantity, 
                       UnitPrice,TotalPrice, PriceBookEntry.Product2.Item_GL_Group__c, PriceBookEntry.Product2.Product_Type__c 
                       FROM OpportunityLineItems)                                  
                       FROM Opportunity WHERE id =: opportunity.Id]; 

        CreateInvoiceInIntacct createInvoice = new CreateInvoiceInIntacct();
        Test.startTest();
        if(Test.isRunningTest())
        {
        createInvoice.createInvoiceForTest(opportunity.id);
        }
        Test.stopTest();        
    }
    
    static testMethod void mySecondUnitTest() 
    {
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;
        
        Account endCustomer = new Account(Name = 'End Customer Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test1');
        insert endCustomer;
        
        Opportunity opportunity = new Opportunity(Name = 'Opportunity Test',Shipping_Date__c = System.today().toStartOfMonth(), AccountID = account.id, End_Customer__c = endCustomer.Id, CloseDate = System.today(), StageName = 'Evaluation' );
        insert opportunity;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(zkfedex__TotalNetCharge__c = 100, Opportunity__c = opportunity.id, zkfedex__ShipDate__c = Date.newInstance(2012,7,1) );
        insert shipment;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'Test Product code', isActive=true);
        insert product;
        
        PricebookEntry d = new PricebookEntry(Pricebook2Id = pb2Standard.id, Product2 = product, Product2Id=product.Id, UnitPrice=99, isActive=true); 
        insert d;
        
        Product2 product1 = new Product2(Name = 'Test Product', Product_Type__c = 'HW');
        insert product1;
        
        PricebookEntry d1 = new PricebookEntry(Pricebook2Id = pb2Standard.id, Product2 = product1, Product2Id=product1.Id, UnitPrice=99, isActive=true); 
        insert d1;
 
        PriceBook2 pb2 = [select Id from Pricebook2 where isStandard=true];
        
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId=opportunity.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, Quantity=1);
        insert(item);
        OpportunityLineItem item1 = new OpportunityLineItem(OpportunityId=opportunity.Id, PriceBookEntry=d1, PriceBookEntryId=d1.Id, UnitPrice=d1.UnitPrice, Quantity=1);
        insert(item1);
       
        opportunity = [SELECT Id, Name, Amount, StageName, CloseDate, AccountId, Shipping_Date__c,
                       Account.Name, Account.IntacctID__c,Account.Credit_Terms__c, End_Customer__c, End_Customer__r.Name,
                       (SELECT ID, PriceBookEntry.Product2.ProductCode, Discount, PriceBookEntry.Product2.Name, Quantity, 
                       UnitPrice,TotalPrice, PriceBookEntry.Product2.Item_GL_Group__c, PriceBookEntry.Product2.Product_Type__c                                                                     
                       FROM OpportunityLineItems)                                  
                       FROM Opportunity WHERE id =: opportunity.Id]; 

        CreateInvoiceInIntacct createInvoice = new CreateInvoiceInIntacct();
        Test.startTest();
        createInvoice.createInvoiceForTest(opportunity.id);
        Test.stopTest();
    }
    static testMethod void mySecondUnitTest3() 
    {
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test Contact', AccountId = account.id, Last_Case_Survery_Completed__c = System.Today());
        insert contact;
        
        Product2 product = new Product2(Name = 'Test Product', ProductCode = 'Test Product code', isActive=true);
        insert product;
        
        Asset asset = new Asset(Name='Test Asset', AccountId = account.id, SerialNumber = 'Test Serial Number', Asset_Tag__c = 'Test2', Product2 = product,  Product2ID = product.id);
        insert asset;
        
        RecordType caseRecordType = [select Id,Name from RecordType where Name like '%DAS Case%' limit 1 
        ];
        
        Case caseRecord = new Case(RecordTypeID = caseRecordType.Id, Type_of_Return__c ='EVAL', AccountId = account.Id, AssetId = asset.Id, ContactId = contact.Id, Type = 'DAS Device Tracker', Case_Reason__c = 'DAS', Origin = 'Sales', Status = 'Open');
        insert caseRecord;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(zkfedex__TotalNetCharge__c = 100, Case__c = caseRecord.id, zkfedex__ShipDate__c = Date.newInstance(2012,7,1) );
        insert shipment;
 
        CreateInvoiceInIntacct createInvoice = new CreateInvoiceInIntacct();
        Test.startTest();
        createInvoice.createInvoiceForTest(caseRecord.id);
        Test.stopTest();
    }
}