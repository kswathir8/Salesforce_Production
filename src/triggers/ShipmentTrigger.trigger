trigger ShipmentTrigger on zkfedex__Shipment__c (after insert, after update) {

    private Map<String, String> objIds = new Map<String, String>();
    private Map<String, Boolean> returnShipments = new Map<String, Boolean>();
    
         
    for(zkfedex__Shipment__c shipment : Trigger.new)
    {
        if(Trigger.isUpdate && Trigger.isAfter)
        {    
                
                zkfedex__Shipment__c oldShipment = Trigger.oldMap.get(shipment.id);
                if(!oldShipment.zkfedex__SsProcessReturnShipment__c && oldShipment.zkfedex__MasterTrackingId__c == null && shipment.zkfedex__MasterTrackingId__c != null)
                {
                    System.Debug('Case Id: ' + shipment.Case__c);
                    if(shipment.Case__c != null)
                    {
                        System.Debug('Case Id: ' + shipment.Case__c);
                        //CreateShipperInIntacct.syncToIntacct(shipment.Case__c);
                    }
                    if(shipment.Opportunity__c != null)
                    {
                        System.Debug('Opportunity Id: ' + shipment.Opportunity__c);
                        //CreateShipperInIntacct.syncToIntacct(shipment.Opportunity__c);
                    }
                }
        }
        if(shipment.Case__c != null)
        {
                    objIds.put(shipment.Id, shipment.Case__c);
        }
        if(shipment.Opportunity__c != null)
        {
                    objIds.put(shipment.Id, shipment.Opportunity__c);
        }
        returnShipments.put(shipment.Id, shipment.zkfedex__SsProcessReturnShipment__c);
     }
     if(objIds.size() > 0) 
     {
                AddAssestListToFedexShipment.CreateProductShipments(objIds, returnShipments);
     }
}