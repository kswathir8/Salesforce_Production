public class AccountPartnerBatch implements Database.Batchable<sObject> {

    public String query;

    public AccountPartnerBatch(){
        RecordType PartnerAccount = [Select id From RecordType Where sObjectType = 'Account' AND Name = 'Partner'];
        query = 'Select id,Primary_Distributor__c,Primary_Disti__c From Account Where RecordTypeID = \''+String.valueOf(PartnerAccount.id).substring(0,15)+'\'';
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
    
        List<Partner> DistiPartners = new List<Partner>();
        
        List<Partner> oldDistiPartners = [Select id,AccountToId,AccountFromID,Role From Partner Where AccountToId IN :(List<Account>)scope OR AccountFromId IN :(List<Account>)scope];
        Map<Id,Partner> AccountFromPartnerToDistt = new Map<Id,Partner>();
        Map<Id,Partner> AccountFromDistiToPartner = new Map<Id,Partner>();
        
        for(Partner p: oldDistiPartners){
            if(p.Role == 'Distributor') AccountFromPartnerToDistt.put(p.id,p);
            if(p.Role == 'Partner') AccountFromDistiToPartner.put(p.id,p);
        }
        
        for(Account partnerAccount: (List<Account>)scope){
            if(partnerAccount.Primary_Disti__c != null){
                if(!AccountFromPartnerToDistt.containsKey(partnerAccount.id) || (AccountFromPartnerToDistt.containsKey(partnerAccount.id) && AccountFromPartnerToDistt.get(partnerAccount.id).AccountFromId != partnerAccount.Primary_Disti__c) )   DistiPartners.add(new Partner(AccountFromId=partnerAccount.id,AccountToId=partnerAccount.Primary_Disti__c,Role='Distributor'));
                if(!AccountFromDistiToPartner.containsKey(partnerAccount.Primary_Disti__c) || (AccountFromDistiToPartner.containsKey(partnerAccount.Primary_Disti__c) && AccountFromDistiToPartner.get(partnerAccount.Primary_Disti__c).AccountFromId != partnerAccount.id) )   DistiPartners.add(new Partner(AccountFromId=partnerAccount.Primary_Disti__c,AccountToId=partnerAccount.id,Role='Partner'));
            }
        }
        
        if(DistiPartners.size() > 0) insert DistiPartners;
    }
    
    public void finish(Database.BatchableContext BC){

   }
   
   
   /*********************************
   *        Test Methods            *
   *********************************/


    public static List<Account> createBatch(Integer numPartners, Integer numDistis){
        
        if(numPartners < numDistis) return new List<Account>();
        
        List<Account> newPartnerAccounts = new List<Account>();
        List<Account> newDistiAccounts = new List<Account>();
        
        List<RecordType> accountRecordType = [Select id,Name From RecordType Where sObjectType = 'Account'];
        Map<String,RecordType> nameToRecordTypeMap = new Map<String,RecordType>();
        for(RecordType rt: accountRecordType)   nameToRecordTypeMap.put(rt.Name,rt);
        
        for(Integer numOfNewAccounts = 0; numOfNewAccounts < numPartners; numOfNewAccounts++){
            newPartnerAccounts.add(new Account(Name='Test Partner Account' + numOfNewAccounts,RecordTypeId=nameToRecordTypeMap.get('Partner').id));
        }
        
        insert newPartnerAccounts;
        
        for(Integer numOfNewAccounts = 0; numOfNewAccounts < numDistis; numOfNewAccounts++){
            Account newDisti = new Account(Name='Test Disti Account' + numOfNewAccounts,RecordTypeId=nameToRecordTypeMap.get('Disti').id);
            insert newDisti;
            newPartnerAccounts.get(numOfNewAccounts).Primary_Disti__c = newDisti.id;
        }
    
        update newPartnerAccounts;
    
        newPartnerAccounts.addAll(newDistiAccounts);
        return newPartnerAccounts;
    }


    public static testMethod void testBatchSingleAccountWithNoDisti(){
        List<Account> AllAccounts = createBatch(1,0);
        
        Test.startTest();
            Database.executeBatch(new AccountPartnerBatch(),200);
        Test.stopTest();
        
        List<Partner> partners = [Select id From Partner];
        System.assertEquals(0,partners.size());
        
    }
    
    public static testMethod void testBatchSingleAccountWithDisti(){
        List<Account> AllAccounts = createBatch(1,1);
        
        Test.startTest();
            Database.executeBatch(new AccountPartnerBatch(),200);
        Test.stopTest();
        
        List<Partner> partners = [Select id From Partner];
        System.assertEquals(2,partners.size());
        
    }
    
   /* public static testMethod void testBatch20AccountsWith10Disti(){
        List<Account> AllAccounts = createBatch(20,10);
        
        Test.startTest();
            Database.executeBatch(new AccountPartnerBatch(),50);
        Test.stopTest();
        
        List<Partner> partners = [Select id From Partner];
        System.assertEquals(20,partners.size());
        
    }*/

}