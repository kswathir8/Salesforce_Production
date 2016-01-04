/******************************************************
*    Trigger Name: AccountShare                       *
*    Created By: Axcient                              *
*    This Trigger does the Account Share for Users.   *
******************************************************/

trigger AccountShare on User (after insert) {
    List<User> users=trigger.new;
    List<Id> accPass = new List<Id>();
    Set<Id> accSet = new Set<Id>();    
    List<Id> accListUser = new List<Id>();
    Integer counter = 0;
    for(User u : users) {
        accSet.add(u.AccountId);
    }
    List<User> accList = [Select u.AccountId From User u where u.AccountId in :accSet order by u.AccountId];
    for(User u : accList) {
        accListUser.add(u.AccountId);
    }
    if(accSet != null && accListUser != null){
        for(Id idUser : accSet){
            for(Id idAcc : accListUser){
                if(idUser == idAcc){
                    counter++;            
                }
            }
            if(!(counter > 1)){
                System.debug('######counter value#######'+ counter);
                accPass.add(idUser);
            }    
        }
    }    
    if(accPass != null && accPass.size() > 0){
        System.debug('######Account List Passed########'+ accPass); 
        AccountShareHelper.insertIntoAccountShare(accPass);  
    }
}