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
private class CreatePackingSlipControllerForCase_Test {

    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
        insert account;
        
        Contact contact = new Contact(LastName = 'Test Contact', AccountId = account.id, Last_Case_Survery_Completed__c = System.Today());
        insert contact;
        
        Asset asset = new Asset(Name='Test Asset', AccountId = account.id, SerialNumber = 'Test Serial Number', Asset_Tag__c = 'Test2',
                                Times_Asset_Shipped__c = 25);
        insert asset;
        
        Case caseRecord = new Case(AssetId = asset.Id, AccountId = account.Id, ContactId = contact.Id, Type = 'DAS Device Tracker', Case_Reason__c = 'DAS', Origin = 'Sales', Status = 'Open');
        insert caseRecord;

        PageReference pg = Page.CreatePackingSlipForCase;
        Test.setCurrentPage(pg);
        pg.getParameters().put('id',caseRecord.id);
        ApexPages.StandardController standardController;
        CreatePackingSlipForCaseController controller = new CreatePackingSlipForCaseController(standardController);

        Test.startTest();
        controller.printPackingSlipForTest(); 
        Test.stopTest(); 
    }
}