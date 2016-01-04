public with sharing class TaskController {

    public static Boolean isRunning;
    Private Map<Id,List<Task>> taskMap; 
    
    public static void updateParentLeads(List<Task> newTasks)
    {
    
        Set<ID> leadIds = new Set<ID>();
        for(Task currentTask: newTasks)
        {
            if(currentTask.WhoId == null) continue;
            else if(String.valueOf(currentTask.WhoId).startsWith('005')) leadIds.add(currentTask.WhoId); 
        }
        
        if(leadIds.size() > 0) update [Select id From Lead Where Id IN:leadIds];
    }

    /********************************************************
    Method: Update Sales Appointment Checkbox
    Description: Updating fields on Task should update Sales Appointment Checkbox
    Author: Swathi Karkala.
    Date : 10/28/2013
    *********************************************************/

        Public static void UpdateSalesAppointmentCheckbox(List<Task> newOrderList,Map<ID,Task> NewOrderMap, Map<ID,Task> oldOrderMap)
        {
        
           String Lead_prefix = Schema.SObjectType.Lead.getKeyPrefix();
    
            Map<Id,Lead> LeadMap = new Map<Id,Lead>();
            Set<id> Ids = new Set<id>();

            for (Task tk: newOrderlist) 
            {
                Ids.add(tk.WhoId);
            }
            
            Map<id,Lead> LeadMap2 = new Map<id,Lead>([Select Id, sales_appointment_checkbox__c from Lead Where Id in :Ids AND status !='Convert']);


             List<Task> allTasks = [SELECT Id,whoId,attended__c,Type__c FROM Task WHERE whoid IN: Ids AND whoId != null 
                                     AND Attended__c= false AND ID!= null AND IsDeleted = false];
                                    
                 for(Task taskObj: allTasks)
                 {
                    /*if((taskObj.Attended__c == false &&
                       (taskObj.Type__c =='SE Call' ||
                       taskObj.Type__c =='Demo' ||
                       taskObj.Type__c =='Business Vulnerability Assessment' ||
                       taskObj.Type__c =='DR Consultation' ||
                       taskObj.Type__c =='Live Assessment' ||
                       taskObj.Type__c =='Partner Demo'))
                       ||
                       (taskObj.Attended__c == true &&
                       (taskObj.Type__c !='SE Call' ||
                       taskObj.Type__c !='Demo' ||
                       taskObj.Type__c !='Business Vulnerability Assessment' ||
                       taskObj.Type__c !='DR Consultation' ||
                       taskObj.Type__c !='Live Assessment' ||
                       taskObj.Type__c !='Partner Demo')))*/
                       
                       if(taskObj.Attended__c == false)
  
                        {
                              if(LeadMap2.get(taskObj.WhoId)!=null)
                              {
                                Lead a = LeadMap2.get(taskObj.WhoId);
                               // a.sales_appointment_checkbox__c = t.attended__c;
                                a.sales_appointment_checkbox__c = false;
                                system.debug('67SalesAppointment---------'+a.sales_appointment_checkbox__c);
                                LeadMap.put(a.id,a);
                              }

                        }
                 } 
                 List<Task> allTasks1 = [SELECT Id,whoId,attended__c,Type__c FROM Task WHERE whoid IN: Ids AND whoId != null 
                                     AND Attended__c= true AND ID!= null AND IsDeleted = false];
                                    
                 for(Task taskObj: allTasks1)
                 {
                    /*if((taskObj.Attended__c== true)&&
                       (taskObj.Type__c=='SE Call' ||
                       taskObj.Type__c=='Demo' ||
                       taskObj.Type__c=='Business Vulnerability Assessment' ||
                       taskObj.Type__c=='DR Consultation' ||
                       taskObj.Type__c=='Live Assessment' ||
                       taskObj.Type__c=='Partner Demo'))*/
                       
                       if(taskObj.Attended__c == true)
  
                        {

                               if(LeadMap2.get(taskObj.WhoId) !=null)
                               {
                                Lead a = LeadMap2.get(taskObj.WhoId);
                               // a.sales_appointment_checkbox__c = t.attended__c;
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
 
    public static testMethod void testInsertionOfTask()
    {
        Lead testLead = new Lead(Company='Some Test Company',email='test@gmail.com',phone='415-555-5555',firstName='Test',lastName='Guy');
        insert testLead;
        Task testTask = new Task(Subject='Test test',whoId=testLead.id,Priority='High',Status='Completed',ReminderDateTime=System.now());
        insert testTask;
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
               
               Task Tsk= new Task();
               Tsk.Attended__c = false;
               Tsk.Type__c = 'Demo';
               Tsk.whoId=ld.id;
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
               
               Task Tsk= new Task();
               Tsk.Attended__c = true;
               Tsk.Type__c = 'Demo';
               Tsk.whoId=ld.id;
               insert Tsk;
               
               Test.stopTest();
             }
             
    }

}