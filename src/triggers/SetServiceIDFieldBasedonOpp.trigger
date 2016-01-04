trigger SetServiceIDFieldBasedonOpp on D_A_S__c (before insert) {
Set<Id> oppId = new Set<Id>(); //hashset
    if(trigger.isInsert){
        //Get the ID of selected Opportunity
        for (D_A_S__c a : Trigger.new) { 
            oppId.add(a.Opportunity__c);
        }
        //here Customer__c is the lookup to opportunity
        List<Service_Id__c> lstSrvID = new List<Service_Id__c>([select Id, Name from Service_Id__c where Customer__c in :oppId order by id limit 1]);
        if(lstSrvID != null && lstSrvID.size() > 0) {
            for (D_A_S__c a: Trigger.new){
               a.Service_Id__c = lstSrvID.get(0).Id;
            }
        }
    }
}