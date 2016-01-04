public with sharing class UpdatePrimaryContact {
     
     
    public List<OpportunityContactRole> contactroles; 
    //public List<String> ErrorMessages {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String email {get;set;}
    public String phone {get;set;}
    public String fax   {get;set;}
    public Boolean finished {get;set;}
    public String contactInput {get;set;}
    
    
    private ApexPages.StandardController page;
    private Opportunity oppty;
    private Map<Id,Contact> contacts;
    private List<Contact> contactList;
    private Contact primary;
    

    // Constructor
    public UpdatePrimaryContact(ApexPages.StandardController stdController) { 
        page = stdController;
        oppty = (Opportunity) stdController.getRecord();
        //ErrorMessages = new List<String>();

        contactList = [Select id,firstName,LastName,email,phone,fax from Contact where AccountId = :oppty.accountId ORDER BY Name ASC];
        contactList.addAll([Select id,firstName,LastName,email,phone,fax from Contact where AccountID IN (Select AccountToID From AccountPartner Where AccountFromID = :oppty.accountId)  ORDER BY Name ASC]);
        contacts = new Map<ID,Contact>(contactList);
        finished = false;
        contactroles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :oppty.id];
           if(oppty.Primary_Contact__c == null && contacts.containsKey(oppty.Primary_Contact__c))
           {
            primary = contacts.get(oppty.Primary_Contact__c);
            firstName = primary.firstName;
            lastName = primary.lastName;
            email = primary.email;
            phone = primary.phone;
            fax = primary.Fax;
           }
    }
    
    
    public PageReference ResetPrimary(){
        
        contactroles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :oppty.id];
        System.debug(contactroles);
        
        ID primaryContact;
        for(OpportunityContactRole con: contactroles){
            if(con.IsPrimary) primaryContact = con.contactID;
        }
        
        //System.debug(primaryContact);
        
        if(primaryContact == null){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Primary Contact selected.'));
             return ApexPages.currentPage();
        }
        
        Contact primary = [Select id,firstName,lastName From Contact Where id = :primaryContact];
        //System.debug(primary);
        
        oppty.Primary_Contact__c = primary.id;
        update oppty;
        
        
        PageReference opPage = new PageReference('/' + oppty.id);
        opPage.setRedirect(true);
        return opPage;
        
    }
    
    public PageReference updateContact(){
        
        if(firstName.trim() == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name on a contact cannot be blank.'));   
            return ApexPages.currentPage();
        }
        
        if(email.trim() == ''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email for a contact cannot be blank.'));   
            return ApexPages.currentPage();
        }
        
        
        try{
            
             addAllContactRoles(contacts.values(),contactroles);
            
            ID contactID = matchContact(email);
            if(contactID == null){
                
                // No match create a new contact and contact Role 
                
                Contact c = new Contact(accountId=oppty.accountId,firstName=this.firstName,lastName=this.lastName,email=this.email,phone=this.phone,fax=this.fax);
                insert c;
                if(!unselectPrimary()){
                    return ApexPages.currentPage();
                }
                OpportunityContactRole role = new OpportunityContactRole(contactID=c.id,isPrimary=true,OpportunityId=oppty.id,Role='Decision Maker');
                insert role;
                
                // reset as primary
                
                ResetPrimary();
            }
            else{
                
                // There's a match and need to update contact
                
                Contact currentContact = contacts.get(contactID);
                currentContact.firstName = firstName;
                currentContact.lastName = lastName;
                currentContact.email = email;
                currentContact.phone = phone;
                currentContact.fax = fax;
                update currentContact;
                
                // Check if Opportunity contact role exists
            
                if(primary != null && contactID != primary.id){
                    
                    Set<ID> contactsWithRoles = new Set<ID>();
                    for(OpportunityContactRole role: contactroles){
                        contactsWithRoles.add(role.ContactID);
                    }
                    
                    if(!contactsWithRoles.contains(contactID)){
                    
                        ID diffNamedContactId = contactID;
                        if(!unselectPrimary()){
                            return ApexPages.currentPage();
                        }
                        OpportunityContactRole role = new OpportunityContactRole(contactID=diffNamedContactId,isPrimary=true,OpportunityId=oppty.id,Role='Decision Maker');
                        insert role;
                    }
                    
                }else if(primary == null){
                    
                    for(OpportunityContactRole role: contactroles){
                        if(role.contactID == currentContact.id){
                            role.isPrimary = true;
                            role.Role = 'Decision Maker';
                            update role;
                            break;
                        }
                    }
                    
                }

                // reset as primary
                primary = currentContact;
                ResetPrimary();
            }
            
        }catch(Exception e){
            if(e.getTypeName() != 'System.DmlException') throw e;
        }
        
        PageReference opPage = ApexPages.currentPage();
        if(ApexPages.getMessages().size() == 0) finished = true;
        return opPage;
    }
    
    
    public ID matchContact(String emailToMatch){
        for(Contact c: contacts.values()){
            if(c.email != null && c.email.toLowerCase() == emailToMatch.toLowerCase() )
                return c.id;
        }
        
        return null;
    }
    
    public Boolean unselectPrimary(){
        for(OpportunityContactRole role: contactroles){
            role.isPrimary = false;
        }
        try{
            update contactRoles;
            oppty.Primary_Contact__c = null;
            update oppty;
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return false;
        }
        return true;
    }
    
    
    public void addAllContactRoles(List<Contact> contactsToAdd, List<OpportunityContactRole> existingRoles){
        Set<ID> contactsWithRoles = new Set<ID>();
        for(OpportunityContactRole role: existingRoles){
            contactsWithRoles.add(role.ContactID);
        }
        
        List<OpportunityContactRole> rolesToAdd = new List<OpportunityContactRole>();
        for(Contact currentContact: contactsToAdd){
            if(!contactsWithRoles.contains(currentContact.id)){
                rolesToAdd.add(new OpportunityContactRole(contactID=currentContact.id,isPrimary=false,OpportunityId=oppty.id,Role='Unknown'));
            }
        }
        
        if(rolesToAdd.size() > 0) insert rolesToAdd;
        contactroles = [Select id,contactID,OpportunityID,isPrimary FROM OpportunityContactRole WHERE OpportunityId = :oppty.id];
    }
    
    public List<SelectOption> getAccountContactsList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','Add New Contact'));
        for(Contact c: contactList){
            options.add(new SelectOption(String.valueOf(c.id),c.firstName + ' ' + c.lastName));
        }
        return options;
   }
   
   public String getContactJSON(){
    return JSON.serialize(contacts).replaceAll('\'','\\\\\'');
   }
   
   public Boolean getContactsEmpty(){
        return contacts.size() > 0;
   }
}