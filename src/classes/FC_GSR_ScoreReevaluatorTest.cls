@isTest (SeeAllData=false)
public class FC_GSR_ScoreReevaluatorTest {

    static testMethod void testRescoreReevaluationOnActiveContact() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');  
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();    
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Contact> cts = initTestContacts('cts', 1);        
        cts[0].FCRM__FCR_Status__c = activeStatusMaps.values()[0].Name;
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());
        insert camps;        
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], ContactID = cts[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        cts[0].put(setting.Contact_Trigger_Field__c, 'new value');
        Test.startTest();
        update cts[0];
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == activeStatusMaps.values()[0].Response_Status_To_Set__c);             
    }
    
    static testMethod void testRescoreReevaluationOnInactiveContact() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');  
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();    
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Contact> cts = initTestContacts('cts', 1);        
        cts[0].FCRM__FCR_Status__c = 'Test Inactive Status';
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());
        insert camps;        
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], ContactID = cts[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        cts[0].put(setting.Contact_Trigger_Field__c, 'new value');
        Test.startTest();
        update cts[0];
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == setting.Response_Status_To_Set__c);             
    }    
    
    static testMethod void testInsertDefaultCampaign() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default'); 
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();     
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Contact> cts = initTestContacts('cts', 1);
        cts[0].FCRM__FCR_Status__c = 'Test Inactive Status';
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());        
        insert camps;  
              
        setting.Default_Campaign_ID__c = camps[0].Id;
        upsert setting;                
        
        cts[0].put(setting.Contact_Trigger_Field__c, 'new value');
        Test.startTest();
        update cts[0];
        Test.stopTest();
                
        List<CampaignMember> responses = [Select FCRM__FCR_Response_Status__c From CampaignMember Where ContactId = :cts[0].Id];
               
        system.assert(responses.size() > 0);             
    }              
    
    static testMethod void testRescoreReevaluationOnContactAsync() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();
    	
    	// Register Plugin            
        installPlugin('FC_GSR_AsyncPlugin');              
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Contact> cts = initTestContacts('cts', 1);        
        insert cts;
        
        List<Campaign> camps = initTestCampaigns('cmp', cts.size());
        insert camps;        
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], ContactID = cts[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        // Make contact have an inactive status
        FCRM.FCR_SupportAPI.DisableApplicationForContext();
        cts[0].FCRM__FCR_Status__c = 'Test Inactive Status';
        update cts[0];
        FCRM.FCR_SupportAPI.UndoDisableApplicationForContext();
        
        FC_GSR_AsyncPlugin plugin = new FC_GSR_AsyncPlugin();
        Test.startTest();
        plugin.ExtensibilityEvent('TimedAsync', getArgs(new List<Id>{cts[0].Id}));
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == setting.Response_Status_To_Set__c);             
    }    
    
    static testMethod void testRescoreReevaluationOnConvertedLead() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');  
    	setting.Follow_Converted_Lead__c = true; 
    	upsert setting;   
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Lead> lds = initTestLeads('lds', 1);
        insert lds;
        
        List<Campaign> camps = initTestCampaigns('cmp', lds.size());
        insert camps;         
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], LeadID = lds[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        // Convert the Lead
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setOwnerId(UserInfo.getUserId());
        lc.setLeadId(lds[0].id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);         
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        // Make sure created lead has an inactive status
        Contact convertedContact = [Select Id, OwnerId, FCRM__FCR_Status__c From Contact Where Id = :lcr.getContactId()];
        FCRM.FCR_SupportAPI.DisableApplicationForContext();
        convertedContact.FCRM__FCR_Status__c = 'Test Inactive Status';
        convertedContact.OwnerId = UserInfo.getUserId();
        update convertedContact;
        FCRM.FCR_SupportAPI.UndoDisableApplicationForContext();                      
        
        FC_GSR_AsyncPlugin plugin = new FC_GSR_AsyncPlugin();
        Test.startTest();
		plugin.ExtensibilityEvent('TimedAsync', getArgs(new List<Id>{lds[0].Id}));
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == setting.Response_Status_To_Set__c);             
    }       
    
    static testMethod void testRescoreReevaluationOnInactiveLead() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');      
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Lead> lds = initTestLeads('lds', 1);
        lds[0].Status = activeStatusMaps.values()[0].Name;
        insert lds;
        
        List<Campaign> camps = initTestCampaigns('cmp', lds.size());
        insert camps;        
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], LeadID = lds[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        lds[0].put(setting.Lead_Trigger_Field__c, 'new value');
        Test.startTest();
        update lds[0];
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == activeStatusMaps.values()[0].Response_Status_To_Set__c);             
    }    
    
    static testMethod void testRescoreReevaluationOnActiveLead() 
    {
    	FCRM.FCR_SupportAPI.SetRepeatResponseUserForContext();
    	
    	// Get custom setting
    	RM_Score_Evaluation_Setting__c setting = getCustomSetting('default');      
    	Map<String, FC_GSR_Active_Status_Map__c> activeStatusMaps = getActiveStatusMaps();
        
        // Bypass scoring requirement because scoring field not visible in test
        FC_GSR_ScoreReevaluator.bypassScoreRequirement = true;
        
        List<Lead> lds = initTestLeads('lds', 1);
        lds[0].Status = 'Test Inactive Status';
        insert lds;
        
        List<Campaign> camps = initTestCampaigns('cmp', lds.size());
        insert camps;        
        
        List<String> unanimatedStatusValues = setting.Response_Status_Values__c.split(';');
        CampaignMember cm = new CampaignMember(Status='Responded', FCRM__FCR_Response_Date__c=Date.today() - 2, FCRM__FCR_Response_Status__c = unanimatedStatusValues[0], LeadID = lds[0].id, CampaignID = camps[0].id);        
        
        insert cm;
        
        lds[0].put(setting.Lead_Trigger_Field__c, 'new value');
        Test.startTest();
        update lds[0];
        Test.stopTest();
                
        CampaignMember response = [Select FCRM__FCR_Response_Status__c From CampaignMember Where Id = :cm.Id];
               
        system.assert(response.FCRM__FCR_Response_Status__c == setting.Response_Status_To_Set__c);             
    }  
    // Args class used for testing the plugin
    public Class Args implements FCRM.FCR_ExtensibilityAPI.IExtensibilityEventArgs
    {
        public List<List<Sobject>> Recordlists;
        public List<Map<ID, Sobject>> RecordMaps;
        public List<List<ID>> RecordIds;
        
        public List<List<Sobject>> getRecordLists() { return RecordLists; }
        public List<Map<ID, Sobject>> getRecordMaps() { return RecordMaps; }
        public List<List<ID>> getRecordIds() { return RecordIds; }
        public List<Object> getAdditionalParams() {return null; }
        public void setRaiseFuture() {  }
        public String getXMLdata() {
            List<String> personIdList = new List<String>();
            for (String id : this.getRecordIds()[0]) personIdList.add(id);          
            return String.valueOf(Datetime.now().addMinutes(5)) + ';' + String.join(personIdList, ',');
        }
        
        public Args(){}
                
    } 
    
    public static Args getArgs(List<Id> taskIdList) 
    {
        Args args = new Args();
        args.RecordIds = new List<List<Id>>();
        args.RecordIds.add(taskIdList);
        return args;
    }    

    public static RM_Score_Evaluation_Setting__c getCustomSetting(String name)
    {    	
    	RM_Score_Evaluation_Setting__c setting = RM_Score_Evaluation_Setting__c.getInstance(name);
    	if (setting == null) setting = new RM_Score_Evaluation_Setting__c(name = name); 
		setting.Lead_Status_after_Response__c = 'Open - Not Contacted';
		setting.Contact_Status_after_Response__c = 'Open - Not Contacted';
		setting.Response_Status_To_Set__c = 'Open - Not Contacted';
		setting.Default_Member_Status__c = 'Responded';
		setting.Contact_Trigger_Field__c = 'Title';
		setting.Lead_Trigger_Field__c = 'Industry';    	
		setting.Response_Status_Values__c = 'Resolved - Already Engaged;Resolved - No Action Required';
		setting.Time_Delay_for_Evaluation__c = 0;
		setting.Owners_Subject_to_Assignment__c = UserInfo.getUserId();
    	upsert setting; 
    	return setting;
    } 
        
    public static Map<String, FC_GSR_Active_Status_Map__c> getActiveStatusMaps()
    {
    	Map<String, FC_GSR_Active_Status_Map__c> activestatusmap = FC_GSR_Active_Status_Map__c.getAll();
    	if (activestatusmap.size() == 0)
    	{
    		activestatusmap = new Map<String, FC_GSR_Active_Status_Map__c>{'Nurture/Marketing' => new FC_GSR_Active_Status_Map__c(
    				name='Nurture/Marketing', 
    				Response_Status_To_Set__c='Open - Not Contacted', 
    				Funnel_Fields__c='FCRM__FCR_QR__c,FCRM__FCR_QR_Date__c')};
    		insert activestatusmap.values();
    	}
    	return activestatusmap;    	
    }    
    
    public static void installPlugin(String pluginname)
    {
        FCRM.FCR_ExtensibilityAPI.EnablePluginsForTest = new Set<String>{pluginname};
        FCRM.FCR_ExtensibilityAPI.InstallPluginClass(pluginname);
    }    

    public static List<Contact> initTestContacts(String prefix, Integer count)  
    {    
        List<Contact>cts = new List<Contact>();    
        for(Integer x=1;x<count+1;x++)    
        {      
          cts.add(new Contact(LastName = prefix + '_' + String.valueOf(x)));
        }
        return cts;  
    }
    
    public static List<Account> initTestAccounts(String prefix, Integer count)
    {
	  List<Account> accounts = new List<Account>();
	  for(Integer x=1; x<count + 1; x++)
	  {
	    accounts.add(new Account(Name= prefix + '_' + String.valueOf(x)));    
	  }
	  return accounts;
    }
    
   public static List<Lead> initTestLeads(String prefix, Integer count)  
   {    
		List<Lead>lds = new List<Lead>();    
		for(Integer x=1;x<count+1;x++)    
		{      
		  lds.add(new Lead(Company= prefix + '_' + String.valueOf(x), OwnerId = UserInfo.getUserId(), LastName = prefix + '_' + String.valueOf(x), Status='Nurture/Marketing'));    
		}    
		return lds;  
   }    
        
    
    public static List<Campaign> initTestCampaigns(String prefix, Integer count)
    {
        List<Campaign> camps = new List<Campaign>();
        for(Integer x=1; x<count+1; x++)
        {
          camps.add(new Campaign(Name = prefix+'_'+ String.ValueOf(x), FCRM__FCR_Repeat_Responses_Allowed__c=true, IsActive = true));
        }
        return camps;
    }    

}