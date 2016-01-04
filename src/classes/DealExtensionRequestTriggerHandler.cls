public class DealExtensionRequestTriggerHandler 
{
    public static void updateOpportunityExpiration(List<Deal_Extension_Request__c> records, List<Deal_Extension_Request__c> old) {
        Set<Id> oppIds = new Set<Id>() ;
        Map<Id, Deal_Extension_Request__c> derOldMap = new Map<Id, Deal_Extension_Request__c>(old) ;
        Map<Id, Deal_Extension_Request__c> derOppMap = new Map<Id, Deal_Extension_Request__c>() ;
        List<Opportunity> oppUpdateList = new List<Opportunity>() ;

        for(Deal_Extension_Request__c der: records) {
            if(der.Approved__c && !derOldMap.get(der.Id).Approved__c) {
                oppIds.add(der.Opportunity__c);
                derOppMap.put(der.Opportunity__c, der) ;
            }
        }
        List<Opportunity> oppList = [
            SELECT
                Name,
                Exp_Date__c
            FROM
                Opportunity
            WHERE Id IN :oppIds
        ] ;
        for(Opportunity o: oppList) {
            o.Exp_Date__c = o.Exp_Date__c.addDays((Integer)derOppMap.get(o.Id).Requested_Extension_Length__c) ;
            oppUpdateList.add(o) ;
        }
        if(!oppUpdateList.isEmpty()) update oppUpdateList ;
    }
}