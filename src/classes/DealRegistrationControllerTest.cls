@isTest
private class DealRegistrationControllerTest {
   static boolean runAllTests = true ;
    
    @isTest static void registrationControllerTest_Error_MissingCampaign() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;
        Test.setCurrentPage(Page.DealRegistration);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        DealRegistrationController drc = new DealRegistrationController() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());

        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, ApexPages.getMessages()[0].getSummary().contains('campaign does not exis'), ApexPages.getMessages());
    }

    @isTest static void registrationControllerTest_Success_OneZipRange() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;
        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;

        Axcitory__c a = new Axcitory__c() ;
        insert a ;
        a = [
            SELECT
                OwnerId
            FROM
                Axcitory__c
            WHERE Id = :a.Id
        ] ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        System.assert(DealRegistrationController.leadRecordTypesByName.containsKey('Deal Registration Lead')) ;

        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;

        System.assertEquals(false, drc.isDealRegistered) ;
        drc.registerDeal() ;
        System.assertEquals(false, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, drc.isDealRegistered) ;
        Lead tmpLead = [
            SELECT
                Partner_Company_Name__c,
                Sales_Contact_First_Name__c,
                Sales_Contact_Phone__c,
                Sales_Contact_Email__c,
                OwnerId
            FROM
                Lead
            WHERE Id = :drc.newLead.Id
        ] ;
        System.assertEquals(drc.newLead.Partner_Company_Name__c, tmpLead.Partner_Company_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_First_Name__c, tmpLead.Sales_Contact_First_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_Phone__c, tmpLead.Sales_Contact_Phone__c);
        System.assertEquals(drc.newLead.Sales_Contact_Email__c, tmpLead.Sales_Contact_Email__c);
        System.assertEquals(a.OwnerId, tmpLead.OwnerId);
    }

    /*@isTest static void registrationControllerTest_Success_TwoZipRange() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;
        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;

        Axcitory__c a = new Axcitory__c() ;
        insert a ;
        a = [
            SELECT
                OwnerId
            FROM
                Axcitory__c
            WHERE Id = :a.Id
        ] ;

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

        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        System.assert(DealRegistrationController.leadRecordTypesByName.containsKey('Deal Registration Lead')) ;

        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;

        System.assertEquals(false, drc.isDealRegistered) ;
        drc.registerDeal() ;
        System.assertEquals(false, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, drc.isDealRegistered) ;
        Lead tmpLead = [
            SELECT
                Partner_Company_Name__c,
                Sales_Contact_First_Name__c,
                Sales_Contact_Phone__c,
                Sales_Contact_Email__c,
                OwnerId
            FROM
                Lead
            WHERE Id = :drc.newLead.Id
        ] ;
        System.assertEquals(drc.newLead.Partner_Company_Name__c, tmpLead.Partner_Company_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_First_Name__c, tmpLead.Sales_Contact_First_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_Phone__c, tmpLead.Sales_Contact_Phone__c);
        System.assertEquals(drc.newLead.Sales_Contact_Email__c, tmpLead.Sales_Contact_Email__c);
        System.assertEquals(a.OwnerId, tmpLead.OwnerId);
    }*/


    @isTest static void registrationControllerTest_Error_Past120Days() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;

        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today().addMonths(4) ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(false, drc.isDealRegistered) ;
        System.assertEquals(true, ApexPages.getMessages()[0].getSummary().contains('within 120 days'), ApexPages.getMessages());

    }

    @isTest static void registrationControllerTest_Error_MustBeFuture() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;

        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today().addMonths(-1) ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, ApexPages.getMessages()[0].getSummary().contains('Timeframe for purchase must'), ApexPages.getMessages());

        drc = new DealRegistrationController() ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today().addMonths(-1) ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());

        System.assertEquals('/apex/dealregistrationlist', drc.Cancel().getURL()) ;
    }

    @isTest static void registrationControllerTest_Error_MissingField() {
        if(!runAllTests) return ;
        // 10/12/15 Added to stop test failures. 
        CreatePackingSlipController.isApexTest = true;
        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, ApexPages.getMessages()[0].getSummary().contains('Required fields are missing'), ApexPages.getMessages());
    }

    @isTest static void registrationControllerTest_Error_NoAxcitory() {
        if(!runAllTests) return ;
        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;
        Test.setCurrentPage(Page.DealRegistration);

        DealRegistrationController drc = new DealRegistrationController() ;
        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'AR' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'Bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;
        drc.registerDeal() ;
        System.assertEquals(true, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, ApexPages.getMessages()[0].getSummary().contains('state does not have an Axcitory'), ApexPages.getMessages());
    }

    @isTest static void registrationControllerTest_Merge() {
        if(!runAllTests) return ;
        Campaign camp = new Campaign(Name = 'Deal Registration', IsActive = true) ;
        insert camp ;
        Test.setCurrentPage(Page.DealRegistration);

        Axcitory__c a = new Axcitory__c() ;
        insert a ;

        Zip_Code_Range__c z = new Zip_Code_Range__c(
                Axcitory__c = a.Id,
                State__c = 'NY',
                Type__c = 'Deal Registration'
            ) ;
        insert z ;

        Lead newLead = new Lead(        
            Partner_Company_Name__c = 'TomBoy',
            Sales_Contact_First_Name__c = 'John',
            Sales_Contact_Phone__c = '585-555-1212',
            Sales_Contact_Email__c = 'tom@tom.com',
            Company = 'Test Company',
            Street = '11 Test Lane',
            City = 'Rochester',
            End_User_State__c = 'NY',
            State = 'NY',
            PostalCode = '14444',
            FirstName = 'Tom',
            LastName = 'Jones',
            Phone = '585-555-1212',
            Email = 'bob@tom.com',
            Title = 'Test',
            Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer',
            Estimated_Monthly_Service_Fees__c = 2000,
            Timeframe_for_Purchase__c = Date.today(),
            Opportunity_Description__c = 'Lead for stuff'
        ) ;
        insert newLead ;
        Lead testLead = [
            SELECT
                Partner_Company_Name__c,
                Email
            FROM
                Lead
            WHERE Id = :newLead.Id
        ] ;
        System.assertEquals(newLead.Partner_Company_Name__c, testLead.Partner_Company_Name__c);
        System.assertEquals(newLead.Email, testLead.Email);

        DealRegistrationController drc = new DealRegistrationController() ;
        System.assert(DealRegistrationController.leadRecordTypesByName.containsKey('Deal Registration Lead')) ;
        drc.newLead.Partner_Company_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_First_Name__c = 'Fred' ;
        drc.newLead.Sales_Contact_Phone__c = '585-555-9833' ;
        drc.newLead.Sales_Contact_Email__c = 'tom@tom.com' ;
        drc.newLead.Company = 'Test Company' ;
        drc.newLead.Street = '11 Test Lane' ;
        drc.newLead.City = 'Rochester' ;
        drc.newLead.End_User_State__c = 'NY' ;
        drc.newLead.PostalCode = '14444' ;
        drc.newLead.FirstName = 'Tom' ;
        drc.newLead.LastName = 'Jones' ;
        drc.newLead.Phone = '585-555-1212' ;
        drc.newLead.Email = 'bob@tom.com' ;
        drc.newLead.Title = 'Test' ;
        drc.newLead.Is_this_a_new_customer_or_a_Current_cust__c = 'New Customer' ;
        drc.newLead.Estimated_Monthly_Service_Fees__c = 2000 ;
        drc.newLead.Timeframe_for_Purchase__c = Date.today() ;
        drc.dateString = drc.newLead.Timeframe_for_Purchase__c.format() ;
        drc.newLead.Opportunity_Description__c = 'Lead for stuff' ;

        System.assertEquals(false, drc.isDealRegistered) ;
        drc.registerDeal() ;
        System.assertEquals(false, ApexPages.hasMessages(), ApexPages.getMessages());
        System.assertEquals(true, drc.isDealRegistered) ;
        Lead tmpLead = [
            SELECT
                Partner_Company_Name__c,
                Sales_Contact_First_Name__c,
                Sales_Contact_Phone__c,
                Sales_Contact_Email__c
            FROM
                Lead
            WHERE Id = :newLead.Id
        ] ;
        System.assertEquals(drc.newLead.Partner_Company_Name__c, tmpLead.Partner_Company_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_First_Name__c, tmpLead.Sales_Contact_First_Name__c);
        System.assertEquals(drc.newLead.Sales_Contact_Phone__c, tmpLead.Sales_Contact_Phone__c);
        System.assertEquals(drc.newLead.Sales_Contact_Email__c, tmpLead.Sales_Contact_Email__c);

    }
}