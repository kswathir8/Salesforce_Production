Public class ChangeOwnerReason
{
/********************************************************
Method: Change Lead Owner
Description: Update Lead Owner on Lead object from Change Owner Reason object (Change Lead Owner)
Author: Swathi Karkala.
Date : 9/24/2013
*********************************************************/  
  /* Public static void ChangeLeadOwner(List<Change_Owner_Reason__c> newOrderList, Map<ID,Change_Owner_Reason__c> NewOrderMap, Map<ID,Change_Owner_Reason__c> oldOrderMap)
    {

        System.debug('ChangeLeadOwner-----------');
        List<Lead> UpdateLeadList = new List<Lead>();
        Map<Id,Id> ChangetoLeadIdMap = new Map<Id,Id>();
        Map<Id,Lead> LeadMap = new Map<Id,Lead>();
        
        for(Change_Owner_Reason__c CR:newOrderList)
        {
            if(CR.Approve_Reject__c == 'Approve')
            ChangetoLeadIdMap.put(CR.id,CR.Lead__c);
        }
        System.debug('ChangeLeadOwner1-----------');
        
        List<lead>LeadList = [select id from Lead where id IN: ChangetoLeadIdMap.values()];

        for(Lead Ld:LeadList)
        {
            LeadMap.put(Ld.id,Ld);
        }
        
        for(Change_Owner_Reason__c CR1:newOrderList)
        { 
          Id Leadid = ChangetoLeadIdMap.get(CR1.id);
          Lead TargetLead = LeadMap.get(Leadid);
          system.debug('Approve-------------------------------------------');
          try
          {
          TargetLead.ownerid=CR1.OwnerId;
          UpdateLeadList.add(TargetLead);
          }
          catch(exception e)
          {
          }

        } 
        Update UpdateLeadList;
        
     }*/
      
}