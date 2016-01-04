@isTest
private class LeadTriggerHandlerTest {
    
    @isTest static void beforeInsertPartnerReconciliationTest() {
        Account a = new Account(
                Name = 'Test Account'
            ) ;
        insert a;
        Account a2 = new Account(
                Name = 'Test Account2'
            ) ;
        insert a2;

        Contact con = new Contact(
                LastName = 'Tom',
                Email = 'test@test.com',
                AccountId = a.Id
            ) ;
        insert con ;
        Contact con2 = new Contact(
                LastName = 'Tom',
                Email = 'test3@test.com'
            ) ;
        insert con2 ;

        List<Lead> leadList = new List<Lead>() ;
        Lead l = new Lead(
                Sales_Contact_Email__c = 'test@test.com',
                LastName = 'Test',
                Company = 'Temp'
            ) ;
        leadList.add(l);
        Lead l2 = new Lead(
                Sales_Contact_Email__c = 'test2@test.com',
                LastName = 'Test',
                Company = 'Temp'
            ) ;
        leadList.add(l2);
        Lead l3 = new Lead(
                Sales_Contact_Email__c = 'test@test.com',
                LastName = 'Test',
                Company = 'Temp',
                Partner__c = a2.Id
            ) ;
        leadList.add(l3);
        Lead l4 = new Lead(
                Sales_Contact_Email__c = 'test3@test.com',
                LastName = 'Test',
                Company = 'Temp'
            ) ;
        leadList.add(l4);
        insert leadList ;

        l = [SELECT Partner__c FROM Lead WHERE Id = :l.Id] ;
        //System.assertEquals(a.id, l.Partner__c);
        l2 = [SELECT Partner__c FROM Lead WHERE Id = :l2.Id] ;
        //System.assertEquals(null, l2.Partner__c);
        l3 = [SELECT Partner__c FROM Lead WHERE Id = :l3.Id] ;
        //System.assertEquals(a2.Id, l3.Partner__c);
        l4 = [SELECT Partner__c FROM Lead WHERE Id = :l4.Id] ;
        //System.assertEquals(null, l4.Partner__c);
    }

    /*
    @isTest static void afterInsertLeadMergeTest() {
        List<Lead> masterList = new List<Lead>() ;
        for(Integer i=0; i <160; ++i) {
            Lead l = new Lead(
                    Email = 'test' + i + '@test.com',
                    LastName = 'Test',
                    Company = 'Temp'
                ) ;
            masterList.add(l) ;
        }
        insert masterList ;
        Lead l2 = new Lead(
                Email = 'test2@test.com',
                LastName = 'Test',
                Company = 'Temp'
            ) ;
        insert l2 ;
        List<Lead> dupList = new List<Lead>() ;
        for(Integer i=0; i <160; ++i) {
            Lead l = new Lead(
                    Email = 'test' + i + '@test.com',
                    LastName = 'Test',
                    Company = 'Temp'
                ) ;
            dupList.add(l) ;
        }

        Test.startTest() ;
        insert dupList ;
        Test.stopTest() ;

        Lead l = [SELECT Email FROM Lead WHERE Id = :masterList[0].Id] ;
        System.assertEquals('test0@test.com', l.Email);
        System.assertNotEquals(dupList[0].Id, l.Id);
        List<Lead> lList = [SELECT Email FROM Lead WHERE Id = :dupList[0].Id] ;
        System.assert(lList.isEmpty());
    }
    */

    @isTest static void afterUpdateConvertLeadTest() {
        List<Lead> masterList = new List<Lead>() ;
            Lead l = new Lead(
                    Email = 'test0@test.com',
                    LastName = 'Test',
                    Company = 'Temp'
                ) ;
                insert l ;
            l.IsApproved__c = true ;
                Test.startTest() ;
                update l ;
                Test.stopTest() ;

                l = [
                    SELECT
                        IsConverted,
                        ConvertedAccountId,
                        ConvertedContactId,
                        ConvertedOpportunityId
                    FROM
                        Lead
                    WHERE Id = :l.Id
                ] ;
                //System.assertEquals(true, l.IsConverted) ;
                //System.assertNotEquals(null, l.ConvertedAccountId) ;
                //System.assertNotEquals(null, l.ConvertedContactId) ;
                //System.assertNotEquals(null, l.ConvertedOpportunityId) ;
    }
}