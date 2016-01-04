global class UpdateAccountFields
{
    @future(callout=true)
    public static void UpdateAccounts()
    
      {   
        
       Date TodayDate = System.Today();
       
       List<ID> accId= new List<ID>();
       List<Account> AccountsToUpdate = new List<Account>();              
       List<Account> AccountList = new List<Account>(
       [select Id,
       Name,
       HC_01__c,
       HC_02__c,
       HC_03__c,
       HC_04__c,
       HC_05__c,
       HC_06__c,
       HC_07A__c,
       HC_07B__c,
       HC_08__c,
       HC_09__c
       from Account 
       where 
       RecordTypeID ='01280000000BQhw' 
       and Partner_Membership_Level__c != ''       
       
       ] 
       );
       
       system.debug('*********' + AccountList.size() );
       
       

       for(Account acc : AccountList)
{
    accId.add(acc.id);
}
 system.debug('#########' + accId.size());
      List<Account> AccCurr = new List<Account>();
      AccCurr= [select Id,Name,HC_01__c,HC_02__c,HC_03__c,HC_04__c,HC_05__c,HC_06__c,HC_07A__c,HC_07B__c,HC_08__c,HC_09__c from Account where Id in:accId ];
      list<string> SFDCAccid = new list<string>();
      for(integer i=0;i<AccCurr.size();i++)
      {
          SFDCAccid.add(AccCurr[i].Id);
      }

      system.debug('@@@@@@@@@@@SFDCAccid:'+SFDCAccid);
      
      list<aggregateResult> CaseCount = [select count(id), AccountID from Case where AccountID in: SFDCAccid and CreatedDate = LAST_N_DAYS:60 group by AccountID  ]; // PL
      Map<ID,integer> SFDCAccountMap1 = new Map<id,integer>();
      for(AggregateResult ar : CaseCount){
      SFDCAccountMap1.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }
               
      list<aggregateResult> AssetCount = [select count(id),AccountID from Asset where AccountID in: SFDCAccid and Asset_Type_1__c ='HW' and HW_Type_1__c='Appliance' group by AccountID ]; // PL
      Map<ID,integer> SFDCAccountMap2 = new Map<id,integer>();
      for(AggregateResult ar : AssetCount){
      SFDCAccountMap2.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }
     
      
      list<aggregateResult> EmailCount = [select count(id),AccountID from Case where AccountID in: SFDCAccid and Time_in_Escalated_Bus_Hrs__c > 0 and CreatedDate = LAST_N_DAYS:30 group by AccountID ]; // PL
      Map<ID,integer> SFDCAccountMap3 = new Map<id,integer>();
      for(AggregateResult ar : EmailCount){
      SFDCAccountMap3.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }
      
      list<aggregateResult> OppCount1  = [select count(id),AccountID from Opportunity where AccountID in: SFDCAccid and StageName='Closed Won' and 
      CloseDate = LAST_N_DAYS:90 and (not Name like '%NFR%') and Status__c = 'Active' group by AccountID ]; // PL
      Map<ID,integer> SFDCAccountMap4 = new Map<id,integer>();
      for(AggregateResult ar : OppCount1){
      SFDCAccountMap4.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }
      
      
      list<aggregateResult> OppCount2  = [select count(id),AccountID from Opportunity where AccountID in: SFDCAccid and StageName='Closed Won' and 
      CloseDate = LAST_N_DAYS:90 and (not Name like '%NFR%') and Status__c = 'Inactive - Cancelled' group by AccountID ]; // PL
      Map<ID,integer> SFDCAccountMap5 = new Map<id,integer>();
      for(AggregateResult ar : OppCount2){
      SFDCAccountMap5.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }
      
       list<Opportunity> OppCount3 = [select CloseDate, AccountID from Opportunity where AccountID in: SFDCAccid and StageName='Closed Won'  and Status__c = 'Active' order by closedate desc]; 
      Map<Id,date> SFDCAccountMap6 = new Map<Id,Date>();
      for(opportunity ar : OppCount3){
        system.debug('######ar:'+ar);
        SFDCAccountMap6.put(ar.AccountId,ar.CloseDate);
        system.debug('######SFDCAccountMap6:'+SFDCAccountMap6);
        }
      
      
      list<On_Boarding__c> OnBoard = [select Id,LastModifiedDate from On_Boarding__c where Account__c = :SFDCAccid and Status__c ='Closed' and RecordTypeID = '01I80000000xnnE' ]; 
      Map<Id,date> SFDCAccountMap7 = new Map<Id,Date>();
      for(On_Boarding__c ar : OnBoard){
        system.debug('######ar:'+ar);
        Datetime CloseDateTime = ar.LastModifiedDate ;
        Date GetClosedDate = date.newinstance(CloseDateTime.year(), CloseDateTime.month(), CloseDateTime.day());
        SFDCAccountMap7.put(ar.Account__c,GetClosedDate);
        system.debug('######SFDCAccountMap7:'+SFDCAccountMap7);
        }
        
        
        

      list<aggregateResult> ContactCount = [select count(id),AccountID from Contact where AccountID in: SFDCAccid and ACE_Certified__c = 'Yes' group by AccountID  ];
      Map<ID,integer> SFDCAccountMap = new Map<id,integer>();
      for(AggregateResult ar : ContactCount){
          system.debug('@@@@@@@@@@@@@@@@@Ar:'+ar);
          SFDCAccountMap.put((ID)ar.get('AccountId'),(integer)ar.get('expr0'));
      }

      system.debug('@@@@@@@@@@@@@@@@@SFDCAccountMap:'+SFDCAccountMap);

      for(integer i=0;i<AccCurr.size();i++)
      {
      
          system.debug('AccCurr[i].Id:'+AccCurr[i].Id);
          integer c = SFDCAccountMap.get(AccCurr[i].Id);
          date d = SFDCAccountMap6.get(AccCurr[i].Id) ;
          
          if(d!=NULL)
          {
          Integer GetDateDays =  d.daysBetween(TodayDate);
          AccCurr[i].HC_06__c =  GetDateDays ;          
          }

          system.debug('@@@@@@@@c:'+SFDCAccountMap.get(AccCurr[i].Id)); 
          system.debug('@@@@@@@@c:'+c);
          
          AccCurr[i].HC_05__c = SFDCAccountMap.get(AccCurr[i].Id) ;
          AccCurr[i].Case_Count__c = SFDCAccountMap1.get(AccCurr[i].Id) ;
          AccCurr[i].Asset_Count__c = SFDCAccountMap2.get(AccCurr[i].Id) ;
          AccCurr[i].Last_Opportunity_Created_Date__c =  d ;
          
          AccCurr[i].HC_03__c = SFDCAccountMap3.get(AccCurr[i].Id) ;
          AccCurr[i].HC_07a__c= SFDCAccountMap4.get(AccCurr[i].Id) ;    
          AccCurr[i].HC_07b__c= SFDCAccountMap5.get(AccCurr[i].Id) ;    
          AccCurr[i].HC_ObCloseDate__c = SFDCAccountMap7.get(AccCurr[i].Id) ;
          
      }
      
      update AccCurr ;    
 
   }

}