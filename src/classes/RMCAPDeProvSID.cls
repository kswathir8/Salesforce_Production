@isTest(seeAllData=true)

global class RMCAPDeProvSID{


/*public static boolean isApexTest = false;
    
       public class IntegrationException extends Exception {}
       
      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
      
      
      @future(callout=true)
      Webservice static void DeProvServiceID(String ServiceID, String ServiceIDName)
      {
      
      
   //   String NetEnrich ;
      
      Asset asst = [select Id, Name,Model_Number__c, Data_Center__r.RMC_Name__c from Asset where Service_ID__c =: ServiceID and Name != 'Axcient DAS Unit' limit 1 ] ;
      
        
      OpportunityLineItem OLI = [select ID,OpportunityID, PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where Asset__c = :asst.Id  LIMIT 1  ] ;
      
      String OpportunityID = OLI.OpportunityID ;
      
      Decimal OffsiteCapacity ;
      
      String PackageValue ;
      
      Opportunity GetOpp = [select  Partner__r.Name, End_Customer__r.Name, End_Customer__c,Partner__c,RMC_EmailA__c,DataCenter__c from Opportunity where ID=: OpportunityID ];
      
      String ResellerName = GetOpp.Partner__r.Name ;
      
      String ClientName =  GetOpp.End_Customer__r.Name ;
      
      String RMCEmail = GetOpp.RMC_EmailA__c ;
      
      String SFDCResellerLong = GetOpp.Partner__c ;
      
      String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      
      String SFDCClientLong = GetOpp.End_Customer__c ;
      
      String SFDCClientID= SFDCClientLong.substring(0, SFDCClientLong.Length()-3);
      
      Integer OLISWCount = [select count() from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS' ] ;
      
      if(OLISWCount > 0)
      
      {     
      OpportunityLineItem OLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
      
      Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c, Model_Number__c from Product2 where Id =: OLISW.PriceBookEntry.Product2Id ];
      
      OffsiteCapacity = Prod.Offsite_Capacity__c ;  
      
      PackageValue = Prod.Package__c ;
      
      }
      
      else
      {
        
        Opportunity Opp = [select Id,Upgraded_From__c from Opportunity where ID=:OpportunityID];
        Opportunity GetOppFrom = [select Id from Opportunity where ID=: Opp.Upgraded_From__c ];
        OpportunityLineItem UndOLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : GetOppFrom.Id and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
        Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c from Product2 where Id =: UndOLISW.PriceBookEntry.Product2Id ];
        
        OffsiteCapacity = Prod.Offsite_Capacity__c ;     
        PackageValue = Prod.Package__c ;
        
      }
      
      String Model = asst.Model_Number__c ;
      
      String DataCenter = asst.Data_Center__r.RMC_Name__c ;
      
      String SerialNumber = asst.Name;
      
      String NetEnrich ;
     
      
      
      
      
       
      
      //String OpportunityID = asst.Opportunity__c ;
      //String DataCenter = asst.Opportunity__r.Data_Center__c ;
      //String SFDCResellerLong = asst.Opportunity__r.AccountID ;
      //String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      //String SFDCClientIDLong = asst.Opportunity__r.End_Customer__c ;
     // String SFDCClientID= SFDCClientIDLong.substring(0, SFDCClientIDLong.Length()-3);
      
 //     OpportunityLineItem OLI = [select ID,PriceBookEntry.ProductCode,Asset__r.Service_ID__r.Name,Asset__r.Name from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c != NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
        
  //    System.debug('************ DeProvServiceID =' + ServiceIDName);
   //   System.debug('************ SerialNumber =' + OLI.Asset__r.Name);
  //    System.debug('************ Model =' + OLI.PriceBookEntry.ProductCode);
      
      String DeProvServiceID = ServiceIDName ;
      //String SerialNumber = OLI.Asset__r.Name ;
      //String Model = OLI.PriceBookEntry.ProductCode ;
      
     // OpportunityLineItem OLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c=NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
    //  Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c from Product2 where Id =: OLISW.PriceBookEntry.Product2Id ];
      
     // Decimal OffsiteCapacity = Prod.Offsite_Capacity__c ;  
      
 //     String PackageValue = Prod.Package__c ;
            
    //  System.debug('************ OffsiteCapacity=' + OffsiteCapacity);
      
    //  System.debug('************ Package Value =' + PackageValue);
                          
      
 
   String datumappdeprov = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+Model+ '",'
      + '"reseller":"'+SFDCResellerID +'",'
      + '"client":"' +SFDCClientID +'",'
      + '"package":"'+ PackageValue +'",'
      + '"offsite":"'+ OffsiteCapacity +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"deactivated'+'"'
      + '}';
     


      
      String endpointapp = URL+'appliance/'+DeProvServiceID;
      Http httpProtocolDeactivateSID = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp ,datumappdeprov);
      System.debug('************ Data sent =' + datumappdeprov );
                  
      try
      {
      HttpResponse responseapp = invokeWebService(httpProtocolDeactivateSID , requestapp );
      System.debug('************ Response =' + responseapp);
      handleWebServiceResponse(responseapp,'Appliance',DeProvServiceID);
      System.debug('******RESPONSE APP*****'+responseapp);
             
     }
     
     catch(DmlException e){
      System.debug('DML Exception : '+ e);
      
    }
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
      
      }
      
      public static HttpRequest buildWebServiceRequest(String endpoint, String body){
      
      HttpRequest request = new HttpRequest();
      request.setEndPoint(endpoint);
      request.setBody(body);
      request.setMethod('PUT');
      request.setHeader('X-API-KEY',KEY);
      request.setHeader('Content-length', String.valueOf(body.length()));
      request.setTimeout(60000);
      
      return request ;
      
      
      
      }
      
      public static HttpResponse invokeWebService(Http h, HttpRequest req){
      HttpResponse res = h.send(req);
      System.debug(res +'Invoke Web Service');
      return res ;
      }

      public static void handleWebServiceResponse(HttpResponse res,String Type, String ServiceID){
      
      System.debug(res +'RESPONSE');
      
      System.debug('Service ID = '+ServiceID)      ;
      
      Service_ID__c ServID = [select Id, Status__c from Service_ID__c where Name =: ServiceID ];
      
      ServID.Status__c = 'Inactive' ;
          
      update ServID ; 
      
      
      }
      
    /*  public static testMethod void TestAPICall() {
   
   String Resellername ='RMC Test Partner Account 2';
   String Clientname ='Atlas Venture Inc' ;
   //Id SFDCResellerId='001V000000BvSx5';
   //String SFDCClientId ='0018000000iPyb6';
   String Status ;
   String message ;
   String Error ;
   String ResellerID ;
   String ClientID ;
   String RMCID ;
   String Type = 'Partner' ;
   String Type2 = 'End Customer' ;
   String Type3 = 'Appliance';
   String SerialNumber= 'ABCDEFGHIJKLMNOPQ';
   String Model ='A20-R-500';
   String DataCenter ='Gen2_SJC';
   String PackageType ='Protect';
   Decimal Offsite = 60 ;
   String Alias = 'abcde';
   String RMCEmail ='teatabc123@gmail.com' ;
   Decimal OffsiteCapacity ;
   String PackageValue ;
   String NetEnrich ;
   String UpgradedFromOppID ;
   String OpportunityID ;
   String SIDStatus1 = 'Create New SID';
   String SIDStatus2 = 'Update Existing SID' ;
   String UpgradeType1 = 'Both';
   String UpgradeType2 = 'Hardware (Appliance)' ;
   String UpgradeType3 = 'Software (Entitlements)';
   
List<RecordType> PartnerrecordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
List<RecordType> ClientrecordID = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
List<RecordType> EnggPartnerrecordID = [select Id from RecordType where name = 'EngTest Partner' and sObjecttype = 'Account' limit 1];
List<RecordType> EnggClientrecordID = [select Id from RecordType where name = 'EngTest End Customer' and sObjecttype = 'Account' limit 1];



Account ResellerAccount = [select Name from Account where RecordTypeId = :PartnerrecordID[0].Id LIMIT 1 ];
Account EndCustomerAccount = [select Name from Account where RecordTypeId = :ClientrecordID[0].Id LIMIT 1 ];
ResellerID = ResellerAccount.Id ;
ClientID = EndCustomerAccount.Id ;

Account EnggResellerAccount = [select Name from Account where RecordTypeId = :EnggPartnerrecordID[0].Id LIMIT 1 ];
Account EnggEndCustomerAccount = [select Name from Account where RecordTypeId = :EnggClientrecordID[0].Id LIMIT 1 ];


Service_ID__c SID1 = new Service_ID__c( Name ='abc1' );
insert SID1 ;

Service_ID__c SID2 = new Service_ID__c( Name ='abc2' );
insert SID2 ;

Service_ID__c SID3 = new Service_ID__c( Name ='abc3' );
insert SID3 ;

Data_Center__c DC = [select Name,RMC_Name__c from Data_Center__c where RMC_Name__c = 'GEN2_SJC' LIMIT 1];

Asset Asset1 = new Asset(Name='AXCIENTTEST123456',Asset_Tag__c='12abe',AccountID = ResellerAccount.id, Service_ID__c = SID1.Id , RMC_End_Customer__c = ClientID , RMC_Model_Number__c = Model , RMC_Checkbox__c = TRUE, RMC_Offsite_Capacity__c = 2000, RMC_Package__c = 'Backup', End_Customer__c = ClientID,Data_Center__c = DC.Id );
insert Asset1; 

Asset Asset2 = new Asset(Name='AXCIENTTEST123457',Asset_Tag__c='12abf', AccountID = ResellerAccount.id,Service_ID__c = SID2.Id , RMC_End_Customer__c = ClientID , RMC_Model_Number__c = Model , RMC_Checkbox__c = TRUE, RMC_Offsite_Capacity__c = 2000, RMC_Package__c = 'Backup', End_Customer__c = ClientID,Data_Center__c = DC.Id );
insert Asset2; 

/*
Asset1.RMC_Model_Number__c = 'A20-TE-2000' ;
update Asset1 ;
Asset2.RMC_Offsite_Capacity__c = 4000 ;
update Asset2 ;


Asset AssetTest = [select Name from Asset where Name!='' and HW_Type_1__c ='Appliance' and Asset_Tag__c !=''  LIMIT 1];

Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where isActive = true and isStandard = false limit 1];
Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];

Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
insert pbk1;

Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true,Offsite_Capacity__c=10,Package__c='Protect');
insert prd1;

Product2 prd2 = new Product2 (Name='Test Product Entry 2',Description='Test Product Entry 2',productCode = '1C4', isActive = true, Product_Type__c='HW', HW_Type__c ='D.A.S',Offsite_Capacity__c=10,Package__c='Protect');
insert prd2;

Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), AccountID = ResellerAccount.id, End_Customer__c = EndCustomerAccount.Id, Partner__c = ResellerAccount.id);
insert opp1;


Opportunity opp2 = new Opportunity (Name='Opp2',StageName='Prospecting',CloseDate=Date.today(), AccountID = ResellerAccount.id, Upgraded_From__c = opp1.Id, End_Customer__c = EndCustomerAccount.Id, Partner__c = ResellerAccount.id );
insert opp2;
UpgradedFromOppID = opp1.Id ;
OpportunityID = opp2.Id ;

PriceBookEntry PBE1 = [Select Id From PricebookEntry where ProductCode= 'A20-TE-1000' and IsActive=TRUE LIMIT 1];
PriceBookEntry PBE2 = [Select Id From PricebookEntry where ProductCode!='DAS' and isActive = TRUE LIMIT 1];
PriceBookEntry PBE3 = [Select Id From PricebookEntry where ProductCode= 'A20-TE-1000' and IsActive=TRUE LIMIT 1];

//[select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;

OpportunityLineItem oli = new OpportunityLineItem (
OpportunityId=opp1.Id,
UnitPrice = 22,
PriceBookEntryId= PBE1.Id ,
Payable_to_Reseller__c = 5,
Quantity =10,
Asset__c = asset1.Id

);
insert oli;

OpportunityLineItem oli2 = new OpportunityLineItem (
OpportunityId=opp2.Id,
UnitPrice = 22,
PriceBookEntryId= PBE2.Id ,
Payable_to_Reseller__c = 5,
Quantity =10


);
insert oli2;

OpportunityLineItem oli3 = new OpportunityLineItem (
OpportunityId=opp1.Id,
UnitPrice = 22,
PriceBookEntryId= PBE3.Id ,
Payable_to_Reseller__c = 5,
Quantity =10


);
insert oli3;


List<RecordType> recordIDCase = [select Id from RecordType where name = 'RMA Case' and sObjecttype = 'Case' limit 1];

Case RMACase = new Case(
            Subject= 'Order Upgrade/Downgrade Request for ' + Resellername,
            
            End_Customer__c = ClientId,
            AccountID = ResellerId,
            RecordTypeID = recordIDCase[0].Id,
            Customer__c = opp1.Id,
            AssetID = asset1.Id
     
            );
insert RMACase ;


// RMCAPIUgrade code coverage

RMCAPDeProvSID.DeProvServiceID(SID1.Id, SID1.Name);

String endpointreseller = URL+'reseller/'+ResellerAccount.Id ;
String endpointclient = URL+'client/'+EndCustomerAccount.Id ;

String datumPartner = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
                
                
                
//RMCAPINewOrderFromOppty.datumapp = datumapp ;             
                
Http httpProtocolGetAccounts = new Http();



String datumclient = '{'
                + '"name": "' + ClientName + '",'
                + '"reseller": "' + ResellerAccount.Id + '"'
                + '}';


String datumapp = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+Model+ '",'
      + '"reseller":"'+ ResellerAccount.Id +'",'
      + '"client":"' + EndCustomerAccount.Id +'",'
      + '"package":"'+ PackageType +'",'
      + '"offsite":"'+ Offsite +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"active'+'"'
      + '}';

String endpointappdeprov= URL+'appliance/';
HttpRequest requestapp1 = RMCAPDeProvSID.buildWebServiceRequest(endpointappdeprov,datumapp);




//HttpRequest requestapp3 = RMCAPIFreshStart.buildWebServiceRequest(endpointreseller,datumapp,Type3);
//Start
Http httpProtocolDeactivateSID = new Http();       // Create HTTP request to send. 
HttpRequest requestappdeprov = new HttpRequest(); // Set the endpoint URL. 

requestappdeprov.setEndPoint(endpointappdeprov);
requestappdeprov.setBody(datumapp);
requestappdeprov.setMethod('POST');
requestappdeprov.setHeader('X-API-KEY',KEY);
requestappdeprov.setHeader('Content-length', String.valueOf(datumapp.length()));



//End


HttpResponse responseapp = new HttpResponse();
HttpResponse responsepartner1 = new HttpResponse();
HttpResponse responseclient1 = new HttpResponse();
HttpResponse responseapp1 = new HttpResponse();
HttpResponse responseapp2 = new HttpResponse();
HttpResponse responsepartner2 = new HttpResponse();
HttpResponse responseclient2 = new HttpResponse();


RMCAPDeProvSID.handleWebServiceResponse(responseapp1,'Appliance',SID1.Name);



}
      
      
      
      public void mainForTest(){
        isApexTest = true;
       
    }
      */
      
      
      
        
     
   }