/**
 
 */
@isTest(seeAllData = true)
private class AddAssestListToFedexShipment_Test {

    static testMethod void UnitTestForOpportunity() {
        // TO DO: implement unit test
        
        Account account = new Account(
        	Name = 'Test Account', 
        	IntacctId__c = 'test'
        );
        insert account;
        
        Opportunity opp = new Opportunity(
        	Name = 'Test Oppty',
        	StageName = 'Prospecting',
        	CloseDate = System.Today(),
        	End_Customer__c = account.Id,
        	AccountId = account.Id
        );
        insert opp;
        
        Product2 product = new Product2(
        	Name = 'Test Product', 
        	HW_Type__c = 'D.A.S', 
        	ProductCode = 'Test Product code', 
        	isActive=true, 
        	Product_Type__c = 'HW'
        );
        insert product;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PricebookEntry d = new PricebookEntry(
        	Pricebook2Id = pb2Standard.id, 
        	Product2Id=product.Id, 
        	UnitPrice=99, 
        	isActive=true
        ); 
        insert d;
        
        Asset asset = new Asset(
        	Name='Test Asset', 
        	AccountId = account.Id,
        	Opportunity__c = opp.Id, 
        	SerialNumber = 'Test Serial Number', 
        	Asset_Tag__c = 'Test2', 
        	Product2 = product,  
        	Product2ID = product.Id
        );
        insert asset;
        OpportunityLineItem oli = new OpportunityLineItem(
        	OpportunityId=opp.Id, 
        	PriceBookEntry=d, 
        	PriceBookEntryId=d.Id, 
        	UnitPrice=d.UnitPrice, 
        	Quantity=1,
        	Asset__c = asset.Id
        );
        insert(oli);
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(
        	zkfedex__TotalNetCharge__c = 100, Opportunity__c = opp.id, 
        	zkfedex__ShipDate__c = Date.newInstance(System.Today().Year(),System.Today().Month(),System.Today().Day()) 
        );
        insert shipment;
        
	    Map<String, String> objIds = new Map<String, String>();
	    objIds.put(shipment.Id, opp.Id);
	    Map<String, Boolean> shipmentIds = new Map<String, Boolean>();
	    shipmentIds.put(shipment.Id, false);
	    
        Test.StartTest();
	       AddAssestListToFedexShipment.CreateProductShipments(objIds, shipmentIds);
        Test.StopTest();
    }
    
    static testMethod void UnitTestForCase() {
        // TO DO: implement unit test
        
        Account account = new Account(
        	Name = 'Test Account', 
        	IntacctId__c = 'test'
        );
        insert account;
        
        Contact contact = new Contact(
        	LastName = 'Test Contact', 
        	AccountId = account.id, 
        	Last_Case_Survery_Completed__c = System.Today()
        );
        insert contact;

        Asset asset = new Asset(
        	Name='Test Asset', 
        	AccountId = account.Id,        	 
        	SerialNumber = 'Test Serial Number', 
        	Asset_Tag__c = 'Test2' 
        );
        insert asset;
        
        Case caseRecord = new Case(
        	AssetId = asset.Id, 
        	AccountId = account.Id, 
        	ContactId = contact.Id, 
        	Type = 'DAS Device Tracker', 
        	Case_Reason__c = 'DAS', 
        	Origin = 'Sales', 
        	Status = 'Open'
        );
        insert caseRecord;
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(
	        	zkfedex__TotalNetCharge__c = 100, Case__c = caseRecord.Id, 
	        	zkfedex__ShipDate__c = Date.newInstance(System.Today().Year(),System.Today().Month(),System.Today().Day()) 
	        );
	    insert shipment;
	    
	    Map<String, String> objIds = new Map<String, String>();
	    objIds.put(shipment.Id, caseRecord.Id);
	    Map<String, Boolean> shipmentIds = new Map<String, Boolean>();
	    shipmentIds.put(shipment.Id, false);
	    
        Test.StartTest();
	       AddAssestListToFedexShipment.CreateProductShipments(objIds, shipmentIds);
        Test.StopTest();
    }
    
    public static testMethod void testInsertShipment(){
    	
    	Account account = new Account(
        	Name = 'Test Account', 
        	IntacctId__c = 'test'
        );
        insert account;
        
        Opportunity opp = new Opportunity(
        	Name = 'Test Oppty',
        	StageName = 'Prospecting',
        	CloseDate = System.Today(),
        	End_Customer__c = account.Id,
        	AccountId = account.Id
        );
        insert opp;
        
        Product2 product = new Product2(
        	Name = 'Test Product', 
        	HW_Type__c = 'D.A.S', 
        	ProductCode = 'Test Product code', 
        	isActive=true, 
        	Product_Type__c = 'HW'
        );
        insert product;
        
        PriceBook2 pb2Standard = [select Id from Pricebook2 where isStandard=true];
        
        PricebookEntry d = new PricebookEntry(
        	Pricebook2Id = pb2Standard.id, 
        	Product2Id=product.Id, 
        	UnitPrice=99, 
        	isActive=true
        ); 
        insert d;
        
        Asset asset = new Asset(
        	Name='Test Asset', 
        	AccountId = account.Id,
        	Opportunity__c = opp.Id, 
        	SerialNumber = 'Test Serial Number', 
        	Asset_Tag__c = 'Test2', 
        	Product2 = product,  
        	Product2ID = product.Id
        );
        insert asset;
        
        OpportunityLineItem oli = new OpportunityLineItem(
        	OpportunityId=opp.Id, 
        	PriceBookEntry=d, 
        	PriceBookEntryId=d.Id, 
        	UnitPrice=d.UnitPrice, 
        	Quantity=1,
        	Asset__c = asset.Id
        );
        insert(oli);
        
        zkfedex__Shipment__c shipment = new zkfedex__Shipment__c(
        	zkfedex__TotalNetCharge__c = 100, Opportunity__c = opp.id, 
        	zkfedex__ShipDate__c = Date.newInstance(System.Today().Year(),System.Today().Month(),System.Today().Day())
        	);
        insert shipment;
        
        
        List<Product_Shipment__c> shipments = [Select id From Product_Shipment__c Where Asset__c = :asset.id AND FedEx_Shipment__c = :shipment.id];
        System.assertEquals(1,shipments.size());
        
        Test.startTest();
        	update shipment;
        Test.stopTest();
        
        shipments = [Select id From Product_Shipment__c Where Asset__c = :asset.id AND FedEx_Shipment__c = :shipment.id];
        System.assertEquals(1,shipments.size());
        
    }
}