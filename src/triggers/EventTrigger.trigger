trigger EventTrigger on Event (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    if(Trigger.isInsert && Trigger.isAfter)
    {
        if(EventContoller.isRunning == null)
        {
            EventContoller.updateParentLeads(Trigger.new);
            EventContoller.isRunning = true;
        }
        EventContoller.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
     if(Trigger.isInsert && Trigger.isBefore)
    {    
        //EventContoller.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.isUpdate && Trigger.isBefore)
    {
         EventContoller.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {    
       
       EventContoller.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
 
    }
}