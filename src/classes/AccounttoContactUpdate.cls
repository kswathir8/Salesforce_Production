public with sharing class AccounttoContactUpdate
{
    Public static void UpdateContact(List<account> newOrderList,Map<ID,account> NewOrderMap, Map<ID,account> oldOrderMap)
        {
        
           //String contact_prefix = Schema.SObjectType.contact.getKeyPrefix();
    
            Map<Id,contact> contactMap = new Map<Id,contact>();
            Set<id> Ids = new Set<id>();

            for (account tk: newOrderlist) 
            {
                Ids.add(tk.Id);
            }
            
           Map<Id,List<Contact>> ContactMap2 = new Map<Id,List<Contact>>();
           List<Account> accList = [Select id,OwnerId,(select Id,OwnerID,Contact_Status__c from Contacts) from Account Where Id in :Ids];
           
           for(Account a:accList)
           {               
               ContactMap2.put(a.id,a.contacts);
           }
           
            system.debug('ContactMap2 is:'+ContactMap2);

             List<account> allaccounts = [SELECT Id,OwnerId,Account_Status__c,Contract_Signed__c,Manual_Override__c FROM account WHERE Id IN: Ids  
                                    AND ID!= null AND IsDeleted = false];
                 
                 system.debug('allaccounts----'+allaccounts);                   
                 for(account accountObj: allaccounts)
                 {
                        system.debug('account entered--------');
                        system.debug('Account status---'+accountObj.Account_Status__c);
                        system.debug('Contactmap---'+contactMap2.get(accountObj.Id));
                        system.debug('Owner Old Map-------'+oldOrderMap.get(accountObj.Id).Ownerid);
                        system.debug('Owner New Map-------'+newOrderMap.get(accountObj.Id).Ownerid);
                        system.debug('Manual_Override__c-------'+accountObj.Manual_Override__c );
                        system.debug('account Owner-----'+accountObj.OwnerID);
                       
                       if(oldOrderMap.get(accountObj.Id).Ownerid != newOrderMap.get(accountObj.Id).Ownerid && accountObj.Manual_Override__c == false){List<Contact> conList=contactMap2.get(accountObj.Id);for(contact cont:conList){cont.OwnerId = accountObj.OwnerId;contactMap.put(cont.id,cont);system.debug('Contact Owner---'+cont.OwnerId); 
                                }                                                                 
                        }
                        else if(accountObj.Account_Status__c == 'Signed Agreement' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Signed Agreement';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c); 
                                }
                                }       
                                                           
                        }
                        else if(accountObj.Account_Status__c == 'Active Customer' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Active Customer';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c);
                                } 
                                }                              
                        }
                        else if(accountObj.Account_Status__c == 'Actively Selling' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Actively Selling';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c);
                                } 
                                }                              
                        }
                        else if(accountObj.Account_Status__c == 'Recycle' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){cont.Contact_Status__c = 'Recycle';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c); 
                                }                                 
                        }
                        else if(accountObj.Account_Status__c == 'Qualified Account' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Qualified Account';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c);
                                } 
                                }                              
                        }
                        else if(accountObj.Account_Status__c == 'Sales Nurture' && contactMap2.get(accountObj.Id)!= null)
                        {       
                               
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Sales Nurture';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c); 
                                }
                                }                                
                        }
                        else if(accountObj.Account_Status__c == 'Not Engaged' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Not Engaged';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c); 
                                }
                                }                                
                        }
                        else if(accountObj.Account_Status__c == 'Working' && contactMap2.get(accountObj.Id)!= null)
                        {       
                              
                                List<Contact> conList=contactMap2.get(accountObj.Id);
                                for(contact cont:conList){if(cont.Contact_Status__c!='Unqualified'){cont.Contact_Status__c = 'Working';contactMap.put(cont.id,cont); 
                                system.debug('Contact status---'+cont.Contact_Status__c); 
                                }
                                }                                
                        }
                        
                        
                         
                 } 
              /*   List<account> allaccounts1 = [SELECT Id,Account_Status__c FROM account WHERE Id IN: Ids  
                                     AND ID!= null AND IsDeleted = false];
                                    
                 for(account accountObj: allaccounts1)
                 {
                       if(accountObj.Account_Status__c == 'Singed Agreement' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'Agreement Signed';
                                contactMap.put(a.id,a);                             
                        }
                        else if(accountObj.Account_Status__c == 'Active Customer' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'Customer';
                                contactMap.put(a.id,a);                             
                        }
                        else if(accountObj.Account_Status__c == 'Recycle' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'Recycle';
                                contactMap.put(a.id,a);                             
                        }
                        else if(accountObj.Account_Status__c == 'Qualified Account' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'SQL';
                                contactMap.put(a.id,a);                             
                        }
                        else if(accountObj.Account_Status__c == 'Sales Nurture' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'Sales Nurture';
                                contactMap.put(a.id,a);                             
                        }
                        else if(accountObj.Account_Status__c == 'Not Engaged' && contactMap2.get(accountObj.Id)!= null)
                        {       
                                contact a = contactMap2.get(accountObj.Id);
                                a.Contact_Status__c = 'Not Engaged';
                                contactMap.put(a.id,a);                             
                        }
                 } */
                 try
                {    
                    update contactMap.values();}catch (System.DMLException e) {
                    System.debug('ERROR:' + e);
                    }  
         }
         
 }