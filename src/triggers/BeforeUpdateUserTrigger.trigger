trigger BeforeUpdateUserTrigger on User (before update) {

    for(User user : trigger.new) {
    if(user.ProfileId=='00e80000001OMYU' || user.ProfileId=='00e80000001OH1w'||user.ProfileId=='00e80000001OMYV'||user.ProfileId=='00e80000001OMYW')
    {

        if(user.ProfileId != user.ProfileText__c && user.ProfileText__c!=NULL) {
            user.ProfileId = user.ProfileText__c;
        }
       }
    }

}