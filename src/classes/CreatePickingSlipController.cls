public with sharing class CreatePickingSlipController {

    public Sales_Order__c salesOrder{get;set;}
    public List<Sales_Order_Item__c> soItems{get;set;}
    public List<String> productNames{get;set;}
    public Account account {get;set;}
    public Opportunity opp {get;set;}
    public Axcient_Addr__c add {get;set;} 
    public static Boolean isApexTest = false;
    
    public CreatePickingSlipController(ApexPages.StandardController controller) {
        Id salesOrderId= ApexPages.CurrentPage().getParameters().get('id');
        productNames = new List<String>();
        
        salesOrder = [select id, name,Reference_Number__c, Document_number__C, Ship_Date__c, Account__c, Opportunity__c, Date__c, Terms__c, 
                      Bill_to_Address_1__c, Bill_to_Address_2__c, Bill_to_City__c, Bill_to_Country__c, Bill_to_Name__c, Ship_to_Name__c, Account__r.Name  
                      from Sales_Order__c where id =: salesOrderId];
                      
        opp = [select id, name, 
            (select ID, PriceBookEntry.Product2.ProductCode, Discount, PriceBookEntry.Product2.Name, Quantity, UnitPrice,TotalPrice,
             PriceBookEntry.Product2.Sales_Unit__c, PriceBookEntry.Product2.Description, PriceBookEntry.Product2.Product_Type__c, PriceBookEntry.Product2.HW_Type__c                                  
               from OpportunityLineItems)
             from Opportunity where id=: salesOrder.Opportunity__c]; 
        
        soItems = [select Name, Item__c, Description__c, Memo__c, Department__c, Location__c, Price__c,Unit__c, Quantity__c,
                   Extended_Price__c, Axcient_Serial_Number__c, Product_Serial_Number__c, Axcient_Asset_Tag__c, Asset_Match__c
                   from Sales_Order_Item__c where Sales_Order__c =: salesOrder.Id];
		
        // custom setting that contains Axcient address       
        add = Axcient_Addr__c.getValues('Axcient Address'); 
       
    }

  //adds an attachment to the opportunity with the pick slip data
    public pageReference addAttachment()
    {  
        if(soItems.size() > 0)
        {
            if(isApexTest)
            {
                opp = [select Id, (select id from OpportunityLineItems) from Opportunity where Id =: salesOrder.Opportunity__c];
                
            }
            if(opp.OpportunityLineItems.size()>0)
            {
              //create the attachment
                Attachment attach = new Attachment(); 
                PageReference pdf = new Pagereference('/apex/createpickingslipTemplate?id=' + salesOrder.id); 
                pdf.setRedirect(true);
                if(!isApexTest)
                    attach.Body=pdf.getContent();  
                attach.Name= salesOrder.Name + ' Pick Slip';  
                attach.ContentType='pdf';  
                attach.ParentID=opp.id;  
                try {  
                    insert(attach);  
                } 
                catch(System.DMLException e) {  
                    ApexPages.addMessages(e);       
                }
                return pdf; 
            }
            else 
            {
              ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no Hardware SKU\'s in the Sales Order ' + salesOrder.Name + '!');
              ApexPages.addMessage(errorMsg);
                return null;
            }
        }
        else
        {
           ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'The Sales Order ' + salesOrder.Name + ' has no items!');
           ApexPages.addMessage(errorMsg);
           return null; 
        }
    }
    
    public pageReference addAttachmentForTest(){
        isApexTest = true;
        return addAttachment();
    }
    
}