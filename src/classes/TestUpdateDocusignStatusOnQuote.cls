/**
* @author: Anusha Surapaneni
* @date: 12/10/2013
* @description: Unit test class for UpdateDocusignStatusOnQuote Trigger
* @history:
    1.
*/
@isTest(SeeAllData=true)
    public class TestUpdateDocusignStatusOnQuote{
        static testMethod void TestUpdateDocusignStatusOnQuote() {
            Id partnerAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId();
      
        Account acc = new Account(Name = 'Test Account',RecordTypeId=partnerAccRTId);
        insert acc;
        Contact con = new Contact(FirstName = 'Test',LastName='Contact',AccountId = acc.id);
        insert con;
        //get standard pricebook
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
        insert pbk1;
        // Insert Products
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC',Family='Hardware', isActive = true);
        insert prd1;
        // Insert PriceBook Entry for corresponding Products
        PricebookEntry pbe1 = new PricebookEntry (Product2ID=prd1.id,Pricebook2ID=standardPb.id,UnitPrice=229, isActive=true);
        insert pbe1;
        
        Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospect',CloseDate=Date.today(),Pricebook2Id = pbe1.Pricebook2Id, AccountId = acc.id,Contract_Terms__C='1-Year Pre-paid',Deal_Registration__C = true);
        insert opp1;
        Quote q = new Quote(Name='Opp1',Pricebook2Id = pbe1.Pricebook2Id, OpportunityId = opp1.id,Discretionary_Discount__C = 3.00,ContactId=con.id,Reason_for_Approval__c='testing');
        insert q;
        QuoteLineItem lineItem1 = new QuoteLineItem (QuoteID=q.id,PriceBookEntryID=pbe1.id,UnitPrice=pbe1.unitprice, quantity=1);
        insert lineItem1;
         
        pagereference pg=new pagereference('https://www.appextremes.com/apps/Conga/PointMerge.aspx?SessionID={!API.Session_ID}&ServerURL={!API.Partner_Server_URL_80}&id={!q.Id}&templateid=a00V0000002wcET&DocuSignVisible=1&DocuSignR1Id={!q.ContactID__c}&DocuSignR1Role=Signer+1&DocuSignExpireVoidEnv=1&DocuSignExpireIn=8&DocuSignSendReminders=1&DefaultPDF=1","_blank","height=460,width=700"'); 
        system.test.setCurrentpage(pg); 
        test.starttest();
        dsfs__DocuSign_Status__c docStatus = new dsfs__DocuSign_Status__c(dsfs__Envelope_Status__c = 'Sent',Quote__c = q.id);
        insert docStatus;
        q.Docusign_Status__c =  'Sent';
        update q;
        test.stoptest();
    }
}