@isTest
private class DealExtensionRequestTriggerHandlerTest {

    static LeadStatus convertStatus {
        get {
            if(convertStatus == null) {
                convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            }
            return convertStatus ;
        }
        set ;
    }

	
	@isTest static void DealExtensionRequestTriggerHandler_success() {
         Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
        //insert user
        string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
        User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
        insert usr;
        
        system.runas(usr)
        {
        	Lead l = new Lead() ;
        	l.LastName = 'Tom' ;
        	l.Company = 'From' ;
        	insert l ;

            List<Database.LeadConvert> lcList = new List<Database.LeadConvert>();
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(l.id);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            lcList.add(lc) ;
            List<Database.LeadConvertResult> lcrList = Database.convertLead(lcList);

            l = [
            	SELECT
            		IsConverted,
            		ConvertedOpportunityId
            	FROM
            		Lead
            	WHERE id = :l.id 
            ] ;

            Opportunity o = [
            	SELECT
            		Name,
            		Exp_Date__c
            	FROM
            		Opportunity
            	WHERE Id = :l.ConvertedOpportunityId
            ] ;
            o.Exp_Date__c = System.Today() ;
            update o ;

            Deal_Extension_Request__c der = new Deal_Extension_Request__c() ;
            der.Opportunity__c = l.ConvertedOpportunityId ;
            der.Reason_for_extension_request__c = 'fred' ;
            der.Requested_Extension_Length__c = 60 ;
            der.Approved__c = false ;
            insert der ;

			Test.startTest();
            der.Approved__c = true ;
            update der ;

            o = [
            	SELECT
            		Name,
            		Exp_Date__c
            	FROM
            		Opportunity
            	WHERE Id = :o.Id
            ] ;

            System.assertEquals(System.Today().addDays(60), o.Exp_Date__c);
       	}
	}
	
}