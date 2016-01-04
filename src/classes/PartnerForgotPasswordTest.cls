@isTest
private class PartnerForgotPasswordTest {
	
	@isTest static void test_forgot_password() {
		PartnerForgotPassword pfp = new PartnerForgotPassword();

		User u = [SELECT Id, Username FROM User WHERE Id = :UserInfo.getUserId()];
		pfp.username = u.Username;

		PageReference pr = pfp.forgotPassword();
		// Forgot password is expected to fail for the test user
		System.assertEquals(null, pr);
	}
	
}