trigger UpdateProductShipment on zkfedex__Shipment__c (after update) {

try
{

for(zkfedex__Shipment__c f : trigger.new) {

if(trigger.IsUpdate)

{

if((f.zkfedex__Delivered__c != Trigger.oldMap.get(f.Id).zkfedex__Delivered__c) || 
        (f.zkfedex__DeliveryDate__c != Trigger.oldMap.get(f.Id).zkfedex__DeliveryDate__c)||(f.TestCheck__c != Trigger.oldMap.get(f.Id).TestCheck__c) )
        {
        Product_Shipment__c Shipment=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id limit 1 ];
        
        if(Shipment.IsChanged__c == FALSE)
        {
        Shipment.IsChanged__c = TRUE;
        update Shipment;
        }
        
        else if(Shipment.IsChanged__c == TRUE)
        {
        //Shipment.IsChanged__c=FALSE;
        update Shipment;
        }
        }
  
      
        
       
      /* if(f.zkfedex__Delivered__c != NULL)
       {
       Product_Shipment__c Shipment2=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id ];
       Shipment2.IsChanged__c = FALSE;
       update Shipment2;
       }*/
       
       if(f.zkfedex__Delivered__c == FALSE)
       {
       Product_Shipment__c Shipment2=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id ];
       Shipment2.IsChanged__c = FALSE;
       update Shipment2;
       }
       
       if(f.zkfedex__DeliveryDate__c  != NULL)
       {
       Product_Shipment__c Shipment2=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id ];
       Shipment2.IsChanged__c = FALSE;
       update Shipment2;
       }
                      
       if(f.TestCheck__c == FALSE)
       {
       Product_Shipment__c Shipment2=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id ];
       Shipment2.IsChanged__c = FALSE;
       update Shipment2;
       }
       
       /*if(f.TestCheck__c != NULL)
       {
       Product_Shipment__c Shipment2=[select Id,Current_Return_Shipment__c,IsChanged__c from Product_Shipment__c where FedEx_Shipment__c = :f.Id ];
       Shipment2.IsChanged__c = FALSE;
       update Shipment2;
       }*/
       
       
       }
       
 }      
 
}
   
   catch(exception e)
        {
        
        System.debug(e.getMessage());
        //f.AddError(e.getMessage());
       
        }     
    
        
        
  
}