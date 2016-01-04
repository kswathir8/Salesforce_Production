/******************************************************
*    Trigger Name: OpenDASRequest                     *
*    Created By: Axcient                              *
*    This Trigger throws error when condition not met.*
******************************************************/

trigger OpenDASRequest on D_A_S__c (before insert){
    Set<Id> caseSet = new Set<Id>(); 
    Set<Id> oppIdSet = new Set<Id>();
    
    for(D_A_S__c a : trigger.new) { 
        oppIdSet.add(a.Opportunity__c);
    }
    if(trigger.isInsert){
        System.debug('#####Case Started#####');
        Map<Id,Group> mapGroupId = new Map<Id,Group>([Select g.Id From Group g where Name = 'D.A.S Requests']);
        System.debug('#####Group Id#####' + mapGroupId);
        // Case List fetched 
        List<Case> caseList = [Select id, c.Customer__c From Case c where c.Customer__c in :oppIdSet and c.Status = 'Open' and c.OwnerId in :mapGroupId.keySet()];
        System.debug('#####Case List Id#####' + caseList);
        for(Case c : caseList){
            caseSet.add(c.Customer__c);
        }
        System.debug('####size of case####' + caseSet.size());
        if(caseSet != null && caseSet.size() > 0){
            for(D_A_S__c a : trigger.new) { 
                if(caseSet.contains(a.Opportunity__c)) {
                    System.debug('#####Case Open#####');
                    a.addError('An open DAS Request already exists for this opportunity');     
                }
            }
        }    
    }
}