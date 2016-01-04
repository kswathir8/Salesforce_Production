/**
* @author: Anusha Surapaneni
* @date: 09/04/2013
* @description: Handler class for CaseCommentTrigger. Used to control all CaseComment trigger actions.
* @history:
    1.
*/
public without sharing class CaseCommentTriggerHandler {    
  
    // default constructor
    public CaseCommentTriggerHandler(){
    
    }   
    // Method to send email to Additional Email Address fields on Case when a case comment is inserted. 
    public void sendEmailOnCaseCommentInsert(List<CaseComment> newCaseComment){
    
        Set<Id> currCaseId = new Set<Id>();
        Map<Id,Case> caseMap = new Map<Id,Case>();
        List<string> toAddressList = new List<string>();
        // Query Axcient Support's OrgEideEmailAddress Id
        string orgWideEmailID = [Select id from OrgWideEmailAddress where DisplayName = 'Axcient Support'].Id;
        // Gives the salesforce Base URL
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        // Get corresponding Case Ids
        for (CaseComment csComment: newCaseComment){
            currCaseId.add(csComment.ParentId);
        }
        
        // Query Corresponding Case fields
        List<Case> caseList=[Select Id,Subject,CaseNumber,contactID,Service_ID__C,ThreadID__c, Additional_Email_Recipient_1__c,Additional_Email_Recipient_2__c,Additional_Email_Recipient_3__c from case where Id in :currCaseId ];
        
        for(case c  : caseList){
           caseMap.put(c.Id,c);
        }
       
        for(CaseComment cc: newCaseComment) {
            Case supportCase =  caseMap.get(cc.ParentId);
            if(caseMap.containskey(cc.ParentId)){
                //sendEmail method(SystemUtils) parameters
                string subject;
                string replyTo = 'support@axcient.com';
                string plainTextBody;
                string htmlBody;
                string[] ccAddresses;
                string[] bccAddresses ;  
                
                // Define Email Subject
                subject = 'Comment Added to Case'+' '+supportCase.CaseNumber+';Service ID:'+supportCase.Service_ID__C+''+supportCase.ThreadID__c; 
                // Define Email Body
                htmlBody = ' Hi, <br/><br/>'+
                'A comment has been added to case #:'+' '+ supportCase.CaseNumber +'<br/><br/>'+
                'Subject:'+' '+ supportCase.Subject +'<br/><br/>'+
                '<i>Start Comment:</i>'+'<br/>'+ cc.CommentBody +'<br/>'+'<i>End Comment</i>'+'<br/><br/>'+
                'Click  on the link to access the Case:'+' '+sfdcBaseURL+'/'+supportCase.Id+'</p></br>'+'<br/><br/>'+'Thank you,'+'<br/>'+'Axcient Technical Support'+'<br/>'+'https://www.axcient.com'+'<br/>'+'Phone: 800-715-2339'+'<br/><br/>'+'<Case Thread ID:'+supportCase.ThreadID__c+'>';
                plainTextBody = 'A comment has been added to case #:'+' '+supportCase.CaseNumber +' '+'Subject:'+ supportCase.Subject+' '+'Start Comment:'+cc.CommentBody+'End Comment';
                
                
                // Building toaddress List
                if(supportCase.Additional_Email_Recipient_1__c != null )
                    toAddressList.add(supportCase.Additional_Email_Recipient_1__c);
                if(supportCase.Additional_Email_Recipient_2__c != null )
                    toAddressList.add(supportCase.Additional_Email_Recipient_2__c);
                if(supportCase.Additional_Email_Recipient_3__c != null )
                    toAddressList.add(supportCase.Additional_Email_Recipient_3__c);
                system.debug('to Address&&&&'+toAddressList);
                
                // Send Email Notifications
                if( toAddressList.size()>0  && cc.IsPublished ){
                    systemUtils.sendEmail(subject,replyTo,toAddresslist,ccAddresses,bccAddresses,htmlBody,plainTextBody,orgWideEmailID); 
                }
            }
        }
    }
}