@isTest
global class PartnerTemplateTest {
	
	@testSetup
	global static void setup() {

		// create a test community user
		Account a = new Account(
			Name = 'TEST',
			RecordTypeId = Account.getSObjectType().getDescribe().getRecordTypeInfosByName().get('Partner').getRecordTypeId()
		);
		insert a;

		Contact c = new Contact(
			FirstName = 'TEST',
			LastName = 'TEST',
			Email = 'test_partner_template_tests@test.com',
			AccountId = a.Id
		);
		insert c;

		//String userRoleName = a.Name + ' Partner Executive';
		//UserRole userRole = [select Id from UserRole where Name = :userRoleName limit 1];

		Profile p = [select Id from Profile where Name = 'Axcient Partner Community User' limit 1];

		User u = new User(
			alias = 'test',
			ContactId = c.Id,
            FirstName = c.FirstName,
            LastName = c.LastName,
            Email = c.Email,
            Username = c.Email,
            CommunityNickname = c.Email,
            ProfileId = p.Id,
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US', 
            timezonesidkey = 'America/Los_Angeles'
		);
		insert u;

	}

	@isTest 
	global static void testRedirectGuestToLogin() {
		PartnerTemplate pt = new PartnerTemplate();
		PageReference pr = pt.redirectGuestToLogin();
		System.assertEquals(null, pr);
	}

	@isTest
	global static void testIsEndUser() {

		User u = [select Id from User where alias = 'test' limit 1];
		PermissionSet ps = [select Id from PermissionSet where Name = 'Partner_Community_End_User_global' limit 1];
		PermissionSetAssignment psa = new PermissionSetAssignment(
			AssigneeId = u.Id,
			PermissionSetId = ps.Id
		);
		insert psa;

		system.runAs(u) {
			PartnerTemplate pt = new PartnerTemplate();
			system.assertEquals(true, pt.isEndUser);	
		}

	}

	@isTest
	global static void testGoToLitmos() {
		Test.setMock(HttpCalloutMock.class, new LitmosSSOTests.ProvisionUserSuccessResponse());
		Test.startTest();
		PartnerTemplate pt = new PartnerTemplate();
		pt.gotoLitmos();
		Test.stopTest();
	}

}