@isTest
private class RequestExtensionControllerTest {
    static boolean runAllTests = true ;
    
    @isTest static void RequestExtensionControllerTest_success() {
        if(!runAllTests) return ;
        Test.setCurrentPage(Page.RequestExtension);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Staging';
        opp.Monthly_Serivce_Price__c = 20;
        insert opp;

        ApexPages.currentPage().getParameters().put('id', opp.Id) ;

        RequestExtensionController rec = new RequestExtensionController() ;
        rec.der.Reason_for_extension_request__c = 'test' ;
        PageReference pg = rec.requestExtension() ;
        System.assertEquals(false, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertNotEquals(null, pg);
        System.assertEquals(Page.DealRegistrationList.getURL(), pg.getURL());
    }

    @isTest static void RequestExtensionControllerTest_failure() {
        if(!runAllTests) return ;
        Test.setCurrentPage(Page.RequestExtension);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Staging';
        opp.Monthly_Serivce_Price__c = 20;
        insert opp;

        ApexPages.currentPage().getParameters().put('id', opp.Id) ;

        RequestExtensionController rec = new RequestExtensionController() ;
        PageReference pg = rec.requestExtension() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        rec.der.Reason_for_extension_request__c = 'Test' ;
        rec.der.Requested_Extension_Length__c = 0 ;
        pg = rec.requestExtension() ;
        rec.der.Requested_Extension_Length__c = 60 ;
        delete z;
        pg = rec.requestExtension() ;
    }

   /* @isTest static void RequestExtensionControllerTest_failure2() {
        if(!runAllTests) return ;
        Test.setCurrentPage(Page.RequestExtension);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z1 = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration',
                Zip_Code_Start__c = '14000',
                Zip_Code_Stop__c = '15000'
            ) ;
        insert z1 ;

        Zip_Code_Range__c z2 = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration',
                Zip_Code_Start__c = '15001',
                Zip_Code_Stop__c = '16000'
            ) ;
        insert z2 ;

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Staging';
        opp.Monthly_Serivce_Price__c = 20;
        insert opp;

        ApexPages.currentPage().getParameters().put('id', opp.Id) ;

        RequestExtensionController rec = new RequestExtensionController() ;
        rec.der.Reason_for_extension_request__c = 'Test' ;
        PageReference pg = rec.requestExtension() ;
    }

    @isTest static void RequestExtensionControllerTest_failure3() {
        if(!runAllTests) return ;
        Test.setCurrentPage(Page.RequestExtension);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Staging';
        opp.Monthly_Serivce_Price__c = 20;
        insert opp;

        ApexPages.currentPage().getParameters().put('id', opp.Id) ;

        RequestExtensionController rec = new RequestExtensionController() ;
        rec.der.Reason_for_extension_request__c = 'Test' ;
        PageReference pg = rec.requestExtension() ;
    }

    @isTest static void OpportunityExpirationBatch_test() {

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Staging';
        opp.Monthly_Serivce_Price__c = 20;
        opp.Exp_Date__c = System.Today().addDays(-1) ;
        insert opp;

        OpportunityExpirationBatch oeb = new OpportunityExpirationBatch();
        SchedulableContext scq;
        oeb.execute(scq);
        opp = [
            SELECT
                Exp_Date__c,
                Status__c
            FROM
                Opportunity
            WHERE Id = :opp.Id
        ] ;
        System.assertEquals('Expired', opp.Status__c) ;
    }

    @isTest static void OpportunityExpirationBatch_test2() {

        //Create an Account
        account acc = new account();
        acc.Name ='testing34782394723';
        acc.Account_Status__c ='Working';
        acc.Contract_Signed__c =true;
        acc.BillingState = 'NY' ;
        acc.BillingPostalCode = '14444' ;
        insert acc;

        //Create an Opportunity
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing34390';
        opp.AccountId = acc.Id;
        opp.CloseDate = date.today();
        opp.StageName = 'Closed Won';
        opp.Monthly_Serivce_Price__c = 20;
        opp.Exp_Date__c = System.Today().addDays(-1) ;
        opp.Status__c = 'Tim' ;
        insert opp;

        OpportunityExpirationBatch oeb = new OpportunityExpirationBatch();
        SchedulableContext scq;
        oeb.execute(scq);
        opp = [
            SELECT
                Exp_Date__c,
                Status__c
            FROM
                Opportunity
            WHERE Id = :opp.Id
        ] ;
        System.assertNotEquals('Expired', opp.Status__c) ;
    }*/
}