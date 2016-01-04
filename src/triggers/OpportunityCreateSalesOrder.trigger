trigger OpportunityCreateSalesOrder on Opportunity (after update) {
    
    for(Opportunity opp : Trigger.new)
    {
        Opportunity oldOpp = Trigger.oldMap.get(opp.id);
        /*//create order
        if(oldOpp.Approval_Status__c!=opp.Approval_Status__c && opp.Approval_Status__c=='Approved')
        { 
            SalesOrderToIntacct.syncToIntacct(opp.Id, opp.sforcekey__c, opp.endpoint__c, false);
        } 
        
        //create $0 order
        if(oldOpp.Approval_Status_Evaluation__c!=opp.Approval_Status_Evaluation__c && opp.Approval_Status_Evaluation__c=='Approved')
        {
            SalesOrderToIntacct.syncToIntacct(opp.Id, opp.sforcekey__c, opp.endpoint__c, true);
        } 
        */
        //create pro-rata invoice
        System.debug('opp from trigger: ' + opp);
        System.debug('oldOpp from Trigger: ' + oldOpp);
        if(oldOpp.Status__c != opp.Status__c && opp.Status__c == 'Converted') 
        {
            CreateInvoiceInIntacct.syncToIntacct(opp.Id); 
        }
    }
}