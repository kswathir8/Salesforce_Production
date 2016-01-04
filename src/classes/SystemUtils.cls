/**
* @author: Anusha Surapaneni
* @date: 09/04/2013
* @description: Utility class for system related functions
* @history:
    1. 09/04/2013: Added sendEmail() method - Anusha Surapaneni
   
*/
public without sharing class SystemUtils{
   
    public static void sendEmail(string Subject,string replyTo, string[] ToAddresses,string[] CcAddresses,string[] BccAddresses,string HTMLBody,string PlainTextBody, string orgWideEmailID){
        string EmailFailure = null;  
        try{ 
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setSubject(subject);
                mail.setToAddresses(ToAddresses);
                mail.setInReplyTo(replyTo);
                mail.setCcAddresses(CcAddresses);
                mail.setBccAddresses(BccAddresses);
                mail.setPlainTextBody(PlainTextBody);
                mail.setHtmlBody(HTMLBody);
                mail.setOrgWideEmailAddressId(OrgWideEmailId);
               
                // Sends the email created. 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(System.EmailException emlEx) {
            EmailFailure = 'Email Failed: ' + emlEx;
            system.debug('%%%%'+EmailFailure);
        }
    }
}