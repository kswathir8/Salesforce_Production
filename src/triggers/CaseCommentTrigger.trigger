/**
* @author: Anusha Surapaneni
* @date: 09/05/2013
* @description: Trigger on Case Comment object with all trigger events
* @history:
    1. 
*/
trigger CaseCommentTrigger on CaseComment (before insert, before update, before delete, 
                                            after insert, after update, after delete ){
    
    public CaseCommentTriggerHandler cctHandler = new CaseCommentTriggerHandler();  
    
    // After insert trigger event
    if(Trigger.isAfter && Trigger.isInsert){        
        // ** ACTION 1 ** : Send Email to Emails fields on Case when Case Comment is added
       cctHandler.sendEmailOnCaseCommentInsert(Trigger.new);
        
    }
    
    /* (Template methods for future use)
    // After Update Trigger Event
    if(Trigger.isAfter && Trigger.isUpdate){
       
    }
    
    // Before Insert Trigger Event
    if(Trigger.isBefore && Trigger.isInsert){
       
    }
    
    // Before Update Trigger Event
    if(Trigger.isBefore && Trigger.isUpdate){
       
    }
    
    // After Delete Trigger Event
    if(Trigger.isAfter && Trigger.isDelete){
       
    }
    
   
    // Before Delete Trigger Event
    if(Trigger.isBefore && Trigger.isDelete){
    }
    
    
    // After Undelete Insert Trigger Event
    if(Trigger.isUndelete){
    }
    
    */  
}