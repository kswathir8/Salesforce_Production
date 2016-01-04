trigger LeadTrigger on Lead (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
        
        if(Trigger.isInsert && Trigger.isBefore)
        {
            TerritoryManager.assignTerritoryForLeads(Trigger.new);   
            LeadTriggerHandler.beforeInsertPartnerReconciliation(Trigger.new);          
        }
        
        /*else if(Trigger.isUpdate && Trigger.isAfter){ 
            //List<Lead> convertedLeads = LeadController.filterConvertedLeads(Trigger.oldMap, Trigger.newMap);
            //if(convertedLeads.size() > 0) 
            //LeadController.addLeadSources(convertedLeads);
        }//*/
    
        else if(Trigger.isUpdate && Trigger.isBefore)
        {

            Map<Id,Lead> territoryMap = new Map<Id,Lead>(Trigger.newMap);
            for(Lead ld:Trigger.new)
            {
                if((Trigger.newMap.get(ld.Id).MQL2__c!=Trigger.oldMap.get(ld.Id).MQL2__c)
                ||(Trigger.newMap.get(ld.Id).Transfer_Lead__c !=Trigger.oldMap.get(ld.Id).Transfer_Lead__c) 
                || (Trigger.newMap.get(ld.Id).state !=Trigger.oldMap.get(ld.Id).state) 
                || (Trigger.newMap.get(ld.Id).PostalCode !=Trigger.oldMap.get(ld.Id).PostalCode) 
                || (Trigger.newMap.get(ld.Id).RecordType_Name_Lead__c != Trigger.oldMap.get(ld.Id).RecordType_Name_Lead__c)
                || (Trigger.newMap.get(ld.Id).Ownership_Trigger__c == True)
                ){
                  //TerritoryManager.assignTerritoryForLeads(Trigger.new); <-- This passes ALL Leads to the method, rather than just those that meet criteria.
                } else {
                    //Instead, let's remove any that DON'T qualify from our "territoryMap" Map, and then pass THAT to TerritoryManager when we are done with this loop.
                    territoryMap.remove(ld.Id);
                }
            }
            if (territoryMap.size() > 0){
                TerritoryManager.assignTerritoryForLeads(territoryMap.values());
                for(Lead ld:Trigger.new)
                {
                    Trigger.newMap.get(ld.Id).Ownership_Trigger__c = False;
                }
                
            }
        }
        else if(Trigger.isUpdate && Trigger.isAfter) {
            // TP 20151116 - deal reg leads will auto-convert after approval process
            LeadTriggerHandler.afterUpdateConvertLead(Trigger.new, Trigger.old) ;
        }
}