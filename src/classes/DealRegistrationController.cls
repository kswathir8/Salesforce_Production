/**
* @author: Anusha Surapaneni
* @date: 09/23/2013
* @description: Controller for Deal Registration Page- Used to insert new "Deal Registration" opportunity when created from Axcient.com
* @history:
    1. MMA - Red Argyle - 07/15/15 Updating Controller to convert deal registration into a lead form not an opportunity.
*/

public class DealRegistrationController {

    public static Map<String, Schema.RecordTypeInfo> leadRecordTypesByName {
        get {
            if(leadRecordTypesByName == null) leadRecordTypesByName = Lead.getSObjectType().getDescribe().getRecordTypeInfosByName();
            return leadRecordTypesByName;
        }
        set;
    }

    public Lead newLead { get; set; }
    public Campaign dealCampaign { get; set; }
    public boolean isDealRegistered { get; set; }
    public String dateString { get; set; }

    // Constructor
    public DealRegistrationController() {
        isDealRegistered = false;
        newLead = new Lead() ;
        newLead.RecordTypeID = leadRecordTypesByName.get('Deal Registration Lead').getRecordTypeId() ;
        newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        List<Campaign> cList = [
            SELECT
                Name
            FROM
                Campaign
            WHERE Name = 'Deal Registration'
        ] ;
        if(cList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Deal Registration campaign does not exist. Please create it.'));
            return ;
        }
        dealCampaign = cList[0] ;
    }

    // Method to insert new deal information as an opportunity
    public Pagereference registerDeal() {
        System.debug('***registerDeal: start');
        try{
            Boolean inApproval = false ;
            Id leadId ;
            System.debug('***registerDeal: got to try');
            Date tmpDate = Date.parse(dateString);
            if(tmpDate > Date.today().addDays(120)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Timeframe for purchase must be within 120 days of today.'));
                return null ;
            }
            if(tmpDate < Date.today()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Timeframe for purchase must be in the future.'));
                return null ;
            }
            if(dealCampaign == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Deal Registration campaign does not exist. Please create it.'));
                return null ;
            }
            List<User> userList = [
                SELECT
                    Contact.AccountId,
                    Name,
                    FirstName,
                    LastName
                FROM User
                WHERE Id = :UserInfo.getUserId()
            ] ;
            User partnerUser = userList[0] ;
            List<Lead> existingLeads = [
                SELECT 
                    Email,
                    InApproval__c
                FROM 
                    Lead 
                WHERE Email = :newLead.Email
            ];
            Id ownerId ;

            // TP 20151106 - removing Type__c = Deal Registration filter per AX-68
            List<Zip_Code_Range__c> zipCodeList = [
                SELECT
                    Axcitory__r.OwnerId,
                    Zip_Code_Start__c,
                    Zip_Code_Stop__c
                FROM
                    Zip_Code_Range__c
                WHERE State__c = :newLead.End_User_State__c
            ] ;
            if(zipCodeList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This state does not have an Axcitory assigned. Please have an admin create it.'));
                return null ;
            } else if(zipCodeList.size() == 1) {
                ownerId = zipCodeList[0].Axcitory__r.OwnerId ;
            } else {
                for(Zip_Code_Range__c z: zipCodeList) {
                    if((z.Zip_Code_Start__c != null) && (z.Zip_Code_Stop__c != null)) {
                        if((Integer.valueOf(newLead.PostalCode) >= Integer.valueOf(z.Zip_Code_Start__c)) && (Integer.valueOf(newLead.PostalCode) <= Integer.valueOf(z.Zip_Code_Stop__c))) {
                            ownerId = z.Axcitory__r.OwnerId ;
                        }
                    }
                }
                if(ownerId == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This state does not have an Axcitory assigned with that zipcode. Please have an admin create it.'));
                    return null ;
                }
            }
            if(existingLeads.isEmpty()) {
                newLead.OwnerId = ownerId ;
                newLead.State = newLead.End_User_State__c ;
                newLead.Status = 'Sent to Partner' ;
                newLead.Deal_Registration_Lead__c = true ;
                newLead.Partner__c = partnerUser.Contact.AccountId ;
                newLead.Timeframe_for_Purchase__c = tmpDate ;
                insert newLead ;
                leadId = newLead.Id ;
                CampaignMember cm = new CampaignMember(CampaignId = dealCampaign.Id, LeadId = newLead.Id) ;
                insert cm ;
            } else {
                Lead masterLead = existingLeads[0] ;
                if(masterLead.InApproval__c) {
                    inApproval = true ;
                }
                masterLead.OwnerId = ownerId ;
                masterLead.Partner_Company_Name__c = newLead.Partner_Company_Name__c ;
                masterLead.Partner_Campaign_Type__c = newLead.Partner_Campaign_Type__c ;
                masterLead.Sales_Contact_First_Name__c = newLead.Sales_Contact_First_Name__c; 
                masterLead.Sales_Contact_Last_Name__c = newLead.Sales_Contact_Last_Name__c;
                masterLead.Sales_Contact_Phone__c = newLead.Sales_Contact_Phone__c;
                masterLead.Sales_Contact_Email__c = newLead.Sales_Contact_Email__c;
                masterLead.Company = newLead.Company;
                masterLead.Street = newLead.Street;
                masterLead.City = newLead.City;
                masterLead.State = newLead.End_User_State__c;
                masterLead.End_User_State__c = newLead.End_User_State__c ;
                masterLead.PostalCode = newLead.PostalCode;
                masterLead.FirstName = newLead.FirstName;
                masterLead.LastName = newLead.LastName;
                masterLead.Phone = newLead.Phone;
                masterLead.End_User_Job_Title__c = newLead.End_User_Job_Title__c;
                masterLead.Is_this_a_new_customer_or_a_Current_cust__c = newLead.Is_this_a_new_customer_or_a_Current_cust__c;
                masterLead.of_Physical_Servers__c = newLead.of_Physical_Servers__c;
                masterLead.of_Virtual_Hosts__c = newLead.of_Virtual_Hosts__c;
                masterLead.Total_GB_of_Server_Storage__c = newLead.Total_GB_of_Server_Storage__c;
                masterLead.Estimated_Monthly_Service_Fees__c = newLead.Estimated_Monthly_Service_Fees__c;
                masterLead.Timeframe_for_Purchase__c = newLead.Timeframe_for_Purchase__c;
                masterLead.Opportunity_Description__c = newLead.Opportunity_Description__c;
                masterLead.Competitor_Replaced__c = newLead.Competitor_Replaced__c;
                masterLead.Status = 'Sent to Partner' ;
                masterLead.RecordTypeID = leadRecordTypesByName.get('Deal Registration Lead').getRecordTypeId() ;
                masterLead.Deal_Registration_Lead__c = true ;
                masterLead.Partner__c = partnerUser.Contact.AccountId ;
                masterLead.Timeframe_for_Purchase__c = tmpDate ;
                update masterLead ;
                leadId = masterLead.Id ;
                List<CampaignMember> cmList = [
                    SELECT
                        CampaignId,
                        LeadId
                    FROM
                        CampaignMember
                    WHERE CampaignId = :dealCampaign.Id AND LeadId = :masterLead.Id
                ] ;
                if(cmList.isEmpty()) {
                    CampaignMember cm = new CampaignMember(CampaignId = dealCampaign.Id, LeadId = masterLead.Id) ;
                    insert cm ;
                }
            }
            isDealRegistered = true;
            if(!inApproval) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Submitting request for approval.');
                req1.setObjectId(leadId);
                // Submit the record to specific process and skip the criteria evaluation
                req1.setProcessDefinitionNameOrId('Deal_Registration_Lead_Approval_Process');
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req1);
            }
        }
        catch(Exception e){
            System.debug('### System Exception : '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error has occured.Please Contact Axcient Support.' + e.getMessage() + ' : ' + e.getStackTraceString()));
        }
        return null;
    }
    
    // Method for Cancel button to reload Deal Registration Page
    public PageReference Cancel() {
        PageReference pg = Page.DealRegistrationList;
        pg.setredirect(true);
        return pg;
    }
}