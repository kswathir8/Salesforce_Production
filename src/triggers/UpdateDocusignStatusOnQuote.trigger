/**
* @author: Anusha Surapaneni
* @date: 12/5/2013
* @description: Trigger on dsfs__DocuSign_Status__c Object to update Docusign Status on Quote when Docusign Status changes.
* @history:
       1.
*/
trigger UpdateDocusignStatusOnQuote on dsfs__DocuSign_Status__c (after insert,after update) {
    Map<string,quote> quoteMap =new Map<string,quote>();
    public List<Id> quoteIdsList = new List<Id>();
    // Add corresponding Quote Id to List
    for(dsfs__DocuSign_Status__c docuSign : Trigger.new){
        quoteIdsList.add(docuSign.Quote__c);
    }
    // Query corresponding Quote
    for(quote q:[select id,docusign_status__c from quote where id IN:quoteIdsList]){
        quoteMap.put(q.id,q);     
    }
    // Update Docusign Envolope Status on Quote
    for(dsfs__DocuSign_Status__c docuSign : Trigger.new){
        if(quotemap.containskey(docuSign.Quote__c)){
            system.debug('docusign ****'+docusign.dsfs__Envelope_Status__c);
            quotemap.get(docusign.quote__c).docusign_status__c = docusign.dsfs__Envelope_Status__c;  
        }
    }
    //Update Quote
    if(quotemap.size()>0)
        update quotemap.values();
}