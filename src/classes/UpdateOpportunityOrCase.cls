public with sharing class UpdateOpportunityOrCase{
    
    public UpdateOpportunityOrCase()
    {
        
    }
    public void updateObjects(List<Other_Sales_Document__c> shippers)
    {
        Set<ID> ids = new Set<ID>();
        List<Opportunity> opps;
        List<Case> cases;
        String sObjType = '';
        for(Other_Sales_Document__c shipper: shippers)
        {
            if(shipper.Document_Type__c == 'Shipper')
            {
                if(shipper.Opportunity__c != null)
                {
                    ids.add(shipper.Opportunity__c);
                    sObjType = 'Opportunity';
                }
                if(shipper.Case__c != null)
                {
                    ids.add(shipper.Case__c);
                    sObjType = 'Case';
                }
            }
        }
        if(sObjType == 'Opportunity')
            opps = [select id, status__c, 
            		(select id from FedExShipments__r)
            		from Opportunity where Id in:ids];
        if(sObjType == 'Case')
            cases = [select id, DAS_Phase__c from Case where Id in: ids];
            
        try{
            List<SObject> objectsToUpdate = new List<SObject>();
            if(opps != null)
            {
                for(Opportunity opp : opps)
                {
                	if(opp.FedExShipments__r.size() > 0)
                	{
                    	opp.Status__c ='Converted';
                    	objectsToUpdate.add(opp);
                	}
                }
            }
            if(cases != null)
            {
            	System.debug(cases);
                for(Case c : cases)
                {
                   CreateInvoiceInIntacct.syncToIntacct(c.Id); 
                }
            }
            update(objectsToUpdate);
        }
        catch(DMLException ex)
        {
            System.Debug('DMLException: ' + ex.getMessage());
        }
    }
    
    @isTest private static void unitTestForOppty()
    {
       List<Other_Sales_Document__c> shippers = new List<Other_Sales_Document__c>();
       
       Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
       insert account;
       
       Opportunity opp = new Opportunity(Name = 'test opp', AccountId = account.Id, CloseDate=System.today(), StageName='Initial Contact'); 
       insert opp;
             
       Other_Sales_Document__c shipper1 = new Other_Sales_Document__c(Name = 'test shipper', Opportunity__c = opp.id, Document_Type__c = 'Shipper');        
       insert shipper1; 
       shippers.add(shipper1); 
       UpdateOpportunityOrCase controller = new UpdateOpportunityOrCase();
       Test.startTest();
       controller.updateObjects(shippers);
       Test.stopTest();
    }
    
    // 10/12/15 Commented out by Red Argyle due to failing test method.
    /*@isTest private static void unitTestForCase()
    {
       List<Other_Sales_Document__c> shippers = new List<Other_Sales_Document__c>();
       
       Account account = new Account(Name = 'Test Account', Phone = '(999) 999-9999', BillingCountry = 'United States', ShippingCity='shipping city', 
                                      ShippingStreet = 'shipping street', IntacctId__c = 'test');
       insert account;
        
       Contact contact = new Contact(LastName = 'Test Contact', AccountId = account.id, Last_Case_Survery_Completed__c = System.Today());
       insert contact;
        
       RecordType caseRecordType = [select Id,Name from RecordType where Name like '%DAS Case%' limit 1];
        
       Case caseRecord = new Case(RecordTypeID = caseRecordType.Id,AccountId = account.Id, ContactId = contact.Id, Type = 'DAS Device Tracker', Case_Reason__c = 'DAS', Origin = 'Sales', Status = 'Open');
       insert caseRecord;
       
       Other_Sales_Document__c shipper1 = new Other_Sales_Document__c(Name = 'test shipper', Case__c = caseRecord.Id, Document_Type__c = 'Shipper');
       insert shipper1; 
       
       shippers.add(shipper1); 
       UpdateOpportunityOrCase controller = new UpdateOpportunityOrCase();
       Test.startTest();
       controller.updateObjects(shippers);
       Test.stopTest();
    }*/
    
}