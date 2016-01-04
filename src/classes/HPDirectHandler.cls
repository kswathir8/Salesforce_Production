global class HPDirectHandler implements Messaging.InboundEmailHandler {

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		  Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          
          try{
	          List<Messaging.InboundEmail.TextAttachment> attachments = email.TextAttachments;
	          
	          /**
	           * Red Argyle - MMA 06/08/2015
	           * OSReportController is a missing class. Removing the functionality, since it currently doesn't work anyway, 
	           * makes the most sense. Eventually, delete this comment and the contained code.
	          if(attachments.size() > 0){ 
	          	OSReportController osreports = new OSReportController(attachments);
				osreports.createReportsFromAttachments();
	          }
	          */
          }
          catch(Exception e){
	          	
		     	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {'gbischof@axcient.com'};
				mail.setToAddresses(toAddresses);
		
				mail.setReplyTo('gbischof@axcient.com');
				mail.setSenderDisplayName('Email Services');
		   		mail.setSubject( 'Test Email Service' );
		   	
		   		mail.setPlainTextBody('Error: \n\n' + e.getMessage() + '\n\n');
		   	
		   		Messaging.sendEmail(new Messaging.Email[] { mail } );
          }
          
          
          return result; 
    }

	public static testMethod void testInboundCSVAttachmentNotOSReportInfo(){
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	    Messaging.InboundEmail.TextAttachment inAtt = new Messaging.InboundEmail.TextAttachment();
	
	    email.subject = 'test';
	    env.fromAddress = 'gbischof@axcient.com';
	 
	    // set the body of the attachment
	    inAtt.body = 'Test, Headers\nValue1,Value2';
	    inAtt.fileName = 'My attachment name.csv';
	    inAtt.mimeTypeSubType = 'text/csv';
	 
	    email.textAttachments = new Messaging.inboundEmail.textAttachment[] {inAtt };
	 
	    // call the class and test it with the data in the testMethod
	    HPDirectHandler emailhandler = new HPDirectHandler();
	    emailhandler.handleInboundEmail(email, env );   
	}
	

}