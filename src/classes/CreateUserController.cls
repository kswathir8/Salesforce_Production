/*
-------------------------------------------------
This Class creates User Object from other Object.
-------------------------------------------------   */  
public class CreateUserController {
    //The property fetches value from Object variable.
    private String contactId ;
    //The property stores status of the User.
    public String userCreateStatus{get;set;}
    //The function creates User and updates the status.
    ///////////////////////
    public Boolean flag{get;set;}
    public Boolean isUserInserted{get;set;}
    Boolean firstUser;
    String eMailMessage{get;set;}
    String partnerMessage{get;set;}
    List<AccountShare> newAccountShares = new List<AccountShare>();
    AccountShare thisAccountShare;
    private set<Id> accountIds=new set<Id>();
    private Map<Id,UserRole> userRoleMap = new Map<Id,UserRole>();
    private Map<Id,Group> groupMap = new Map<Id,Group>();
    User u;
    ///////////////////////
    public PageReference doCreateUser() {
        contactId = ApexPages.currentPage().getParameters().get('contactId');
        Contact contact = [select FirstName,LastName,Email,AccountId, account.name,account.Partner_Membership_Level__c from Contact where Id=: contactId];
        Account acc = [select Partner_Membership_Level__c,IsPartner, RecordTypeId from Account where id=:contact.AccountId];
        List<RecordType> recordID=[select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        if(recordID[0].Id != null && recordID[0].Id==acc.RecordTypeId && (!acc.isPartner)){
            userCreateStatus=System.Label.Partner_Not_Enabled;
            System.debug('#####Account is not Partner Enabled#####');
            flag=true;
            return null;
        }    
        if(contact.Email==null) {
            userCreateStatus=System.Label.Email_field_empty;
            System.debug('####Email Field is Empty####');
            flag=true;
            return null;
        }    
        List<Account> accName = [select Name,Partner_Membership_Level__c from Account where Id=:contact.AccountId];
        //what we need to do is it should check the account's partner membership level, if it is Premier then Axcient Premier User, if Elite, then Axcient Elite User, if Partner then Axcient Partner User
        System.debug('@@@####Accname##########'+accName[0]);
        //PL CODE CHANGE START:
        String membershiplevel = acc.Partner_Membership_Level__c;
        String profilename ;
        
        if(membershiplevel =='Elite'){
        profilename ='Axcient Elite User';
        }
                
        else if(membershiplevel =='Partner'){
        profilename ='Axcient Partner User';
        }
        
        else if(membershiplevel =='Premier'){
        profilename ='Axcient Premier User';
        }
        else 
        { 
        profilename='Axcient Partner User';
        }
        
       //profilename='Axcient Partner User';          
        
        list<Profile> p = [select id from Profile where Name =:profilename];
        //PL CODE CHANGE END
        String rolename = contact.Account.Name + ' Partner Executive';
        roleName = String.escapeSingleQuotes(roleName);
        String roleQuery = 'select id from UserRole where Name = \'' + rolename + '\'';
        System.debug('Query = ' + roleQuery);
        List<UserRole> roles = Database.query(roleQuery);
        //UserRole uRole = [select id from UserRole where Name =: accName[0].Name+ ' Partner Executive'];
        System.debug('########UserRole#########'+roles);        
        String uName = 'ax-'+contact.Email;
        String cName = contact.FirstName+contact.LastName;
        System.debug('###uName###'+uName);
        List<User> allCommUser = [select CommunityNickname from User where CommunityNickname=:cName ];
        if(allCommUser != null && allCommUser.size()>0) {
            cName=cName+'1';
        }
        System.debug('#####cName#####'+cName);
        if(roles.size() > 0) {
            u = new User(contactId = contact.Id,
            alias = 'standt',
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            Username = uName,
            CommunityNickname = cName,
            profileId = p[0].Id,emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles',            
            UserRoleId = roles[0].Id);
        }
        else{
            u = new User(contactId = contact.Id,
            alias = 'standt',
            FirstName = contact.FirstName,
            LastName = contact.LastName,
            Email = contact.Email,
            Username = uName,
            CommunityNickname = cName,
            profileId = p[0].Id,emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles');            
            //UserRoleId = roles[0].Id);
            firstUser = true;
        }
        System.debug('#####User#####'+u);
        try {
            //the below line generates a new password for the user and send an email with the link to login and change pwd page.
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = true;
            u.setOptions(dlo);
            insert u;
            flag = false;
            isUserInserted = true;
            userCreateStatus = System.Label.User_Created;
            if(firstUser != null && (firstUser)){
                //if this is the first user being created for the account, we need to update the user's role to Partner Executive
                roles = Database.query(roleQuery);//get the roles again
                if(roles.size()>0)
                {
                u.UserRoleId = roles[0].Id;//set the UserRoleId
                }
                update u;//update user
            }
            return null;
        }
        catch(DMLException e) {
             userCreateStatus = System.Label.User_Exist;
             flag = true;
             return null;
        }
    }
    public PageReference cancel() {
        if(isUserInserted != null) {
            return new PageReference('/'+u.Id);
        }
        else {
            return new PageReference('/'+contactId);
        }
        //return null;
    }  
}