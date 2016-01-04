/************************************************************************
 *  Created by Gerald Xie
 *  Date: 5/15/2014
 *  Description: This class sends emails to Customers who has 
 *  assets that require to be sent back. Please check the schdedule 
 *  for the frequency of this class.
 *  
 *  Test class: ***.cls
 * 
 *  Current Version: v1.4
 *  Last Modified: 7/21/2014 
 *
 *  Updates:
 *  v1.4: 7/21/14 - Added check for the 60 requset by support.
 *  v1.3: 7/08/14 - Modified the paramters for executing this code.
 *  v1.2: 6/17/14 - Added features for email notification.
 *  v1.1: 6/10/14 - Made it batchabel for multiple emails.
 *  v1.0: 5/15/14 - Initial work.
 ************************************************************************
 */

global class RMAEmailReminder implements Database.Batchable<sObject>, Schedulable{  
    
    /**
     *  returns the query that gets the RMA cases that are open with hardware, The suject must contain "RMA Request" which is created by RMA Wizard.
     *  @param bc
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, caseNumber, Contact.name, Contact.Email, type, RMAed_Asset__c, Escalated_for_RMA__c, RecordTypeId, Status, CreatedBy.Name, CreatedBy.Email, CreatedDate, Return_Shipment_Ship_Date__c, Type_of_Return__c, Delay_60_Days__c ,RMA_Ship_Date__c '; 
        query+='FROM case Where Owner.name=\'RMA Requests\' AND type =\'Hardware\' AND RMAed_Asset__c!=\'\' AND RMA_Ship_Date__c=LAST_N_DAYS:76 AND (Type_of_Return__c!=\'Spare Parts\' AND  Type_of_Return__c!=\'Virtual Appliance\') AND RMA_Return_Date__c=null AND (Status !=\'Closed\' or Status !=\'Monitoring\')'; 
        system.debug('query-----'+query);
        return Database.getQueryLocator(query); 
    }
    
    /**
     * @param sc - the tme when it will execute this with a batch. 
     */
    global void execute(SchedulableContext sc) {
        RMAEmailReminder scheduled = new RMAEmailReminder();
        Database.executeBatch(scheduled, 20);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> casesToEmail){
        for(Case caseToEmail: casesToEmail){
            String contactPerson = caseToEmail.Contact.name;  
            String contactPersonEmail = caseToEmail.Contact.Email;
            String caseNumber = caseToEmail.caseNumber;
            DateTime activeTime = caseToEmail.CreatedDate;
            String createdByName = caseToEmail.CreatedBy.Name;
            String createdByEmail = caseToEmail.CreatedBy.Email;
                    
            //Calculate the length of time between the cases. 
            Date begDate = Date.valueOf(caseToEmail.RMA_Ship_Date__c);
            Date timeNow = System.now().date();
            Integer lengthOfTime;
            if(caseToEmail.Delay_60_Days__c){
                lengthOfTime = begDate.daysBetween(timeNow)+30;
            } else {
                lengthOfTime = begDate.daysBetween(timeNow);
            }

            if((lengthOfTime==15 && !caseToEmail.Delay_60_Days__c) || (lengthOfTime==45 && caseToEmail.Delay_60_Days__c) || 
                //(lengthOfTime==45 && caseToEmail.Delay_60_Days__c) || (lengthOfTime==60 && caseToEmail.Delay_60_Days__c)){
                (Date.Today()>Date.valueOf('2014-09-02 09:00:00') && ((lengthOfTime==30 && !caseToEmail.Delay_60_Days__c) || (lengthOfTime==60 && caseToEmail.Delay_60_Days__c)))){                         
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                List<String> emailAddress = new List<String>();
                emailAddress.add(contactPersonEmail); //uncomment when ready
                
                List<String> bccEmailAddress = new List<String>();
                bccEmailAddress.add('kswathi@axcient.com'); //this is for testing purpose. Only sends the email to Gerald Xie
                bccEmailAddress.add('wou@axcient.com'); //this is for testing purpose. Only sends the email to Will Ou
                
                OrgWideEmailAddress emailId = [Select id from OrgWideEmailAddress Where address = 'no-reply@axcient.com' limit 1];
                
                //This is the Email below.
                String subject = 'Reminder to Return Your Axcient Device';
                String body = '<html><head><style>';
                    body+='body{font-family:Arial;}';
                    body+='p.text{font-size:16px;line-height:24px;}';
                    body+='</style></head><body><div align="left" width="505"><table border="0" cellpadding="0" width="500"><tbody>';
                    body+='<tr height="65px" style="height:65px;"><td width="400px;"><img src="http://static.wixstatic.com/media/dcb417_f1c91f70d7ab4d1aa3a29e01acdc8a2b.png_srz_294_94_75_22_0.50_1.20_0.00_png_srz" /></td></tr>';
                    body+='<tr height="1px" bgcolor="background:#CCCCCC" style="height:1px;background:#CCCCCC;"></tr>';
                    body+='<tr style="padding:10px;"><p class="text">Dear '+contactPerson +',</p>';  
                if(lengthOfTime==30 && !caseToEmail.Delay_60_Days__c){  
                    body+='<p class="text">Our records indicate that the device associated with RMA #'+caseNumber+' is still outstanding. ';
                    body+='Failure to return this device by '+ Datetime.newInstance(begDate+45, Time.newInstance(0,0,0,0)).format('MM/dd/yy') +' will result in an invoice.</p>';
                }
                else if(lengthOfTime==60 && caseToEmail.Delay_60_Days__c){
                    body+='<p class="text">Our records indicate that the device associated with RMA #'+caseNumber+' is still outstanding. ';
                    body+='Failure to return this device by '+ Datetime.newInstance(begDate+75, Time.newInstance(0,0,0,0)).format('MM/dd/yy') +' will result in an invoice.</p>';
                }
                else{
                    body+='<p class="text">Our records indicate that the device associated with RMA #'+caseNumber+' has not been returned.</p>';
                } 
                    body+='<p class="text"> If you have recently returned the device such that the device may be in transit, please ignore this automated message. </p>';
                    body+='<p class="text">Should you have any questions or feel you are receiving this message in error, please email '+CreatedByName+' at <a href="mailto:'+createdByEmail +'">'+createdByEmail +'</a>.</p>';
                    body+='<p class="text"> Thank you, <br /> The Axcient Team </p></tr>';
                    body+='<tr height="1px" bgcolor="background:#CCCCCC" style="height:1px;background:#CCCCCC;">';
                    body+='<tr><p style="font-size:9px" color="gray">Please do not reply directly to this automated email.</p></tr>';
                    body+='</tr></tbody></table></div></body></html>';
                
                /* For Phase 2 - Issue with getting the return label as PDF 
                Messaging.Emailfileattachment shippingLabelFile = new Messaging.EmailFileAttachment(); 
                shippingLabelFile.setFileName('ReturnLabel.pdf');
                shippingLabelFile.setBody();
                mail.setFileAttachments(new Messaging.Emailfileattachment[]{shippingLabelFile});
                */
                        
                mail.setToAddresses(emailAddress);
                mail.setBccAddresses(bccEmailAddress);
                mail.setOrgWideEmailAddressId(emailId.id);  
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                mail.setSaveAsActivity(true);
                Messaging.sendEmail(new Messaging.Singleemailmessage[] {mail});  
            }
            else if((lengthOfTime==75 && caseToEmail.Delay_60_Days__c)|| (lengthOfTime==45 && !caseToEmail.Delay_60_Days__c)){  
                //Creates the email for the 45 day email to Axcient to notify charges. 
                List<Asset> asset = [SELECT id, Model_Number__c, Name FROM Asset Where id=:caseToEmail.RMAed_Asset__c Limit 1];
                if(asset.size()>0){
                    Messaging.Singleemailmessage mailToFinance = new Messaging.Singleemailmessage();
                    OrgWideEmailAddress emailId = [Select id from OrgWideEmailAddress Where address = 'no-reply@axcient.com' limit 1];
                    mailToFinance.setOrgWideEmailAddressId(emailId.id);
                    mailToFinance.setSubject('Please Invoice - RMA #'+caseNumber);
                    mailToFinance.setToAddresses(new List<String>{'billing@axcient.com'});
                    mailToFinance.setHtmlBody('Dear Billing, <br /><br /> Please invoice for outstanding device '+
                        asset.get(0).Model_Number__c +' under RMA #'+caseNumber+'. <br /><br />Case Link: <a href="https://na6.salesforce.com/'+
                        caseToEmail.id+'">na6.salesforce.com/'+caseToEmail.id+'</a><br /></a><br /><br />Thank you, <br />Axcient Robot \n');
                        
                    Messaging.sendEmail(new Messaging.Singleemailmessage[] {mailToFinance});
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){   
        //Sends an email to Gerald - notice that emails are sent.
        Messaging.Singleemailmessage mailToFinance = new Messaging.Singleemailmessage();
        OrgWideEmailAddress emailId = [Select id from OrgWideEmailAddress Where address = 'no-reply@axcient.com' limit 1];
        mailToFinance.setOrgWideEmailAddressId(emailId.id);
        mailToFinance.setSubject('RMA Email Reminders Sent');
        //mailToFinance.setToAddresses(new List<String>{'kswathi@axcient.com', 'wou@axcient.com'});
        mailToFinance.setToAddresses(new List<String>{'kswathi@axcient.com', 'wou@axcient.com'}); //ask will where to send the email for production
        mailToFinance.setHtmlBody('RMA Email Reminders Sent!');
        Messaging.sendEmail(new Messaging.Singleemailmessage[] {mailToFinance});
    }
}