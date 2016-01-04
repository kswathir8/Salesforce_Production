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
private class CreateShipperInIntacct_Test {

    static testMethod void unitTestForOpportunity() 
    {
        // TO DO: implement unit test
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', End_Customer__c = account.Id, CloseDate = System.today(), StageName = 'Evaluation');
        insert opp;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(zkfedex__TotalNetCharge__c = 100, Opportunity__c = opp.id, zkfedex__ShipDate__c = Date.newInstance(2012,7,28) );
        insert shipment;
        
        Sales_Order__c salesOrder = new Sales_Order__c(Name='Test Sales Order', Date__c = System.Today(), Opportunity__c = opp.id, Account__c = account.id, Ship_Date__c = System.today());
        insert salesOrder;
        
        Sales_Order_Item__c soItem1 = new Sales_Order_Item__c(Name = 'Test Sales Order Item', Sales_Order__c = salesOrder.id, Axcient_Serial_Number__c = 'Test Asset1', Product_Serial_Number__c = 'Test Serial Number1', Axcient_Asset_Tag__c ='Test1'  );
        //insert soItem1;
        Sales_Order_Item__c soItem2 = new Sales_Order_Item__c(Name = 'Test Sales Order Item2', Sales_Order__c = salesOrder.id, Axcient_Serial_Number__c = 'Test Asset', Product_Serial_Number__c = 'Test Serial Number', Axcient_Asset_Tag__c ='Test'  );
        //insert soItem2;
        
        List<Sales_Order_Item__c> items = new List<Sales_Order_Item__c>();
        items.add(soItem1);
        items.add(soItem2);
        insert items;
        
        salesOrder = [select id, name,Reference_Number__c,Ship_Date__c, Account__c, Date__c, Terms__c, Bill_to_Address_1__c, Bill_to_Address_2__c,
                     Bill_to_City__c, Bill_to_Country__c, Bill_to_Name__c, Ship_to_Name__c, Opportunity__r.Name, Ship_to_city__c,
                     Ship_to_Country__c, Ship_to_State__c, Ship_to_zip_Code__c, Bill_to_zip_Code__c, Bill_to_State__c, Ship_to_Address_1__c,
                     Account__r.Id, Account__r.Name, Account__r.IntacctID__c, Account__r.Credit_Terms__c,Opportunity__r.id,
                     (select id, Quantity__c, price__c, Item__c, Sales_Order__c, Axcient_Asset_Tag__c, Axcient_Serial_Number__c,Product_Serial_Number__c
                     from R00N40000001bdlLEAQ__r ) 
                     from Sales_Order__c WHERE Opportunity__c =: opp.Id order by Date__c DESC Limit 1 ];
        System.assertEquals(salesOrder.Name,'Test Sales Order');

        CreateShipperInIntacct createShip = new CreateShipperInIntacct();
        Test.startTest();
        createShip.createShipperForTest(opp.id);
        Test.stopTest();
    }
    
    static testMethod void unitTestForCase() 
    {
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test Contact', AccountId = account.id, Last_Case_Survery_Completed__c = System.Today());
        insert contact;
        
        Case caseRecord = new Case(AccountId = account.Id, ContactId = contact.Id, Type = 'DAS Device Tracker', Case_Reason__c = 'DAS', Origin = 'Sales', Status = 'Open');
        insert caseRecord;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(zkfedex__TotalNetCharge__c = 100, Case__c = caseRecord.id, zkfedex__ShipDate__c = Date.newInstance(2012,7,28) );
        insert shipment;
        CreateShipperInIntacct createShip = new CreateShipperInIntacct();
        Test.startTest();
        createShip.createShipperForTest(caseRecord.Id);
        Test.stopTest();
    }
}