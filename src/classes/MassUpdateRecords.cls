global class MassUpdateRecords implements Database.Batchable<sObject>, Database.stateful {

    global final String Query;
    global String errors;

    global MassUpdateRecords(String q){
        Query = q;
        errors = 'Id,Error\n';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Database.SaveResult> dsrs = Database.update(scope, false);
        Integer i = 0;
        for(Database.SaveResult dsr : dsrs){
            String errorMessages = '';
            if(!dsr.isSuccess()){
                for(Database.Error err: dsr.getErrors()){
                    errorMessages += err.getMessage() + '; ';
                }
                errors += dsr.id + ',' + errorMessages + '\n';
            }
            i++;
        }
   }
   
   global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'biz-apps@axcient.com'};
        mail.setToAddresses(toAddresses);

        mail.setReplyTo('biz-apps@axcient.com');
        mail.setSenderDisplayName('BatchApex');
        mail.setSubject( 'Mass Record Update Batch' );
    
        mail.setPlainTextBody('\n\nBatch Run: ' + System.now() + '\n\nBy: ' + UserInfo.getName() + '\n\n');

        Blob errorb = blob.valueOf(errors.replaceAll('null',''));
        
        // Create the email attachment
        Messaging.EmailFileAttachment err = new Messaging.EmailFileAttachment();
        err.setFileName('Errors.csv');
        err.setBody(errorb);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {err});
    
        Messaging.sendEmail(new Messaging.Email[] { mail } );
   }
   
   /*public static testMethod void testBatch() {

    // Create 200 test accounts - this simulates one execute.   

        List <Account> accns = new List<Account>();
        for(integer i = 0; i<200; i++){
             Account a = new Account(Name='testAccount'+i); 
             accns.add(a);
        }

        insert accns;

    // Important - the Salesforce.com test framework only allows you to   
    // test one execute.   

       Test.StartTest();
       Database.executeBatch(new MassUpdateRecords('Select id from Account Where Name like \'testAccount%\''));
       Test.StopTest();

   } */      

}