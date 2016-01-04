public class LeadTriggerHandler
{
    static LeadStatus convertStatus {
        get {
            if(convertStatus == null) {
                convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            }
            return convertStatus ;
        }
        set ;
    }

    /********************************************************
    Method: TranferLeadUserName
    Description: Check of Transfer Leads check box field will Update Transfer Lead User Name (Sales requirement for Reporting)
    Author: Swathi Karkala.
    Date : 9/4/2013
    *********************************************************/
    /*  
    public static void TranferLeadUserName(List<lead> newOrderList, Map<ID,lead> NewOrderMap, Map<ID,Lead> oldOrderMap)
    { 
       for(lead ld:newOrderList)
       {
            if(ld.Transfer_Lead__c == True)
            //&&(newordermap.get(ld.id).Transfer_Lead__c !=oldordermap.get(ld.id).Transfer_Lead__c)
            {
                 ld.Transfer_leads_User_Name__c = UserInfo.getFirstName()+' '+ UserInfo.getLastName();
            } 
            else 
            {
                 ld.Unchecked_Transfer_Leads_User_Name__c= UserInfo.getFirstName()+' '+ UserInfo.getLastName();
            }        
       }
    
    } 
    */

    /**
     * @description: reconcile the Sales Contact Email contact linkage with an account
     * @author: Matthew Allen - Red Argyle
     * @date: 07/21/15
     * @param - records - List of Leads to be reconciled before they are saved to database.
     */
    public static void beforeInsertPartnerReconciliation(List<Lead> records) {
        // TODO: DETERMINE IF A FILTER IS NEEDED TO ONLY RUN THIS ON LEADS FROM THE DEAL REG FORM
        Set<String> emails = new Set<String>();

        for(Lead l : records) {
            // build a set of email addresses (use Set to ensure no dupes)
            emails.add(l.Sales_Contact_Email__c);        
        }

        if(emails.contains(null)) {
            emails.remove(null) ;
        }
        if(emails.isEmpty()) return ;

        // query contacts with matching email addresses
        // note the CreatedDate sort, used to ensure oldest Contact wins in the event of multiple contacts with the same email
        // TODO: VALIDATE LOGIC WITH AXCIENT
        List<Contact> contacts = [
            SELECT 
                Email, 
                AccountId 
            FROM 
                Contact 
            WHERE Email IN :emails ORDER BY CreatedDate ASC 
        ];

        // build a map out of the results, using email as key for efficiency
        Map<String, Contact> contactsByEmail = new Map<String, Contact>();
        for(Contact c : contacts) {
            // here's where the oldest-contact-wins logic kicks in
            if(!contactsByEmail.containsKey(c.Email)) {
                contactsByEmail.put(c.Email, c);
            }
        }

        // loop through the leads again
        // try to locate a matching contact
        // if found, assign partner company id
        for(Lead l : records) {
            // TODO: CHANGED TO CORRECT EMAIL FIELD
            String email = l.Sales_Contact_Email__c ;
            if(contactsByEmail.containsKey(email)) {
                Contact contact = contactsByEmail.get(email);
                if(contact.AccountId != null) {
                    if(l.Partner__c == null) {
                        l.Partner__c = contact.AccountId;
                    }
                }
            }
        }
    }

    /**
     * @description: Merge the new deal lead with old existing leads if they match
     * @author: Matthew Allen - Red Argyle
     * @date: 07/21/15
     * @param - records - List of Leads to be checked for merging after they are saved to the database.
     * @deprecated
     */
     /*
    public static void afterInsertLeadMerge(List<Lead> records) {
        Set<String> emails = new Set<String>();

        for(Lead l : records) {
            emails.add(l.Email);        
        }

        List<Lead> existingLeads = [
                SELECT 
                    Email 
                FROM 
                    Lead 
                WHERE Email = :emails AND Id != :Trigger.new ORDER BY CreatedDate ASC
            ];

        Map<String, Lead> existingLeadsByEmail = new Map<String, Lead>();
        for(Lead l : existingLeads) {
            if(!existingLeadsByEmail.containsKey(l.Email)) {
                existingLeadsByEmail.put(l.Email, l);
            }
        }

        // TODO: check for future call limits while building
        List<Id> masterLeadIds = new List<Id>() ;
        List<Id> duplicateLeadIds = new List<Id>() ;
        Integer i = 0;
        for(Lead l : records) {
            String email = l.Email;
            if(existingLeadsByEmail.containsKey(email)) {
                masterLeadIds.add(existingLeadsByEmail.get(email).Id);
                duplicateLeadIds.add(l.Id) ;
                // after 150 leads spawn off the merge future call. This hands off the extra DML to another limit bucket
                if(i >= 130) {
                    // init a future call with new and old lead ids that will perform the merge async
                    mergeLeadsFuture(masterLeadIds, duplicateLeadIds);
                    masterLeadIds = new List<Id>() ;
                    duplicateLeadIds = new List<Id>() ;
                    i = 0 ;
                } else {
                    ++i ;
                }
            }
        }
        if(!masterLeadIds.isEmpty()) {
            mergeLeadsFuture(masterLeadIds, duplicateLeadIds);
        }
    }

    // future call allows us to make additional DML calls since merge calls need to happen on an individual basis
    @future 
    public static void mergeLeadsFuture(List<Id> masterLeadIds, List<Id> duplicateLeadIds) {
        for(Integer x = 0; x < masterLeadIds.size(); x++) {
            Database.merge(new Lead(Id = masterLeadIds[x]), new List<Id>{duplicateLeadIds[x]});
        }
    }
    */

    /**
     * @description: After the lead is approved, convert the lead to account, contacts and opportunities.
     * @author: Matthew Allen - Red Argyle
     * @date: 07/21/15
     * @param - records - List of Leads to be converted after approval
     */
    public static void afterUpdateConvertLead(List<Lead> records, List<Lead> oldRecords) {
        Map<Id, Lead> oldLeadMap = new Map<Id, Lead>(oldRecords) ;
        List<Id> leadIds = new List<Id>() ;
        for(Lead l: records) {
            if(l.IsApproved__c && oldLeadMap.containsKey(l.Id) && !oldLeadMap.get(l.Id).IsApproved__c && !l.IsConverted) {
                leadIds.add(l.Id) ;
            }
            if(leadIds.size() >= 90) {
                System.enqueueJob(new AsyncConvertLeads(leadIds)) ;
                leadIds.clear() ;
            }
        }
        if(!leadIds.isEmpty()) {
            System.enqueueJob(new AsyncConvertLeads(leadIds)) ;
        }
    }

    // Convert the list of leads. Conversion calls lots of other triggers so this can balloon quickly in SOQL queries.
    /*
    public static void convertLeads(List<Id> leadIds) {
        List<Database.LeadConvert> lcList = new List<Database.LeadConvert>();
        for(Id i: leadIds) {
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(i);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lcList.add(lc) ;
        }
        System.debug('***afterUpdateConvertLead: Limits DML pre: ' + Limits.getDMLStatements());
        List<Database.LeadConvertResult> lcrList = Database.convertLead(lcList);
        System.debug('***afterUpdateConvertLead: Limits DML post: ' + Limits.getDMLStatements());
    }
    */
    public class AsyncConvertLeads implements Queueable {
        private List<Id> leadIds ;
        public AsyncConvertLeads(List<Id> Ids) {
            leadIds = Ids ;
        }
        public void execute(QueueableContext context) {
            List<Database.LeadConvert> lcList = new List<Database.LeadConvert>();
            for(Id i: leadIds) {
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(i);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                lcList.add(lc) ;
            }
            System.debug('***afterUpdateConvertLead: Limits DML pre: ' + Limits.getDMLStatements());
            List<Database.LeadConvertResult> lcrList = Database.convertLead(lcList);
            System.debug('***afterUpdateConvertLead: Limits DML post: ' + Limits.getDMLStatements());   
        }
    }
}