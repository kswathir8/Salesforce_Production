@isTest
private class PartnerLoginControllerTest {
	
	@isTest static void test_partner_login_controller() {
		PartnerLoginController plc = new PartnerLoginController();

		plc.username = 'testuser';
		plc.password = 'testpassword';

		PageReference pr = plc.forwardToCustomAuthPage();
		System.assertNotEquals(null, pr);

		// Login will fail in unit test
		pr = plc.login();
		System.assertEquals(null, pr);
	}
	
}