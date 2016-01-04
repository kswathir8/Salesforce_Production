/************************************************
* Test Class Name: TestForOpenDASRequest        *       
* Created By     : Axcient                      *                        
* This class tests OpenDASRequest trigger.      *                                          
************************************************/

@isTest
class TestForOpenDASRequest {
    static testMethod void testMethodForCodeCoverage(){
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        Opportunity opp = new Opportunity(Name = 'OppTest', RMC_Email__c = 'opp@test.com', CloseDate = myDate, StageName = 'Initial Contact');
        insert opp;
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account for DAS', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc;
        Contact cont = new Contact(AccountId = acc.Id, LastName = 'Jolie');
        insert cont;
        Group dasGroup = [select Id from Group where Name ='D.A.S Requests'];       
        Case c = new Case(Origin = 'Phone', Status = 'Open', Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp.Id);
        insert c;
        c.OwnerId = dasGroup.Id;
        update c;     // Case Updated   
        D_A_S__c das = new D_A_S__c(Opportunity__c = opp.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        try {
            insert das;   
        }
        catch(Exception e){
            e.getMessage();
            System.debug('######## Message ####' + e.getMessage());      
        }             
    }
    static testMethod void testMethodForBulkRequest(){
        DateTime dT = System.now();
        Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
        Opportunity opp1 = new Opportunity(Name = 'OppTest1', RMC_Email__c = 'opp@test1.com', CloseDate = myDate, StageName = 'Initial Contact');
        Opportunity opp2 = new Opportunity(Name = 'OppTest2', RMC_Email__c = 'opp@test2.com', CloseDate = myDate, StageName = 'Initial Contact');
        Opportunity opp3 = new Opportunity(Name = 'OppTest3', RMC_Email__c = 'opp@test3.com', CloseDate = myDate, StageName = 'Initial Contact');
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp1);
        oppList.add(opp2);
        oppList.add(opp3);
        insert oppList;
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test Class', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes');
        insert acc;
        Contact cont = new Contact(AccountId = acc.Id, LastName = 'Jolie');
        insert cont;
        Group dasGroup = [select Id from Group where Name ='D.A.S Requests'];       
        Case c1 = new Case(Origin = 'Phone', Status = 'Open', Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp1.Id);
        Case c2 = new Case(Origin = 'Phone', Status = 'Open', Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting', Customer__c = opp2.Id);
        Case c3 = new Case(Origin = 'Phone', Status = 'Open', Type = 'Software', Case_Reason__c = 'Customer Network Troubleshooting');
        List<Case> caseList = new List<Case>();
        caseList.add(c1);
        caseList.add(c2);
        caseList.add(c3);
        insert caseList;   // Case Inserted 
        for(Case c : caseList){
            c.OwnerId = dasGroup.Id;
        }
        update caseList;   // Case Updated
        D_A_S__c das1 = new D_A_S__c(Opportunity__c = opp1.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        D_A_S__c das2 = new D_A_S__c(Opportunity__c = opp3.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        D_A_S__c das3 = new D_A_S__c(Opportunity__c = opp1.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        D_A_S__c das4 = new D_A_S__c(Opportunity__c = opp3.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        D_A_S__c das5 = new D_A_S__c(Opportunity__c = opp2.Id, Status__c = 'NEW REQUEST', EST_DATA_SIZE__c = '51G-100G', Contact_del__c = cont.Id);       
        List<D_A_S__c> dasList = new List<D_A_S__c>();
        dasList.add(das1);
        dasList.add(das2);
        dasList.add(das3);
        dasList.add(das4);
        dasList.add(das5);
        try{
            insert dasList;
        }
        catch(Exception e){
            e.getMessage();
            System.debug('######## Message ####' + e.getMessage());      
        }
    }    
}