trigger SetSrvIdInCase on Case (before insert) {
    Set<Id> oppId = new Set<Id>(); //hashset
    //Get the ID of selected Opportunity
    for (Case newCase : Trigger.new) { 
        if(newCase.Customer__c != null) {
            oppId.add(newCase.Customer__c);
        }
    }
    if(oppId.size() > 0) {
        List<Service_Id__c> lstSrvID = new List<Service_Id__c>([select Id, Name from Service_Id__c where Customer__c in :oppId and Status__c = 'Active' order by id limit 1]);
        system.debug('service Id***'+lstSrvID);
        if (lstSrvID != null && lstSrvID.size()> 0) {
            System.debug('SIDs new:->' + lstSrvId[0].Name);
            for (Case newCase: Trigger.new){
                system.debug('Setting service id');
                newCase.Service_Id__c = lstSrvID.get(0).Id;
            }
        }
    }
}