@isTest
class TestForUpdateCaseScheduler {
    // This Method creates Account and Contact Objects
      
    public static testMethod void testschedulecase() {

Test.StartTest();
System.schedule('Test Case Update', '0 0 2/1 * * ?', new UpdateCaseScheduler());
Test.stopTest();


    
    
    }
    }