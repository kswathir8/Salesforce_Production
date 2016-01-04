trigger UpdateAsset on Product_Shipment__c (after update, after insert ) {

	/* Changes made by Alexandru Boghean - aboghean@sererra.com
	 * #####START####
	*/
	//holds ids of Assets and lists of related Product Shipment records 
	private Map<String, List<Product_Shipment__c>> assetsAndProducts = new Map<String, List<Product_Shipment__c>>();
	private Set<Id> assetIds = new Set<Id>();
	private List<Asset> assets = new List<Asset>();
	private Map<String, Asset> assetsMap = new Map<String, Asset>();
	private Map<Id, Product_Shipment__c> prodsToUpdate = new Map<Id, Product_Shipment__c>();
	private Map<Id, Asset> assetsToUpdate = new Map<Id, Asset>();
	
	for(Product_Shipment__c ps : Trigger.New)
	{
		assetIds.add(ps.Asset__c);
	}
	
	try
	{
		//get the list of Product Shipments for each Asset that is found in the insert/update of a Product Shipment
		assets = [
			SELECT Id, Name, Outbound_Shipment_Tracking__c, Outbound_Asset_Ship_Date__c, Outbound_Asset_Actual_Delivery_Date__c,
				Track_Outbound_Shipments__c, Track_Return_Shipments__c,
            	(SELECT Id, Current_Return_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c, IsChanged__c, 
            		FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c , FedEx_Shipment__r.zkfedex__SsProcessReturnShipment__c,
            		FedEx_Shipment__r.zkfedex__ShipDate__c, Current_Outbound_Shipment__c, Asset__c, Asset__r.Track_Outbound_Shipments__c,
            		Asset__r.Track_Return_Shipments__c
            	 FROM Shipments__r 
            	 WHERE Current_Outbound_Shipment__c = true OR Current_Return_Shipment__c = true
            	)
            FROM Asset
            WHERE Id IN: assetIds
		];
	}
	catch(QueryException ex)
	{
		System.debug('QueryException from UpdateAsset trigger: ' + ex.getMessage());
		assets = null;
	}
	
	System.debug(assets);
	List<Product_Shipment__c> prods = new List<Product_Shipment__c>();
	for(Asset asset : assets)
	{
		for(Product_Shipment__c ps : asset.Shipments__r)
		{
			if(ps.Asset__c == asset.Id)		prods.add(ps);
		}
		//add asset Id and list of Product Shipment records
		assetsAndProducts.put(asset.Id, prods); 		assetsMap.put(asset.Id, asset);
	}	
	
	if(assets != null)
	{
		for(Asset asset : assets)
		{
			//this way we remove the chance to have duplicates
			assetsMap.put(asset.Id, asset);
		}
	}
	
	if(Trigger.isInsert && Trigger.isAfter)
	{
		String masterTrackingId = '';
		Date shipDate; Date deliveryDate;
		for(String assetId : assetsAndProducts.keySet())
		{
			for(Product_Shipment__c ps : Trigger.New)
			{
				if(assetsMap.get(ps.Asset__c).Shipments__r.size() > 0)
				{
					for(Product_Shipment__c psFromAsset : assetsMap.get(ps.Asset__c).Shipments__r)
					{
						if(ps.Id != psFromAsset.Id)
						{
							if(ps.Current_Outbound_Shipment__c && psFromAsset.Current_Outbound_Shipment__c)
							{
								psFromAsset.Current_Outbound_Shipment__c = false;
								prodsToUpdate.put(psFromAsset.Id, psFromAsset);
								break;
							}
							if(ps.Current_Return_Shipment__c && psFromAsset.Current_Return_Shipment__c)
							{
								psFromAsset.Current_Return_Shipment__c = false;
								prodsToUpdate.put(psFromAsset.Id, psFromAsset);
								break;
							}
						}
						else
						{
							masterTrackingId = psFromAsset.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
							shipDate = psFromAsset.FedEx_Shipment__r.zkfedex__ShipDate__c;
							deliveryDate = psFromAsset.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
						}
					}
				}
				if(ps.Current_Outbound_Shipment__c)
				{
					System.debug('ps:' + ps);
					Asset asset = assetsMap.get(ps.Asset__c);
					asset.Outbound_Shipment_Tracking__c = masterTrackingId;
	    			asset.Outbound_Asset_Ship_Date__c = shipDate;
	    			asset.Outbound_Asset_Actual_Delivery_Date__c = deliveryDate;
	    			assetsToUpdate.put(asset.Id, asset);
	    			System.debug('asset: ' + asset);
				}
				if(ps.Current_Return_Shipment__c)
				{
					System.debug(ps);
					Asset asset = assetsMap.get(ps.Asset__c);
					asset.Return_Shipment_Tracking__c = masterTrackingId;
	    			asset.Return_Shipment_Ship_Date__c = shipDate;
	    			asset.Return_Shipment_Actual_Delivery_Date__c = deliveryDate;
	    			assetsToUpdate.put(asset.Id, asset);
				}
			}
		}
	}
	if(Trigger.isUpdate)
	{
		String masterTrackingId = '';
		Date shipDate; Date deliveryDate;
		System.debug(assetsAndProducts);
		Boolean updateAsset = true;
		for(String assetId : assetsAndProducts.keySet())
		{
			for(Product_Shipment__c ps : Trigger.New)
			{
				system.debug(ps.Id);
				if((ps.Current_Outbound_Shipment__c &&  ps.Current_Outbound_Shipment__c != Trigger.oldMap.get(ps.Id).Current_Outbound_Shipment__c) || 
        		   (ps.Current_Return_Shipment__c && ps.Current_Return_Shipment__c != Trigger.oldMap.get(ps.Id).Current_Return_Shipment__c) || 
        		   (ps.IsChanged__c))
        		{
        			system.debug(assetsMap.get(ps.Asset__c).Shipments__r);
        			system.debug(assetsMap.get(ps.Asset__c).Shipments__r.size());
					if(assetsMap.get(ps.Asset__c).Shipments__r.size() > 0)
					{
						for(Product_Shipment__c psFromAsset : assetsMap.get(ps.Asset__c).Shipments__r)
						{
							system.debug(ps.Id);
							system.debug(psFromAsset.Id);
							if(ps.Id != psFromAsset.Id)
							{
								System.debug(ps.Asset__r.Track_Outbound_Shipments__c);
								System.debug(psFromAsset.Current_Outbound_Shipment__c);
								if(ps.Current_Outbound_Shipment__c && psFromAsset.Asset__r.Track_Outbound_Shipments__c > 0 && psFromAsset.Current_Outbound_Shipment__c)
								{
									ps.addError('The Current Outbound Shipment Checkbox is already checked in in another shipment: '+URL.getSalesforceBaseUrl().toExternalForm()+ '/' + psFromAsset.Id+ '. Please Click Cancel and change the checkbox.');
									updateAsset = false;
									break;
								}
								if(ps.Current_Return_Shipment__c && psFromAsset.Asset__r.Track_Return_Shipments__c > 0 && psFromAsset.Current_Return_Shipment__c)
								{
									ps.addError('The Current Return Shipment Checkbox is already checked in another shipment: '+URL.getSalesforceBaseUrl().toExternalForm()+ '/' + psFromAsset.Id+ '. Please Click Cancel and change the checkbox.');
									updateAsset = false;
									break;
								}
							}
							else if(updateAsset)
							{
								masterTrackingId = psFromAsset.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
								shipDate = psFromAsset.FedEx_Shipment__r.zkfedex__ShipDate__c;
								deliveryDate = psFromAsset.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
							}
						}
						if(ps.Current_Outbound_Shipment__c && updateAsset)
						{
							System.debug(ps);
							Asset asset = assetsMap.get(ps.Asset__c);
							asset.Outbound_Shipment_Tracking__c = masterTrackingId;
			    			asset.Outbound_Asset_Ship_Date__c = shipDate;
			    			asset.Outbound_Asset_Actual_Delivery_Date__c = deliveryDate;
			    			assetsToUpdate.put(asset.Id, asset);
						}
						if(ps.Current_Return_Shipment__c && updateAsset)
						{
							System.debug(ps);
							Asset asset = assetsMap.get(ps.Asset__c);
							asset.Return_Shipment_Tracking__c = masterTrackingId;
			    			asset.Return_Shipment_Ship_Date__c = shipDate;
			    			asset.Return_Shipment_Actual_Delivery_Date__c = deliveryDate;
			    			assetsToUpdate.put(asset.Id, asset);
						}
					}
        		}
			}
		}
	}
	try{
		if(prodsToUpdate.size() > 0)			update(prodsToUpdate.values());
		if(assetsToUpdate.size() > 0)			update(assetsToUpdate.values());
	}
	catch(DMLException ex)
	{
		System.debug('DMLException from UpdateAsset trigger: ' + ex.getMessage());
	}
}
	/*
	 * ####END####
	*/
/*

Set<Id> assetIdSet = new Set<Id>();
Set<Id> FedExIdSet = new Set<Id>();
Integer count=0 ;
String flag;

  
//Map<Id,Product_Shipment__c> ShipmentsUnderAsset = new Map<Id,Product_Shipment__c>();

for(Product_Shipment__c ps : trigger.new) {

//Product_Shipment__c p = [select Id,FedEx_Shipment__r.zkfedex__ShipDate__c,FedEx_Shipment__r.zkfedex__DeliveryDate__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c from Product_Shipment__c where id =: ps.Id];

assetIdSet.add(ps.Asset__c);
FedExIdSet.add(ps.FedEx_Shipment__c);

if(trigger.isUpdate )
{

if((ps.Current_Outbound_Shipment__c != Trigger.oldMap.get(ps.Id).Current_Outbound_Shipment__c) || 
        (ps.Current_Return_Shipment__c != Trigger.oldMap.get(ps.Id).Current_Return_Shipment__c) || (ps.IsChanged__c == TRUE) )

    {
          
//see what is being checked

    if(ps.Current_Outbound_Shipment__c==TRUE)
        {
        
        List<Product_Shipment__c> Shipment=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet ];
        

        for(Integer i=0; i< Shipment.size(); i++)

            {

            if(Shipment[i].Current_Outbound_Shipment__c==TRUE )
                {
                count ++;
                }

            if(count>0 && ps.IsChanged__c==FALSE)
                {
                //show error message
                ps.addError('The Current Outbound Shipment Checkbox is already checked in in another shipment: '+'https://cs12.salesforce.com/'+Shipment[i].ID+ '. Please Click Cancel and change the checkbox.');
                }
                
             

            }
            
             if(count==0)
             {
                //assign the values of the asset with the shipment information
                Product_Shipment__c S=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet and FedEx_Shipment__c in: FedExIdSet LIMIT 1 ];
                Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c,Name from Asset where Id in : assetIdSet];
                a.Outbound_Shipment_Tracking__c = S.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Outbound_Asset_Ship_Date__c = S.FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Outbound_Asset_Actual_Delivery_Date__c = S.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;
                
              }
              
              else if(count==1 && ps.IsChanged__c==TRUE)
              {
                Product_Shipment__c S=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet and FedEx_Shipment__c in: FedExIdSet LIMIT 1 ];
                Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c,Name from Asset where Id in : assetIdSet];
                a.Outbound_Shipment_Tracking__c = S.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Outbound_Asset_Ship_Date__c = S.FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Outbound_Asset_Actual_Delivery_Date__c = S.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;
              
              }

        }

    else if(ps.Current_Return_Shipment__c== TRUE)
         {

           // List<Product_Shipment__c> Ship=[select Id,Current_Return_Shipment__c from Product_Shipment__c where Asset__c in: assetIdSet];
            
            List<Product_Shipment__c> Shipment=[select Id,Current_Return_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__SsProcessReturnShipment__c,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet ];                

            for(Integer i=0; i< Shipment.size(); i++)

            {
                if(Shipment[i].Current_Return_Shipment__c==TRUE)
                {
                count ++;
                }
                       
                if(count>0 && ps.IsChanged__c==FALSE)
                {
                //show error message
                ps.addError('The Current Return Shipment Checkbox is already checked in another shipment: '+'https://cs12.salesforce.com'+Shipment[i].ID+ '. Please Click Cancel and change the checkbox.');
                }
                      
               //PL:26NOV2012 - moving outside FOR loop     
                
                //assign the values of the asset with the shipment information
               
           

            }
           zkfedex__Shipment__c fedex = [select id, zkfedex__SsProcessReturnShipment__c from zkfedex__Shipment__c where Id in :FedExIdSet limit 1  ];
           if(fedex.zkfedex__SsProcessReturnShipment__c==FALSE)
                {
                ps.addError('The Return Shipment checkbox at the FedEx Shipment is not checked. This needs to be a return shipment in order to be checked.' );
                }
            
             if(count==0)
               {
                //assign the values of the asset with the shipment information
                Product_Shipment__c S=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet and FedEx_Shipment__c in: FedExIdSet LIMIT 1 ];
                Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c,Name from Asset where Id in : assetIdSet];
                a.Return_Shipment_Tracking__c= S.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Return_Shipment_Ship_Date__c = S.FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Return_Shipment_Actual_Delivery_Date__c = S.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;
               }
               
              else if(count==1 && ps.IsChanged__c==TRUE)
              {
              Product_Shipment__c S=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet and FedEx_Shipment__c in: FedExIdSet LIMIT 1 ];
                Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c,Name from Asset where Id in : assetIdSet];
                a.Return_Shipment_Tracking__c= S.FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Return_Shipment_Ship_Date__c = S.FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Return_Shipment_Actual_Delivery_Date__c = S.FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;
              
              }
               

        }
        
    else if(ps.Current_Outbound_Shipment__c==FALSE  )
    {
    
    //List<Product_Shipment__c> Ship=[select Id,Current_Return_Shipment__c from Product_Shipment__c where Asset__c in: assetIdSet];        

            
            
                Asset a = [select Id,Name from Asset where Id in : assetIdSet];
                a.Outbound_Shipment_Tracking__c = '';
                a.Outbound_Asset_Ship_Date__c = NULL ;
                a.Outbound_Asset_Actual_Delivery_Date__c = NULL ;
                
                update a;
            
            
    
    

    }

    else if(ps.Current_Return_Shipment__c==FALSE)
    {
    
   // List<Product_Shipment__c> Ship=[select Id,Current_Return_Shipment__c from Product_Shipment__c where Asset__c in: assetIdSet];        

           
            
                Asset a = [select Id,Name from Asset where Id in : assetIdSet];
                a.Return_Shipment_Tracking__c= '';
                a.Return_Shipment_Ship_Date__c = NULL ;
                a.Return_Shipment_Actual_Delivery_Date__c = NULL;
                update a;
       
            
    
    

    }



}

}

///put here:

if(Trigger.isInsert && Trigger.isBefore)
{



List<Product_Shipment__c> Shipments=[select Id,Current_Outbound_Shipment__c,Current_Return_Shipment__c from Product_Shipment__c where Asset__c in: assetIdSet  ];        

//see what is being checked
   if(ps.Current_Outbound_Shipment__c==TRUE)
        {
        
        List<Product_Shipment__c> Shipment=[select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet ];

        for(Integer i=0; i< Shipment.size(); i++)

            {

            if(Shipment[i].Current_Outbound_Shipment__c==TRUE )
                {
                count ++;
                }

           if(count>0)
                {
                //show error message
                //ps.addError('The Current Outbound Shipment Checkbox is already checked in in another shipment: '+'https://cs12.salesforce.com/'+Shipment[i].ID+ '. Please Click Cancel and change the checkbox.');
                Shipment[i].Current_Outbound_Shipment__c=FALSE;
                update Shipment[i];
                count--;
                }

           if(count==0)
                {
                
               
            Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,
            Outbound_Asset_Actual_Delivery_Date__c,
            Name from Asset where Id in : assetIdSet];
                //Product_Shipment__c s = [select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where id =:ps.Id ];
                
                a.Outbound_Shipment_Tracking__c =Shipment[i].FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Outbound_Asset_Ship_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Outbound_Asset_Actual_Delivery_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;

                

                }

            }

        }

    else if(ps.Current_Return_Shipment__c== TRUE)
         {

           // List<Product_Shipment__c> Ship=[select Id,Current_Return_Shipment__c from Product_Shipment__c where Asset__c in: assetIdSet];
            
            List<Product_Shipment__c> Shipment=[select Id,Current_Return_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__SsProcessReturnShipment__c,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet ];                

// for (Timecard__c timecard : newTimecards)
            //for(Integer i=0; i< Shipment.size(); i++)
 //PL:26NOV2012 Commented for loop and introduced new for loop
            for(Product_Shipment__c ship : Shipment)

            {
                if(ship.Current_Return_Shipment__c==TRUE)
                {
                count ++;
                }
             //PL:26NOV2012 - modified for loop
                       
                if(count>0)
                {
                //show error message
                //ps.addError('The Current Return Shipment Checkbox is already checked in another shipment: '+'https://cs12.salesforce.com'+Shipment[i].ID+ '. Please Click Cancel and change the checkbox.');
                ship.Current_Return_Shipment__c= FALSE ;
                update ship;
                count--;
                }
                
            }
                if(count==0)
                {
                   
                zkfedex__Shipment__c fedex = [select id, zkfedex__SsProcessReturnShipment__c from zkfedex__Shipment__c where Id in :FedExIdSet limit 1  ];
                
                if(fedex.zkfedex__SsProcessReturnShipment__c==FALSE)
                {
                ps.addError('The Return Shipment checkbox at the FedEx Shipment is not checked. This needs to be a return shipment in order to be checked.' );
                }
                //assign the values of the asset with the shipment information
                
                                 
                
                }

            

        }

}

if(Trigger.isInsert && Trigger.isAfter)
{

if(ps.Current_Outbound_Shipment__c==TRUE)
{

List<Product_Shipment__c> Shipment=[select Id,Current_Return_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,
FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__SsProcessReturnShipment__c,
FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c 
where Asset__c in: assetIdSet ];                


for(Integer i=0; i< Shipment.size(); i++)

{

 

if(count==0)
{
Asset a = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,
            Outbound_Asset_Actual_Delivery_Date__c,
            Name from Asset where Id in : assetIdSet];
                //Product_Shipment__c s = [select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where id =:ps.Id ];
                
                a.Outbound_Shipment_Tracking__c =Shipment[i].FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Outbound_Asset_Ship_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Outbound_Asset_Actual_Delivery_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;

}

}
}

else if(ps.Current_Return_Shipment__c== TRUE)
{

List<Product_Shipment__c> Shipment=[select Id,Current_Return_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,
FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__SsProcessReturnShipment__c,
FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where Asset__c in: assetIdSet ];                

for(Integer i=0; i< Shipment.size(); i++)

{

if(count==0)
{
Asset a = [select Id,Return_Shipment_Tracking__c,Return_Shipment_Ship_Date__c,Return_Shipment_Actual_Delivery_Date__c,Name from Asset where Id in : assetIdSet];
                Product_Shipment__c s = [select Id,Current_Outbound_Shipment__c,FedEx_Shipment__r.zkfedex__MasterTrackingId__c,FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c ,FedEx_Shipment__r.zkfedex__ShipDate__c from Product_Shipment__c where id =:ps.Id ];
                a.Return_Shipment_Tracking__c= Shipment[i].FedEx_Shipment__r.zkfedex__MasterTrackingId__c;
                a.Return_Shipment_Ship_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ShipDate__c ;
                a.Return_Shipment_Actual_Delivery_Date__c = Shipment[i].FedEx_Shipment__r.zkfedex__ActualDeliveryDate__c;
                update a;

}
}
}


}
}
}*/