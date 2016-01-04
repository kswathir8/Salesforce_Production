public class AccountShareBatch implements Database.Batchable<sObject> {

	public String query;
	private static Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>();
    private static Map<Id,Group> groupMap = new Map<Id,Group>();

	public AccountShareBatch(){
		query = 'Select id From Account Where IsPartner = true';
	}
	
	public AccountShareBatch(String queryString){
		query = queryString;
	}
	
	public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }

	public void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
    
    	List<Account> queryAccounts = (List<Account>)scope;
    	System.debug(queryAccounts);
    	Map<Id,Account> accountMap = new Map<Id,Account>(queryAccounts);
    	userRoleMap = AccountShareHelper.getAllUserRoles(new List<ID>(accountMap.keySet()));
        groupMap = AccountShareHelper.getAllGroups(userRoleMap); 
        
        
        List<AccountShare> accountShares = [Select id,UserOrGroupId From AccountShare Where AccountID IN :accountMap.keySet() AND UserOrGroupID IN :groupMap.keySet()];
        Map<ID,AccountShare> accountIDtoAccountShareMap = new Map<ID,AccountShare>();
        for(AccountShare share: accountShares){
        	accountIDtoAccountShareMap.put(share.AccountId,share);
        }
 		
 		List<ID> AccountsNeedingAccountShares = new List<ID>();
 		for(Account currentAccount: queryAccounts){
 			if(!accountIDtoAccountShareMap.containsKey(currentAccount.id)) AccountsNeedingAccountShares.add(currentAccount.id);
 		}
        
        System.debug(AccountsNeedingAccountShares);
		if(AccountsNeedingAccountShares.size() > 0)	insertIntoAccountShare(AccountsNeedingAccountShares);   
                    
    }

	public void finish(Database.BatchableContext BC){
	
	}
	
	public static void insertIntoAccountShare(List<Id> accountIds){       
        
        System.debug('insertIntoAccountShare started');
        
        List<AccountShare> newAccountShares = new List<AccountShare>();
        //accountIds = getAllAccountId(accIds);   
        userRoleMap = AccountShareHelper.getAllUserRoles(accountIds);
        groupMap = AccountShareHelper.getAllGroups(userRoleMap);                           
        for(Id accId: accountIds){       
            AccountShare thisAccountShare = new AccountShare();
            //thisAccountShare.userorgroupid = groupMap.get((userRoleMap.get(theAccount.Distributor_Reseller_Name__c).Id)).Id;
            if(userRoleMap.containsKey(accId)){
            	if(groupMap.containsKey(userRoleMap.get(accId).Id)){
		            thisAccountShare.userorgroupid = groupMap.get((userRoleMap.get(accId).Id)).Id;      
		            thisAccountShare.accountid = accId;       
		            thisAccountShare.accountaccesslevel = 'Read';       
		            thisAccountShare.OpportunityAccessLevel = 'Read';       
		            thisAccountShare.CaseAccessLevel = 'Edit';      
		            //thisAccountShare.ContactAccessLevel = 'Read';               
		            newAccountShares.add(thisAccountShare);                 
            	}
            }
        }   
        
        system.debug(newAccountShares);
        
        if(newAccountShares.size() > 0) insert newAccountShares;
    }
	
   /*********************************
   *		Test Methods			*
   *********************************/


	public static testMethod void createBatchWithNoAccountSharesAndShareEnabledFalse(){
		
		RecordType partnerRecordType = [Select id From RecordType Where sObjectType='Account' and Name='Partner'];
		
		List<Account> testAccounts = new List<Account>();
		for(Integer num = 0; num < 1; num++){
			testAccounts.add(new Account(Name='Test Account ' + num,AccountShare_Enabled__c=false,RecordTypeId=partnerRecordType.id,Partner_Agreement_Signed__c='YES'));
		}
		
		insert testAccounts;
		
		Test.startTest();
			AccountShareBatch testBatch = new AccountShareBatch();
			Database.executeBatch(testBatch);
		Test.stopTest();
		
		
	}
	
	public static testMethod void createBatchWithNoAccountSharesAndShareEnabledTrue(){
		
		RecordType partnerRecordType = [Select id From RecordType Where sObjectType='Account' and Name='Partner'];
		
		List<Account> testAccounts = new List<Account>();
		for(Integer num = 0; num < 1; num++){
			testAccounts.add(new Account(Name='Test Account ' + num,AccountShare_Enabled__c=true,RecordTypeId=partnerRecordType.id,Partner_Agreement_Signed__c='YES'));
		}
		
		insert testAccounts;
		
		Test.startTest();
			AccountShareBatch testBatch = new AccountShareBatch();
			Database.executeBatch(testBatch);
		Test.stopTest();
		
		
	}
	
	public static testMethod void createBatchWithPartnerExecAccountSharesAndShareEnabledFalse(){
		
		RecordType partnerRecordType = [Select id From RecordType Where sObjectType='Account' and Name='Partner'];
		
		List<Account> testAccounts = new List<Account>();
		for(Integer num = 0; num < 1; num++){
			testAccounts.add(new Account(Name='Test Account ' + num,AccountShare_Enabled__c=false,RecordTypeId=partnerRecordType.id,Partner_Agreement_Signed__c='YES'));
		}
		
		insert testAccounts;
		
		
		Test.startTest();
			AccountShareBatch testBatch = new AccountShareBatch();
			Database.executeBatch(testBatch);
		Test.stopTest();
		
		
	}
	
	public static testMethod void createBatchWithPartnerExecAccountSharesAndShareEnabledTrue(){
		
		RecordType partnerRecordType = [Select id From RecordType Where sObjectType='Account' and Name='Partner'];
		
		List<Account> testAccounts = new List<Account>();
		for(Integer num = 0; num < 1; num++){
			testAccounts.add(new Account(Name='Test Account ' + num,AccountShare_Enabled__c=true,RecordTypeId=partnerRecordType.id,Partner_Agreement_Signed__c='YES'));
		}
		
		insert testAccounts;
		
		AccountShareHelper.insertIntoAccountShare(new List<ID>(new Map<ID,Account>(testAccounts).keySet()));
		List<AccountShare> testAccountShares = [Select id From AccountShare Where AccountId IN :testAccounts];
		Integer numAccountShares = testAccountShares.size();
		
		System.assertNotEquals(0,([Select id From AccountShare Where AccountID IN :testAccounts]).size());
		
		Test.startTest();
			AccountShareBatch testBatch = new AccountShareBatch();
			Database.executeBatch(testBatch);
		Test.stopTest();
		
		
	}
	

}