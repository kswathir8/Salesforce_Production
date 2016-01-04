public class caseupdatecont{

public Boolean showButton {get;set;}

   public caseupdatecont(ApexPages.StandardController controller) {
   
   if(ProfileID=='00e80000001OM80')
       {
         showButton=true;
        }
      else{
            showButton=false;
        }
     
    }

Id caseid = ApexPages.CurrentPage().getparameters().get('id');

String UserType = UserInfo.getUserType();

String ProfileId = UserInfo.getProfileId();    

Integer count = 0;
 
public PageReference updatecases() 
{


List<Case> CasesList = new List<Case>([select Id,FLAGS__ViewedFlag__c,status,OwnerID from Case where Status !='Closed' and Status!='Pending Partner Close'  ] );
  List<Case> CasesToUpdate = new List<Case>();
  List<Case> CasesToUpdatewithNULL = new List<Case>();
  
  
  for(Case c : CasesList)
  {
      if(c.OwnerId != '00G800000022jgR' && c.OwnerID !='00G800000023L19' && c.FLAGS__ViewedFlag__c == NULL && UserType != 'Partner' && UserType != 'Customer Portal User' && UserType != 'Customer Portal Manager' )
      {
      c.FLAGS__ViewedFlag__c = DateTime.Now();
      CasesToUpdatewithNULL.add(c);
      }
      
      if(c.OwnerId != '00G800000022jgR' && c.OwnerID !='00G800000023L19' && UserType != 'Partner' && UserType != 'Customer Portal User' && UserType != 'Customer Portal Manager' )
      {
      CasesToUpdate.add(c);
      }
      
  }
   
update CasesToUpdate;
update CasesToUpdatewithNULL;
   
 return null;
  



  }


}