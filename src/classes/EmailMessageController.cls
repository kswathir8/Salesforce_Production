public class EmailMessageController {

	@future
	public static void forwardMessagesToSupport(List<ID> messageIDS){
		
		if(messageIDS.size() == 0) return;
		
		List<EmailMessage> messages = [Select id,BccAddress,CcAddress,FromAddress,FromName,HasAttachment,Headers,MessageDate,ParentId,Subject,TextBody,ToAddress,HtmlBody From EmailMessage Where id IN :messageIDs];
		List<Messaging.SingleEmailMessage> forwardMessages = new List<Messaging.SingleEmailMessage>();
		
		Set<ID> caseIds = new Set<Id>();
		for(EmailMessage origMessage: messages) caseIds.add(origMessage.ParentId);
		
		Map<ID,Case> caseMap = new Map<Id,Case>([Select id,CaseNumber From Case Where id IN :caseIds]);
		
		for(EmailMessage origMessage: messages){
			
			Messaging.SingleEmailMessage newMessage = new Messaging.SingleEmailMessage();
			newMessage.setToAddresses(new String[]{'support@axcient.com'}); 
			newMessage.setReplyTo(origMessage.FromAddress); 
			if(origMessage.BccAddress != null) newMessage.setBccAddresses(origMessage.BccAddress.split(';'));
			if(origMessage.ccAddress != null) newMessage.setCcAddresses(origMessage.ccAddress.split(';'));
			newMessage.setSubject('Closed Case: ' + caseMap.get(origMessage.ParentId).CaseNumber + ' – New Comment Added!');
			if(origMessage.TextBody != null) newMessage.setPlainTextBody('https://na6.salesforce.com/' + origMessage.ParentId + '\n\nMessage:\n\n' + origMessage.TextBody.replaceAll('ref:','reference:'));
			if(origMessage.HtmlBody != null) newMessage.setHtmlBody(origMessage.HtmlBody.replaceAll('ref:','reference:'));
		
			forwardMessages.add(newMessage);
		}
		
		if((forwardMessages.size() > 0) && (!Test.isRunningTest())) Messaging.sendEmail(forwardMessages);
		
	}

	
	public static void updateMessagesWithClosedCases(List<EmailMessage> messages){
		
		Set<Id> parentIDs = new Set<ID>();
		for(EmailMessage newMessage: messages){
			if(newMessage.parentID != null) parentIDs.add(newMessage.ParentID);
		}
		
		// Get RecordTypes
		Map<Id,RecordType> caseRecordTypes = new Map<Id,RecordType>([Select id,Name From RecordType Where sObjectType = 'Case' AND Name IN ('DAS Case','RMA Case','RMA Case Fresh Start Not Provisioned','RMA Case Fresh Start Provisioned','RMA Case Migration Not Provisioned','RMA Case Migration Provisioned')]);
		System.debug(caseRecordTypes);
		
		// Get Cases
		List<ID> messageIds = new List<ID>();
		Map<ID,Case> closedCases = new Map<ID,Case>([Select id,Status,RecordTypeId From Case Where id IN :parentIds]);
		for(EmailMessage message: messages){
			if( closedCases.containsKey(message.parentID) && message.Incoming && ( closedCases.get(message.parentID).Status == 'Closed' || caseRecordTypes.containsKey(closedCases.get(message.parentID).RecordTypeID) ) )	messageIds.add(message.id) ;	
		}
		
		if(messageIds.size() > 0) forwardMessagesToSupport(messageIds);
	}
	
	/****************************
	*		Test Methods		*
	****************************/


	public static testMethod void testNewMessageCreationWithParentID(){

		Case firstCase = new Case();
		firstCase.Status = 'Open';
		firstCase.SuppliedEmail = 'gbischof@axcient.com';
		insert firstCase;
		
		EmailMessage incomingMessageForFirstCase = new EmailMessage();
		incomingMessageForFirstCase.FromAddress = 'gbischof@axcient.com';
		incomingMessageForFirstCase.TextBody = 'Hello!';
		incomingMessageForFirstCase.Incoming = true;
		incomingMessageForFirstCase.MessageDate = Date.Today();
		incomingMessageForFirstCase.ParentID = firstCase.id;
		
		Test.startTest();
			insert incomingMessageForFirstCase;
		Test.stopTest();
		
		List<Case> cases = [Select id From Case];
		System.assertEquals(1,cases.size());
	}
	
	public static testMethod void testNewMessageCreationWithParentIDOfClosedCase(){

		Case firstCase = new Case();
		firstCase.Status = 'Closed';
		firstCase.SuppliedEmail = 'gbischof@axcient.com';
		insert firstCase;
		
		EmailMessage incomingMessageForFirstCase = new EmailMessage();
		incomingMessageForFirstCase.FromAddress = 'gbischof@axcient.com';
		incomingMessageForFirstCase.TextBody = 'Hello!';
		incomingMessageForFirstCase.Incoming = true;
		incomingMessageForFirstCase.MessageDate = Date.Today();
		incomingMessageForFirstCase.ParentID = firstCase.id;
		
		Test.startTest();
			insert incomingMessageForFirstCase;
		Test.stopTest();
		
	}
	
	@isTest(seeallData=true)
	public static void testNewMessageCreationWithParentIDOfDASCase(){
		
		// Get RecordTypes
		RecordType caseRecordTypes = [Select id,Name From RecordType Where sObjectType = 'Case' AND Name = 'DAS Case'];
		
		Case firstCase = new Case();
		firstCase.Status = 'Open';
		firstCase.RecordTypeId = caseRecordTypes.id;
		firstCase.SuppliedEmail = 'gbischof@axcient.com';
		insert firstCase;
		
		EmailMessage incomingMessageForFirstCase = new EmailMessage();
		incomingMessageForFirstCase.FromAddress = 'gbischof@axcient.com';
		incomingMessageForFirstCase.TextBody = 'Hello!';
		incomingMessageForFirstCase.Incoming = true;
		incomingMessageForFirstCase.MessageDate = Date.Today();
		incomingMessageForFirstCase.ParentID = firstCase.id;
		
		Test.startTest();
			insert incomingMessageForFirstCase;
		Test.stopTest();
	}

}