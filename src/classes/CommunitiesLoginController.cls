/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
    }
    
    global PageReference forwardToCustomPartnerAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        String ec = System.currentPageReference().getParameters().get('ec');
        String inst = System.currentPageReference().getParameters().get('inst');
        PageReference pr = Page.PartnerLogin;
        pr.getParameters().put('startURL', startURL);
        pr.getParameters().put('displayType', displayType);
        pr.getParameters().put('ec', ec);
        pr.getParameters().put('inst', inst);
        return pr;
    }
}