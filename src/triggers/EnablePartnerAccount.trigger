/*
 *  EnablePartnerAccount  is used for When the Partner Agreement signed field is “Yes”, 
 *  automatically enable the Partner account “Work with Portal"
 */
trigger EnablePartnerAccount on Account (after insert, before update){
    List<Account> accountList=trigger.new;
    //Make Partner Enable if Partner Agreement Signed is YES
    List<RecordType> recordID=[select id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
    System.debug('#######Record Id##########'+recordID[0].id);
    if(trigger.isUpdate){
        for(Account a:accountList){
            if(a.Partner_Agreement_Signed__c != null){           
                if(a.RecordTypeId != null && a.RecordTypeId == recordID[0].Id){
                    if((a.Partner_Agreement_Signed__c).equals('YES')){
                        a.isPartner= true;
                        System.debug('#######Partner Enabled##########');
                    }
                }
            }
        }
        if(system.isFuture()) 
        return;
        PartnerPortalAccessUpdate accessUpdate = new PartnerPortalAccessUpdate(Trigger.newMap,Trigger.oldMap, 'update');
        
    }else{
        Set<Id> accIds = new Set<Id>();
        for(Account a:accountList){
            if(a.Partner_Agreement_Signed__c != null){           
                if(a.RecordTypeId != null && a.RecordTypeId == recordID[0].Id){
                    if((a.Partner_Agreement_Signed__c).equals('YES')){
                        accIds.add(a.Id);
                        System.debug('#######Partner Enabled##########');
                    }
                }
            }
        }
        if(accIds.size() > 0){
            EnablePartner.enablePartnerAccount(accIds);
        }
    }
}