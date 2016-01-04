public with sharing class EventContoller {

    public static Boolean isRunning;
    
    public static void updateParentLeads(List<Event> newEvents)
    {
    
        Set<ID> leadIds = new Set<ID>();
        for(Event currentEvent: newEvents){
            if(currentEvent.WhoId == null) continue;
            else if(String.valueOf(currentEvent.WhoId).startsWith('005')) leadIds.add(currentEvent.WhoId); 
        }
        
        if(leadIds.size() > 0) update [Select id From Lead Where Id IN:leadIds];
    }
    
    /********************************************************
    Method: Update Sales Appointment Checkbox
    Description: Updating fields on Event should update Sales Appointment Checkbox
    Author: Swathi Karkala.
    Date : 10/28/2013
    *********************************************************/

        Public static void UpdateSalesAppointmentCheckbox(List<Event> newOrderList,Map<ID,Event> NewOrderMap, Map<ID,Event> oldOrderMap)
        {
        
           String Lead_prefix = Schema.SObjectType.Lead.getKeyPrefix();
           
           Set<id> Ids = new Set<id>();
            Map<Id,Lead> LeadMap = new Map<Id,Lead>();
            for (Event tk: newOrderlist) 
            {
                Ids.add(tk.WhoId);
            }
            
            Map<id,Lead> LeadMap2 = new Map<id,Lead>([Select Id, sales_appointment_checkbox__c from Lead Where Id in :Ids]);
 
              List<Event> allEvents = [SELECT Id,whoId,attended__c,Type__c FROM Event WHERE whoid IN: Ids AND whoId != null 
                                     AND Attended__c= false AND ID!= null AND IsDeleted = false];
                                    
                 for(Event EventObj: allEvents)
                 {
                   /* if((EventObj.Attended__c == false &&
                       (EventObj.Type__c =='SE Call' ||
                       EventObj.Type__c =='Demo' ||
                       EventObj.Type__c =='Business Vulnerability Assessment' ||
                       EventObj.Type__c =='DR Consultation' ||
                       EventObj.Type__c =='Live Assessment' ||
                       EventObj.Type__c =='Partner Demo'))
                       ||
                       (EventObj.Attended__c == true &&
                       (EventObj.Type__c !='SE Call' ||
                       EventObj.Type__c !='Demo' ||
                       EventObj.Type__c !='Business Vulnerability Assessment' ||
                       EventObj.Type__c !='DR Consultation' ||
                       EventObj.Type__c !='Live Assessment' ||
                       EventObj.Type__c !='Partner Demo')))*/
                       
                       if(EventObj.Attended__c== false) 
                        {
                                if(LeadMap2.get(EventObj.WhoId) != null)
                                {
                                    Lead a = LeadMap2.get(EventObj.WhoId);
                                    a.sales_appointment_checkbox__c = false;
                                    system.debug('67SalesAppointment---------'+a.sales_appointment_checkbox__c);
                                    LeadMap.put(a.id,a);
                                }
                        }

                 } 
                 List<Event> allEvents1 = [SELECT Id,whoId,attended__c,Type__c FROM Event WHERE whoid IN: Ids AND whoId != null 
                                     AND Attended__c= true AND ID!= null AND IsDeleted = false ];
                                    
                 for(Event EventObj: allEvents1)
                 {
                   /* if((EventObj.Attended__c== true)&&
                       (EventObj.Type__c=='SE Call' ||
                       EventObj.Type__c=='Demo' ||
                       EventObj.Type__c=='Business Vulnerability Assessment' ||
                       EventObj.Type__c=='DR Consultation' ||
                       EventObj.Type__c=='Live Assessment' ||
                       EventObj.Type__c=='Partner Demo'))*/
                    
                        if(EventObj.Attended__c==true)
                        {
                          if(LeadMap2.get(EventObj.WhoId)!= null)
                          {
                            Lead a = LeadMap2.get(EventObj.WhoId);
                            a.sales_appointment_checkbox__c = true;
                            system.debug('67SalesAppointment---------'+a.sales_appointment_checkbox__c);
                            LeadMap.put(a.id,a);
                          }
                        }
                 }   
            
                try
                {
                    update LeadMap.values();
                }
                    catch (system.Dmlexception e) 
                    {
                    system.debug (e);
                    }
       
        }
    
    /*********************************
    *       Test Methods            *
    *********************************/
 
    public static testMethod void testInsertionOfEvent(){
        Lead testLead = new Lead(Company='Some Test Company',email='test@gmail.com',phone='415-555-5555',firstName='Test',lastName='Guy');
        insert testLead;
        Event testEvent = new Event(Subject='Test test',whoId=testLead.id,ActivityDateTime=System.Now(),DurationInMinutes=5);
        insert testEvent;
    } 
    
    Public static testMethod void testUpdateSalesAppointmentCheckbox()
    {
    Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
               
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient';  
               ld.sales_appointment_checkbox__c = false;  
               insert ld;
               
               Event Tsk= new Event();
               Tsk.Attended__c = false;
               Tsk.Type__c = 'Demo';
               Tsk.DurationInMinutes=789;
               Tsk.whoId=ld.id;
               Tsk.ActivityDateTime=System.Now();
               insert Tsk;

               Tsk.Attended__c = true;
               Tsk.Type__c = 'Email';
               update Tsk;
               
               Test.stopTest();
             }
             
    }
    
    Public static testMethod void testUpdateSalesAppointmentCheckbox1()
    {
    Profile lstProfile = [Select Id FROM Profile WHERE Name = 'SUPER SYS ADMIN' limit 1 ];
            
            //insert user
            string str =[select id from user where profileid =:lstProfile.id and isactive =true limit 1].id;
            User usr = new User(Email='tt_test@axcient.com',username = 'et_test@yahoo.com',FirstName = 'tst',LastName = 'te',ProfileId =lstProfile.id,CommunityNickname='kd',alias='ttAD',LocaleSidKey='en_US',TimezoneSidKey='America/Los_Angeles',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US');
            insert usr;
            
             system.runas(usr)
             {
               Test.startTest();
               
               Lead ld = new lead(); 
               ld.leadsource='List';     
               ld.LastName='Axcienttest';
               ld.company='Axcient';  
               ld.sales_appointment_checkbox__c = true;
               insert ld;
               
               Event Tsk= new Event();
               Tsk.Attended__c = true;
               Tsk.Type__c = 'Demo';
               Tsk.DurationInMinutes=789;
               Tsk.whoId=ld.id;
               Tsk.ActivityDateTime=System.Now();
               insert Tsk;
               
               Test.stopTest();
             }
             
    }
 
}