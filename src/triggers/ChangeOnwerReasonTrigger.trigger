Trigger ChangeOnwerReasonTrigger on Change_Owner_Reason__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

 /*   if(Trigger.isUpdate && Trigger.isAfter)
    { 
       ChangeOwnerReason.ChangeLeadOwner(Trigger.New, Trigger.NewMap,Trigger.oldMap);
       //ChangeOwnerReason.sendMailtoLeadOwner(Trigger.New,Trigger.NewMap,Trigger.oldMap);
       //ChangeOwnerReason.UpdateCurrentLeadOwnerEmail(Trigger.old, Trigger.NewMap,Trigger.oldMap);
       
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    { 
        ChangeOwnerReason.ChangeLeadOwner(Trigger.New,Trigger.NewMap,Trigger.oldMap);
        //ChangeOwnerReason.sendMailtoLeadOwner(Trigger.New,Trigger.NewMap,Trigger.oldMap);
        //ChangeOwnerReason.UpdateCurrentLeadOwnerEmail(Trigger.old, Trigger.NewMap,Trigger.oldMap);      
    }
    else if(Trigger.isInsert && Trigger.isAfter)
    {
         SendEmailstoLeadOwner.sendMailtoLeadOwner(Trigger.New,Trigger.NewMap,Trigger.oldMap);
    }
    else if(Trigger.isInsert && Trigger.isBefore)
    {
        //ChangeOwnerReason.sendMailtoLeadOwner(Trigger.New,Trigger.NewMap,Trigger.oldMap);
    }*/
 }