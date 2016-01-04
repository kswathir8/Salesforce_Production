public with sharing class FC_GSR_ScoreReevaluator {

	public static Boolean bypassScoreRequirement = false;

    public static void requestHandler(Map<Id, sObject> personRecs, Map<Id, sObject> oldPersonRecs)
    {    	
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');
    	if (setting==null) return;
    	
    	List<Id> personIds = new List<Id>(personRecs.keySet());
    	String firstPersonId = personIds[0];
    	String personType = firstPersonId.startsWith('003') == true ? 'Contact' : 'Lead';  	
    	String monitoredFieldName =  personType == 'Contact' ? setting.Contact_Trigger_Field__c : setting.Lead_Trigger_Field__c; 
    	String scoringField = FCRM.FCR_SupportAPI.GetScoringInfo(personType);
    	    	
    	Map<Id, sObject> personsToProcess = new Map<Id, sObject>();    	
        for (sObject person : personRecs.values())
        {
        	// Verify scoring fields and the system's threshold value aren't null and that the monitoring field has been changed, unless the records aren't being checked for being at threshold again 
        	if(monitoredFieldName != null && (person.get(monitoredFieldName) != oldPersonRecs.get((Id)person.get('Id')).get(monitoredFieldName) && person.get(monitoredFieldName) != null && person.get(monitoredFieldName) != false))
        	{
        		if (bypassScoreRequirement || IsAtThreshold(person, personType, null, null))
        		{
        			personsToProcess.put((Id)person.get('Id'), person);	
        		}    			
        	}
        } 
        
        system.debug('personsToProcess' + personsToProcess);        
        
        if (personsToProcess==null || personsToProcess.size() == 0) return;
        
    	List<String> personIdList = new List<String>();
    	for (String id : personsToProcess.keySet()) personIdList.add(id);    
    	    
        if (setting.Time_Delay_for_Evaluation__c > 0 && !Test.isRunningTest())
        {        	        	
            FCRM.FCR_SupportAPI.ScheduleAsyncOperation(
                'FC_GSR_AsyncPlugin', 
                Datetime.now().addMinutes((Integer)setting.Time_Delay_for_Evaluation__c), 
                String.valueOf(Datetime.now()) + ';' + String.join(personIdList, ',')
            );        	
        }
        else processPersonRecords(personsToProcess, personType, false, Test.isRunningTest() ? Datetime.now().addMinutes(5) : Datetime.now());
    } 
    
    public static Boolean IsAtThreshold(sObject personRec, String personType, Campaign camp, CampaignMember response)
    {
    	String scoringField = FCRM.FCR_SupportAPI.GetScoringInfo(personType);
    	if (scoringField == null || personRec.get(scoringField) == null || FCRM.FCR_SupportAPI.GetEvaluationThreshold() == null) return false;
    	 
    	String scoringFieldCamp = FCRM.FCR_SupportAPI.GetScoringInfo('Campaign');
    	String scoringFieldCampMemb = FCRM.FCR_SupportAPI.GetScoringInfo('CampaignMember');    	    	
		Decimal subtractAmntFromScore = 0;  
		Decimal addAmntToScore = 0;      			
		if (personRec.get('FCRM__FCR_Prior_' + personType + '_Score__c') != null)
		{
			subtractAmntFromScore = (Decimal)personRec.get('FCRM__FCR_Prior_' + personType + '_Score__c');
			if (personRec.get('FCRM__FCR_Response_Score__c') != null)
			{
				addAmntToScore = (Decimal)personRec.get('FCRM__FCR_Response_Score__c'); 	
			}
		}
		Decimal currentScore = (Decimal)personRec.get(scoringField) - subtractAmntFromScore + addAmntToScore;
		if (camp != null && scoringFieldCamp != null && camp.get(scoringFieldCamp) != null) currentScore += (Decimal)camp.get(scoringFieldCamp);
		if (response != null && scoringFieldCampMemb != null && response.get(scoringFieldCampMemb) != null) currentScore += (Decimal)response.get(scoringFieldCampMemb);
		if (currentScore >= (Decimal)FCRM.FCR_SupportAPI.GetEvaluationThreshold())
		{
			return true;		
		}
		return false; 
    }     
    
    public static void processPersonRecords(Map<Id, sObject> personsToProcess, String personType, Boolean isAsyncContext, DateTime timeBeforeTimeDelay)
    {    	
    	system.debug('personsToProcess0' + personsToProcess);
    	system.debug('isAsyncContext' + isAsyncContext);
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');
    	if (setting==null) return;
    	
    	Map<Id, sObject> personRecs = personsToProcess.deepClone();
    	Set<Id> convertedContactIds = new Set<Id>();
    	if (isAsyncContext && personType == 'Lead')
    	{
    		List<Lead> convertedLeads = [Select Id, ConvertedContactId From Lead Where IsConverted = true and Id IN :personRecs.keySet()];
    		for (Lead l : convertedLeads) 
    		{
    			personsToProcess.remove(l.Id);
    			if (setting.Follow_Converted_Lead__c) convertedContactIds.add(l.ConvertedContactId);
    		}
    		if (convertedContactIds.size() > 0)
    		{     
	    		Map<Id, sObject> convertedContactsToProcess = new Map<Id, sObject>([Select Id, OwnerId, FCRM__FCR_Admin_Update_Counter__c, FCRM__FCR_Nurture_Timeout__c, FCRM__FCR_Status__c From Contact Where Id IN :convertedContactIds]);
	    		processPersonRecords(convertedContactsToProcess, 'Contact', false, timeBeforeTimeDelay);       			
    		}
    	}
    	
    	if (personsToProcess.size() == 0) return; 
    	
    	system.debug('personsToProcess2' + personsToProcess);
    	
        // Remove records that have an active response 
        // ------------------------------------------------------------------------------------------------------------------------------------
        List<Id> personRecIds = new List<Id>();
        for (Id personRecId : personsToProcess.keySet()) personRecIds.add(personRecId);    	
		Map<Id, CampaignMember> activeResponses = new Map<Id, CampaignMember>(FCRM.FCR_SupportAPI.GetActiveResponses(personRecIds));		
		Map<Id, CampaignMember> activeAndOppActiveResponses = new Map<Id, CampaignMember>(FCRM.FCR_SupportAPI.GetActiveAndOpActiveResponses(personRecIds));

		for (CampaignMember cm : activeResponses.values())
		{
			Id personId = cm.ContactId != null ? cm.ContactId : cm.LeadId;
			if (personsToProcess.containsKey(personId)) personsToProcess.remove(personId);
		}    
		
		if (personsToProcess.size() == 0) return;
		
		system.debug('personsToProcess3' + personsToProcess);
		
		// Previously active response that was created during the time delay
		// ------------------------------------------------------------------------------------------------------------------------------------
		Datetime minResponseDate = DateTime.now().addDays((Integer)setting.Search_Timeframe_Days__c * -1).addMinutes((Integer)setting.Search_Timeframe_Minutes__c * -1);		
			
		system.debug('minResponseDate' + minResponseDate);		
		
		List<String> invalidPrevActiveResponseStatuses = new List<String>{'Not a Response', 'Resolved - Non-Response RT'};
		Datetime myDate2 = Date.today();	
				
		system.debug('timeBeforeTimeDelay' + timeBeforeTimeDelay);		
		system.debug('personRecIds' + personRecIds);				
		List<CampaignMember> prevActiveResponses = [Select Id, ContactId, LeadId, FCRM__FCR_Response_Date__c, FCRM__FCR_Status_Last_Set__c, FCRM__FCR_Response_Status__c From CampaignMember Where (FCRM__FCR_Response_Date__c >= :timeBeforeTimeDelay or FCRM__FCR_Status_Last_Set__c >= :timeBeforeTimeDelay) 
			and FCRM__FCR_Response_Status__c NOT IN :invalidPrevActiveResponseStatuses and (ContactId IN :personRecIds or LeadId IN :personRecIds)];
			
		system.debug('prevActiveResponses' + prevActiveResponses);
					
		for (CampaignMember cm : prevActiveResponses)
		{
			Id personId = cm.ContactId != null ? cm.ContactId : cm.LeadId;
			if (personsToProcess.containsKey(personId)) personsToProcess.remove(personId);
		}   		    
        
        if (personsToProcess.size() == 0) return;
        
        system.debug('personsToProcess4' + personsToProcess);

		// If Contacts_Allowed_Additional_Response__c = true, a response can be opened up if the contact has an opportunity active response.
		// ------------------------------------------------------------------------------------------------------------------------------------
		for (Id cmId : activeAndOppActiveResponses.keySet())
		{
			CampaignMember cm = activeAndOppActiveResponses.get(cmId); 
			Id personId = cm.ContactId != null ? cm.ContactId : cm.LeadId;
			if (personsToProcess.containsKey(personId) && !activeResponses.containsKey(cmId) && !setting.Contacts_Allowed_Additional_Response__c)
				personsToProcess.remove(personId);
		}
		
		if (personsToProcess.size() == 0) return;        

		system.debug('personsToProcess5' + personsToProcess);

		// Fetch unopened responses
		// ------------------------------------------------------------------------------------------------------------------------------------
		Set<String> unopenStatusValues = new Set<String>(setting.Response_Status_Values__c.split(';'));		 		

		Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = FC_GSR_Active_Status_Map__c.getAll();
		
		// Set of all the funnel fields mapped in active status map settings
		Set<String> mappedFunnelFields = new Set<String>();
		List<String> mappedFunnelFieldsList = new List<String>();
		for (FC_GSR_Active_Status_Map__c asm : activeStatusMaps.values())
		{
			if (asm.Funnel_Fields__c != null) 
			{
				for (String funnelField : asm.Funnel_Fields__c.split(','))
				{
					if (!mappedFunnelFields.contains(funnelField))
					{
						mappedFunnelFields.add(funnelField);
						mappedFunnelFieldsList.add(funnelField);
					}
				}
			}
		}
		Set<Id> personIdsToProcess = personsToProcess.keySet();
		if (!mappedFunnelFields.contains('FCRM__FCR_TQR__c')) mappedFunnelFieldsList.add('FCRM__FCR_TQR__c');
		String scoringFieldCampMemb = FCRM.FCR_SupportAPI.GetScoringInfo('CampaignMember');
		String unopenedResponsesQueryString = 'Select Id, ContactId, LeadId, FCRM__FCR_Response_Date__c, ' +
			(mappedFunnelFieldsList.size() > 0 ? (String.join(mappedFunnelFieldsList, ', ') + ', ') : '') +
            (scoringFieldCampMemb != null ? scoringFieldCampMemb + ', ' : '') + 'FCRM__FCR_Response_Status__c, CampaignId, CRCR_Rescored_Date__c, FCRM__FCR_First_Owner_Type__c, FCRM__FCR_First_Owner_Assigned__c, FCRM__FCR_First_Queue_Assigned__c From CampaignMember ' + 
            'Where LeadId IN :personIdsToProcess or ContactId IN :personIdsToProcess ' +
            'Order By FCRM__FCR_Response_Date__c DESC';
        List<CampaignMember> unopenedResponses = Database.query(unopenedResponsesQueryString);  
        
        system.debug('unopenedResponses' + unopenedResponses);
        
    	Set<Id> contactIdsToOpen = new Set<Id>();
    	Set<Id> leadIdsToOpen = new Set<Id>(); 
    	Map<Id, Integer> changeFlagMap = new Map<Id, Integer>();
    	Map<Id, sObject> personRecsToUpdate = new Map<Id, sObject>();    
    	Map<Id, CampaignMember> responsesToUpdate = new Map<Id, CampaignMember>();
    	Set<Id> campaignIds = new Set<Id>();
    	for (CampaignMember cm : unopenedResponses) campaignIds.add(cm.CampaignId);
    	String scoringFieldCamp = FCRM.FCR_SupportAPI.GetScoringInfo('Campaign');
    	Id defaultCampId = (Id)setting.Default_Campaign_ID__c;
    	List<Campaign> campaignsList = Database.query('Select Id, ' + (scoringFieldCamp != null ? scoringFieldCamp + ', ' : '') + 'FCRM__FCR_Bypass_Nurture_Timeout__c From Campaign Where Id IN :campaignIds or Id = :defaultCampId'); 
    	Map<Id, Campaign> campaignsById = new Map<Id, Campaign>(campaignsList);    	
    	
        for (CampaignMember cm : unopenedResponses)
        {
            if (cm.FCRM__FCR_Response_Date__c >= minResponseDate 
            	&& unopenStatusValues.contains(cm.FCRM__FCR_Response_Status__c) 
            	&& !contactIdsToOpen.contains(cm.ContactId) && !leadIdsToOpen.contains(cm.LeadId) 
            	&& cm.CRCR_Rescored_Date__c == null)
            {
            	Id personRecId;
            	String statusFieldName;             	
            	
            	if (personType == 'Contact')
            	{
            		contactIdsToOpen.add(cm.ContactId);
            		personRecId = cm.ContactId;
            		statusFieldName = 'FCRM__FCR_Status__c';
            	}
            	else
            	{
            		leadIdsToOpen.add(cm.LeadId);
            		personRecId = cm.LeadId;
            		statusFieldName = 'Status';
            	}
				
				sObject personRec = personRecs.get(personRecId);
				system.debug('personRec' + personRec);          					            	            	

            	// If there was a time delay, check whether lead/contact is at threshold again
            	// Check if nurture timeout applies and isn't bypassed
            	if ((!bypassScoreRequirement && setting.Time_Delay_for_Evaluation__c > 0 && !IsAtThreshold(personRec, personType, campaignsById.get(cm.CampaignId), cm))
            		|| ((Date)personRec.get('FCRM__FCR_Nurture_Timeout__c') > Date.today() && campaignsById.get(cm.CampaignId).FCRM__FCR_Bypass_Nurture_Timeout__c == false)) continue;
            	
            	// Remove person rec because it has a response to reopen
            	personsToProcess.remove(personRecId);        	 
            					
				cm.CRCR_Rescored_Date__c = DateTime.now();
				cm.FCRM__FCR_Status_Last_Set__c = DateTime.now();
				cm.FCRM__FCR_TQR__c = true;		
				cm.FCRM__FCR_First_Owner_Type__c = ((String)personRec.get('OwnerId')).startsWith('005') ? 'User' : 'Queue';
				if (cm.FCRM__FCR_First_Owner_Type__c == 'User') cm.FCRM__FCR_First_Owner_Assigned__c = (Id)personRec.get('OwnerId');
				else if (cm.FCRM__FCR_First_Owner_Type__c == 'Queue') cm.FCRM__FCR_First_Queue_Assigned__c = (Id)personRec.get('OwnerId');
				FC_GSR_Active_Status_Map__c activeStatusMap;							
												
				// If person status is Active		
				if (activeStatusMaps.size() > 0 && activeStatusMaps.containsKey((String)personRec.get(statusFieldName)))
				{
					activeStatusMap = activeStatusMaps.get((String)personRec.get(statusFieldName));
					cm.FCRM__FCR_Response_Status__c = activeStatusMap.Response_Status_To_Set__c;
					cm.FCRM__FCR_First_Owner_Worked__c = (Id)personRec.get('OwnerId');
				}	
				// If person status is not Active	
				else
				{
					for (FC_GSR_Active_Status_Map__c statusMap : activeStatusMaps.values()) if (statusMap.Response_Status_To_Set__c == setting.Response_Status_To_Set__c) activeStatusMap = statusMap;
					cm.FCRM__FCR_Response_Status__c = setting.Response_Status_To_Set__c;
	                changeFlagMap.put(personRecId, 4); // Source sync field has changed                     
	                personRecsToUpdate.put(personRecId, personRec); // Person records will have their status updated						
				}	
				
				// Set funnel fields
				if (activeStatusMap != null && activeStatusMap.Funnel_Fields__c != null)
				{
					List<String> funnelFieldNames = activeStatusMap.Funnel_Fields__c.split(',');	 		 		
					Map<String, Schema.SObjectField> cmFieldMap = Schema.SObjectType.CampaignMember.fields.getMap();					
        			for (String fieldName : funnelFieldNames)
        			{
        				// Set Fields listed in Active Status Funnel Map for the Active Status to either (Today) For Date fields, or (True) for Boolean Fields. Any field not of those types should be ignored
    					Schema.DescribeFieldResult fieldDesc = cmFieldMap.get(fieldName).getDescribe();
    					if (fieldDesc.getType() == DisplayType.DATE) cm.put(fieldName, Date.today());
    					else if (fieldDesc.getType() == DisplayType.BOOLEAN) cm.put(fieldName, true);
        			} 						
				} 						
											
				responsesToUpdate.put(cm.Id, cm);										 
            }
        }                 
        
        // personsToProcess is now the set of person Ids that don't have a response to reopen.
        // If Default Campaign Id is populated in the custom setting, then insert new response with default campaign associated
        // ------------------------------------------------------------------------------------------------------------------------------------
        if (setting.Default_Campaign_ID__c != null && setting.Default_Member_Status__c != null && personsToProcess.size() > 0)
        {
        	List<CampaignMember> cmsWithDefaultCampaignToInsert = new List<CampaignMember>();
        	for (Id personId : personsToProcess.keySet())
        	{
        		sObject personRec = personRecs.get(personId);
        		// Skip if person status is active
        		String statusFieldName = personType == 'Contact' ? 'FCRM__FCR_Status__c' : 'Status';
				if (activeStatusMaps.size() > 0 && activeStatusMaps.containsKey((String)personRec.get(statusFieldName))) continue;
        		// Check if nurture timeout applies and isn't bypassed
            	if ((Date)personRec.get('FCRM__FCR_Nurture_Timeout__c') > Date.today() && campaignsById.get(setting.Default_Campaign_ID__c).FCRM__FCR_Bypass_Nurture_Timeout__c == false) continue; 
            		       		
        		CampaignMember cm = new CampaignMember(
        			Status='Responded', 
        			FCRM__FCR_Response_Date__c=DateTime.now(), 
        			FCRM__FCR_Response_Status__c=setting.Default_Member_Status__c,  
        			CampaignID = setting.Default_Campaign_ID__c,
        			FCRM__FCR_Admin_Response_Control__c = 2
        		);
        		if (personType == 'Contact') cm.ContactId = personId;
        		else if (personType == 'Lead') cm.LeadId = personId;
        		
            	// If there was a time delay, check whether lead/contact is at threshold again
            	if (!bypassScoreRequirement && setting.Time_Delay_for_Evaluation__c > 0 && !IsAtThreshold(personRec, personType, campaignsById.get(setting.Default_Campaign_ID__c), null)) continue;       		
        		
        		cmsWithDefaultCampaignToInsert.add(cm);
        	}
        	if (cmsWithDefaultCampaignToInsert.size() > 0)
        	{
        		try {
        			system.debug('cmsWithDefaultCampaignToInsert' + cmsWithDefaultCampaignToInsert);
        			Database.insert(cmsWithDefaultCampaignToInsert, false);
        		} catch (Exception e) {
        			// When system tries to insert repeat but repeats aren't allowed
        			system.debug(e.getMessage());
        		}
        	} 
        }
        
        system.debug('responsesToUpdate' + responsesToUpdate);
        
        if (responsesToUpdate.size() > 0)
        {           
            
            FCRM.FCR_SupportAPI.DisableApplicationForContext();
                        
            update responsesToUpdate.values();
            
            Database.DMLOptions dmo;
	        for (sObject obj : personRecsToUpdate.values())
	        {           
                if (personType == 'Contact') obj.put('FCRM__FCR_Status__c', setting.Contact_Status_after_Response__c);
                else 
	        	{
	        		obj.put('Status', setting.Lead_Status_after_Response__c);
	        		if (setting.Owners_Subject_to_Assignment__c != null)
	        		{	        			
	        			Set<String> ownersSubjectToAssignment = new Set<String>(setting.Owners_Subject_to_Assignment__c.split(';'));
	        			if (ownersSubjectToAssignment.contains(((String)obj.get('OwnerId')).left(15)))
	        			{
	        				dmo = new Database.DMLOptions();
	        				if (setting.Assignment_Rule__c != null) dmo.assignmentRuleHeader.assignmentRuleId = setting.Assignment_Rule__c;
							else dmo.assignmentRuleHeader.useDefaultRule = true;
							
	        			}
	        		}	        		
	        	}
                obj.put('FCRM__FCR_Admin_Update_Counter__c', (Decimal)obj.get('FCRM__FCR_Admin_Update_Counter__c') == null ? 1 : (Decimal)obj.get('FCRM__FCR_Admin_Update_Counter__c') + 1);
	        }

	        if (dmo != null && personType == 'Lead') 
	        {
	        	List<Lead> leadsToUpdate = (List<Lead>)personRecsToUpdate.values(); 
	        	Database.update(leadsToUpdate, dmo);
	        }
	        else update personRecsToUpdate.values();
	        
	        FCRM.FCR_SupportAPI.UndoDisableApplicationForContext();
	        
	        Set<Id> responsesToSync = new Set<Id>(responsesToUpdate.keySet());  
	        
	        system.debug('personRecsToUpdate' + personRecsToUpdate);
	        
            FCRM.FCR_SupportAPI.PerformResponseSync(
                personRecsToUpdate.keySet(), 
                responsesToSync, 
                personType == 'Lead' ? 0 : 1,
                changeFlagMap
            );  
        }      	
    } 
    
    public static RM_Score_Evaluation_Setting__c getCustomSetting(String name)
    {
    	RM_Score_Evaluation_Setting__c setting = RM_Score_Evaluation_Setting__c.getInstance(name);
    	if (setting == null)
    	{
	    	setting = new RM_Score_Evaluation_Setting__c(
				Lead_Status_after_Response__c = 'Open - Not Contacted',
				Contact_Status_after_Response__c = 'Open - Not Contacted',
				Response_Status_To_Set__c = 'Open - Not Contacted',
				Default_Member_Status__c = 'Responded',
				Contact_Trigger_Field__c = 'Title',
				Lead_Trigger_Field__c = 'Industry',    	
				Response_Status_Values__c = 'Resolved - Already Engaged,Resolved - No Action Required',
				Time_Delay_for_Evaluation__c = 0
	    	); 
	    	if (!Test.isRunningTest()) upsert setting;    		
    	}  
    	return setting;
    }     

}