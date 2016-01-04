/**
* @author: Matthew Allen
* @date: 09/03/2015
* @description: Controller for Deal Registration List Page. Used to sort and control the initial list view of Deal Registrations.
* @history:
*/

public class DealRegistrationListController {

    public List<Lead> deals { get; set; }
    public List<Opportunity> oppList { get; set; }
    public Id oppid { get; set; }

    // Constructor
    public DealRegistrationListController() {
        Set<Id> oppIds = new Set<Id>() ;
    	try {
	        List<User> userList = [
	            SELECT
	                Contact.AccountId,
	                Name,
	                FirstName,
	                LastName
	            FROM User
	            WHERE Id = :UserInfo.getUserId()
	            LIMIT 1
	        ] ;
	        User partnerUser = userList[0] ;
	        deals = [
	        	SELECT
	                OwnerId,
	                Partner_Company_Name__c,
	                Partner_Campaign_Type__c,
	                Sales_Contact_First_Name__c,
	                Sales_Contact_Last_Name__c,
	                Sales_Contact_Phone__c,
	                Sales_Contact_Email__c,
	                Company,
	                Street,
	                City,
	                State,
	                End_User_State__c,
	                PostalCode,
	                FirstName,
	                LastName,
	                Phone,
	                End_User_Job_Title__c,
	                Is_this_a_new_customer_or_a_Current_cust__c,
	                of_Physical_Servers__c,
	                of_Virtual_Hosts__c,
	                Total_GB_of_Server_Storage__c,
	                Estimated_Monthly_Service_Fees__c,
	                Timeframe_for_Purchase__c,
	                Opportunity_Description__c,
	                Competitor_Replaced__c,
	                Status,
	                RecordTypeID,
	                Deal_Registration_Lead__c,
	                Partner__c,
	                Name,
	                InApproval__c,
	                IsConverted,
	                ConvertedOpportunityId
	        	FROM
	        		Lead
	        	WHERE
	        		Partner__c = :partnerUser.Contact.AccountId
	        ] ;
	        if(deals == null) deals = new List<Lead>() ;
	        System.debug('***DealRegistrationListController: deals: ' + deals) ;
	        for(Integer i = 0; i < deals.size(); i++) {
	        	if(deals[i].IsConverted) {
			        System.debug('***DealRegistrationListController: deals[i]: ' + deals[i]) ;
	        		oppIds.add(deals[i].ConvertedOpportunityId);
	        		deals.remove(i) ;
	        		System.debug('***DealRegistrationListController: oppIds2: ' + oppIds) ;
	        	}
	        }
	        System.debug('***DealRegistrationListController: oppIds: ' + oppIds) ;
	        oppList = [
	        	SELECT
	        		Name,
	        		StageName,
	        		CloseDate
	        	FROM
	        		Opportunity
	        	WHERE Id IN :oppIds 
	        ] ;
	        if(oppList == null) oppList = new List<Opportunity>() ;
	        System.debug('***DealRegistrationListController: oppList: ' + oppList) ;
		} catch(Exception e) {
			System.debug('***DealRegistrationListController: constructor: ' + e.getMessage() + ' trace: ' + e.getStackTraceString()) ;
		}
    }

    public Pagereference extendDeal() {
        PageReference pg = Page.RequestExtension;
        pg.getParameters().put('id', oppId) ;
        pg.setredirect(true);
        return pg;
    }

    // Method to insert new deal information as an opportunity
    public Pagereference registerDeal() {
        PageReference pg = Page.DealRegistration;
        pg.setredirect(true);
        return pg;
    }

}