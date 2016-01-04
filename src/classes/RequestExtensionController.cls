public without sharing class RequestExtensionController {

	private Id oppId ;
	private Opportunity o ;
	private List<Zip_Code_Range__c> zipCodeList ;
	public Deal_Extension_Request__c der { get; set; }

	public RequestExtensionController() {
//		Id leadId = ApexPages.currentPage().getParameters().get('id') ;
		oppId = ApexPages.currentPage().getParameters().get('id') ;
		der = new Deal_Extension_Request__c() ;
//		der.Lead__c = leadId ;
		der.Opportunity__c = oppId ;
		List<Opportunity> oppList = [
			SELECT
				Name,
				Account.BillingState,
				Account.BillingPostalCode
			FROM Opportunity
			WHERE Id = :oppId
		] ;
		o = oppList[0] ;

        zipCodeList = [
            SELECT
                Axcitory__r.OwnerId,
                Zip_Code_Start__c,
                Zip_Code_Stop__c
            FROM
                Zip_Code_Range__c
            WHERE Type__c = 'Deal Registration' AND State__c = :o.Account.BillingState
        ] ;
	}

    public PageReference requestExtension() {
    	try {
    		id ownerId ;
            System.debug('***requestExtension: got to try');
            if(der.Requested_Extension_Length__c > 60 || der.Requested_Extension_Length__c < 1) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The length of extension must be from 1-60.'));
                return null ;
            }
            if(der.Reason_for_extension_request__c == null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must include a reason for the extension.'));
                return null ;
            }
            if(zipCodeList.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This state for this associate Deal does not have an Axcitory assigned. Please have an admin create it.'));
                return null ;
            } else if(zipCodeList.size() == 1) {
                ownerId = zipCodeList[0].Axcitory__r.OwnerId ;
            } else {
                for(Zip_Code_Range__c z: zipCodeList) {
                    if((z.Zip_Code_Start__c != null) && (z.Zip_Code_Stop__c != null)) {
                        if((Integer.valueOf(o.Account.BillingPostalCode) >= Integer.valueOf(z.Zip_Code_Start__c)) && (Integer.valueOf(o.Account.BillingPostalCode) <= Integer.valueOf(z.Zip_Code_Stop__c))) {
                            ownerId = z.Axcitory__r.OwnerId ;
                        }
                    }
                }
                if(ownerId == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This state does not have an Axcitory assigned with that zipcode. Please have an admin create it.'));
                    return null ;
                }
            }
            der.OwnerId = ownerId ;
            insert der ;
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(der.Id);
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('Deal_Extension_Request_Approval_Process');
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
		} catch(Exception e) {
            System.debug('### System Exception : '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Error has occured. Please Contact Axcient Support.' + e.getMessage() + ' : ' + e.getStackTraceString()));
            return null ;
		}
        PageReference pg = Page.DealRegistrationList;
        pg.setredirect(true);
        return pg;
    }
}