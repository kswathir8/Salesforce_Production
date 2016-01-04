Public Class SendEmailstoLeadOwner
{
/********************************************************
Method: sendMailtoLeadOwner
Description: Send mail to Lead Onwer
Author: Swathi Karkala.
Date : 10/24/2013
*********************************************************/
  public static void sendMailtoLeadOwner(List<Change_Owner_Reason__c> newOrderList, Map<ID,Change_Owner_Reason__c> NewOrderMap, Map<ID,Change_Owner_Reason__c> oldOrderMap) 
  {
        List<Lead> UpdateLeadList = new List<Lead>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Lead> LeadOwner = new List<Lead>();
        List<Id> LeadIdList = new List<Id>();
        Map<Id,Id> ChangeOwnerLeadEmail= new Map<Id,Id>();
        Map<Id,Lead> LeadIdtoLead = new Map<Id,Lead>();
        Map<Id,String> LeadEmailMap= new Map<Id,String>();
        List<string> toAddressList = new List<string>();
        string orgWideEmailID = null;
        // Gives the salesforce Base URL
        String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        for(Change_Owner_reason__c CR: newOrderlist)
        {
                LeadIdList.add(CR.Lead__c);
                ChangeOwnerLeadEmail.put(CR.id,CR.Lead__c);
                system.debug('ChangeOwnerLeadEmail------'+ ChangeOwnerLeadEmail);
        }
        
        LeadOwner = [Select ID,OwnerId from Lead where Id IN:LeadIdList];
        system.debug('LeadOwner-------'+LeadOwner);

        for(Lead Ld:LeadOwner)
        {
            LeadIdtoLead.put(Ld.id,Ld);
            system.debug('LeadIdtoLead----'+LeadIdtoLead);
        }
        
        /*for(Change_Owner_Reason__c CR1:newOrderList)
        {
            Id Leadid = ChangeOwnerLeadEmail.get(CR1.id);
            system.debug('ChangeOwnerLeadEmail.get(CR1.id)====='+ChangeOwnerLeadEmail.get(CR1.id));
            Id LeadEmail= LeadIdtoLead .get(Leadid).OwnerId;
            system.debug('LeadIdtoLead .get(Leadid).OwnerId====='+LeadIdtoLead .get(Leadid).OwnerId);
            system.debug('Lead Email-----'+LeadEmail);
            mail.setTargetObjectId(LeadEmail);
            LeadEmailMap.put(CR1.Id,LeadEmail); 
            system.debug('LeadEmailMap.put(CR1.Id,LeadEmail)---'+LeadEmailMap.put(CR1.Id,LeadEmail));
           // String toAddresses =  LeadEmail;
           // mail.setToAddresses(toAddresses);
            mail.setReplyTo('salesops@axcient.com');
            //mail.setSenderDisplayName('');
            //mail.setSubject('Request to Change Owner');
            mail.setSaveAsActivity(false);
             
        }

       EmailTemplate et=[Select id from EmailTemplate where DeveloperName=:'Change_Lead_Owner_Email'];
       mail.setTemplateId(et.id);
       //system.debug('setTemplateId(et.id)----'+mail.setTemplateId(et.id));
       Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); */
       
       for(Change_Owner_Reason__c cc: newOrderList)
       {    
                //Id Leadid = ChangeOwnerLeadEmail.get(cc.id);
                //Id LeadEmail= LeadIdtoLead .get(Leadid).OwnerId;
                //system.debug('LeadIdtoLead.get(cc.Id)----------'+LeadIdtoLead.get(cc.Id));

                //sendEmail method(SystemUtils) parameters
                string subject;
                string replyTo = 'salesops@axcient.com';
                string plainTextBody;
                string htmlBody;
                string[] ccAddresses;
                string[] bccAddresses ;  
                
                // Define Email Subject
                subject = 'Request to Change Lead Owner to'+' '+cc.Owner_Duplicate__c; 
                // Define Email Body
                htmlBody = 'Hi'+' '+cc.Current_Lead_Owner__c+','+'<br/><br/>'+
                '<b>Change Lead Owner Request Information:</b>'+'<br/><br/>'+
                'Lead Name:'+' '+cc.Lead_Name__c+'<br/>'+
                'Company Name:'+' '+cc.Lead_Company_Name__c+'<br/>'+
                'Lead Link:'+' '+sfdcBaseURL+'/'+cc.Lead__c +'<br/><br/>'+
                'Requestor Name:'+' '+ cc.Owner_Duplicate__c +'<br/>'+
                'Requestor Reason:'+' '+ cc.Requestor_Reason__c +'<br/>'+ 
                'Change Owner Reason Number:'+' '+ cc.Name +'<br/><br/>'+            
                'Please "Approve" or "Reject" using the following the link:'+''+
                ' '+sfdcBaseURL+'/'+cc.Id+'<br/>'+
                '*Approve/Reject Reason is required.'+'<br/><br/>'+
                'Thank you,'+'<br/>'+cc.Owner_Duplicate__c+'<br/>';
                 plainTextBody = 'Request to Change Lead Owner :'+' '+'Lead Name:'+' '+cc.Lead_Name__c +' '+'Requestor Name:'+ cc.Owner_Duplicate__c+' '+'Requestor Reason:'+cc.Requestor_Reason__c+'End Comment';
                
                
                // Building toaddress List
                toAddressList.add(cc.CurrentLeadOwnerEmail__c);
                system.debug('to Address&&&&'+toAddressList);
                
                // Send Email Notifications
                systemUtils.sendEmail(subject,replyTo,toAddresslist,ccAddresses,bccAddresses,htmlBody,plainTextBody,orgWideEmailID);  
        }   
  }
}