global without sharing class FC_GSR_AsyncPlugin implements FCRM.FCR_ExtensibilityAPI.IExtensibilityPlugin  {

    public static final String TIMEDASYNC = 'TimedAsync';   
    
    global Set<String> RequestedAPIs() { return new Set<String>{TIMEDASYNC} ;}   

    global String GetUniqueName() { return 'FC_GSR_AsyncPlugin' ;}
    
    global Map<String,Set<String>> RequestedFields() 
    { 
        return new Map<String, Set<String>>();
    }    
    
    global void ExtensibilityEvent(String eventname, FCRM.FCR_ExtensibilityAPI.IExtensibilityEventArgs args) {

        if (eventname == TIMEDASYNC && args.getXMLdata() != null)
        {
        	List<String> dateAndPersonIds = args.getXMLdata().split(';');
        	DateTime timeBeforeTimeDelay = DateTime.now();
        	if (dateAndPersonIds[0] != '0')
        	{
        		try {
        			timeBeforeTimeDelay = DateTime.valueOf(dateAndPersonIds[0]);	
        		} catch (Exception e) {
        			system.debug(e.getMessage());
        		}
        	}
            List<String> personIds = dateAndPersonIds[1].split(',');
            system.debug('personIds' + personIds);
			String firstPersonId = personIds[0];
    		String personType = firstPersonId.startsWith('003') == true ? 'Contact' : 'Lead';
    		String scoringField = FCRM.FCR_SupportAPI.GetScoringInfo(personType);
    		String statusField = personType == 'Contact' ? 'FCRM__FCR_Status__c' : 'Status';
    		String queryStr = 'Select Id, FCRM__FCR_Admin_Update_Counter__c, OwnerId, FCRM__FCR_Nurture_Timeout__c, ' 
    			+ statusField + (scoringField != null ? ', ' + scoringField : '') + ' From ' + personType + ' Where Id IN :personIds';   
    		List<sObject> personsToProcessList = Database.query(queryStr);
    		system.debug('personsToProcessList' + personsToProcessList);    
    		Map<Id, sObject> personsToProcess = new Map<Id, sObject>(personsToProcessList);
    		system.debug('personsToProcess' + personsToProcess);   
    		FC_GSR_ScoreReevaluator.processPersonRecords(personsToProcess, personType, true, timeBeforeTimeDelay);
        } 
         
        return;
           
    }

}