@isTest
private class PartnerDashboardTest {
	
	@isTest static void test_partner_dashboard() {
		PartnerDashboard pd = new PartnerDashboard();
		System.assertEquals(null, pd.account);
		System.assertEquals(false, pd.isEndUser);
	}
	
}