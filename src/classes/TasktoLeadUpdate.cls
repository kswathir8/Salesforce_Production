public with sharing class TasktoLeadUpdate
{
    Public static void UpdateLead(List<Task> newOrderList,Map<ID,Task> NewOrderMap, Map<ID,Task> oldOrderMap)
        {
        
           String Lead_prefix = Schema.SObjectType.Lead.getKeyPrefix();
    
            Map<Id,Lead> LeadMap = new Map<Id,Lead>();
            Set<id> Ids = new Set<id>();

            for (Task tk: newOrderlist) 
            {
                Ids.add(tk.WhoId);
            }
            
            Map<id,Lead> LeadMap2 = new Map<id,Lead>([Select Id,status,sales_appointment_checkbox__c from Lead Where Id in :Ids ]);
            DateTime dateTimeFormat = DateTime.now();
            
            system.debug('dateTimeFormat--'+dateTimeFormat);

             List<Task> allTasks = [SELECT Id,whoId,status,LastModifiedDate FROM Task WHERE whoid IN: Ids AND whoId != null 
                                    AND ID!= null AND IsDeleted = false AND LastModifiedDate >=:DateTimeFormat];
                system.debug('allTasks---'+allTasks);                    
                
                 for(Task taskObj: allTasks)
                 {
                        system.debug('Task entered--------');
                        system.debug('LeadMap2-----'+LeadMap2);
                        system.debug('allTasks---'+allTasks);
                        
                        
                       if((taskObj.status == 'No show customer' ||taskObj.status == 'No show internal'|| taskObj.status == 'Unqualified') )
                        {
                        system.debug('Entered task----');
                        
                              if(LeadMap2.get(taskObj.WhoId)!=null)
                              {
                              
                                Lead a = LeadMap2.get(taskObj.WhoId);
                                a.status = 'Requalify';                               
                                LeadMap.put(a.id,a);
                                system.debug('a.status---'+a.status );
                                
                                Lead b = LeadMap2.get(taskObj.WhoId);
                                b.transfer_lead__c=false;                               
                                LeadMap.put(b.id,b);
                                system.debug('b.transfer_lead__c---'+b.transfer_lead__c);
                                  
                                Lead c = LeadMap2.get(taskObj.WhoId);
                                c.Requalify_Date_Time__c= datetime.now();
                                LeadMap.put(c.id,c);
                                system.debug('c.Requalify_Date_Time__c---'+c.Requalify_Date_Time__c);
                              }

                        }
                 } 
                /* List<Task> allTasks1 = [SELECT Id,status,whoId,attended__c,Why_Unqualified__c,Type__c FROM Task WHERE whoid IN: Ids AND whoId != null 
                                     AND ID!= null AND IsDeleted = false];
                                    
                 for(Task taskObj: allTasks1)
                 {
                       if(taskObj.status == 'No show customer' ||taskObj.status == 'No show internal' || taskObj.Why_Unqualified__c == 'No qualified pain' || taskObj.Why_Unqualified__c == 'No financial or technical Decision Maker')
                        {
                         

                               if(LeadMap2.get(taskObj.WhoId) !=null)
                               {
                                Lead a = LeadMap2.get(taskObj.WhoId);
                                a.status = 'Requalify';
                                LeadMap.put(a.id,a);
                                Lead b = LeadMap2.get(taskObj.WhoId);
                                b.transfer_lead__c=false;
                                LeadMap.put(b.id,b); 
                                }

                        }
                 } */
                 try
                {    
                    update LeadMap.values();
                }
                    catch (system.Dmlexception e) 
                    {
                    system.debug (e);
                    }  
         }
         
 }