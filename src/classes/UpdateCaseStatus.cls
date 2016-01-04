global class UpdateCaseStatus
{
    @future(callout=true)
    public static void UpdateCases()
    
      {   //for our simple example we are going to just update the quotes on one Account
       
       List<Case> CasesList = new List<Case>([select Id,FLAGS__ViewedFlag__c,status,OwnerID from Case where Status !='Closed' and Status!='Pending Partner Close'  ] );
  List<Case> CasesToUpdate = new List<Case>();
  List<Case> CasesToUpdatewithNULL = new List<Case>();
  
  
  for(Case c : CasesList)
  {
      if(c.OwnerId != '00G800000022jgR' && c.OwnerID !='00G800000023L19' && c.FLAGS__ViewedFlag__c == NULL  )
      {
      c.FLAGS__ViewedFlag__c = DateTime.Now();
      CasesToUpdatewithNULL.add(c);
      }
      
      if(c.OwnerId != '00G800000022jgR' && c.OwnerID !='00G800000023L19' )
      {
      CasesToUpdate.add(c);
      }
      
  }
   
update CasesToUpdate;
update CasesToUpdatewithNULL;

   
       

   }

}