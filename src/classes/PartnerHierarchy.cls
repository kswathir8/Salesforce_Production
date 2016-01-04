public class PartnerHierarchy {

    public static List<RecordType> RecordTypes = [Select id,Name,SObjectType From RecordType Where SObjectType IN ('Account','Opportunity')];
    public static Map<String,RecordType> nameToAccountRecordTypeMap;
    public static Map<String,RecordType> nameToOpportunityRecordTypeMap;
    public static Boolean beenInserted;

    public static void createOpportunityPartnersForEndCustomer(List<Opportunity> opps){
        
        
        Set<ID> acctIds = new Set<ID>();
        
        // Get all the OpportunityPartner records
        Map<ID,Map<String,Partner>> oppIDToRoleToPartner = new Map<ID,Map<String,Partner>>();
        for(Partner opPartner: [Select id,AccountToID,Role,OpportunityID From Partner Where OpportunityID IN :Opps ORDER BY CreatedDate DESC NULLS LAST]){
            
            if(!oppIDToRoleToPartner.containsKey(opPartner.OpportunityId)){ 
                    Map<String,Partner> roleToPartnerMap = new Map<String,Partner>();
                    roleToPartnerMap.put('Partner',null);
                    roleToPartnerMap.put('Distributor',null);
                    oppIDToRoleToPartner.put(opPartner.OpportunityId,roleToPartnerMap );
            }
            
            if(opPartner.Role == 'Partner' && oppIDToRoleToPartner.get(opPartner.OpportunityID).get('Partner') == null)  oppIDToRoleToPartner.get(opPartner.OpportunityID).put('Partner',opPartner);
            if(opPartner.Role == 'Distributor' && oppIDToRoleToPartner.get(opPartner.OpportunityID).get('Distributor') == null)  oppIDToRoleToPartner.get(opPartner.OpportunityID).put('Distributor',opPartner);
            acctIds.add(opPartner.AccountToID);
        }

        System.debug(oppIDToRoleToPartner.size());
    
        if(nameToAccountRecordTypeMap == null) initNameToRecordTypeMap();
        
        // Get Opp Accounts
        for(Opportunity op: opps){
            if(op.AccountId != null)    acctIds.add(op.AccountID);
        }
        Map<ID,Account> acctMap = new Map<ID,Account>([Select id,Name,RecordTypeID From Account Where id IN :AcctIds]);
        
        for(Opportunity op: opps){
            
            if(op.AccountId == null || op.Probability >= 70) continue;
            if(op.End_Customer__c == null)
            {
            op.End_Customer__c = op.AccountId;
            }
            if(AcctMap.get(op.AccountID).RecordTypeID == nameToAccountRecordTypeMap.get('Partner').id) op.Partner__c = op.AccountID;
            if(AcctMap.get(op.AccountID).RecordTypeID == nameToAccountRecordTypeMap.get('Disti').id){
                op.Partner__c = op.AccountID;
                op.Disti__c = op.AccountID;
            }
            
            if(oppIDToRoleToPartner.size() > 0){
                if(oppIDToRoleToPartner.get(op.id).get('Partner') != null && acctMap.containsKey(oppIDToRoleToPartner.get(op.id).get('Partner').AccountToID) && acctMap.get(oppIDToRoleToPartner.get(op.id).get('Partner').AccountToID).RecordTypeID == nameToAccountRecordTypeMap.get('Partner').id ) op.Partner__c = oppIDToRoleToPartner.get(op.id).get('Partner').AccountToID;
                if(oppIDToRoleToPartner.get(op.id).get('Distributor') != null && acctMap.containsKey(oppIDToRoleToPartner.get(op.id).get('Distributor').AccountToID) && acctMap.get(oppIDToRoleToPartner.get(op.id).get('Distributor').AccountToID).RecordTypeID == nameToAccountRecordTypeMap.get('Disti').id) op.Disti__c = oppIDToRoleToPartner.get(op.id).get('Distributor').AccountToID;   
            }
        }
        
    }
    
    public static void initNameToRecordTypeMap(){
        if(RecordTypes == null) RecordTypes = [Select id,Name,SObjectType From RecordType Where SObjectType IN ('Account','Opportunity')];
        if(nameToAccountRecordTypeMap == null) nameToAccountRecordTypeMap = new Map<String,RecordType>();
        if(nameToOpportunityRecordTypeMap == null) nameToOpportunityRecordTypeMap = new Map<String,RecordType>();
        for(RecordType rType: RecordTypes){
            if(rType.SobjectType == 'Account')  nameToAccountRecordTypeMap.put(rType.name,rType);
            if(rType.SobjectType == 'Opportunity')  nameToOpportunityRecordTypeMap.put(rType.name,rType);
        }
    }
    
    
    public static void insertPartnerRelationships(List<Opportunity> opps){
        
        Set<ID> acctIDs = new Set<ID>();
        for(Opportunity op: opps){
            if(op.AccountID != null)    acctIDs.add(op.AccountID);
        }
        
        List<Partner> accountPartners = [Select id,AccountToID,AccountFromID,Role From Partner Where AccountFromID IN :acctIDs AND OpportunityId = ''];
        if(accountPartners.size() == 0) return;
        
        Map<ID,List<Partner>> AccountFromIDtoPartner = new Map<ID,List<Partner>>();
        for(Partner aPartner: accountPartners){
            if(!AccountFromIDToPartner.containsKey(aPartner.AccountFromID)) AccountFromIDToPartner.put(aPartner.AccountFromID,new List<Partner>());
            AccountFromIDToPartner.get(aPartner.AccountFromID).add(aPartner);
        }
        
        List<Partner> newPartners = new List<Partner>();
        for(Opportunity op: opps){
            if(!AccountFromIDToPartner.containsKey(op.AccountId)) continue;
            for(Partner aPartner:AccountFromIDToPartner.get(op.AccountId) ){
                newPartners.add(new Partner(OpportunityId=op.id,AccountToId=aPartner.AccountToId,Role=aPartner.Role));
            }
        }
        
        if(newPartners.size() > 0 ) insert newPartners;
    }
    
    
    /****************************
    *       Test Methods        *
    ****************************/


    // inserting Opportunity
    
    public static testMethod void testNewOppFromAccountWithOnePartner(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account endCustomer = new Account(name='End Customer Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('End Customer').id);
        accts.add(endCustomer);
        Account Partner = new Account(name='Partner Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Partner').id);
        accts.add(Partner);
        insert accts;
        
        Partner endCustomerToPartner = new Partner(AccountFromID=endCustomer.id,AccountToID=partner.id,Role='Partner');
        insert endCustomerToPartner;
        
        Opportunity newOpp = new Opportunity(name='End Customer Opportunity',closeDate=Date.today(),stageName='Prospect',AccountId=endCustomer.id);
        
        Test.startTest();
            insert newOpp;
        Test.stopTest();
        
        List<Partner> oppPartners = [Select id,AccountFromID,AccountToID,OpportunityID From Partner Where OpportunityID = :newOpp.id];
        System.assert(oppPartners.size() > 0);
        for(Partner oppPartner: oppPartners){
            System.assertEquals(endCustomer.id,oppPartner.AccountFromID);
            System.assertEquals(newOpp.id,oppPartner.OpportunityID);
            System.assertEquals(partner.id,oppPartner.AccountToId);
        }
        
        
    }
    
    /*
    public static testMethod void testNewOppsFromAccountsWithAPartner(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        List<Partner> endCustomerToPartners = new List<Partner>();
        
        for(Integer Accountcounter = 0; AccountCounter < 1; AccountCounter++){
            Account endCustomer = new Account(name='End Customer Account' + Accountcounter,RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('End Customer').id);
            accts.add(endCustomer);
            Account Partner = new Account(name='Partner Account' + Accountcounter,RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Partner').id);
            accts.add(Partner);
        }
        insert accts;
        
        
        Set<ID> endCustomerIDs = new Set<ID>();
        Set<ID> partnerIDs = new Set<ID>();
        List<Opportunity> newOpps = new List<Opportunity>();
        for(Integer Accountcounter = 0; AccountCounter < accts.size() - 2; AccountCounter+2){
            
            endCustomerIDs.add(accts.get(Accountcounter).id);
            partnerIDs.add(accts.get(Accountcounter+1).id);
            endCustomerToPartners.add(new Partner(AccountFromID=accts.get(AccountCounter).id,AccountToID=accts.get(AccountCounter+1).id,Role='Partner'));
            newOpps.add(new Opportunity(name='End Customer Opportunity',closeDate=Date.today(),stageName='Prospect',AccountId=accts.get(Accountcounter).id));   
        }
        
        insert endCustomerToPartners;
        
        Test.startTest();
            insert newOpps;
        Test.stopTest();
        
        Map<ID,Opportunity> oppMap = new Map<ID,Opportunity>(newOpps);
        List<Partner> oppPartners = [Select id,AccountFromID,AccountToID,OpportunityID From Partner Where OpportunityID IN :oppMap.keySet()];
        System.assert(oppPartners.size() > 0);
        for(Partner oppPartner: oppPartners){
            System.assert(endCustomerIds.contains(oppPartner.AccountFromID));
            System.assert(partnerIDs.contains(oppPartner.AccountToID));
            System.assert(oppMap.containsKey(oppPartner.OpportunityID));
        }
        
        
    }
    */
    

    // updating Opportunity

    public static testMethod void testOppWithNoOpportunityPartnerRecords(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account endCustomer = new Account(name='End Customer Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('End Customer').id);
        accts.add(endCustomer);
        insert accts;
        
        Opportunity testOp = new Opportunity(name='Test Opp',stageName='Initial Contact',closeDate=Date.Today(),AccountID=endCustomer.id);
        insert testOp;
        
        Test.startTest();
            update [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        Test.stopTest();
        
        testOp = [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
    
        System.assertEquals(testOp.AccountId,testOp.End_Customer__c);
        System.assertEquals(null,testOp.Partner__c);
        System.assertEquals(null,testOp.Disti__c);
    
    }
    
    public static testMethod void testOppWithNoOpportunityPartnerRecordsIsPartner(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account Partner = new Account(name='Partner Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Partner').id);
        accts.add(Partner);
        insert accts;
        
        Opportunity testOp = new Opportunity(name='Test Opp',stageName='Initial Contact',closeDate=Date.Today(),AccountID=Partner.id);
        insert testOp;
        
        Test.startTest();
            update [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        Test.stopTest();
        
        testOp = [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
    
        System.assertEquals(testOp.AccountId,testOp.End_Customer__c);
        System.assertEquals(testOp.AccountId,testOp.Partner__c);
        System.assertEquals(null,testOp.Disti__c);
    
    }
    
    
    public static testMethod void testOppWithNoOpportunityPartnerRecordsIsDisti(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account Disti = new Account(name='Disti Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Disti').id);
        accts.add(Disti);
        insert accts;
        
        Opportunity testOp = new Opportunity(name='Test Opp',stageName='Initial Contact',closeDate=Date.Today(),AccountID=Disti.id);
        insert testOp;
        
        Test.startTest();
            update [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        Test.stopTest();
        
        testOp = [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
    
        System.assertEquals(testOp.AccountId,testOp.End_Customer__c);
        System.assertEquals(testOp.AccountId,testOp.Partner__c);
        System.assertEquals(testOp.AccountId,testOp.Disti__c);
    
    }
    
    
    public static testMethod void testOppWithPartnerOpportunityPartnerRecord(){
    
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account endCustomer = new Account(name='End Customer Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('End Customer').id);
        accts.add(endCustomer);
        Account partner = new Account(name='Partner Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Partner').id);
        accts.add(partner);
        insert accts;
        
        Opportunity testOp = new Opportunity(name='Test Opp',stageName='Initial Contact',closeDate=Date.Today(),AccountID=endCustomer.id);
        insert testOp;
        
        List<Partner> partners = new List<Partner>();
        partners.add(new Partner(OpportunityID=testOp.id,AccountToID=partner.id,Role='Partner'));
        insert partners;
        
        Test.startTest();
            update [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        Test.stopTest();
        
        testOp = [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        System.assertEquals(testOp.AccountId,testOp.End_Customer__c);
        System.assertEquals(partner.id,testOp.Partner__c);
        System.assertEquals(null,testOp.Disti__c);
        
    }
    
    public static testMethod void testOppWithDistiAndOpportunityPartnerRecord(){
        
        PartnerHierarchy.initNameToRecordTypeMap();
        List<Account> accts = new List<Account>();
        Account endCustomer = new Account(name='End Customer Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('End Customer').id);
        accts.add(endCustomer);
        Account partner = new Account(name='Partner Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Partner').id);
        accts.add(partner);
        Account Disti = new Account(name='Disti Account',RecordTypeID=PartnerHierarchy.nameToAccountRecordTypeMap.get('Disti').id);
        accts.add(Disti);
        insert accts;
        
        Opportunity testOp = new Opportunity(name='Test Opp',stageName='Initial Contact',closeDate=Date.Today(),AccountID=endCustomer.id);
        insert testOp;
        
        List<Partner> partners = new List<Partner>();
        partners.add(new Partner(OpportunityID=testOp.id,AccountToID=partner.id,Role='Partner'));
        partners.add(new Partner(OpportunityID=testOp.id,AccountToID=Disti.id,Role='Distributor'));
        insert partners;
        
        Test.startTest();
            update [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        Test.stopTest();
        
        testOp = [Select id,AccountID,End_Customer__c,Partner__c,Disti__c From Opportunity Where id = :testOp.id];
        System.assertEquals(testOp.AccountId,testOp.End_Customer__c);
        System.assertEquals(partner.id,testOp.Partner__c);
        System.assertEquals(disti.id,testOp.Disti__c);
        
    }
    

}