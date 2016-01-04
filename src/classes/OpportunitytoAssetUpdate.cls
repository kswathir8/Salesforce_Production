public with sharing class OpportunitytoAssetUpdate
{
    Public static void UpdateAsset(List<Opportunity> newOrderList,Map<ID,Opportunity> NewOrderMap, Map<ID,Opportunity> oldOrderMap)
        {
        
           //String Asset_prefix = Schema.SObjectType.Asset.getKeyPrefix();
    
            Map<Id,Asset> AssetMap = new Map<Id,Asset>();
            Set<id> Ids = new Set<id>();

            for (Opportunity tk: newOrderlist) 
            {
                Ids.add(tk.Id);
            }
            
           Map<Id,List<Asset>> AssetMap2 = new Map<Id,List<Asset>>();
           List<Opportunity> accList = [Select id,
                                       ship_to_email__c,ship_to_Name__c, 
                                       Additional_Ship_To_Email_Text__c,
                                       Additional_Ship_To_Email_Notification_01__c,
                                       Additional_Ship_To_Email_Notification_02__c,
                                       Additional_Ship_To_Contact_Text__c,
                                       Additional_Ship_To_Contact_1__r.FirstName,
                                       Additional_Ship_To_Contact_1__r.LastName,
                                       Additional_Ship_To_Contact_2__r.FirstName,
                                       Additional_Ship_To_Contact_2__r.LastName,
                                       (select Id,Ship_to_Email_opp__c,
                                       ship_to_Name_opp__c,
                                       Additional_Ship_To_Email_Text__c,
                                       Additional_Ship_To_Email_Notification_1__c,
                                       Additional_Ship_To_Email_Notification_2__c,
                                       Additional_Ship_To_Contact_Text__c,
                                       Additional_Ship_To_Contact_1__c,
                                       Additional_Ship_To_Contact_2__c
                                       from Assets__r) from Opportunity Where Id in :Ids];
           
           for(Opportunity a:accList)
           {               
               AssetMap2.put(a.id,a.Assets__r);
           }
           
            system.debug('AssetMap2 is:'+AssetMap2);

             List<Opportunity> allOpportunitys = [SELECT Id,ship_to_email__c,ship_to_Name__c,
                                                 Additional_Ship_To_Email_Text__c,
                                                 Additional_Ship_To_Email_Notification_01__c,
                                                 Additional_Ship_To_Email_Notification_02__c,
                                                 Additional_Ship_To_Contact_Text__c,
                                                 Additional_Ship_To_Contact_1__r.FirstName,
                                                 Additional_Ship_To_Contact_1__r.LastName,
                                                 Additional_Ship_To_Contact_2__r.FirstName,
                                                 Additional_Ship_To_Contact_2__r.LastName
                                                 FROM Opportunity WHERE Id IN: Ids  
                                                 AND ID!= null AND IsDeleted = false];
                                                 
                // Boolean IngramMicro= myString.contains('@ingrammicro.com');                               
                 system.debug('allOpportunitys----'+allOpportunitys);                   
                 for(Opportunity OpportunityObj: allOpportunitys)
                 {
                        system.debug('Opportunity entered--------');
                        system.debug('Opportunity status---'+OpportunityObj.ship_to_email__c);
                        system.debug('Assetmap---'+AssetMap2.get(OpportunityObj.Id));

                       if(OpportunityObj.Ship_to_email__c !=null && AssetMap2.get(OpportunityObj.Id)!= null){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.ship_to_email_opp__c= OpportunityObj.Ship_to_email__c;AssetMap.put(cont.id,cont); }}  
                       if(OpportunityObj.Ship_to_Name__c !=null && AssetMap2.get(OpportunityObj.Id)!= null){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.ship_to_Name_opp__c= OpportunityObj.Ship_to_Name__c;AssetMap.put(cont.id,cont); }} 
                       if(OpportunityObj.Additional_Ship_To_Email_Text__c !=null && AssetMap2.get(OpportunityObj.Id)!= null && !OpportunityObj.Additional_Ship_To_Email_Text__c.contains('@ingrammicro.com')){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Email_Text__c= OpportunityObj.Additional_Ship_To_Email_Text__c;AssetMap.put(cont.id,cont);  }       }  
                       if(OpportunityObj.Additional_Ship_To_Contact_Text__c !=null && AssetMap2.get(OpportunityObj.Id)!= null) { List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Contact_Text__c= OpportunityObj.Additional_Ship_To_Contact_Text__c;AssetMap.put(cont.id,cont); }       } 
                       if(OpportunityObj.Additional_Ship_To_Email_Notification_01__c !=null && AssetMap2.get(OpportunityObj.Id)!= null && !OpportunityObj.Additional_Ship_To_Email_Notification_01__c.contains('@ingrammicro.com')){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Email_Notification_1__c= OpportunityObj.Additional_Ship_To_Email_Notification_01__c;AssetMap.put(cont.id,cont);}}  
                       if(OpportunityObj.Additional_Ship_To_Contact_1__c !=null && AssetMap2.get(OpportunityObj.Id)!= null){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Contact_1__c= OpportunityObj.Additional_Ship_To_Contact_1__r.FirstName+' '+OpportunityObj.Additional_Ship_To_Contact_1__r.LastName;AssetMap.put(cont.id,cont);}} 
                       if(OpportunityObj.Additional_Ship_To_Email_Notification_02__c !=null && AssetMap2.get(OpportunityObj.Id)!= null && !OpportunityObj.Additional_Ship_To_Email_Notification_02__c.contains('@ingrammicro.com')){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Email_Notification_2__c= OpportunityObj.Additional_Ship_To_Email_Notification_02__c;AssetMap.put(cont.id,cont); }       }  
                       if(OpportunityObj.Additional_Ship_To_Contact_1__c !=null && AssetMap2.get(OpportunityObj.Id)!= null){List<Asset> conList=AssetMap2.get(OpportunityObj.Id);for(Asset cont:conList){cont.Additional_Ship_To_Contact_2__c= OpportunityObj.Additional_Ship_To_Contact_2__r.FirstName +' '+ OpportunityObj.Additional_Ship_To_Contact_2__r.LastName;AssetMap.put(cont.id,cont); } } 
                 } 
            
                 try
                {    
                    update AssetMap.values();}catch (System.DMLException e) {
                    System.debug('ERROR:' + e);
                }  
         }
         
 }