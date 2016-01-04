public class UpdateAccount {
    public UpdateAccount(ApexPages.StandardController controller) {
    }
    
    Id accountid = ApexPages.CurrentPage().getparameters().get('id');

    Integer count = 0;
 
    public PageReference updateaccounts(){
        try
        {
            Account GetAccount = [select 
            Id,
            Name,
            Case_Count__c,
            Asset_Count__c ,
            Churn_Value__c ,
               PHIL_file_upload_date__c,
               Offsite_Performance_Value__c,
               New_Opportunities_Value__c
               from Account 
               where 
               Id =:accountid] ;
                       
    
        //RecordType OpportunityType = [Select id From RecordType Where SobjectType='Opportunity' AND name = 'EVAL' limit 1];
          
        Integer CaseCount = [select count() from Case where AccountID =:GetAccount.Id and CreatedDate = LAST_N_DAYS:30  ];
          
        Integer AssetCount = [select count() from Asset where AccountID = :GetAccount.Id and HW_Type_1__c ='Appliance' ];
        
        GetAccount.Case_Count__c = CaseCount ;
          
        GetAccount.Asset_Count__c = AssetCount ;
          
        datetime myDateTime = GetAccount.PHIL_file_upload_date__c - 3;
                
        Integer OffsiteCount = [select count() from Asset where AccountID =:GetAccount.Id and Last_Successful_Offsite__c < :myDateTime and HW_Type_1__c ='Appliance'  ];
          
        GetAccount.Offsite_Performance_Value__c = OffsiteCount ;
                           
        Integer OppCount1 = [Select count() from Opportunity where  Accountid =:GetAccount.Id and 
            StageName='Closed Won' and 
            CloseDate = LAST_N_DAYS:60];
          
        Integer OppCount2 = [Select count() from Opportunity where  Accountid =:GetAccount.Id and 
            StageName='Closed Won' and 
            CloseDate = LAST_N_DAYS:120];
                       
        GetAccount.New_Opportunities_Value__c = OppCount1;
          
        GetAccount.New_Opportunities_Value_120_days__c = OppCount2;
          
        System.debug('ACCOUNT ID' + GetAccount.Id);
         
        Integer ChurnCounter=0;
          
        List<Opportunity> GetAllOpps = [select Id, AccountID , Churn_Count__c from Opportunity where Churn_Count__c>0 and AccountID = : GetAccount.Id];
        
        for(Opportunity opp : GetAllOpps)
        {
            List<Churn__c> GetAllChurns = [select Id, Notice_Date__c from Churn__c where Opportunity__c = : opp.Id and Notice_Date__c = LAST_N_DAYS:30 ];
      
            if(GetAllChurns.Size() > 0)
                ChurnCounter++ ; 
        }

               
       System.debug('######## nu####' + ChurnCounter ); 

       if(GetAccount != null && (CaseCount !=0 || AssetCount != 0 || OffsiteCount != 0 || OppCount1 != 0 || OppCount2 != 0 || GetAllOpps.size()>0))
       {
       GetAccount.Churn_Value__c = ChurnCounter ;
       update GetAccount ;
       }
      
      }
      
       catch(Exception e)
       {
            e.getMessage();
            System.debug('######## Message ####' + e.getMessage());      
       }
      
return null;

}
}