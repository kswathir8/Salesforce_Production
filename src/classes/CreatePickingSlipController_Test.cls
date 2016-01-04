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
@isTest(seeAllData = true)
private class CreatePickingSlipController_Test {

    static testMethod void unitTest1() {
        // TO DO: implement unit test
        
        Account accEnd = new Account(Name = 'Test Account',BillingCountry = 'United States');
        insert accEnd;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', End_Customer__c = accEnd.Id, CloseDate = System.today(), StageName = 'Evaluation');
        insert opp;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        Product2 product = new Product2(Name = 'Test Product',isActive=true, Product_Type__c = 'HW');
        insert product;
        
        PricebookEntry d = new PricebookEntry(Pricebook2Id = pb2Standard.id, Product2Id=product.Id, UnitPrice=99, isActive=true); 
        //[select Id, UnitPrice from PricebookEntry where IsActive = true limit 1];
        insert d;
        
        OpportunityLineItem item = new OpportunityLineItem(OpportunityId = opp.Id, PriceBookEntry=d, PriceBookEntryId=d.Id, UnitPrice=d.UnitPrice, Quantity=1);
        insert(item);
        item = [select id,OpportunityId from OpportunityLineItem where OpportunityId =: opp.Id limit 1];
        System.assertEquals(item.OpportunityId, opp.Id);
        
        Account acc = new Account(Name = 'Test Account',BillingCountry = 'United States');
        insert acc;
        
        Sales_Order__c salesOrder = new Sales_Order__c(Name='Test Sales Order', Opportunity__c = opp.id, Account__c = acc.id);
        insert salesOrder;
        
        opp = [select id, (select id from OpportunityLineItems) from Opportunity where Id =: opp.Id];
        System.assertEquals(opp.OpportunityLineItems.size(), 1);
        
        PageReference pg = Page.createPickingslipTemplate;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id',salesOrder.id);
        ApexPages.StandardController controller;
        CreatePickingSlipController pickSlip = new CreatePickingSlipController(controller);
        pickSlip.addAttachmentForTest();
    }
     static testMethod void unitTest2() {
          
        Account acc = new Account(Name = 'Test Account',BillingCountry = 'United States');
        insert acc;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', End_Customer__c = acc.Id, CloseDate = System.today(), StageName = 'Evaluation');
        insert opp;
        
        Sales_Order__c salesOrder = new Sales_Order__c(Name='Test Sales Order', Opportunity__c = opp.id, Account__c = acc.id);
        insert salesOrder;

        PageReference pg = Page.CreatePickingSlip;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id',salesOrder.id);
        ApexPages.StandardController controller;
        CreatePickingSlipController pickSlip = new CreatePickingSlipController(controller);
        pickSlip.addAttachmentForTest();
     }
}