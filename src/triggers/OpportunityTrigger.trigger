trigger OpportunityTrigger on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
 
    if(Trigger.isUpdate && Trigger.isBefore){  
        OpportunitytoAssetUpdate.UpdateAsset(Trigger.new,Trigger.NewMap,Trigger.OldMap); 
        PartnerHierarchy.createOpportunityPartnersForEndCustomer(Trigger.new);
        OpportunityStageChanges.revertRecordType(Trigger.oldMap, Trigger.new);
        OpportunityController.adjustQuotaLookUp(OpportunityController.filterOpportunitiesThatHaveBeenSetToClosedWon(Trigger.new,Trigger.oldMap).values());
    }
    if(Trigger.isUpdate && Trigger.isAfter){
     for(Opportunity opp:Trigger.New)
         {
           if((Trigger.newmap.get(opp.Id).ship_to_email__c!=Trigger.oldmap.get(opp.Id).ship_to_email__c)
           ||(Trigger.newmap.get(opp.Id).ship_to_Name__c !=Trigger.oldmap.get(opp.Id).ship_to_Name__c ))
           OpportunitytoAssetUpdate.UpdateAsset(Trigger.new,Trigger.NewMap,Trigger.OldMap);
         }
   
        Set<Id> oppIds = OpportunityController.filterOpportunitiesThatUpdatedPQLFields(Trigger.new,Trigger.oldMap).keySet();
        if(oppIds.size() > 0 && OpportunityController.isRunning == null){
                OpportunityController.rollUpToAccountsFromOpportunity(oppIds);
                OpportunityController.isRunning = true;
        }
    }
    if(Trigger.isInsert && Trigger.isAfter){ 
        OpportunitytoAssetUpdate.UpdateAsset(Trigger.new,Trigger.NewMap,Trigger.OldMap);   
        if(PartnerHierarchy.beenInserted == null) PartnerHierarchy.insertPartnerRelationships(Trigger.new);
        Set<Id> oppIds = OpportunityController.filterOpportunitiesThatUpdatedPQLFields(Trigger.new).keySet();
        if(oppIds.size() > 0 && OpportunityController.isRunning == null){
            //OpportunityController.addOpportunityContactRoles(Trigger.new);  
            OpportunityController.rollUpToAccountsFromOpportunity(oppIds);
            OpportunityController.isRunning = true;
        }
    }
}