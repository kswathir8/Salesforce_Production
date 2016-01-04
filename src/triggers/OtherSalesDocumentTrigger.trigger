trigger OtherSalesDocumentTrigger on Other_Sales_Document__c (after insert) {

    UpdateOpportunityOrCase updateOppOrCase = new UpdateOpportunityOrCase();
    updateOppOrCase.updateObjects(Trigger.new);
}