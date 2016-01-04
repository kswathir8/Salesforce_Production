/**
* @author: Anusha Surapaneni
* @date: 01/24/2012
* @description: Unit test class for "Send Email Method".
* @history:
    1.
*/
@isTest(SeeAllData=true)
    public class TestCaseCommentTrigger{
    
     // Unit Test 1: Accept Advanced Services SR from Queue  
    static testMethod void sendEmail() {
        test.startTest();
        Account testAccount = new Account(Name='Test Acccount');
        insert testAccount;
        
        Case testCase = new Case(AccountId=testAccount.id,Subject='Test subject');
        testCase.Additional_Email_Recipient_1__C= 'test@test.com ';
        testCase.Additional_Email_Recipient_2__C = 'test2@test.com';
        testCase.Additional_Email_Recipient_3__C = 'test3@test.com';
        insert testCase;
        test.stopTest();
        CaseComment testCC = new CaseComment(isPublished=true,ParentId=testCase.id);
        insert testCC;
        
   }   
}