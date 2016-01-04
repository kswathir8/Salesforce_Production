trigger DealExtensionRequestTrigger on Deal_Extension_Request__c (before update) {

		if (Trigger.isBefore && Trigger.isUpdate) {
			List<Deal_Extension_Request__c> tmpList = Trigger.new ;
	    	DealExtensionRequestTriggerHandler.updateOpportunityExpiration(Trigger.new, Trigger.old);
		}
}