/************************************************
* Test Class Name: TestForOpenDASRequest        *       
* Created By     : Axcient                      *                        
* This class tests OpenDASRequest trigger.      *                                          
************************************************/

@isTest /*added by Sererra */(seeAllData = true)
class TestForUpdateCasesForAsset {
    static testMethod void testMethodForCodeCoverage(){
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        Opportunity opp = new Opportunity(Name = 'OppTest', RMC_Email__c = 'opp@test.com', CloseDate = myDate, StageName = 'Initial Contact');
        insert opp;
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account for DAS12', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc;
        Contact cont = new Contact(AccountId = acc.Id, LastName = 'Jolinou');
        insert cont;
        Group dasGroup = [select Id from Group where Name ='D.A.S Requests'];       
        
                      
        Asset as1 = new Asset(Name = 'AA0211A0211200034',Asset_Tag__c ='2431',ContactId=cont.Id);
                
        
//        D_A_S__c das = new D_A_S__c(Opportunity__c = opp.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        try {
            insert as1;
        }
        catch(Exception e){
            e.getMessage();
            System.debug('######## Message ####' + e.getMessage());      
        }
        
        Case c = new Case(Origin = 'Phone', Status = 'Open', AccountId = acc.Id, Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp.Id, OwnerId = dasGroup.Id );
        insert c;
        
        c.AssetId = as1.Id;
        update c;
        
        Case c1 = new Case(Origin = 'Phone', Status = 'Open', AccountId = acc.Id,Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp.Id, OwnerId = dasGroup.Id, AssetID= as1.Id );
        insert c1;
        
        Case c2 = new Case(Origin = 'Phone', Status = 'Closed', AccountId = acc.Id, Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp.Id, OwnerId = dasGroup.Id, AssetID= as1.Id);
        insert c2;
        
        /*added by Sererra
         * Start
        */
        c = [
            SELECT id, AccountId FROM Case where Id =: c.Id
        ];
        System.assertEquals(c.AccountId, acc.Id);
        c1 = [
            SELECT id, AccountId FROM Case where Id =: c1.Id
        ];
        System.assertEquals(c1.AccountId, acc.Id);
        c2 = [
            SELECT id, AccountId FROM Case where Id =: c2.Id
        ];
        System.assertEquals(c2.AccountId, acc.Id);
        /*
         * End
        */
        as1.DAS_Phase__c ='1) Requested';
        as1.Outbound_Shipment_Tracking__c = '1234567';
        update as1;
                
        
        as1.DAS_Phase__c ='2) Returned';      
        as1.Outbound_Asset_Actual_Delivery_Date__c = myDate; 
        as1.Return_Shipment_Actual_Delivery_Date__c = myDate ;
        as1.Return_Shipment_Ship_Date__c = myDate + 2 ;
        as1.Return_Shipment_Tracking__c = '12121212' ;
                
        update as1;
        
        
        c1.Type = '';
        update c1;
        
        
        
      
                     
    
    }    
}