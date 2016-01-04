public class LeadController {

    public static Boolean rollupCalled;
    public static Boolean calledTerritoryManager;

    public static void addLeadSources(List<Lead> convertedLeads){
          List<Lead_Source__c> newLeadSources = new List<Lead_Source__c>();
          for(Lead ld : convertedLeads){
            
            Lead_Source__c newLDS = new Lead_Source__c();
            newLDS.Name = String.valueOf(ld.id).substring(0,15);
            newLDS.Account__c = ld.convertedAccountID;
            newLDS.Opportunity__c = ld.convertedOpportunityID;
            newLDS.Contact__c = ld.convertedContactID;
            newLDS.Lead_Source__c = ld.LeadSource;
            newLDS.Lead_Sub_Source__c = ld.Lead_Sub_Category__c;
            newLDS.Publication__c = ld.Publication__c;
            newLDS.Event__c = ld.Event__c; 
            newLDS.Referral__c = ld.Referral__c;
            newLDS.first_Lead__c = ld.first_Lead__c;
            newLDS.ConvertedDate__c = ld.ConvertedDate;
            newLDS.Experience_selling_BDR_and_backup_prods__c = ld.Experience_selling_BDR_and_backup_prods__c;
            newLDS.Experience_selling_cloud_services__c = ld.Experience_selling_cloud_services__c;
            newLDS.How_many_identified_end_user_opps__c = ld.How_many_identified_end_user_opps__c;
            newLDS.How_many_managed_customers_do_you_have__c = ld.How_many_managed_customers_do_you_have__c;
            newLDS.How_many_sales_people_do_you_have__c = ld.How_many_sales_people_do_you_have__c;
            newLDS.How_many_technical_resource_people__c = ld.How_many_technical_resource_people__c;
            newLds.MRR_opps_expected_within_24_months__c = ld.MRR_opps_expected_within_24_months__c;
            newLeadSources.add(newLDS);  
            
          }
          if(newLeadSources.size() > 0) insert newLeadSources;
    }
    
    public static List<Lead> filterConvertedLeads(Map<ID,Lead> oldLeads, Map<Id,Lead> newLeads){
        List<Lead> returnList = new List<Lead>();
        for(Lead checkConverted: newLeads.values()){
            if(checkConverted.isConverted && !oldLeads.get(checkConverted.id).isConverted) returnList.add(checkConverted);
        }
        return returnList;
    }
    
    @future
    public static void rollupActivitiesToLeads(Set<ID> leadIdsToUpdate){

        rollupCalled = true;
        
        if(leadIdsToUpdate.size() == 0 ) return;
        
        //Get all Activites associated with the leads
        List<Task> leadTasks = [Select id,WhoId,WhatID,CreatedDate From Task Where (WhoId IN :leadIdsToUpdate OR WhatId IN :leadIdsToUpdate) AND (Subject like 'Call%' OR Subject like 'call%' OR Subject like 'Email%' OR Subject like 'email%') ORDER BY CreatedDate ASC];
        List<Event> leadEvents = [Select id,WhoId,WhatID,CreatedDate From Event Where (WhoId IN :leadIdsToUpdate OR WhatId IN :leadIdsToUpdate) AND (Subject like 'Call%' OR Subject like 'call%' OR Subject like 'Email%' OR Subject like 'email%') ORDER BY CreatedDate ASC];
        
        if(leadTasks.size() == 0 && leadEvents.size() == 0) return;
        
        //Map tasks and events to the leads
        Map<ID,List<Task>> leadIdToListofTasksMap = new Map<ID,List<Task>>();
        Map<ID,List<Event>> leadIdToListofEventsMap = new Map<ID,List<Event>>();
        for(Task currentTask: leadTasks){
            if(currentTask.WhoId == null){
                if(!leadIdToListofTasksMap.containsKey(currentTask.whatID)) leadIdToListofTasksMap.put(currentTask.whatID,new List<Task>());
                leadIdToListofTasksMap.get(currentTask.whatID).add(currentTask);
            }
            else{
                if(!leadIdToListofTasksMap.containsKey(currentTask.whoID))  leadIdToListofTasksMap.put(currentTask.whoID,new List<Task>());
                leadIdToListofTasksMap.get(currentTask.whoID).add(currentTask);
            }
        }
        
        for(Event currentEvent: leadEvents){
            if(currentEvent.WhoId == null){
                if(!leadIdToListofEventsMap.containsKey(currentEvent.whatID))   leadIdToListofEventsMap.put(currentEvent.whatID,new List<Event>());
                leadIdToListofEventsMap.get(currentEvent.whatID).add(currentEvent);
            }
            else{
                if(!leadIdToListofEventsMap.containsKey(currentEvent.whoID))    leadIdToListofEventsMap.put(currentEvent.whoID,new List<Event>());
                leadIdToListofEventsMap.get(currentEvent.whoID).add(currentEvent);
            }
        }
        
        //update Leads
        List<Lead> leadList = [Select id,First_Activity__c,First_Activity_Type__c,Number_of_Rep_Activities__c From Lead Where id IN :leadIdsToUpdate];
        
        for(Lead currentlead: leadList){
            
            if(!leadIdToListofTasksMap.containsKey(currentlead.id) && !leadIdToListofEventsMap.containsKey(currentlead.id)) continue;
            
            Decimal numOfActivities = 0;
            DateTime firstActivityTime = currentLead.First_Activity__c;
            
            if(leadIdToListofTasksMap.containsKey(currentlead.id) && leadIdToListofTasksMap.get(currentlead.id).size() > 0){ 
                if(firstActivityTime == null){  
                    firstActivityTime = leadIdToListofTasksMap.get(currentlead.id).get(0).createdDAte;
                    currentLead.First_Activity_Type__c = 'Task';
                }
                numOfActivities += leadIdToListofTasksMap.get(currentlead.id).size();
            }
            if(leadIdToListofEventsMap.containsKey(currentlead.id) && leadIdToListofEventsMap.get(currentlead.id).size() > 0){ 
                if(firstActivityTime == null){ 
                    firstActivityTime = leadIdToListofEventsMap.get(currentlead.id).get(0).createdDate;
                    currentLead.First_Activity_Type__c = 'Event';
                }
                else if(firstActivityTime < leadIdToListofEventsMap.get(currentlead.id).get(0).createdDate){
                    firstActivityTime = leadIdToListofEventsMap.get(currentlead.id).get(0).createdDate;
                    currentLead.First_Activity_Type__c = 'Event';
                }
                numOfActivities += leadIdToListofEventsMap.get(currentlead.id).size();
            }
            currentLead.First_Activity__c = firstActivityTime;
            currentLead.Number_of_Rep_Activities__c = numOfActivities;
        }
        
        System.debug(leadlist);
        
        update leadList;
        
    }
    
    /**********************************
    *       Test Methods              *
    **********************************/
   
   
   // LeadSource during conversion
  /* public static testMethod void testLeadConversionWithOneLead(){
        
        Lead firstLead = new Lead();
        firstLead.Street = '111 Fake St.';
        firstLead.City = 'Mountian View';
        firstLead.PostalCode = '94034';
        firstLead.State = 'CA';
        firstLead.Company = 'Test Account';
        firstLead.Email = 'test@test.com';
        firstLead.Description = 'Some description';
        firstLead.FirstName = 'Guy';
        firstLead.LastName = 'Someone';
        firstLead.LeadSource = 'Advertising';
        firstLead.Lead_Sub_Category__c = 'Bing-PPC-Axcient-Demo';
        firstLead.Phone = '415-848-8298';
        insert firstLead;
        
        Test.startTest();
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(firstLead.id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true AND MasterLabel = 'Convert'  LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        Test.stopTest();
        
        
        List<Lead_Source__c> sources = [Select id,Account__c,Opportunity__c,Contact__c,Lead_Source__c,Lead_Sub_Source__c,Publication__c,Event__c,Referral__c,first_Lead__c From Lead_Source__c Where Name = :String.valueOf(firstLead.id).substring(0,15)];
        System.assertEquals(1,sources.size());
        
        firstLead = [Select id,convertedAccountID,convertedOpportunityID,convertedContactID,LeadSource,Lead_Sub_Category__c,Publication__c,Event__c,Referral__c,first_Lead__c,ConvertedDate From Lead Where id = :firstLead.id];
        System.assertEquals(firstLead.convertedAccountID,sources.get(0).Account__c);
        System.assertEquals(firstLead.convertedOpportunityID,sources.get(0).Opportunity__c);
        System.assertEquals(firstLead.convertedContactID,sources.get(0).Contact__c);
        System.assertEquals(firstLead.LeadSource,sources.get(0).Lead_Source__c);
        System.assertEquals(firstLead.Lead_Sub_Category__c,sources.get(0).Lead_Sub_Source__c);
        System.assertEquals(firstLead.Publication__c,sources.get(0).Publication__c);
        System.assertEquals(firstLead.Event__c,sources.get(0).Event__c);
        System.assertEquals(firstLead.Referral__c,sources.get(0).Referral__c);
        System.assertEquals(firstLead.first_Lead__c,sources.get(0).first_Lead__c);
        
   }
   
   public static testMethod void testLeadConversionWithOneLeadConvertedANDOneNot(){
        
        Lead firstLead = new Lead();
        firstLead.Street = '111 Fake St.';
        firstLead.City = 'Mountian View';
        firstLead.PostalCode = '94034';
        firstLead.State = 'CA';
        firstLead.Company = 'Test Account';
        firstLead.Email = 'test@test.com';
        firstLead.Description = 'Some description';
        firstLead.FirstName = 'Guy';
        firstLead.LastName = 'Someone';
        firstLead.LeadSource = 'Advertising';
        firstLead.Lead_Sub_Category__c = 'Bing-PPC-Axcient-Demo';
        firstLead.Phone = '415-848-8298';
        insert firstLead;
        
        Lead secondLead = new Lead();
        secondLead.Street = '111 Fake St.';
        secondLead.City = 'Mountian View';
        secondLead.PostalCode = '94034';
        secondLead.State = 'CA';
        secondLead.Company = 'Test Account 2';
        secondLead.Email = 'test2@test.com';
        secondLead.Description = 'Some other description';
        secondLead.FirstName = 'Test';
        secondLead.LastName = 'another Someone';
        secondLead.LeadSource = 'Advertising';
        secondLead.Lead_Sub_Category__c = 'Bing-PPC-Axcient-Demo';
        secondLead.Phone = '415-848-8298';
        insert secondLead;
        
        Test.startTest();
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(firstLead.id);
            
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true AND MasterLabel = 'Convert'  LIMIT 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
            update secondLead;
        Test.stopTest();
        
        
        List<Lead_Source__c> sources = [Select id,Account__c,Opportunity__c,Contact__c,Lead_Source__c,Lead_Sub_Source__c From Lead_Source__c];
        System.assertEquals(1,sources.size());
        
   }
   
   // Rollup of Activities
   public static testMethod void testNoActivities(){
   
        List<Lead> testLeads = new List<Lead>();
        for(Integer numofLeads = 0; numofLeads < 200; numOfLeads++){
            testLeads.add(new Lead(Company='Test Company'+numofLeads,firstName='Test',lastName='Guy'+numOfLeads));
        }
        insert testLeads;
       
        Test.startTest();
            update testLeads;
        Test.stopTest();
        
       testLeads = [Select id,First_Activity__c,Number_of_Rep_Activities__c,CreatedDate From Lead Where id IN :testLeads];
       for(Lead currentLead: testLeads){
            System.assertEquals(null,currentLead.First_Activity__c);
            System.assertEquals(null,currentLead.Number_of_Rep_Activities__c);
       }
    
   }
  
   public static testMethod void testAssociateOneTaskPerLead(){
   
        List<Lead> testLeads = new List<Lead>();
        for(Integer numofLeads = 0; numofLeads < 200; numOfLeads++){
            testLeads.add(new Lead(Company='Test Company'+numofLeads,firstName='Test',lastName='Guy'+numOfLeads));
        }
        insert testLeads;
        
        Map<ID,List<Task>> testTasksToLeadMap = new Map<ID,List<Task>>();
        List<Task> alltestTasks = new List<Task>();
        Integer numOfTasksPerLead = 1;
        for(Lead currentLead: testLeads){
            List<Task> testTasks = new List<Task>();
            for(Integer numOfTasks = 0; numOfTasks < numOfTasksPerLead; numOfTasks++){
                testTasks.add(new Task(Priority='High',Status='Completed',WhoId=currentLead.id,Subject='Call me maybe'));
            }
            alltestTasks.addAll(testTasks);
        }
        insert alltestTasks;
        
        alltestTasks = [Select id,WhoID,WhatID,createdDate,subject From Task Where id IN :alltestTasks];
        
        for(Task currentTask: alltestTasks){
            if(!testTasksToLeadMap.containsKey(currentTask.WhoId)) testTasksToLeadMap.put(currentTask.WhoId,new List<Task>());
            testTasksToLeadMap.get(currentTask.WhoId).add(currentTask);
        }
       
        Test.startTest();
            update testLeads;
        Test.stopTest();
        
       testLeads = [Select id,First_Activity__c,Number_of_Rep_Activities__c,CreatedDate From Lead Where id IN :testLeads];
       for(Lead currentLead: testLeads){
            System.assert(testTasksToLeadMap.containsKey(currentLead.id));
            System.assertEquals(testTasksToLeadMap.get(currentLead.id).get(0).createdDate,currentLead.First_Activity__c);
            System.assertEquals(1,currentLead.Number_of_Rep_Activities__c);
       }
    
   }
   
   public static testMethod void testAssociateOneEventPerLead(){
   
        List<Lead> testLeads = new List<Lead>();
        for(Integer numofLeads = 0; numofLeads < 200; numOfLeads++){
            testLeads.add(new Lead(Company='Test Company'+numofLeads,firstName='Test',lastName='Guy'+numOfLeads));
        }
        insert testLeads;
        
        Map<ID,List<Event>> testTasksToLeadMap = new Map<ID,List<Event>>();
        List<Event> alltestTasks = new List<Event>();
        Integer numOfTasksPerLead = 1;
        for(Lead currentLead: testLeads){
            List<Event> testTasks = new List<Event>();
            for(Integer numOfTasks = 0; numOfTasks < numOfTasksPerLead; numOfTasks++){
                testTasks.add(new Event(ActivityDateTime=System.now(),DurationInMinutes=1,WhoId=currentLead.id,Subject='Call me maybe'));
            }
            alltestTasks.addAll(testTasks);
        }
        insert alltestTasks;
        
        alltestTasks = [Select id,WhoID,WhatID,createdDate,subject From Event Where id IN :alltestTasks];
        
        for(Event currentTask: alltestTasks){
            if(!testTasksToLeadMap.containsKey(currentTask.WhoId)) testTasksToLeadMap.put(currentTask.WhoId,new List<Event>());
            testTasksToLeadMap.get(currentTask.WhoId).add(currentTask);
        }
       
        Test.startTest();
            update testLeads;
        Test.stopTest();
        
       testLeads = [Select id,First_Activity__c,Number_of_Rep_Activities__c,CreatedDate From Lead Where id IN :testLeads];
       for(Lead currentLead: testLeads){
            System.assert(testTasksToLeadMap.containsKey(currentLead.id));
            System.assertEquals(testTasksToLeadMap.get(currentLead.id).get(0).createdDate,currentLead.First_Activity__c);
            System.assertEquals(1,currentLead.Number_of_Rep_Activities__c);
       }
    
   }*/

}