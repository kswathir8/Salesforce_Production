trigger ContactController on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    if( (Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter && !System.isBatch()){ 
        if(contactController.isRunning == null)
        { 
            if(system.isFuture()) 
            return;
            contactController.rollUpAttendedDemo(Trigger.newMap.keySet());
            contactController.isRunning = true; 
        }
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
            contactController.updatenoLongerEmployedContacts(contactController.sortOutContactThatAreNoLongerEmployed(Trigger.oldMap,Trigger.newMap));   
    }
}