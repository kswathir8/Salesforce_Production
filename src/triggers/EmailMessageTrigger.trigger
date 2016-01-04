trigger EmailMessageTrigger on EmailMessage (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
	if(Trigger.isInsert && Trigger.isAfter) EmailMessageController.updateMessagesWithClosedCases(Trigger.new); 
}