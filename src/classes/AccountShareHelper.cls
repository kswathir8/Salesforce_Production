/**************************************************
*    Class Name: AccountShareHelper               *
*    Created By: Cleartask                        *
*    This class shares the Account for the User   *
**************************************************/

public class AccountShareHelper {
    // This List holds the AccountShare 
    static List<AccountShare> newAccountShares = new List<AccountShare>();
    static AccountShare thisAccountShare;
    // This variable holds Account Ids
    private Set<Id> accountIds=new Set<Id>();
    private static Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>();
    private static Map<Id,Group> groupMap = new Map<Id,Group>();
    // This Method inserts the values of Accounts in AccountShare
    @future
    public static void insertIntoAccountShare(List<Id> accountIds){       
        //accountIds = getAllAccountId(accIds);   
        userRoleMap = getAllUserRoles(accountIds);
        groupMap = getAllGroups(userRoleMap);                           
        for(Id accId: accountIds){       
            thisAccountShare = new AccountShare();
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
        try{
            System.debug('####before Share inserted####');
            System.debug('####Shared Value####'+newAccountShares);
            insert newAccountShares;
            System.debug('####after Share inserted####');
        }catch(DMLException dme){
            System.debug('Exception:'+dme.getMessage());
        }   
    }
    
    public static set<Id> getAllAccountId(List<User> userList){
        set<Id> accId=new set<Id>();
        for(User u: userList){
            //accId.add(dr.Distributor_Reseller_Name__c);
            accId.add(u.contact.AccountId);
        }
        return accId;
    }
    
    public static Map<Id,UserRole> getAllUserRoles(List<Id> accountIds){
        Map<Id,UserRole> tempUserRoleMap=new Map<Id,UserRole>();
        List<UserRole> lstUserRole = [Select u.Id, u.Name, u.ParentRoleId, u.PortalAccountId, 
            u.PortalType from UserRole u where u.portalAccountId in :accountIds 
            and u.Name like '%Partner Executive'];
        for(UserRole uRole:lstUserRole){
            tempUserRoleMap.put(uRole.PortalAccountId,uRole);
        }
        return  tempUserRoleMap;        
    }
    
    public static Map<Id,Group> getAllGroups(Map<Id,UserRole> usrRoleMap){
        Map<Id,Group> tempGroupMap=new Map<Id,Group>();
        set<Id> uRoleIds=new set<Id>();
        for(UserRole uRole:usrRoleMap.values()){
            uRoleIds.add(uRole.Id);
        }
        for(Group groups:[Select g.Type, g.SystemModstamp, g.RelatedId, g.OwnerId, g.Name, 
                        g.LastModifiedDate, g.LastModifiedById, g.Id, g.Email, g.DoesSendEmailToMembers, 
                        g.CreatedDate, g.CreatedById From Group g where g.RelatedId in :uRoleIds 
                        and g.Type='RoleAndSubordinates']){
            tempGroupMap.put(groups.RelatedId,groups);          
        }
        return tempGroupMap;        
    }
}