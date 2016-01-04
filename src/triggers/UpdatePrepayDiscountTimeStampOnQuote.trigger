/**
* @author: Anusha Surapaneni
* @date: 12/5/2013
* @description: Trigger on Opportunity to update Prepay Discount Updated Timestamp and Reqistered Discount Updated Timestamp on QuoteLineItem
* @history:
       1.
*/
trigger UpdatePrepayDiscountTimeStampOnQuote on Opportunity (after insert,after update) {
      list<string> OpptyId = new list<string>();
      List<Id> qId = new List<Id>();
      Map<string,quotelineitem> qliMap =new Map<string,quotelineitem>();
      List<QuoteLineItem> qliList = new List<QuoteLineItem>();
    if(trigger.isafter && trigger.isupdate){
        for(opportunity opp: Trigger.New){
            if((trigger.oldmap.get(opp.id).Contract_Terms__C != Trigger.newmap.get(opp.id).Contract_Terms__C)||(trigger.oldmap.get(opp.id).Deal_Registration__c != Trigger.newmap.get(opp.id).Deal_Registration__c)||(trigger.oldmap.get(opp.id).Partner__C != Trigger.newmap.get(opp.id).Partner__C)){
                 OpptyId.add(opp.id);
              }
      }
    if(OpptyId.size()>0){
        for(quoteLineItem qli:[select id,Quoteid,Quote.Opportunityid,pricebookentry.product2id,pricebookentry.product2.family,Prepay_Discount_Updated_On__c,Registered_Discount_Updated_On__c from QuoteLineItem where Quote.Opportunityid IN:OpptyId ]){
            qliMap.put(qli.id,qli);     
        }
        
         for(Opportunity opp:Trigger.new){
             for(QuoteLineItem qli:qliMap.values()){
                    // Trigger an update on QLI when Contract Term changes
                    if(Trigger.oldmap.get(opp.id).Contract_Terms__C != Trigger.newmap.get(opp.id).Contract_Terms__C && opp.id == qli.Quote.Opportunityid )
                    { 
                       qli.Prepay_Discount_Updated_On__c = system.now();
                       qliList.add(qli);
                    }
                    // Trigger an update on QLI when Deal Registration checkbox/ Partner changes
                    else if(((Trigger.oldmap.get(opp.id).Deal_Registration__c != Trigger.newmap.get(opp.id).Deal_Registration__c )||(Trigger.oldmap.get(opp.id).Partner__C != Trigger.newmap.get(opp.id).Partner__C)) && opp.id == qli.Quote.Opportunityid )
                    { 
                       qli.Registered_Discount_Updated_On__c = system.now();
                       qliList.add(qli);
                    }
               }
         }
     }
               if(qliList.size()>0)
                   update qliList;
        
   }

}