trigger AccountTrigger on Account (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {


    if(Trigger.isUpdate && Trigger.isBefore)
    {           
        Map<Id,Account> territoryMap = new Map<Id,Account>(Trigger.newMap);
        //TerritoryManager.assignTerritoryForAccounts(Trigger.new);
        system.debug('territoryMap size----'+territoryMap.size());
        
         for(Account acc:Trigger.New)
         {
           system.debug('Entered the first for loop------');
           
           if( (Trigger.newMap.get(acc.Id).Transfer_Lead__c !=Trigger.oldMap.get(acc.Id).Transfer_Lead__c) 
                || (Trigger.newMap.get(acc.Id).Transfer_Account__c !=Trigger.oldMap.get(acc.Id).Transfer_Account__c)
                || (Trigger.newMap.get(acc.Id).Billingstate !=Trigger.oldMap.get(acc.Id).Billingstate) 
                || (Trigger.newMap.get(acc.Id).BillingPostalCode !=Trigger.oldMap.get(acc.Id).BillingPostalCode) 
                || (Trigger.newMap.get(acc.Id).RecordType != Trigger.oldMap.get(acc.Id).RecordType)
                || (Trigger.newMap.get(acc.Id).Ownership_Trigger__c == True)
                || (Trigger.newMap.get(acc.Id).Axcitory__c != Trigger.oldMap.get(acc.Id).Axcitory__c)
                || (Trigger.newMap.get(acc.Id).Account_status__c!= Trigger.oldMap.get(acc.Id).Account_status__c))
           {
                if(territoryMap.size() > 0 && acc.Acc_Record_Type__c != 'MSP End User')
                {
                system.debug('Ownership Trigger is true===='+Trigger.newMap.get(acc.Id).Ownership_Trigger__c);
                TerritoryManager.assignTerritoryForAccounts(territoryMap.values());
                system.debug('New OwnerId2----'+Trigger.newmap.get(acc.Id).OwnerId);
                system.debug('Old OwnerId2----'+Trigger.oldmap.get(acc.Id).OwnerId);
                Trigger.newMap.get(acc.Id).Ownership_Trigger__c = False;
                system.debug('Ownership Trigger is false====='+Trigger.newMap.get(acc.Id).Ownership_Trigger__c);
                }     
           }
           
           if((Trigger.newmap.get(acc.Id).Account_Status__c !=Trigger.oldmap.get(acc.Id).Account_Status__c) ||
             (Trigger.newmap.get(acc.Id).OwnerId !=Trigger.oldmap.get(acc.Id).OwnerId && acc.manual_override__c == false))
            {
               if(territoryMap.size() >0)
               system.debug('Entered first loop of account to contact update----');
               AccounttoContactUpdate.UpdateContact(Trigger.new,Trigger.NewMap,Trigger.OldMap);
            }
          
         }
     }
          
    if(Trigger.isUpdate && Trigger.isAfter)  
    {  
    
    Map<Id,Account> territoryMap = new Map<Id,Account>(Trigger.newMap);
        for(Account acc:Trigger.New)
         {
           if((Trigger.newmap.get(acc.Id).Account_Status__c !=Trigger.oldmap.get(acc.Id).Account_Status__c) ||
             (Trigger.newmap.get(acc.Id).OwnerId !=Trigger.oldmap.get(acc.Id).OwnerId && acc.manual_override__c == false))
            {
               if(territoryMap.size() >0)
               {
                system.debug('Entered second loop of account to contact update----');
                AccounttoContactUpdate.UpdateContact(Trigger.new,Trigger.NewMap,Trigger.OldMap);
               }
            }
          
         }
        
    }
    if(Trigger.isInsert && Trigger.isAfter)
    {
       // Add classes here
    }
    if(Trigger.isUpdate && Trigger.isAfter)
    {
    Map<Id,Account> territoryMap = new Map<Id,Account>(Trigger.newMap);
        for(Account acc:Trigger.New)
         {
           if((Trigger.newmap.get(acc.Id).Account_Status__c !=Trigger.oldmap.get(acc.Id).Account_Status__c) ||
             (Trigger.newmap.get(acc.Id).OwnerId !=Trigger.oldmap.get(acc.Id).OwnerId && acc.manual_override__c == false))
            {
               if(territoryMap.size() >0)
               {
                system.debug('Entered third loop of account to contact update----');
                AccounttoContactUpdate.UpdateContact(Trigger.new,Trigger.NewMap,Trigger.OldMap);
               }
            }
         }
  
    }
    
}