public class EnablePartner {
    //future method to enable account as partner on insert if Partner Agreement Signed field = Yes
    @future
    public static void enablePartnerAccount(Set<Id> accIds){
        List<Account> accounts = [select id, isPartner from Account where id in :accIds];
        for(Account a : accounts){
            a.IsPartner = true;
        }
        try{
            update accounts;
        }catch(DMLException e){
            System.debug('Exception in Enabling partner Account on Insert: ' + e.getDMLMessage(0));
        }
    }
}