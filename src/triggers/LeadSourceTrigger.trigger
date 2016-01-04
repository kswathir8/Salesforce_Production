trigger LeadSourceTrigger on Lead_Source__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	if(Trigger.isInsert && Trigger.isAfter)	LeadSourceController.rollUpToAccounts(Trigger.newMap.keySet());

}