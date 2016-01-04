trigger TaskTrigger on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        if(TaskController.isRunning == null)
        {
            TaskController.updateParentLeads(Trigger.new);
            TaskController.isRunning = true;
        }
        //TaskController.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
        TasktoLeadUpdate.UpdateLead(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.isInsert && Trigger.isBefore)
    {    
       TasktoLeadUpdate.UpdateLead(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.isUpdate && Trigger.isBefore)
    {
         //TaskController.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
         TasktoLeadUpdate.UpdateLead(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {     

      //TaskController.updateSalesAppointmentCheckbox(Trigger.new,Trigger.NewMap,Trigger.OldMap);
      TasktoLeadUpdate.UpdateLead(Trigger.new,Trigger.NewMap,Trigger.OldMap);
    }
           
}