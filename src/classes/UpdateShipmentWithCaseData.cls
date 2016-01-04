public with sharing class UpdateShipmentWithCaseData {
        
    public String caseId {get; set;}
    public UpdateShipmentWithCaseData()
    {
        caseId = ApexPages.CurrentPage().getParameters().get('CF00N80000004iebR_lkid');
    }

    public void updateShipment(List<zkfedex__Shipment__c> shipments)
    {
        if(caseID != null)
        {
            for(zkfedex__Shipment__c s : shipments)
            {
                s.Recipient_Case__c = caseId;
            }
        }
    }
    
    private static testmethod void unitTest()
    {
        Account acc = new Account(Name ='Test Account', BillingCountry = 'United States');
        insert acc;
        acc = [select name from Account where Id =: acc.id];
        System.assertEquals(acc.name, 'Test Account');
        
        Contact cont = new Contact(LastName = 'Test Contact', AccountId = acc.Id, Last_Case_Survery_Completed__c = System.today());
        insert cont;
        cont = [select LastName from Contact where Id =: cont.id];
        System.assertEquals(cont.LastName, 'Test Contact');
        
        Case testCase = new Case(ContactId = cont.Id, Origin = 'Sales', Status = 'Open', Type = 'DAS Device Tracker', Case_Reason__c = 'DAS', Subject = 'Test Case', Description = 'Test Description');
        insert testCase;
        testCase = [select ContactId from Case where Id =: testCase.id];
        System.assertEquals(testCase.ContactId, cont.Id);
        
        List<zkfedex__Shipment__c> shipments = new List<zkfedex__Shipment__c>();
        for(Integer i = 0; i<200; i++)
        {
            zkfedex__Shipment__c shipment = new zkfedex__Shipment__c();
            shipments.add(shipment);
        }
        insert shipments;
        
        PageReference pageRef = Page.zkfedex__rateStep1;
        Test.setCurrentPage(pageRef);

        ApexPages.CurrentPage().getParameters().put('CF00NV0000000IXui_lkid', testCase.Id);
        UpdateShipmentWithCaseData controller = new UpdateShipmentWithCaseData();
        controller.updateShipment(shipments);        
    }
}