public without sharing class TaskCounterSupport {

	private static Set<ID> filteredTaskIDs = null;

	public static void HandleTaskTrigger(List<Task>newList, Map<ID, Task>oldMap, Boolean isInsert)
	{
		List<Task> closedTasks = new List<Task>();
		Set<ID> contactIDs = new Set<ID>();
		Set<ID> leadIDs = new Set<ID>();
		set<String> allRoleNames = new Set<String>();
		
		Map<String, TaskCounterRoles__c> allConfiguredRoles = TaskCounterRoles__c.getAll();
		for(TaskCounterRoles__c cs: allConfiguredRoles.values()) allRoleNames.add(cs.Role__c);

		Map<ID, User> allowedUsers = new Map<ID, User>([Select ID from User where UserRole.Name in :allRoleNames]);
		for(Task t: newList) 
		{
			if(t.IsClosed && (isInsert || !oldMap.get(t.id).isClosed) && allowedUsers.containsKey(t.CreatedByID) && t.whoid!=null && (t.whoid.getSObjectType()==Schema.Contact.SObjectType || t.whoid.getSObjectType()==Schema.Lead.SObjectType) 
				&& (filteredTaskIDs==null || !filteredTaskIDs.contains(t.id)))
			{
				 closedTasks.add(t);
				 if(t.whoid.getSObjectType()==Schema.Contact.SObjectType) {
				 	contactIDs.add(t.whoid);
				 }
				 else
				 {
				 	leadIDs.add(t.whoid);
				 }
			}
		}

		if(closedTasks.size()==0) return;
		Map<ID, ID> refActiveResponses = getActiveResponsesForContacts(contactIDs);	
		Map<ID, ID> refActiveResponses2 = getActiveResponsesForLeads(leadIDs);
		refActiveResponses.putAll(refActiveResponses2);
		
		if(filteredTaskIDs==null) filteredTaskIDs = new Set<ID>();
		for(Task t: closedTasks)
		{
			if(refActiveResponses.containsKey(t.whoid)) filteredTaskIDs.add(t.id);
		}
		List<Task> tasksToUpdate = new List<Task>();
		tasksToUpdate = [Select ID, Whoid, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID in :filteredTaskIDs];
		Map<ID, CampaignMember> cmsToUpdate = new Map<ID, CampaignMember> ([Select ID, Campaign.Name, Activity_Counter__c from CampaignMember where ID in :refActiveResponses.values()]);
	
		for(Task t: tasksToUpdate)
		{
			t.Active_Response_ID__c = refActiveResponses.get(t.whoid);			
			t.Active_Response_Campaign__c = cmsToUpdate.get(refActiveResponses.get(t.whoid)).Campaign.Name;			
		}
		
		// Make sure our app doesn't do anything during these updates
		FCRM.FCR_SupportAPI.DisableApplicationForContext();
		
		update tasksToUpdate;
		for(CampaignMember cm: cmsToUpdate.values())
		{
			cm.Activity_Counter__c = (cm.Activity_Counter__c==null)? 1: cm.Activity_Counter__c+1;
		}
		update cmsToUpdate.values();

	}


	public static void HandleTaskAppointments(List<Task>newList)
	{
		List<Task> newAppointments = new List<Task>();
		Set<ID> contactIDs = new Set<ID>();
		Set<ID> leadIDs = new Set<ID>();

		for(Task t: newList) 
		{
			if(t.IsAppointment__c && t.whoid!=null && (t.whoid.getSObjectType()==Schema.Contact.SObjectType || t.whoid.getSObjectType()==Schema.Lead.SObjectType))
			{
				 newAppointments.add(t);
				 if(t.whoid.getSObjectType()==Schema.Contact.SObjectType) {
				 	contactIDs.add(t.whoid);
				 }
				 else
				 {
				 	leadIDs.add(t.whoid);
				 }
			}
		}
		if(newAppointments.size()==0) return;
		Map<ID, ID> refActiveResponses = getActiveResponsesForContacts(contactIDs);	
		Map<ID, ID> refActiveResponses2 = getActiveResponsesForLeads(leadIDs);
		refActiveResponses.putAll(refActiveResponses2);
		
		filteredTaskIDs = new Set<ID>();
		for(Task t: newAppointments)
		{
			if(refActiveResponses.containsKey(t.whoid)) filteredTaskIDs.add(t.id);
		}
		List<Task> tasksToUpdate = new List<Task>();
		tasksToUpdate = [Select ID, Whoid, Active_Response_ID__c, Active_Response_Campaign__c from Task where ID in :filteredTaskIDs];
		Map<ID, CampaignMember> cmsToUpdate = new Map<ID, CampaignMember> ([Select ID, Campaign.Name, Task_Appointments__c from CampaignMember where ID in :refActiveResponses.values()]);
	
		for(Task t: tasksToUpdate)
		{
			t.Active_Response_ID__c = refActiveResponses.get(t.whoid);			
			t.Active_Response_Campaign__c = cmsToUpdate.get(refActiveResponses.get(t.whoid)).Campaign.Name;			
		}
		
		// Make sure our app doesn't do anything during these updates
		FCRM.FCR_SupportAPI.DisableApplicationForContext();
		
		update tasksToUpdate;
		for(CampaignMember cm: cmsToUpdate.values())
		{
			cm.Task_Appointments__c = (cm.Task_Appointments__c==null)? 1: cm.Task_Appointments__c+1;
		}
		update cmsToUpdate.values();
	}


	// map of contact IDs to correct active response (if one exists)
	public static Map<ID, ID> getActiveResponsesForContacts(Set<ID> contactIDs)
	{
		Map<ID, ID> results = new Map<ID, ID>();
		Map<ID, CampaignMember> allCMS = new Map<ID, CampaignMember>(FCRM.FCR_SupportAPI.GetActiveAndOpActiveResponses(new List<ID>(contactIDs)));

		for(CampaignMember cm: allCMS.values())
		{
			if(!results.containsKey(cm.ContactID))
			{
				results.put(cm.ContactID, cm.id);
			}
			else
			{
				CampaignMember currentcm = allCMS.get(results.get(cm.ContactID));
				// If current isn't op active and new one is, or both are new one is older, swap
				if(currentcm.FCRM__FCR_Admin_Opportunity_Status__c==0 ||
				   (cm.FCRM__FCR_Admin_Opportunity_Status__c>0 && currentcm.FCRM__FCR_Response_Date__c > cm.FCRM__FCR_Response_Date__c ))
					results.put(cm.ContactID, cm.id);				   
			}
		}
		return results;
	}

	// map of lead IDs to correct active response (if one exists)
	public static Map<ID, ID> getActiveResponsesForLeads(Set<ID> leadIDs)
	{
		Map<ID, ID> results = new Map<ID, ID>();
		Map<ID, CampaignMember> allCMS = new Map<ID, CampaignMember>(FCRM.FCR_SupportAPI.GetActiveAndOpActiveResponses(new List<ID>(leadIDs)));

		for(CampaignMember cm: allCMS.values())
		{
			if(!results.containsKey(cm.LeadID))
			{
				results.put(cm.LeadID, cm.id);
			}
			else
			{
				CampaignMember currentcm = allCMS.get(results.get(cm.LeadID));
				// If current isn't op active and new one is, or both are new one is older, swap
				if(currentcm.FCRM__FCR_Admin_Opportunity_Status__c==0 ||
				   (cm.FCRM__FCR_Admin_Opportunity_Status__c>0 && currentcm.FCRM__FCR_Response_Date__c > cm.FCRM__FCR_Response_Date__c ))
					results.put(cm.LeadID, cm.id);				   
			}
		}
		return results;
	}

}