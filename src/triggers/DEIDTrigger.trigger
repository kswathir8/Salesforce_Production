trigger DEIDTrigger on DEID__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

	if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
		DEIDController.updateOppFromDEID(Trigger.new);
	}

}