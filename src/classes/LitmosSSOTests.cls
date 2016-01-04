@isTest
global class LitmosSSOTests {
	
	@testSetup
	static void setup() {
		LitmosSSOSettings__c settings = new LitmosSSOSettings__c();
		settings.APIKey__c = 'ABC123';
		insert settings;
	}	

	@isTest
	static void testProvisionUser() {
		Test.setMock(HttpCalloutMock.class, new ProvisionUserSuccessResponse());
		Test.startTest();
		HttpResponse httpResponse = LitmosSSO.provisionUser(new User(
			Username = 'test@test.com',
            FirstName = 'TEST',
            LastName = 'TEST',
            Email = 'test@test.com'
		));
		Test.stopTest();
		system.assertEquals(httpResponse.getStatusCode(), 201);
	}

	global class ProvisionUserSuccessResponse implements HttpCalloutMock {
		global HttpResponse respond(HttpRequest httpRequest) {
			HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml');
	        res.setBody('<User xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><Id>bh8UPenOgts1</Id><UserName>test@test.com</UserName><FirstName>test</FirstName><LastName>test</LastName><FullName>test test</FullName><Email>test2@test.com</Email><AccessLevel>Learner</AccessLevel><DisableMessages>true</DisableMessages><Active>true</Active><Skype/><PhoneWork/><PhoneMobile/><LastLogin/><LoginKey>https://continuitypartnerportal.litmos.com//login.aspx?loginkey=1bcaab61-52df-4f4e-b5af-903d47dd95f9</LoginKey><IsCustomUsername>false</IsCustomUsername><Password/><SkipFirstLogin>false</SkipFirstLogin><TimeZone>Pacific Standard Time</TimeZone><SalesforceId i:nil="true"/><OriginalId>2963517</OriginalId><Street1/><Street2/><City/><State/><PostalCode/><Country/><CompanyName/><JobTitle/><CustomField1/><CustomField2/><CustomField3/><Culture>en-US</Culture><CustomField4/><CustomField5/><CustomField6/><CustomField7/><CustomField8/><CustomField9/><CustomField10/><SalesforceContactId i:nil="true"/><SalesforceAccountId i:nil="true"/><CreatedDate>2015-11-19T09:08:04Z</CreatedDate><Points>0</Points></User>');
	        res.setStatusCode(201);
	        return res;
		}
	}

	@isTest
	static void testGetLitmosUserIdSuccess() {
		Test.setMock(HttpCalloutMock.class, new GetLitmosUserIdSuccessResponse());
		Test.startTest();
		String userId = LitmosSSO.getLitmosUserId(new String[] { 'test@test.com' });
		Test.stopTest();
		system.assertEquals('ABC123', userId);
	}

	@isTest
	static void testGetLitmosUserIdNoResults() {
		Test.setMock(HttpCalloutMock.class, new GetLitmosUserIdNoResultsResponse());
		Test.startTest();
		String userId = LitmosSSO.getLitmosUserId(new String[] { 'test@test.com' });
		Test.stopTest();
		system.assertEquals(null, userId);
	}
	
	global class GetLitmosUserIdSuccessResponse implements HttpCalloutMock {
		global HttpResponse respond(HttpRequest httpRequest) {
			HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml');
	        res.setBody('<Users xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><User><Id>ABC123</Id><UserName>test@test.com</UserName><FirstName>TEST</FirstName><LastName>TEST</LastName><Active>true</Active><Email>test@test.com</Email><AccessLevel>Administrator</AccessLevel></User></Users>');
	        res.setStatusCode(200);
	        return res;
		}
	}

	global class GetLitmosUserIdNoResultsResponse implements HttpCalloutMock {
		global HttpResponse respond(HttpRequest httpRequest) {
			HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml');
	        res.setBody('<Users xmlns:i="http://www.w3.org/2001/XMLSchema-instance"/>');
	        res.setStatusCode(200);
	        return res;
		}
	}

	@isTest
	static void testGetLitmosLoginKeySuccess() {
		Test.setMock(HttpCalloutMock.class, new GetLitmosLoginKeySuccessResponse());
		Test.startTest();
		String loginKey = LitmosSSO.getLitmosSSOUrl('ABC123');
		Test.stopTest();
		system.assertEquals('https://continuitypartnerportal.litmos.com//login.aspx?loginkey=4b4b5ca3-d9eb-41c4-8a70-d3283ccdca99', loginKey);
	}

	global class GetLitmosLoginKeySuccessResponse implements HttpCalloutMock {
		global HttpResponse respond(HttpRequest httpRequest) {
			HttpResponse res = new HttpResponse();
	        res.setHeader('Content-Type', 'text/xml');
	        res.setBody('<User xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><LoginKey>https://continuitypartnerportal.litmos.com//login.aspx?loginkey=4b4b5ca3-d9eb-41c4-8a70-d3283ccdca99</LoginKey></User>');
	        res.setStatusCode(200);
	        return res;
		}
	}
}