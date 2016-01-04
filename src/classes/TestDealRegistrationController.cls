/**
* @author: Anusha Surapaneni
* @date: 10/4/2013
* @description: Unit test class for Deal Registration Page Controller- Used to insert deal registration Opportunity from Axcient.com
* @history:
    1.
*/
@isTest(SeeAllData=true)
public class TestDealRegistrationController{
    /*
     private static final Id axcitoryRecordTypeId =Schema.SObjectType.Axcitory__C.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
     // Unit Test 1: Insert Opportunity
     static testMethod void insertOpportunity() {
        // Insert Axcitory
        Axcitory__c ax = new Axcitory__C();
        ax.RecordTypeId = axcitoryRecordTypeId; 
        ax.Name = 'East';
        insert ax;
        
        //Insert Range for New York
        Zip_Code_Range__C nyRange = new Zip_Code_Range__C();
        nyRange.Axcitory__c = ax.id;
        nyRange.Name = 'east';
        nyRange.Type__C = 'Partner';
        nyRange.State__c = 'NY';
        nyRange.State_Full_Name__c = 'New York';
        insert nyRange;
        
        //Insert Range for California
        Zip_Code_Range__C caRange = new Zip_Code_Range__C();
        caRange.Axcitory__c = ax.id;
        caRange.Name = 'east';
        caRange.Type__C = 'Partner';
        caRange.State__c = 'CA';
        caRange.State_Full_Name__c = 'California';
        caRange.Zip_Code_Start__c = '90001';
        caRange.Zip_Code_Stop__c = '93599';
        insert caRange;
        
        Opportunity opp = new Opportunity();
        opp.Partner_Company_Name__c = 'test partner name';
        opp.Partner_Contact_Name__c = 'test partner Contact';
        opp.Partner_Contact_Email__c = 'testpartner@test.com';
        opp.Deal_Description__c = 'Test Deal Description';
        opp.End_Customer_Name__c = 'Test End Customer Name';
        opp.End_Customer_Contact_Name__c = 'Test End Customer Contact Name';
        opp.End_Customer_Contact_Email_Address__c = 'TestEmail@test.com';
        opp.End_Customer_State__c = 'New York';
        opp.Proposed_Close_Date__c = date.today()+1;
        opp.State_of_Partner_Headquarters__c = 'California';
        opp.Zip_Code__c = '93333';
        opp.Name = opp.Deal_Description__C;
        opp.StageName = 'Prospect';
        opp.Closedate = date.today()+1;
        insert opp;
        system.debug('Exception***'+opp);
        Apexpages.StandardController stdController = new Apexpages.StandardController(opp);
        DealRegistrationController insertDealRegOpp = new DealRegistrationController(stdController);
        insertDealRegOpp.opp.State_of_Partner_Headquarters__c = 'California';
        insertDealRegOpp.opp.Zip_Code__c = '93333';
        insertDealRegOpp.registerDeal();
   } 
    
    // Unit Test 2: Cancel method 
    static testMethod void cancelOpportunity() {
    
        Opportunity opp = new Opportunity();
        opp.Partner_Company_Name__c = 'test partner name';
        opp.Partner_Contact_Name__c = 'test partner Contact';
        opp.Partner_Contact_Email__c = 'testpartner@test.com';
        opp.Deal_Description__c = 'Test Deal Description';
        opp.End_Customer_Name__c = 'Test End Customer Name';
        opp.End_Customer_Contact_Name__c = 'Test End Customer Contact Name';
        opp.End_Customer_Contact_Email_Address__c = 'TestEmail@test.com';
        opp.Proposed_Close_Date__c = date.today()+1;
        opp.State_of_Partner_Headquarters__c = 'California';
        opp.Zip_Code__c = '93333';
        opp.Name = opp.Deal_Description__C;
        opp.StageName = 'Prospect';
        opp.Closedate = date.today()+1;
        insert opp;
      
        Apexpages.StandardController stdController = new Apexpages.StandardController(opp);
        DealRegistrationController insertDealRegOpp = new DealRegistrationController(stdController);
        insertDealRegOpp.opp.State_of_Partner_Headquarters__c = 'California';
        insertDealRegOpp.opp.Zip_Code__c = '93333';
        insertDealRegOpp.cancel();
   }   
   */
}