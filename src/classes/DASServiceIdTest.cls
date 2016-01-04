/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class DASServiceIdTest {

    static testMethod void myUnitTest() {
        //create new account
        Account a = new Account(Name = 'Test Acc');
		insert a;
        // Create new Opportunity with user created above
        Opportunity newOpp = new Opportunity(Name= 'TestOpp021',closeDate=System.today(),StageName='Prospecting', accountid = a.id, RMC_Email__c = 'a@a.com');
        insert newOpp ;
        
        // Create new Service ID for the above created Opportunity
        Service_id__c newSid = new Service_id__c(Name= 'TestSE101',Customer__c=newOpp.id);
        insert newSid ;
        
        // Create new DAS with Name and Opportunity, SID is expected to be updated automatically
        D_A_S__c newdas= new D_A_S__c(Opportunity__c= newOpp.Id);
        insert newdas;

        // Get the new updated SID
        D_A_S__c newdas1= [select Service_Id__c from D_A_S__c where id = :newdas.id];
        
        // Test the Expected Vs Updated value
        System.assertEquals(newSid.id,newdas1.service_id__c );
    }
}