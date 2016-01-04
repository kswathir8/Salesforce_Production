trigger TaskCounterTrigger on Task (before insert, after insert, after update) {

	if(trigger.isAfter)
	{
		if(trigger.isInsert) TaskCounterSupport.HandleTaskAppointments(trigger.new);
		TaskCounterSupport.HandleTaskTrigger(trigger.new, trigger.oldMap, trigger.isInsert);
	}

}