/**
* @author: Anusha Surapaneni
* @date: 11/7/2013
* @description: Handler class for QuoteTriggerHandler. Used to control all Quotetrigger events.
* @history:
       1.
*/
public without sharing class QuoteTriggerHandler{
    public void updateMRRValuesOnQuote(List<Quote> quoteList){
      /*  list<String> QuoteIdList = new List<String>();
        Set<String> QuoteIdset = new set<String>();
        map<String,QuoteLineItem> QLIMap = new Map<string,QuoteLineItem>();
        Map<String,Decimal> SumMap = new Map<String,Decimal>();
         for(Quote q:quoteList){
                QuoteIdList.add(q.id);  
            }
            for(QuoteLineItem qli:[select id,QuoteId, Quote.name, pricebookentryid, pricebookentry.product2.family,unitprice,totalprice,Subtotal,Discount,Contract_Term_Month__c from QuoteLineItem where QuoteId IN:QuoteidList]){
                QLIMap.put(qli.Quoteid,qli); 
               if(SumMap.containskey(Qli.Quoteid) && QliMap.get(quoteRecs.id).product_type__C ='Services'){
                    
                     Decimal d = SumMap.get(Qli.Quoteid);
                     Decimal d1 = d + Qli.Field;
                     Summap.put(Qli.Quoteid,d1);
                 }
                else {
                    Summap.put(Qli.Quoteid,Qli.Field);
                }
               
            }
            Decimal d =0;
            for(Quote quoteRecs: quoteList){
                 if(QLIMap.containskey(quoteRecs.id) && SumMap.containskey(quoteRecs.id) ) {
                       if(QLIMap.get(quoteRecs.id).Contract_Term_Month__c != 0.00 )
                        quoteRecs.MRR_Services__C = (QLIMap.get(quoteRecs.Id).TotalPrice)/(QLIMap.get(quoteRecs.id).Contract_Term_Month__c);
                        else
                        quoteRecs.MRR_Services__C = QLIMap.get(quoteRecs.Id).TotalPrice;
                 
                 }
            
            
            }*/
    }
}