@isTest
private class PartnerChatterTest {
	
	@isTest static void test_partner_chatter() {
		PartnerChatter pc = new PartnerChatter();
		System.assertNotEquals(null, pc.user);
	}
	
}