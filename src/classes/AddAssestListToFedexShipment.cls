public class AddAssestListToFedexShipment {
	
	private static final String obj_Opportunity = 'Opportunity';
	private static final String obj_Case = 'Case';
	private static Map<ID,Opportunity> oppMap;
	private static Map<Id,Case> caseMap;
	private static Opportunity opp {get;set;}
	private static Case caseRecord {get;set;}
	public static String function;
	
	/*
	 * Creates Product Shipment records with data from Opportunity Line Items or Cases
	 * Design to be called from ShipmentTrigger trigger (when a fedex shipment is created)
	 *@param objIds, shipmentIds
	*/	
	public static void CreateProductShipments(Map<String, String> objIds, Map<String, Boolean> shipmentIds)
	{
		
		function = 'AddAssestListToFedexShipment.CreateProductShipments';
		
		if(objIds.size() == 0 ) return;
		
		List<Product_Shipment__c> prodsToInsert = new List<Product_Shipment__c>();
		GetAssetList(objIds.values());
		
		Set<Id> assetIds = getAssetIDs(oppMap.values(),caseMap.values());
		if(assetIds.size() == 0) return;
		
		List<Product_Shipment__c> shipments = [Select id,Asset__c,FedEx_Shipment__c From Product_Shipment__c Where Asset__c IN :assetIds AND FedEx_Shipment__c IN :objIds.keySet() ];
		Set<String> AssetAndShipmentIDs = new Set<String>();
		for(Product_Shipment__c shipment: shipments){
			AssetAndShipmentIDs.add(String.valueOf(shipment.Asset__c) + String.valueOf(shipment.FedEx_Shipment__c));
		}
		
		System.debug(assetIds);
		System.debug(shipments);
		System.debug(AssetAndShipmentIDs);
		
			//GetAssetList(objIds.values());
		for(String shipmentId : objIds.keySet())
		{
			
			if(!oppMap.containsKey(objIds.get(shipmentId)) && !caseMap.containsKey(objIds.get(shipmentId))) continue;
			
			if(caseMap.containsKey(objIds.get(shipmentId))) caseRecord = caseMap.get(objIds.get(shipmentId));
			else caseRecord = null;
			
			if(oppMap.containsKey(objIds.get(shipmentId))) opp = oppMap.get(objIds.get(shipmentId));
			else opp = null;
			
			if( opp != null && opp.OpportunityLineItems.size() > 0)
			{
				for(OpportunityLineItem oli : opp.OpportunityLineItems)
				{
					
					if(AssetAndShipmentIDs.contains(String.valueOf(oli.Asset__c)+String.valueOf(shipmentId))) continue;
					
					Product_Shipment__c prod = new Product_Shipment__c();
					prod.FedEx_Shipment__c = shipmentId;
					prod.Asset__c = oli.Asset__c;
					prod.Current_Outbound_Shipment__c = !shipmentIds.get(shipmentId);
					prod.Current_Return_Shipment__c = shipmentIds.get(shipmentId);
					prodsToInsert.add(prod);
				}
			}
			else
				if(caseRecord != null && caseRecord.AssetId != null && !AssetAndShipmentIDs.contains(String.valueOf(caseRecord.AssetId)+String.valueOf(shipmentId)))
				{
					Product_Shipment__c prod = new Product_Shipment__c();
					prod.FedEx_Shipment__c = shipmentId;
					prod.Asset__c = caseRecord.AssetId;
					prod.Current_Outbound_Shipment__c = !shipmentIds.get(shipmentId);
					prod.Current_Return_Shipment__c = shipmentIds.get(shipmentId);
					prodsToInsert.add(prod);
				}
		}
		try{
			if(prodsToInsert.size() > 0)	insert(prodsToInsert);
		}
		catch(DMLException ex)
		{
			System.debug('DMLException: ' + ex.getMessage());
		}
	}
	
	public static Set<ID> getAssetIDs(List<Opportunity> opps, List<Case> cases){
		Set<ID> assetIds = new Set<ID>();
		for(Opportunity op: opps){
			if(op.OpportunityLineItems.size() > 0){
				for(OpportunityLineItem item: op.OpportunityLineItems){
					if(item.Asset__c != null) assetIds.add(item.Asset__c);
				}
			}
		}
		for(Case c: cases){
			if(c.AssetID != null)	assetIds.add(c.assetID);
		}
		return assetIds;
	}
	
	/*
	 * Gets the Asset Lists from either Opportunity Line Items or Cases
	 *@param objIds
	*/
	private static void GetAssetList(List<String> objIds)
	{
			system.debug(objIds);
			Set<ID> oppIds = new Set<Id>();
			Set<ID> caseIds = new Set<Id>();
		
			for(String objId : objIds)
			{
				//check to see if object type is Opportunity or Case
				if(GetKeyPrefix(objId).toLowerCase() == obj_Opportunity.toLowerCase()){
					oppIds.add(objId);
				}
				else if(GetKeyPrefix(objId).toLowerCase() == obj_Case.toLowerCase()){
					caseIds.add(objId);
				}
				
			}
			
			oppMap = new Map<ID,Opportunity>([
						SELECT Id,
						(
							SELECT Id, Asset_Type_Asset__c, Asset__c 
							FROM OpportunityLineItems 
							WHERE Asset_Type_Asset__c = 'HW' 
						)
						FROM Opportunity 
						WHERE Id IN :oppIds
					]);
					
			caseMap = new Map<Id,Case>([
							SELECT Id, AssetId 
							FROM Case
							WHERE Id IN :caseIds
							AND Type Like '%DAS Device Tracker%' 
						]);
	}
	
	// map to hold global describe data  
    private static Map<String,Schema.SObjectType> gd;  
      
    // map to store objects and their prefixes  
    private static Map<String, String> keyPrefixMap;  
  
    // to hold set of all sObject prefixes  
    private static Set<String> keyPrefixSet;  
      
    private static void init() {  
        // get all objects from the org  
        gd = Schema.getGlobalDescribe();  
          
        // to store objects and their prefixes  
        keyPrefixMap = new Map<String, String>{};  
          
        //get the object prefix in IDs  
        keyPrefixSet = gd.keySet();  
          
        // fill up the prefixes map  
        for(String sObj : keyPrefixSet)  
        {  
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();  
            String tempName = r.getName();  
            String tempPrefix = r.getKeyPrefix();  
            keyPrefixMap.put(tempPrefix, tempName);  
        }  
    }  
    
    /*
     *Sets the object type based on the Id value
     *@param objId
     *@return objectType
    */  
    private static String GetKeyPrefix(String objId)  
    {  
        init() ;  
        String tPrefix = ObjId;  
        tPrefix = tPrefix.subString(0,3);  
          
        //get the object type now  
        String objectType = keyPrefixMap.get(tPrefix);  
        return objectType;  
    }  
}