public with sharing class CaseCommentCreateController {
	
	public CaseComment newCaseComment {get;set;}
	public Case parentCase {get;set;}
	public List<CaseComment> otherComments {get;set;}
	public Boolean sendCustomerNotification {get;set;}
	public Boolean addTask {get;set;}
	public Task newReminder {get;set;}
	
	public CaseCommentCreateController(ApexPages.StandardController stdContoller){ 
		parentCase = (Case)stdContoller.getRecord();
		newCaseComment = new CaseComment(parentId=parentCase.ID);
		newReminder = new Task(WhatID=parentCase.id,ownerID=userInfo.getUserID());
		otherComments = [Select id,CommentBody,IsPublished,CreatedByID,CreatedBy.Name,CreatedDate From CaseComment Where parentID = :parentCase.id];
		addTask = false;
	}
	
	public PageReference saveRecords(){
		insert newCaseComment;
		if(addTask){
			if(newReminder.ReminderDateTime != null) newReminder.IsReminderSet = true;
			newReminder.Subject = newCaseComment.CommentBody; 
			insert newReminder;
		}
		
		if(ApexPages.hasMessages()) return null;
		return new PageReference('/' + parentCase.id).setRedirect(true);
	}
	
	public void addTask(){
		addTask = true;
	}
	
	public void removeTask(){
		addTask = false;
	}
	
	/********************************
	*		Test Methods			*
	********************************/
	
	public static testMethod void testConstructor(){
		Account testAccount = new Account(Name='Test Acccount');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		Test.startTest();
			ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testCase);
			CaseCommentCreateController newCaseComment = new CaseCommentCreateController(stdController);
		Test.stopTest();
		
		System.assert(!ApexPages.hasMessages());
	}
	
	public static testMethod void testConstructorWithCaseComments(){
		Account testAccount = new Account(Name='Test Acccount');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		CaseComment comment = new CaseComment(isPublished=true,ParentId=testCase.id);
		insert comment;
		
		Test.startTest();
			ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testCase);
			CaseCommentCreateController newCaseComment = new CaseCommentCreateController(stdController);
		Test.stopTest();
		
		System.assert(!ApexPages.hasMessages());
	}
	
	public static testMethod void testAddAndRemoveTask(){
		Account testAccount = new Account(Name='Test Acccount');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		Test.startTest();
			ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testCase);
			CaseCommentCreateController newCaseComment = new CaseCommentCreateController(stdController);
			newCaseComment.addTask();
			newCaseComment.removeTask();
		Test.stopTest();
		
		System.assert(!ApexPages.hasMessages());
	}
	
	public static testMethod void testSaveRecordWithoutTask(){
		Account testAccount = new Account(Name='Test Acccount');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		Test.startTest();
			ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testCase);
			CaseCommentCreateController newCaseComment = new CaseCommentCreateController(stdController);
			newCaseComment.newCaseComment.CommentBody = 'A new Comment';
			newCaseComment.saveRecords();
		Test.stopTest();
		
		System.assert(!ApexPages.hasMessages());
		
		List<CaseComment> newComments = [Select id,commentBody From CaseComment Where parentID = :testCase.id];
		System.assertEquals(1,newComments.size());
		
		List<Task> newTasks = [Select id,WhoId,WhatID,AccountID From Task Where WhoId = :testCase.id];
		System.assertEquals(0,newTasks.size());
	}
	
	public static testMethod void testSaveRecordWithTask(){
		Account testAccount = new Account(Name='Test Acccount');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		Test.startTest();
			ApexPages.Standardcontroller stdController = new Apexpages.Standardcontroller(testCase);
			CaseCommentCreateController newCaseComment = new CaseCommentCreateController(stdController);
			newCaseComment.newCaseComment.CommentBody = 'A new Comment';
			newCaseComment.addTask();
			newCaseComment.newReminder.status = 'Not Started';
			newCaseComment.newReminder.Priority = 'Normal';
			newCasecomment.newReminder.ReminderDateTime = System.now();
			newCaseComment.saveRecords();
		Test.stopTest();
		
		System.assert(!ApexPages.hasMessages());
		
		List<CaseComment> newComments = [Select id,commentBody From CaseComment Where parentID = :testCase.id];
		System.assertEquals(1,newComments.size());
		
		List<Task> newTasks = [Select id,WhoId,WhatID,AccountID,subject From Task];
		System.assertEquals(1,newTasks.size());
		System.assertEquals(newComments.get(0).commentBody,newTasks.get(0).subject);
	}
	
}