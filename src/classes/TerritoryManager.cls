public without sharing class TerritoryManager {

   public static List<RecordType> recordTypes = [Select id,Name From RecordType Where SObjectType = 'Zip_Code_Range__c'];
    public static List<RecordType> AccountRecordType = [Select id, Name From RecordType Where SObjectType = 'Account'];
    public static List<RecordType> leadRecordType = [Select id, Name From RecordType Where SObjectType = 'Lead'];
    public static Map<String,RecordType> nameToRecordTypesMap;
    public static Map<String,String> LeadRecordTypeMap = new Map<String,String>();
    public static Map<String,String> AccountRecordTypeMap = new Map<String,String>();
    public static Map<String,String> RangeRecordTypeMap = new Map<String,String>();
    public static Boolean Recurrsion = false;
 

//Assigning Territory for Accounts "Partner Accounts" ,"End User Accounts" and "Reseller Accounts"
   
    public static void assignTerritoryForAccounts(List<Account> AccountsToUpdate)
    {
        
        List<RecordType> partner = [Select id From RecordType Where sObjectType = 'Account' AND (Name='Partner ' or Name='End Customer' or Name='Reseller')];
        
        // Pull BillingStates first
        Set<String> States = new Set<String>();
         String AccountRec;
         String AccountRecAct;
         
         for(RecordType accs: AccountRecordType)
         {
              AccountRecordTypeMap.put(accs.Id,accs.Name);

         }
         
        for(Account acc: AccountsToUpdate)
        {
            if(acc.BillingState != null )
            {
            acc.BillingState = acc.BillingState.toUpperCase(); // Force Upper-case for BillingState
            }
            States.add(acc.BillingState);
            AccountRec = AccountRecordTypeMap.get(acc.RecordTypeId);
            system.debug('BBB:'+acc.RecordTypeId);
            system.debug('AAA:'+AccountRec);
            AccountRecAct = AccountRec.substring(0,2);
        }
  
                    
        
         
        List<Zip_Code_Range__c> territories = [Select id,Type__c,State__c,Zip_Code_Start__c,Zip_Code_Stop__c,RecordTypeId,OwnerID,Axcitory__c From Zip_Code_Range__c Where State__c IN :States];
        if(territories.size() == 0 ) return;
        
         
        
        // Map Objects
        initRecordTypesMap();
        Map<String,Zip_Code_Range__c> startingZipToRangeMap = new Map<string,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> StateToRangeMap = new Map<String,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> CollectionofPostalCodes = new Map<String,Zip_Code_Range__c>();
          String RangeRec;
          String RangeRecAct;
        
             
        for(Zip_Code_Range__c postalrange: territories)
        {
           if(postalrange.Zip_Code_Start__c !=null && postalrange.Zip_Code_Stop__c !=null)
            {
                Integer startzip = Integer.valueof(postalrange.Zip_Code_Start__c);
                Integer stopzip = Integer.valueof(postalrange.Zip_Code_Stop__c);
                for(Integer i=startzip;i<=stopzip;i++)
                {
                   if(postalrange.Zip_Code_Start__c != null && postalrange.Zip_Code_Stop__c !=null)
                   {
                       CollectionofPostalCodes.put(postalrange.State__c+string.valueof(i),postalrange);
                       system.debug('CollectionofPostalCodes---------'+CollectionofPostalCodes.put(postalrange.State__c+string.valueof(i),postalrange));
                   }
                }
            }
        }
                
        Set<String> StatesOfZipCodeRanges = new Set<String>();

        for(Zip_Code_Range__c range: territories)
        {
             
            if(range.recordTypeId == nameToRecordTypesMap.get('State').id && range.State__c!='CA' && range.State__c!='TX' && range.State__c!='NY') 
            {  
                if(AccountRecAct != null)
                {
                StateToRangeMap.put(range.State__c,range);
                startingZipToRangeMap.put(range.State__c+range.Zip_Code_Start__c+range.Zip_Code_Stop__c,range);
                }
            }
          
        }

        // Pull Territories and adjust Accounts
        Map<ID,Axcitory__c> axcitories = new Map<Id,Axcitory__c>([Select id,OwnerId,Partner_Recruiter__c,TSM__c From Axcitory__c]);
        
        for(Account acc: AccountsToUpdate)
        {
                               
             AccountRec = AccountRecordTypeMap.get(acc.RecordTypeId);
             AccountRecAct = AccountRec.substring(0,2);
             
            ID AxcitoryID;

             system.debug('AccountBillingState-------'+acc.BillingState);
             system.debug('AccountBillingPostalCode-------'+acc.BillingPostalCode);

             if(acc.BillingCountry == 'Australia' && acc.Transfer_Account__c == true)
             {
                acc.OwnerId = '00580000003T4P5';
                Continue;
             }
             else if((acc.BillingState =='CA'|| acc.BillingState =='NY'|| acc.BillingState =='TX') && acc.BillingPostalCode == null){acc.ownerId = '00580000008hVqu';}
            
        

            if(acc.BillingState != null && StateToRangeMap.containsKey(acc.BillingState))
            {
                if(StateToRangeMap.get(acc.BillingState)!=null)
                {
                    AxcitoryID = StateToRangeMap.get(acc.BillingState).Axcitory__c;
                }
            }
            else if(acc.BillingState != null && acc.BillingPostalCode != null && CollectionofPostalCodes.containsKey(acc.BillingState+acc.BillingPostalCode))
            {
              AxcitoryID = CollectionofPostalCodes.get(acc.BillingState+acc.BillingPostalCode).Axcitory__c; 
            }
            else if(acc.BillingState != null && acc.BillingPostalCode != null && acc.BillingPostalCode.length() >= 5 && CollectionofPostalCodes.containsKey(acc.BillingState+acc.BillingPostalCode.substring(0,4)))
            {
              AxcitoryID = CollectionofPostalCodes.get(acc.BillingState+acc.BillingPostalCode.substring(0,4)).Axcitory__c;
            }



            if(AxcitoryID != null || acc.BillingState != null)
            {
                 if((stateToRangeMap.get(acc.BillingState) !=null) && (acc.BillingState != null) && (acc.Manual_Override__c== false)) 
                 {
                 
                        if(acc.Transfer_Account__c==true && axcitories.get(AxcitoryID).TSM__c !=null && acc.Transfer_Lead__c== true)
                        {
                            acc.Axcitory__c = AxcitoryID; 
                            acc.OwnerId = axcitories.get(AxcitoryID).TSM__c;
                        }
                        else if(acc.Transfer_Account__c==false && axcitories.get(AxcitoryID).TSM__c !=null && acc.Transfer_Lead__c== true)
                        {
                            acc.Axcitory__c = AxcitoryID;
                            acc.OwnerId = axcitories.get(AxcitoryID).OwnerId;
                        }
                        else if(acc.Transfer_Lead__c== false && acc.Transfer_Account__c == false)
                        {
                            acc.Axcitory__c = AxcitoryID;
                            acc.OwnerId = axcitories.get(AxcitoryID).Partner_Recruiter__c; 
                        }
                   
                 } 
                 
            else if(acc.BillingPostalCode!=null && (acc.Manual_Override__c== false))
            {
                   if(CollectionofPostalCodes.get(acc.BillingState+acc.BillingPostalCode) !=null )
                   {
                
                            if(acc.Transfer_Account__c==true && axcitories.get(AxcitoryID).TSM__c !=null && acc.Transfer_Lead__c== true) 
                            {
                                acc.Axcitory__c = AxcitoryID;
                                acc.OwnerId = axcitories.get(AxcitoryID).TSM__c;
                            }
                            else if(acc.Transfer_Account__c==false && axcitories.get(AxcitoryID).TSM__c !=null && acc.Transfer_Lead__c== true)
                            {
                                acc.Axcitory__c = AxcitoryID;
                                acc.OwnerId = axcitories.get(AxcitoryID).OwnerId;
                            }
                            else if(acc.Transfer_Lead__c== false && acc.Transfer_Account__c == false)
                            {
                                acc.Axcitory__c = AxcitoryID;
                                acc.OwnerId = axcitories.get(AxcitoryID).Partner_Recruiter__c;
                            }
                     
                        }
                    }
                }
            
            }
         } 
         
//Populate Partner Related List(Accounts with record type="End customer") with AccountOwner

    Public static void populateParwithAccOwner(map<Id,Account> parentAccountMap)
    {
        if(!RecursiveTriggerController.hasAlreadyRunTrigger()) {
        
         map<Id,set<Id>> partnerFromToMap = new map<Id,set<Id>>();
         map<Id,Account> primaryToPartner = new map<Id,Account>();
         map<Id,list<Account>> parenttoPartnerAccount = new map<Id,list<Account>>();
         List<Partner> EachPartnerAcc = [select accountToId,accountFromId from Partner where accountFromId IN: parentAccountMap.keySet()];
        for(Partner eachPartner : EachPartnerAcc){if(partnerFromToMap.get(eachPartner.accountFromId) == null)partnerFromToMap.put(eachPartner.accountFromId,new set<Id>()); partnerFromToMap.get(eachPartner.accountFromId).add(eachPartner.accountToId);}

        for(Account value : parentAccountMap.values()) 
        {
        for(Account partnerValue : [select Id, OwnerId,Partner__c from Account where Id IN:partnerFromToMap.get(value.Id)]){if(parenttoPartnerAccount.get(value.Id) == null)parenttoPartnerAccount.put(value.Id,new list<Account>());parenttoPartnerAccount.get(value.Id).add(partnerValue);}

        }

         list<Account> updatedPartners = new list<Account>();
         List<Account> FinalAccsQ =[select Id,OwnerId,Partner__c from Account where Id IN:parenttoPartnerAccount.keySet()];
            for(Account finalAccs : FinalAccsQ) {if(finalAccs.OwnerId != null && parenttoPartnerAccount.get(finalAccs.Id) != null){for(Account acc : parenttoPartnerAccount.get(finalAccs.Id)){acc.OwnerId = finalAccs.OwnerId;updatedPartners.add(acc);}}}

            if(updatedPartners.size() >0) {try {RecursiveTriggerController.setAlreadyRunTrigger();update updatedPartners;}catch(Exception e) {system.debug('Error Updating partner Account Owners'+e.getMessage());}}}    
    }
        
 
//Assigning Territory for Leads "Partner Leads" and "End User Leads"
   
    public static void assignTerritoryForLeads(List<Lead> leadsToUpdate)
    {
        
        List<RecordType> partner = [Select id From RecordType Where sObjectType = 'Lead' AND (Name='Partner Leads' or Name='End User Leads' 
        or Name='Reseller Leads')];
        
        // Pull States first
        Set<String> states = new Set<String>();
         String LeadRec;
         String LeadRecAct;
         
         for(RecordType lds: leadRecordType)
         {
              LeadRecordTypeMap.put(lds.Id,lds.Name);

         }
         
        for(Lead ld: leadsToUpdate)
        {
            if(ld.State != null ){ld.State = ld.State.toUpperCase(); // Force Upper-case for state
            }
            states.add(ld.State);
            LeadRec = leadRecordTypeMap.get(ld.RecordTypeId);
            system.debug('BBB:'+ld.RecordTypeId);
            system.debug('AAA:'+LeadRec);
            LeadRecAct = LeadRec.substring(0,2);
        }
  
                    
         for(RecordType lds: leadRecordType)
         {
              LeadRecordTypeMap.put(lds.Id,lds.Name);

         } 
         
        List<Zip_Code_Range__c> territories = [Select id,Type__c,State__c,Zip_Code_Start__c,Zip_Code_Stop__c,RecordTypeId,OwnerID,Axcitory__c From Zip_Code_Range__c Where State__c IN :states];
        if(territories.size() == 0 ) return;
        
         
        
        // Map Objects
        initRecordTypesMap();
        Map<String,Zip_Code_Range__c> startingZipToRangeMap = new Map<string,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> startingZipToRangeMapECL= new Map<string,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> startingZipToRangeMapReseller= new Map<string,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> stateToRangeMap = new Map<String,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> stateToRangeMapECL = new Map<String,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> stateToRangeMapReseller = new Map<String,Zip_Code_Range__c>();
        Map<String,Zip_Code_Range__c> CollectionofpostalCodes = new Map<String,Zip_Code_Range__c>();
         //String RangeRec;
         //String RangeRecAct;
        
             
        for(Zip_Code_Range__c postalrange: territories)
        {
        //RangeRec = postalrange.Type__c;
        //RangeRecAct = RangeRec.substring(0,2);
           if(postalrange.Zip_Code_Start__c !=null && postalrange.Zip_Code_Stop__c !=null)
            {
                Integer startzip = Integer.valueof(postalrange.Zip_Code_Start__c);
                Integer stopzip = Integer.valueof(postalrange.Zip_Code_Stop__c);
                for(Integer i=startzip;i<=stopzip;i++)
                {
                   if(postalrange.Zip_Code_Start__c != null && postalrange.Zip_Code_Stop__c !=null){
                       CollectionofpostalCodes.put(postalrange.state__c+string.valueof(i),postalrange);
                       system.debug('CollectionofpostalCodes---------'+CollectionofpostalCodes.put(postalrange.state__c+string.valueof(i),postalrange));
                   }
                }
            }
        }
                
        Set<String> statesOfZipCodeRanges = new Set<String>();

        for(Zip_Code_Range__c range: territories)
        {
                
            if(range.recordTypeId == nameToRecordTypesMap.get('State').id && range.state__c!='CA' && range.state__c!='TX' && range.state__c!='NY') 
            {  
             
                if(LeadRecAct != null)
                {
                    stateToRangeMap.put(range.State__c,range);
                    startingZipToRangeMap.put(range.State__c+range.Zip_Code_Start__c+range.Zip_Code_Stop__c,range);
                }
               
            }
          
        }

        // Pull Territories and adjust Accounts
        Map<ID,Axcitory__c> axcitories = new Map<Id,Axcitory__c>([Select id,OwnerId,Partner_Recruiter__c,TSM__c From Axcitory__c]);
        List<Change_Owner_Reason__c> ChangeOwner= new List<Change_Owner_Reason__c>();
        ChangeOwner = [Select id,Approve_Reject__c from Change_Owner_Reason__c where Approve_Reject__c = 'Approve' order by createddate desc limit 1];
        List<campaign> campaign = new List<campaign>();
        campaign = [Select id, Name from campaign where Name like '%Event-TradeShow%'];
        
        for(Lead ld: leadsToUpdate)
        {
                               
             LeadRec = leadRecordTypeMap.get(ld.RecordTypeId);
             LeadRecAct = LeadRec.substring(0,2);
             
            ID AxcitoryID;
            
           
             system.debug('leadstate-------'+ld.state);
             system.debug('leadpostalcode-------'+ld.postalcode);

             if(ld.Country == 'Australia' && ld.Transfer_Lead__c == true)
             {
                ld.OwnerId = '00580000003T4P5';
                Continue;
             }
             

            if(ld.State != null && (stateToRangeMap.containsKey(ld.State)))
            { 
                 if(stateToRangeMap.get(ld.State)!=null)
                 {
                     AxcitoryID = stateToRangeMap.get(ld.State).Axcitory__c;
                 }
            } 
            else if(ld.State != null && ld.PostalCode != null && CollectionofpostalCodes.containsKey(ld.state+ld.PostalCode))
            {
                AxcitoryID = CollectionofPostalCodes.get(ld.state+ld.PostalCode).Axcitory__c;
            } 
            else if(ld.State != null && ld.PostalCode != null && ld.PostalCode.length() > 5 && CollectionofpostalCodes.containsKey(ld.state+ld.PostalCode.substring(0,4)))
            {
                AxcitoryID = CollectionofPostalCodes.get(ld.state+ld.PostalCode.substring(0,4)).Axcitory__c;
            }

            if(AxcitoryID != null  || ld.state != null)
            {
            system.debug('Entered state----');
                if((stateToRangeMap.get(ld.State) !=null) && (ld.state != null)) 
                {
             
                        if(ld.Transfer_Lead__c==true && axcitories.get(AxcitoryID).OwnerId !=null)
                        {
                            ld.Axcitory__c = AxcitoryID;
                            ld.OwnerId = axcitories.get(AxcitoryID).OwnerId;
                            system.debug('Owner ID State 1----'+ld.OwnerId); 
                        }
                        else if(axcitories.get(AxcitoryID).OwnerId !=null)
                        {
                            ld.Axcitory__c = AxcitoryID;
                            ld.OwnerId = axcitories.get(AxcitoryID).Partner_Recruiter__c;
                            system.debug('Owner ID State 2----'+ld.OwnerId); 
                        }
                   
                }
               
                  else if(ld.PostalCode!=null)
                  {
                  system.debug('Entered PostalCode-----');
                  if(CollectionofPostalCodes.get(ld.state+ld.PostalCode) !=null )
                  {
                           if(ld.Transfer_Lead__c==true)
                           {
                               ld.Axcitory__c = AxcitoryID;
                               ld.OwnerId = axcitories.get(AxcitoryID).OwnerId;
                               system.debug('Owner ID Postal 1----'+ld.OwnerId); 
                           }
                           else
                           {
                               ld.Axcitory__c = AxcitoryID;
                               ld.OwnerId = axcitories.get(AxcitoryID).Partner_Recruiter__c;
                               system.debug('Owner ID Postal 2----'+ld.OwnerId); 
                           }

                    }
                }
            } 

            if((ld.state =='CA'|| ld.state =='NY'|| ld.state =='TX') && ld.PostalCode == null){ld.ownerId = '00580000008hVqu';}
            
            }}private static ID getRangeFromZip(String Zip, Map<string,Zip_Code_Range__c> rangeMap){for(string startZip: rangeMap.KeySet()){if( inZipRange(Zip, rangeMap.get(startZip) ) ) return rangeMap.get(startZip).Axcitory__c;}return null;}private static Boolean inZipRange(string zip, Zip_Code_Range__c range){if(range == null || zip == null) return false;if(zip >= range.Zip_Code_Start__c && zip <= range.Zip_Code_Stop__c) return true;return false;}
    
    public static void initRecordTypesMap(){
        if(recordTypes == null ) return;
        nameToRecordTypesMap = new Map<String,RecordType>();
        for(RecordType record: recordTypes){
            nameToRecordTypesMap.put(record.name,record);
        }
    }
 

}