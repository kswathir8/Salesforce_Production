@isTest
class TestForUpdateAccountScheduler {
    // This Method creates Account and Contact Objects
      
    public static testMethod void testscheduleaccouny() {

Test.StartTest();
System.schedule('Test Account Update21', '0 0 6/1 * * ?', new UpdateAccountSchedulerNew());
Test.stopTest();


    
    
    }
    }