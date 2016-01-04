public class CaseTimerController {

	public Case parentCase;

	public CaseTimerController(ApexPages.standardController stdController){
		parentCase = (Case)stdController.getRecord();
	}
	
	@RemoteAction
	public static void createNewCaseTimerObject(String CaseID, String Stage, String numOfMilliseconds){
		ID parentID = ID.valueOf(caseID);
		Integer milliseconds = Integer.valueOf(numOfMilliseconds);
		Case_Timer__c newTimer = new Case_Timer__c(case__c=parentID,Total_Milliseconds__c=milliseconds,stage__c=Stage);
		insert newTimer;
	}

	public void refreshPage(){
		//refreshes page
	}
	
	/****************************
	*		Test Methods		*
	****************************/

	public static testMethod void testConstructor(){
		
		Account testAccount = new Account(Name='TEst Account');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
		insert testCase;
		
		Test.startTest();
			ApexPages.standardController stdContolller = new ApexPages.standardController(testCase);
			CaseTimerController ctc = new CaseTimerController(stdContolller);
		Test.stopTest();
		
		System.assertEquals(ctc.parentCase.id,testCase.id);
		
	}
	
	public static testMethod void testCreateNewCaseTimerObject(){
		
		Account testAccount = new Account(Name='TEst Account');
		insert testAccount;
		
		Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject',status='Open');
		insert testCase;
		
		ApexPages.standardController stdContolller = new ApexPages.standardController(testCase);
		CaseTimerController ctc = new CaseTimerController(stdContolller);
		
		Test.startTest();
				CaseTimerController.createNewCaseTimerObject(String.valueOf(testcase.id),String.valueOf(testcase.status),'1000');
				ctc.refreshPage();
		Test.stopTest();
		
		List<Case_Timer__c> timers = [Select id,case__c,stage__c From Case_Timer__c Where Case__c = :testCase.id];
		System.assertEquals(1,timers.size());
		System.assertEquals('Open',timers.get(0).stage__c);
	}

}