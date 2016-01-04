/**
* @author: Anusha Surapaneni
* @date: 11/21/2013
* @description: Handler class for QuoteLineItemTriggerHandler. Used to control all QuoteLineItemtrigger events.
* @history:
       1.
*/
public without sharing class QuoteLineItemTriggerHandler{
  
    public void updateDiscountOnQuoteLineItem(List<QuoteLineItem> qliRecs){
        list<String> quoteIdList = new List<String>();
        Set<String> quoteIdSet = new Set<String>();
        Map<String,Quote> quoteMap = new Map<string,Quote>();
        Map<String,QuoteLineItem> QLIMap = new Map<string,QuoteLineItem>();
        Set<String> approvalProcessSet = new Set<String>();
       
        // Add parent quote Ids to list
        for(QuoteLineItem qIds:qliRecs){
            QuoteIdList.add(qIds.Quoteid);  
        }
        // Query Corresponding Quote fields
        for(Quote q:[select id,Discount,Opportunity.Account.RecordType.name,OpportunityId,Opportunity.Contract_Terms__c,Opportunity.Deal_Registration__c,Approval_Status__C,Discretionary_Discount__C,Reason_for_Approval__c from Quote where Id IN:QuoteidList]){
            QuoteMap.put(q.id,q); 
        }
        for(QuoteLineItem currQLI:qliRecs){
            decimal discDiscountDecimal = 0.00;
            decimal regDiscountDecimal = 0.00;
            decimal prepayDicountDecimal = 0.00;
            decimal regDiscountNet = 0.00;
            decimal discDiscountNet = 0.00;
            system.debug('Registered Discount ****'+currQLI.Registered_Discount__C);
            // Remove '%' symbol from text version of Registered Discount
            string regDiscountText = currQLI.Registered_Discount__C;
            List<string> registeredDiscount = regDiscountText.split('%');
            
            // Remove '%' symbol from text version of Discretionary Discount
            string discDiscountTxt = currQLI.Discretionary_Discount__C;
            List<string> discDiscount = discDiscountTxt.split('%');
            
            // Remove '%' symbol from text version of Prepay Discount
            string prepDiscountText = currQLI.Prepay_Discount__C;
            List<string> prepayDiscount = prepDiscountText.split('%');
            
            // Assign decimal Value on Registered Discount 
            if(currQLI.Registered_Discount__c != 'N/A'){
                regDiscountDecimal = Decimal.Valueof(registeredDiscount[0]);
            }    
            // Assign decimal Value on Discretionary Discount
            system.debug('discretionary Discount Decimal***'+discDiscount[0]);
            if(discDiscount[0] == 'N/A' || discDiscount.isEmpty())
                discDiscountDecimal = 0.00;
            else
                discDiscountDecimal = Decimal.Valueof(discDiscount[0]);
           
            // Assign decimal Value on Prepay Discount
            if(currQLI.Prepay_Discount__c != 'N/A'){
                prepayDicountDecimal =  Decimal.Valueof(prepayDiscount[0]); 
            }
            //Net Price Calculation
            if(QuoteMap.Containskey(currQLI.Quoteid) ){
               //Net Price Calculation applying Registered Discount
                if(regDiscountDecimal >0.00){
                    regDiscountNet = currQLI.Gross_Price__c - (currQLI.Gross_Price__c  * regDiscountDecimal/100);
                }
                else 
                    regDiscountNet = currQLI.Gross_Price__c;
                //Net Price Calculation applying Discretionary Discount
                if( discDiscountDecimal >0.00 ){
                    discDiscountNet = regDiscountNet - (regDiscountNet * discDiscountDecimal/100);
                    system.debug('discretionary Net&&&&'+ discDiscountNet);
                }
                else
                    discDiscountNet = regDiscountNet;
                //Net Price Calculation applying Prepay Discount
                if(prepayDicountDecimal >0.00)
                     currQLI.Net_Price__c = discDiscountNet - (discDiscountNet * prepayDicountDecimal/100);
                 else
                    currQLI.Net_Price__c = discDiscountNet;
                 
                   // Invoke Approval Process when Discretionary Discount is over 5%
                if(quoteMap.get(currQLI.quoteid).Discretionary_Discount__C > 5 && quoteMap.get(currQLI.quoteid).Reason_for_Approval__c != '' && quoteMap.get(currQLI.quoteid).Approval_Status__C !='Approved' && quoteMap.get(currQLI.quoteid).Approval_Status__C !='Pending' && quoteMap.get(currQLI.quoteid).Approval_Status__C !='Rejected'){
                  //  discDiscountNet = regDiscountNet - (regDiscountNet * discDiscountDecimal/100);
                    System.debug('I am In Approval Process$$$');
                    quoteIdSet.add(quoteMap.get(currQLI.quoteid).id); 
                    // Query Approval Process
                    for(ProcessInstance p: [SELECT Id,targetobjectid, Status from ProcessInstance where targetobjectid IN:Quoteidset and (Status ='Pending'  Or Status ='Approved')]){
                        approvalProcessSet.add(p.targetobjectid);
                    }
                    for(string qID :quoteIdSet){
                        if(!approvalProcessSet.contains(qID)){
                        system.debug('I am not In');
                            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                                req1.setObjectId(qID);  
                            try{                     
                                Approval.ProcessResult result = Approval.process(req1);
                            }catch(exception e){
                                system.debug('Exception***'+e);
                            }
                        }
                    }
                }   
            }
        }
   }
}