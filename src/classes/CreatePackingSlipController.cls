public with sharing class CreatePackingSlipController {

    public Sales_Order__c salesOrder{get;set;}
    public List<Sales_Order_Item__c> allSoItems{get;set;}
    public List<Sales_Order_Item__c> soItems{get;set;}
    public List<Sales_Order_Item__c> popupSoItems {get;set;}
    public Integer numberOfItems {get;set;}
    public Opportunity opp {get;set;}
    public Boolean isValidDAS {get;set;}
    public Boolean isValidAppliance {get;set;}   
    public static Boolean isApexTest = false;
    public Boolean displayPopup {get; set;}
    public List<Asset> shippedMaxAssets {get; set;}
    public List<Asset> assets {get;set;}
    public List<String> productNames{get;set;}
    public Axcient_Addr__c add {get;set;}
    
    //constructor
    public CreatePackingSlipController(ApexPages.StandardController controller) 
    {    
        numberOfItems = 0;
        soItems = new List<Sales_Order_Item__c>();
        Id salesOrderId= ApexPages.CurrentPage().getParameters().get('id');
        productNames = new List<String>();
        // custom setting that contains Axcient address 
        add = Axcient_Addr__c.getValues('Axcient Address');
        
        getSalesOrder(salesOrderId);
        opp = [select id, name, 
              (select ID, PriceBookEntry.Product2.ProductCode, Discount, PriceBookEntry.Product2.Name, Quantity, UnitPrice,TotalPrice,
                      PriceBookEntry.Product2.Sales_Unit__c, PriceBookEntry.Product2.Description, PriceBookEntry.Product2.Product_Type__c, PriceBookEntry.Product2.HW_Type__c                                  
                                   FROM OpportunityLineItems)
               from Opportunity where id=: salesOrder.Opportunity__c];  
               
        //get all the product names from the opportunity line item used to identify hardware sales order items          
        for(OpportunityLineItem oppLineItem : opp.OpportunityLineItems)
        {
        	if(oppLineItem.PriceBookEntry.Product2.Product_Type__c == 'HW' )
            	productNames.add(oppLineItem.PriceBookEntry.Product2.ProductCode);
        }      
                   
        allSoItems = [select Name, Item__c, Description__c, Memo__c, Department__c, Location__c, Price__c, Unit__c, Quantity__c, 
                   Extended_Price__c, Axcient_Serial_Number__c, Product_Serial_Number__c, Axcient_Asset_Tag__c,  Asset_Match__c,
                   Manufacturer_Serial_Number_Error__c, Axcient_Serial_Number_Error__c, Asset_Tag_Error__c
                   from Sales_Order_Item__c where Sales_Order__c =: salesOrder.Id];// and Item__c in: productNames];
        
        system.debug(productNames);
        system.debug(allSoItems);
        if(productNames.size() > 0)
        {
	        for(Sales_Order_Item__c soItem : allSoItems)
			{
				for(String prCode : productNames)
				{
					if(soItem.Item__c == prCode)
						soItems.add(soItem);
				}
			}
        }
        system.debug(soItems);
        if(soItems != null)
            numberOfItems = soItems.size();
        
        //make all fields blank and ready to be filled with new values
        for(Sales_Order_Item__c s : soItems)
        {
            s.Axcient_Serial_Number__c = '';
            s.Product_Serial_Number__c = '';
            s.Axcient_Asset_Tag__c = '';
            s.Manufacturer_Serial_Number_Error__c = false;
            s.Axcient_Serial_Number_Error__c = false;
            s.Asset_Tag_Error__c = false;
        }
        displayPopup = false;
    }
    
    //get the sales order 
    public Sales_Order__c getSalesOrder(Id salesOrderId)
    {
        salesOrder = [select id, name,Reference_Number__c,Ship_Date__c, Account__c, Date__c, Terms__c, Bill_to_Address_1__c, Bill_to_Address_2__c,
                      Bill_to_City__c, Bill_to_Country__c, Bill_to_Name__c, Ship_to_Name__c, Opportunity__r.Name, Ship_to_city__c,
                      Ship_to_Country__c, Ship_to_State__c, Ship_to_zip_Code__c, Bill_to_zip_Code__c, Bill_to_State__c, Ship_to_Address_1__c,
                      Opportunity__c, Account__r.Name
                      from Sales_Order__c where id =: salesOrderId];
        return salesOrder;
    }

    //updates or create assets 
    public void checkAssets()
    {
        // flag used for checking match between asset tags of sales order items and assets
        Boolean noMatch;
        isValidDAS = true;
        isValidAppliance = true;
        for(Sales_Order_Item__c s : soItems) 
        {
            noMatch = true;
            for(OpportunityLineItem oppLineItem : opp.OpportunityLineItems)
            {
                if(oppLineItem.PriceBookEntry.Product2.Product_Type__c == 'HW' &&
                	 oppLineItem.PricebookEntry.Product2.ProductCode == s.Item__c)
                {
                    if(oppLineItem.PricebookEntry.Product2.HW_Type__c == 'D.A.S')
                    {                        
                            Asset assetDAS = new Asset();
                            if(s.Axcient_Asset_Tag__c != null)
                                s.Asset_Tag_Error__c = false;
                            else
                            {
                                s.Asset_Tag_Error__c = true;
                                isValidDAS = false;
                            }
                            if(s.Axcient_Serial_Number__c != null)
                                assetDAS.Name = s.Axcient_Serial_Number__c;
                            else
                                assetDAS.Name = 'Axcient DAS Unit';
                            assetDAS.AccountId = salesOrder.Account__c;
                            assetDAS.description = s.Item__c;
                            assetDAS.SerialNumber = s.Product_Serial_Number__c;
                            assetDAS.Opportunity__c = salesOrder.Opportunity__c;
                            assetDAS.Asset_Tag__c = s.Axcient_Asset_Tag__c;
                            assetDAS.Product2ID = oppLineItem.PricebookEntry.Product2.id;                        
                            try
                            {
                                if(isValidDAS)
                                {
                                    insert(assetDAS);
                                    oppLineItem.Asset__c = assetDAS.Id;   
                                }                      
                            }
                            catch(DMLException ex)
                            {
                                System.Debug('DML Exception: ' + ex.getMessage());
                            }
                       
                    }
                    else if(oppLineItem.PricebookEntry.Product2.HW_Type__c == 'Appliance')
                    {                
                        if(s.Product_Serial_Number__c != null)
                           s.Manufacturer_Serial_Number_Error__c = false;
                        else
                           s.Manufacturer_Serial_Number_Error__c = true;
                        if(s.Axcient_Serial_Number__c != null)
                           s.Axcient_Serial_Number_Error__c = false;
                        else
                           s.Axcient_Serial_Number_Error__c = true;
                        if(s.Axcient_Asset_Tag__c != null)
                           s.Asset_Tag_Error__c = false;
                        else 
                           s.Asset_Tag_Error__c = true;
                        if(s.Manufacturer_Serial_Number_Error__c ||  s.Axcient_Serial_Number_Error__c || s.Asset_Tag_Error__c || s.Axcient_Asset_Tag__c.length() > 8)
                               isValidAppliance = false;
                        if(isValidAppliance && isValidDAS)
                        {                          
                            for(List<Asset> assets : [select id, Times_Asset_Shipped__c, Name, Asset_Tag__c, SerialNumber, Opportunity__c, AccountId from Asset where Asset_Type_1__c = 'HW' and Product2.Id =: oppLineItem.PricebookEntry.Product2.Id ] )
                            {
                              for(Asset a : assets)
                              {
                                 if(a.Asset_Tag__c == s.Axcient_Asset_Tag__c) 
                                 {
                                       //check number of times shipped on asset
                                      if(a.Times_Asset_Shipped__c == null)		a.Times_Asset_Shipped__c = 0;
                                      if(a.Times_Asset_Shipped__c <=24)
                                      {
                                          a.Name = s.Axcient_Serial_Number__c;
                                          a.SerialNumber = s.Product_Serial_Number__c;
                                          a.Times_Asset_Shipped__c = a.Times_Asset_Shipped__c + 1;
                                          oppLineItem.Asset__c = a.id;                                        
                                          try{                                              
                                              update(a);
                                          }
                                          catch(DMLException ex){System.Debug('Update Asset Exception: ' + ex.getMessage());}
                                      }
                                      else 
                                      {
                                          shippedMaxAssets.add(a);
                                          s.Asset_Match__c = 'shipped 25 times';
                                          popupSoItems.add(s); 
                                      } 
	                                      noMatch = false;
	                                      break;  
                                } 
                              
                              }
                          }
                          if(!noMatch)
                            break;
                      }
                      if(noMatch)
                      {
                          
                          if(s.Manufacturer_Serial_Number_Error__c ||  s.Axcient_Serial_Number_Error__c || s.Asset_Tag_Error__c || s.Axcient_Asset_Tag__c.length() > 8)
                               isValidAppliance = false;
                          if(isValidAppliance && isValidDAS)
                          {
                               Asset asset = new Asset();
                              //insert a new asset for DAS products
                              if(oppLineItem.PricebookEntry.Product2.ProductCode == s.Item__c)
                              {
                                  if(oppLineItem.PricebookEntry.Product2.HW_Type__c != 'D.A.S')
                                  {
                                       
                                      s.Asset_Match__c = '';
                                    
                                      asset.Name = s.Axcient_Serial_Number__c;
                                      asset.AccountId = salesOrder.Account__c;
                                      asset.description = s.Item__c;
                                      asset.SerialNumber = s.Product_Serial_Number__c;
                                      asset.Opportunity__c = salesOrder.Opportunity__c;
                                      asset.Asset_Tag__c = s.Axcient_Asset_Tag__c;
                                      asset.Times_Asset_Shipped__c = 1;
                                      
                                      //add the opportunity line item product to the asset record
                                      asset.Product2ID = oppLineItem.PricebookEntry.Product2.id;
        
                                      try
                                      {
                                          insert(asset);
                                          oppLineItem.Asset__c = asset.Id;                            
                                      }
                                      catch(DMLException ex){System.Debug('DML Exception: ' + ex.getMessage());}
                                  }
                              } 
                          }              
                      }                  
                    } 
                }
            }
       } 
    }
     
    public Boolean showPopup()
    {
        shippedMaxAssets = new List<Asset>();
        popupSoItems = new List<Sales_Order_Item__c>();
        //database savepoint 
        Savepoint sp = Database.setSavepoint();
        checkAssets();
        if(!isValidAppliance || !isValidDAS)
        	Database.rollback(sp);
        if(isValidAppliance && isValidDAS)
        {
	        if(shippedMaxAssets.size() > 0)
	        {
	            displayPopup = true;
	            Database.rollback(sp);
	        }
        }
        return displayPopup;
    }
    
    //closes the popup window
    public pageReference closePopup()
    {
        displayPopup = false;
        return null;
    }
    //adds an attachment to the sales order with the packing slip data and displays the packing slip 
    public pageReference printPackingSlip()
    {  
        if(isApexTest)
        {
            opp = [select Id, (select id from OpportunityLineItems) from Opportunity where Id =: salesOrder.Opportunity__c];
        }
        if(!showPopup() && isValidDAS && isValidAppliance)
        { 
            Attachment attach=new Attachment(); 
            PageReference pdf = new Pagereference('/apex/preparePackingSlipTemplate?id=' + salesOrder.id); 
            pdf.setRedirect(false);
            if(!isApexTest)
              attach.Body=pdf.getContent();  
            attach.Name=salesOrder.Name + ' Packing Slip';  
            attach.ContentType='pdf';  
            attach.ParentID=salesOrder.id;  
            try {  
                update soItems;
                update opp.OpportunityLineItems;
                insert(attach);  
            } 
            catch(System.DMLException e) {  
                System.debug('Exception: ' +e.getMessage());       
            } 
            return pdf;
        }
        else
            return null; 
    }
    
    public pageReference printPackingSlipForTest()
    {
      isApexTest = true;
      return printPackingSlip();
    }
}