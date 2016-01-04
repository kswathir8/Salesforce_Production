trigger CaseTrigger on Case (after insert, after update) {
    
    if(Trigger.isUpdate)
    {
        if(Trigger.isAfter)
        {
            for(Case newCase : Trigger.new)
            {
                Case oldCase = Trigger.oldMap.get(newCase.id);
                //create sales invoice
                if(oldCase.DAS_Phase__c != newCase.DAS_Phase__c && newCase.DAS_Phase__c.Contains('Requested')) 
                {
                    CreateInvoiceInIntacct.syncToIntacct(newCase.Id); 
                }
                
            }
        }
    }
}