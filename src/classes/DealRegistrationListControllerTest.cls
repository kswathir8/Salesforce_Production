@isTest
private class DealRegistrationListControllerTest {
	static boolean runAllTests = true ;
	
	@isTest static void DealRegistrationListController() {
		if(!runAllTests) return ;
        Test.setCurrentPage(Page.DealRegistrationList);

		DealRegistrationListController drlc = new DealRegistrationListController() ;
		PageReference pg = drlc.extendDeal() ;
		System.assertEquals(Page.RequestExtension.getURL(), pg.getURL()) ;
	}
	
}