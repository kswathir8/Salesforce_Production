global with sharing class OpportunityExpirationBatch implements Schedulable {
	global OpportunityExpirationBatch() {
	}
	global void execute(SchedulableContext SC) {
		List<Opportunity> oppList = [
				SELECT
					Exp_Date__c
				FROM
					Opportunity
				WHERE Exp_Date__c < TODAY AND IsClosed = false
			] ;
		for(Opportunity o: oppList) {
			o.Status__c = 'Expired' ;
		}
		if(!oppList.isEmpty()) update oppList ;
	}
}