trigger FedExShipmentToUpdateOpportunity on zkfedex__Shipment__c (after insert) {

Set<Id> OpportunityIds = new Set<Id>();

List<Opportunity> OppToUpdate = new List<Opportunity>();

for(zkfedex__Shipment__c shipment : Trigger.new)
{

OpportunityIds.Add(shipment.opportunity__c);

}

//Map<Id, Opportunity> opps = new Map<Id, Opportunity>([Select Contract_Start_Date__c from Opportunity Where Id in :OpportunityIds]);

list<Opportunity> opps = [select Contract_Start_Date__c from Opportunity where Id in :OpportunityIds ];

for(Opportunity o : opps)
{

o.Contract_Start_Date__c = System.TODAY()+5  ;
OppToUpdate.add(o);
}

update OpptoUpdate ;





}