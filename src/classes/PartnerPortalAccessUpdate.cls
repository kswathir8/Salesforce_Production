public with sharing class PartnerPortalAccessUpdate {

    public static Map<ID,Account> triggerAccounts;
    public List<AccountShare> AccountSharesBeingInserted;
    public List<ID> filteredAccounts;
    public Map<String,ID> PartnerExecutiveRoleNameToID;
    public Map<ID,Group> GroupsWithPartnerRoles;
    public Map<ID,UserRole> roles;
    
    public static Boolean run;
    
    /*
    // Filters Accounts recieved to those who have are partnered or are changing owner
    */
    public  PartnerPortalAccessUpdate(Map<ID,Account> newAccounts, Map<ID,Account> oldAccounts, String triggerEvent){
        
        if(run == null){
            
            filteredAccounts = new List<ID>();
            for(Account a: newAccounts.values()){
                if(TriggerEvent == 'update' && a.isPartner && ( a.ownerId != oldAccounts.get(a.id).ownerId ) )  filteredAccounts.add(a.id);
            }
            
            if(filteredAccounts.size() > 0){
                run = true;
                AccountShareHelper.insertIntoAccountShare(filteredAccounts);  
            }
            
        }
        
    }
    
    
    static testMethod void testChangeAccountOwner(){
        
        Boolean hasPartnerExecutive = false;
        
        List<RecordType> recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        
        Account partnerAccount = new Account();
        partnerAccount.name = 'partnerAccountTest2983648172';
        partnerAccount.RecordTypeId = recordID.get(0).id;
        insert partnerAccount;
        
        recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Contact' limit 1];
        
        Contact partner = new Contact(firstName='Gram',lastName='Test');
        partner.email = 'gram@test293847236.com';
        partner.accountid = partnerAccount.id;
        partner.RecordTypeID = recordID.get(0).id;
        insert partner;
        partnerAccount.Partner_Agreement_Signed__c = 'YES';
        update partnerAccount;
        
        partnerAccount = [Select id,ownerId,name From Account Where id =:partnerAccount.id];
        System.assertEquals(UserInfo.getUserId(), partnerAccount.ownerID);
        
        String startsWithAccountName =  partnerAccount.name + '%';
        List<UserRole> roles = [Select id,name From UserRole Where name like :startsWithAccountName];
        System.assertEquals(0,roles.size());
        
        String partnerUsername = 'ax-' + partner.email;
        List<User> users = [Select id,Name From User Where username = :partnerUsername];
        System.assertEquals(0,users.size());
        
        Test.setCurrentPage(new PageReference('/apex/CreateUser?contactid=' + partner.id));
        
        
        
        CreateUserController cuc = new CreateUserController();
        cuc.doCreateUser();
        
        users = [Select id,Name,username From User Where username = :partnerUsername];
        //System.assertEquals(1,users.size());
        
        roles = [Select id,name From UserRole Where name like :startsWithAccountName];
        //System.assertEquals(3,roles.size());
        //System.debug(roles);
        
        Profile sysAdmin = [Select id From Profile Where name = 'System Administrator'];
        User newOwner = [Select id,name From User Where name = 'Axcient Bot' limit 1];
        //System.debug(newOwner);
        
        
        
        List<AccountShare> shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        // Gram Bischof
        // All Internal Users
        // Partner User
        
        // Add Partner Executive
        UserRole role;
        
        for(UserRole roleItr: roles){
            if(roleItr.name.contains('Partner')) 
            role = roleItr;
        }
        
        Map<ID,Group> partnerExecGroup = new Map<ID,Group>([Select id,RelatedID,Name,DeveloperName From Group Where RelatedId = :role.id]);
        
        AccountShare share = new AccountShare(AccountId=partnerAccount.id,AccountAccessLevel='Read',OpportunityAccessLevel='Edit',CaseAccessLevel='Edit',UserOrGroupId=partnerExecGroup.values().get(0).id);
        insert share;
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        hasPartnerExecutive = false;
        for(AccountShare shareItr: shares){
            if(partnerExecGroup.containsKey(shareItr.UserOrGroupId) ) hasPartnerExecutive = true;
        }
        System.assert(hasPartnerExecutive);
        // Gram Bischof
        // All Internal Users
        // Partner User
        // Partner Executive
        
        Test.startTest();
        
        partnerAccount.ownerId = newOwner.id;
        update partnerAccount;
        
        Test.stopTest();
        
        partnerExecGroup = new Map<ID,Group>([Select id,RelatedID,Name,DeveloperName From Group Where RelatedId = :role.id]);
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        // Gram Bischof
        // All Internal Users
        // Pranav Lal
        // Partner User
        // Partner Executive 
        
        hasPartnerExecutive = false;
        for(AccountShare shareItr: shares){
            if(partnerExecGroup.containsKey(shareItr.UserOrGroupId) ) hasPartnerExecutive = true;
        }
        System.assert(hasPartnerExecutive);
    }
    
    static testMethod void testChangeOpportunityOwner(){
        
        Boolean hasPartnerExecutive = false;
        
        List<RecordType> recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        
        Account partnerAccount = new Account();
        partnerAccount.name = 'partnerAccountTest2983648172';
        partnerAccount.RecordTypeId = recordID.get(0).id;
        insert partnerAccount;
        
        recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Contact' limit 1];
        Contact partner = new Contact(firstName='Gram',lastName='Test');
        partner.email = 'gram@test293847236.com';
        partner.accountid = partnerAccount.id;
        partner.RecordTypeID = recordID.get(0).id;
        insert partner;
        partnerAccount.Partner_Agreement_Signed__c = 'YES';
        update partnerAccount;
        
        partnerAccount = [Select id,ownerId,name From Account Where id =:partnerAccount.id];
        System.assertEquals(UserInfo.getUserId(), partnerAccount.ownerID);
        
        String startsWithAccountName =  partnerAccount.name + '%';
        List<UserRole> roles = [Select id,name From UserRole Where name like :startsWithAccountName];
        System.assertEquals(0,roles.size());
        
        String partnerUsername = 'ax-' + partner.email;
        List<User> users = [Select id,Name From User Where username = :partnerUsername];
        System.assertEquals(0,users.size());
        
        Test.setCurrentPage(new PageReference('/apex/CreateUser?contactid=' + partner.id));
        
        
        
        CreateUserController cuc = new CreateUserController();
        cuc.doCreateUser();
        
        users = [Select id,Name,username From User Where username = :partnerUsername];
        //System.assertEquals(1,users.size());
        
        roles = [Select id,name From UserRole Where name like :startsWithAccountName];
        //System.assertEquals(3,roles.size());
        //System.debug(roles);
        
        Profile sysAdmin = [Select id From Profile Where name = 'System Administrator'];
        User newOwner = [Select id,name From User Where name = 'Axcient Bot' limit 1];
        //System.debug(newOwner);
        
        
        
        List<AccountShare> shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        // Gram Bischof
        // All Internal Users
        // Partner User
        
        // Add Partner Executive
        UserRole role;
        
        for(UserRole roleItr: roles){
            if(roleItr.name.contains('Partner')) 
            role = roleItr;
        }
        
        Map<ID,Group> partnerExecGroup = new Map<ID,Group>([Select id,RelatedID,Name,DeveloperName From Group Where RelatedId = :role.id]);
        
        AccountShare share = new AccountShare(AccountId=partnerAccount.id,AccountAccessLevel='Read',OpportunityAccessLevel='Edit',CaseAccessLevel='Edit',UserOrGroupId=partnerExecGroup.values().get(0).id);
        insert share;
        
        Opportunity oppty = new Opportunity(AccountId=partnerAccount.id,closeDate=Date.today(),stageName='Evaluation',name='Test Op',End_Customer__c=partnerAccount.Id);
        insert oppty;
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        hasPartnerExecutive = false;
        for(AccountShare shareItr: shares){
            if(partnerExecGroup.containsKey(shareItr.UserOrGroupId) ) hasPartnerExecutive = true;
        }
        System.assert(hasPartnerExecutive);
        // Gram Bischof
        // All Internal Users
        // All Internal Users (this should show up twice)
        // Partner User
        // Partner Executive
        
        Test.startTest();
        
        oppty.ownerId = newOwner.id;
        update oppty;
        
        Test.stopTest();
        
        partnerExecGroup = new Map<ID,Group>([Select id,RelatedID,Name,DeveloperName From Group Where RelatedId = :role.id]);
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        hasPartnerExecutive = false;
        for(AccountShare shareItr: shares){
            if(partnerExecGroup.containsKey(shareItr.UserOrGroupId) ) hasPartnerExecutive = true;
        }
        System.assert(hasPartnerExecutive);
    }
    
    static testMethod void testChangeAccountOwnerWhenNotPartner(){
        
        List<RecordType> recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account partnerAccount = new Account();
        partnerAccount.name = 'partnerAccountTest2983648172';
        partnerAccount.RecordTypeId = recordID.get(0).id;
        insert partnerAccount;
        
        
        List<AccountShare> shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        //System.assertEquals(2,shares.size());
        // Gram Bischof
        // All Internal Users
        
        Test.startTest();
        
        Profile sysAdmin = [Select id From Profile Where name = 'System Administrator'];
        User newOwner = [Select id,name From User Where name = 'Axcient Bot' limit 1];
        
        partnerAccount.ownerId = newOwner.id;
        update partnerAccount;
        
        Test.stopTest();
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        //System.assertEquals(2,shares.size());
        // All Internal Users
        // Pranav Lal
        
    }
    
    static testMethod void testChangeAccountOwnerWhenNotPartnerWithContact(){
        
        List<RecordType> recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        
        Account partnerAccount = new Account();
        partnerAccount.name = 'partnerAccountTest2983648172';
        partnerAccount.RecordTypeId = recordID.get(0).id;
        insert partnerAccount;
        
        recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Contact' limit 1];
        
                
        Contact partner = new Contact(firstName='Gram',lastName='Test');
        partner.email = 'gram@test293847236.com';
        partner.accountid = partnerAccount.id;
        partner.RecordTypeID = recordID.get(0).id;
        insert partner;
        partnerAccount.Partner_Agreement_Signed__c = 'YES';
        update partnerAccount;
        
        
        List<AccountShare> shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        //System.assertEquals(2,shares.size());
        // Gram Bischof
        // All Internal Users
        
        Test.startTest();
        
        Profile sysAdmin = [Select id From Profile Where name = 'System Administrator'];
        User newOwner = [Select id,name From User Where name = 'Axcient Bot' limit 1];
        
        partnerAccount.ownerId = newOwner.id;
        update partnerAccount;
        
        Test.stopTest();
        
        shares = [Select id,UserOrGroupId From AccountShare Where AccountId = :partnerAccount.id];
        //System.assertEquals(3,shares.size());
        // Gram Bischof
        // All Internal Users
        // Pranav Lal
        
    }

}