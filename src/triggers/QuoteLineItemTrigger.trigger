/**
* @author: Anusha Surapaneni
* @created: 11/21/2013
* @description: Trigger on QuoteLineItem object with all trigger events
* @history:
*/
trigger QuoteLineItemTrigger on QuoteLineItem (before insert, after insert, before update, after update, before delete, after delete) {
   public QuoteLineItemTriggerHandler qliTriggerHandler = new QuoteLineItemTriggerHandler();

    //Before Insert
    if(Trigger.isBefore && Trigger.isInsert){
        system.debug('Before Insert Trigger****');
       qliTriggerHandler.updateDiscountOnQuoteLineItem(trigger.new);
    }

    //Before Update
   if(Trigger.isBefore && Trigger.isUpdate){
        system.debug('Before Update Trigger****');
        qliTriggerHandler.updateDiscountOnQuoteLineItem(trigger.new);
    }

    //Before Delete
    if(Trigger.isBefore && Trigger.isDelete){
    }
    
    //After Update
    if(Trigger.isAfter && Trigger.isUpdate){
       //  system.debug('After Update Trigger****');
       // qliTriggerHandler.updateDiscountOnQuoteLineItem(trigger.new);
    }

    //After Insert
    if(Trigger.isAfter && Trigger.isInsert){
    }
    
    //After Delete
    if(Trigger.isAfter && Trigger.isDelete){
    }
    
}