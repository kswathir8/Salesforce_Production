trigger UpdateRMCEmailfieldOnAccount on Contact (before update, before insert, after update, after insert) {

    System.debug('UpdateRMCEmail - Starting Code1');
    
    try{
        List<Account> AccountsToUpdate = new List<Account>{};
        
        Integer count = 0;
        
        System.debug('UpdateRMCEmail - Starting Code2');
        
        if(Trigger.isUpdate && Trigger.isBefore){
            System.debug('UpdateRMCEmail - Inside Code');
            if(Trigger.new[0].RMC_Contact__c != Trigger.old[0].RMC_Contact__c){
                if(Trigger.new[0].RMC_Contact__c == TRUE){
                    List<Contact> ContactList = [select Id,Name,RMC_Contact__c from Contact where AccountID =: Trigger.new[0].AccountID];
                    for(Contact con: contactList){
                        if(con.RMC_Contact__c == TRUE){
                            count ++;
                            System.debug('UpdateRMCEmail - ***** Is a RMC Contact ... : ' + con.RMC_Contact__c + '************');
                        }
                    }
                    
                    if(count > 0 ){
                        System.debug('UpdateRMCEmail - There is already a contact');
                        //Trigger.new[0].RMC_Contact__c.addError('There is already a contact under the account marked as the RMC Email Contact. Please uncheck that to have this one as the RMC Email Admin.');
                    }
                    else if(count == 0){
                        Account AccountToUpdate = [select Id,Name,RMC_Email__c from Account where Id =:Trigger.new[0].AccountID LIMIT 1];
                        AccountToUpdate.RMC_Email__c = Trigger.new[0].Email ;
                        update AccountToUpdate ; 
                        System.debug('UpdateRMCEmail - Account Updated');
                    }
                }
            
                if(Trigger.new[0].RMC_Contact__c == FALSE){
                    Account AccountToUpdate = [select Id,Name,RMC_Email__c from Account where Id =:Trigger.new[0].AccountID LIMIT 1];
                    AccountToUpdate.RMC_Email__c = '';
                    update AccountToUpdate ; 
                    System.debug('UpdateRMCEmail - Email address Ereased');
                }
            }
        }
        
        if(Trigger.isInsert && Trigger.isBefore){
            if(Trigger.new[0].RMC_Contact__c == TRUE){
                List<Contact> ContactList = [select Id,Name,RMC_Contact__c from Contact where AccountId =: Trigger.new[0].AccountID];
                for(Contact con: contactList){
                    if(con.RMC_Contact__c == TRUE){
                        count ++;
                    }
                }
        
                if(count > 0 ){
                    //Trigger.new[0].RMC_Contact__c.addError ('There is already a contact under the account marked as the RMC Email Contact. Please uncheck that to have this one as the RMC Email Admin.');
                }
                else if(count == 0){
                    Account AccountToUpdate = [select Id,Name,RMC_Email__c from Account where Id =:Trigger.new[0].AccountID LIMIT 1];
                    AccountToUpdate.RMC_Email__c = Trigger.new[0].Email ;
                    update AccountToUpdate ; 
                }
            }
        }
    }
    catch (Exception e) {
        System.debug('ERROR:' + e);
    }
}