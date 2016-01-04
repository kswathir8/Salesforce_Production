@isTest(seeAllData=true)
global class RMCAPIFreshStart {

    
public static boolean isApexTest = false;

  static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
  static String URL = RMC_Login__c.getInstance().API_URL__c ;
             
      public class IntegrationException extends Exception {}
      
@future(callout=true)
Webservice static void ServiceIDFreshStart(String RMAAssetId,String AssetId,String CaseID)

 {

     List<Service_ID__c> InsertSID = new List<Service_ID__c>{};
     List<Asset> AssetToUpdate= new List<Asset>{};
      
      Decimal OffsiteCapacity ;
      String PackageValue ;
           
      Asset RMAAsset = [select Name,Status,Service_ID__r.Name,SerialNumber,Model_Number__c,DC1__c,Net_Enrich__c,Opportunity__c,Opportunity__r.Data_Center__c,Opportunity__r.RMC_EmailA__c from Asset where Id =:RMAAssetId];
      
      String SerialNumberDeProv = RMAAsset.Name; // PL
      
      String OppID = RMAAsset.Opportunity__c ;
      
      OpportunityLineItem OLI,OLISW;
      
//      OpportunityLineItem OLI = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where OpportunityID = :OppID and Asset_Tag_Asset__c=NULL  LIMIT 1  ] ;

      OLI = [select ID,OpportunityID, PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where Asset__c = :RMAAsset.Id  LIMIT 1  ] ;
      
      String OpportunityID = OLI.OpportunityID ;
      
      OLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
      
      Opportunity GetOpp = [select  Partner__r.Name, End_Customer__r.Name, End_Customer__c,Partner__c,RMC_EmailA__c,DataCenter__c from Opportunity where ID=: OpportunityID ];
      
      String ResellerName = GetOpp.Partner__r.Name ;
      
      String ClientName =  GetOpp.End_Customer__r.Name ;
      
      String RMCEmail = GetOpp.RMC_EmailA__c ;
      
      String SFDCResellerLong = GetOpp.Partner__c ;
      
      String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      
      String SFDCClientLong = GetOpp.End_Customer__c ;
      
      String SFDCClientID= SFDCClientLong.substring(0, SFDCClientLong.Length()-3);
      
      Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c from Product2 where Id =: OLISW.PriceBookEntry.Product2Id ];
      
      OffsiteCapacity = Prod.Offsite_Capacity__c ;  
      
      PackageValue = Prod.Package__c ;
      
      //String RMCEmail = RMAAsset.Opportunity__r.RMC_EmailA__c ;
     System.debug('************* Product2ID ='+OLI.PriceBookEntry.Product2Id); 
     System.debug('************* RMAAssetID ='+RMAAssetId);
     System.debug('************* SFDC ResellerID='+SFDCResellerId);
     System.debug('************* SFDC Client ID ='+SFDCClientID);
     System.debug('************* Reseller Name='+ResellerName);
     System.debug('************* Client Name ='+ClientName);           
     System.debug('************ OffsiteCapacity=' + OffsiteCapacity);
     System.debug('************ Package Value =' + PackageValue);
      
      String RMAServiceID = RMAAsset.Service_ID__r.Name ;
      String Model = RMAAsset.Model_Number__c ;
      String DataCenter = GetOpp.DataCenter__c ;
      String NetEnrich = RMAAsset.Net_Enrich__c ;
      
      System.debug('************ Model =' +RMAAsset.Model_Number__c );
      System.debug('************ DataCenter =' +DataCenter);
      System.debug('************ NetEnrich =' +RMAAsset.Net_Enrich__c);
      
      Asset NewAsset = [select Name,SerialNumber,Model_Number__c,DC1__c,Net_Enrich__c,Service_Id__c,Service_Id__r.Name from Asset where Id =:AssetId];
      String SerialNumber = NewAsset.Name;
      System.debug('************ New Serial Number =' + NewAsset.SerialNumber);
            
      
      String datum = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
      String endpointreseller = URL+'reseller/'+SFDCResellerID;
      Http httpProtocolInsertReseller = new Http();
      HttpRequest request = buildWebServiceRequest(endpointreseller,datum,'');
           
      try
      {
      HttpResponse response = invokeWebService(httpProtocolInsertReseller ,request);
      handleWebServiceResponse(response,'Reseller','');
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
      }
      catch(System.CalloutException e)
      {
      System.debug('Call out error message : '+ e);
      }
      
      

       String datumclient = '{'
                + '"name": "' + ClientName + '",'
                + '"reseller": "' +SFDCResellerID + '"'
                + '}';
                
      String endpointclient = URL+'client/'+SFDCClientID;
      Http httpProtocolInsertClient = new Http();       // Create HTTP request to send. 
      HttpRequest requestclient = buildWebServiceRequest(endpointclient,datumclient,'');
      
      try
      {
      HttpResponse responseclient = invokeWebService(httpProtocolInsertClient, requestclient );
      handleWebServiceResponse(responseclient,'Client','');
      
      System.debug(responseclient.getBody()+'CLIENT INSERTION CHECK 1') ;
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
    }
    /*    PL CHANGES START        */
    
    String datumappdeprov = '{'
      + '"serial_number":"'+SerialNumberDeProv + '",'
      + '"model":"'+Model+ '",'
      + '"reseller":"'+SFDCResellerID +'",'
      + '"client":"' +SFDCClientID +'",'
      + '"package":"'+ PackageValue +'",'
      + '"offsite":"'+ OffsiteCapacity +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"deactivated'+'",'
      + '"support_tier":"'+NetEnrich + '"'
      + '}';
      
      
      Http httpProtocolDeactivateSID = new Http();       // Create HTTP request to send. 
      HttpRequest requestappdeprov = new HttpRequest(); // Set the endpoint URL. 
      String endpointappdeprov= URL+'appliance/'+RMAAsset.Service_ID__r.Name;
      requestappdeprov.setEndPoint(endpointappdeprov);
      requestappdeprov.setBody(datumappdeprov);
      requestappdeprov.setMethod('PUT');
      requestappdeprov.setHeader('X-API-KEY',KEY);
      requestappdeprov.setHeader('Content-length', String.valueOf(datumappdeprov.length()));
      requestappdeprov.setTimeout(120000);
        
      
     try
      {
      
      HttpResponse responseappdeprov = httpProtocolDeactivateSID.send(requestappdeprov);
      System.debug(responseappdeprov.getBody()+'APPLIANCE INSERTION CHECK 1');  
      
      
      
     } 
      catch(Exception e){
      System.debug('Exception : '+ e);
            
    }
       
     
    
    /*String endpointappdel = URL+'appliance/'+RMAServiceID;
    Http httpProtocolDeactivateSID = new Http();  
    HttpRequest requestappdel = new HttpRequest(); // Set the endpoint URL. 
    requestappdel.setEndPoint(endpointappdel);
    requestappdel.setMethod('DELETE');
    requestappdel.setHeader('X-API-KEY',KEY);

    HttpResponse responseappdel = httpProtocolDeactivateSID.send(requestappdel);   
    */
                   
      
       String datumapp = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+Model+ '",'
      + '"reseller":"'+ SFDCResellerID +'",'
      + '"client":"' + SFDCClientID +'",'
      + '"package":"'+ PackageValue +'",'
      + '"offsite":"'+ OffsiteCapacity +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"active'+'",'
      + '"support_tier":"'+NetEnrich + '"'
      + '}';
      
          
      
      Http httpProtocolInsertAppliance = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = new HttpRequest(); // Set the endpoint URL. 
      String endpointapp = URL+'appliance/';
      requestapp.setEndPoint(endpointapp);
      requestapp.setBody(datumapp);
      requestapp.setMethod('POST');
      requestapp.setHeader('X-API-KEY',KEY);
      requestapp.setHeader('Content-length', String.valueOf(datumapp.length()));
      requestapp.setTimeout(120000);
      
        
      
      try
      {
      
      HttpResponse responseapp = httpProtocolInsertAppliance.send(requestapp);
      System.debug(responseapp.getBody()+'APPLIANCE INSERTION CHECK 1');
      System.debug(responseapp.getHeader('Location')+'APPLIANCE INSERTION CHECK 1');
      System.debug(datumapp);
      
      
           
      //Stop   
      
      
      String Location = String.valueof(responseapp.getHeader('Location'));  // http://rmc01.axcient.net/sfapi/appliance/35rf
      Boolean Success =FALSE ;
      
      if(Location!=NULL)
      {
      String GetGenId = Location.Substring(Location.Length()-4,Location.Length());
      
      System.debug('SERVICE ID: '+ GetGenId);           
      Service_ID__c SID = new Service_ID__c(
      Name = GetGenId 
     
      );
      insert SID;
      
      Asset assetUpdate = [select ID from Asset where ID =: AssetID ];
      assetUpdate.ServiceID__c = Location.Substring(Location.Length()-4,Location.Length());
      assetUpdate.Service_ID__c = SID.Id ;
      update assetUpdate;
      
      System.debug('SID '+SID.Id);
      System.debug('AssetID '+assetUpdate.Id);
      System.debug('SID Name'+SID.Name);
      
     // update assetUpdate;
      
      
      System.debug('RMA SID '+RMAAsset.Service_Id__c);
      System.debug('RMA AssetID '+RMAAsset.Id);
      System.debug('RMA SID Name'+RMAAsset.Service_ID__r.Name);
      
      RMAAsset.Status= 'Pending Return' ;

      update RMAAsset;

      
     
      Service_ID__c ServID = [select Id, Status__c from Service_ID__c where Name =: RMAServiceID ];
      
      ServID.Status__c = 'Inactive' ;
          
      update ServID ; 
      
      Case RMACase = [select Customer__c,RecordTypeID from Case where Id=:CaseID ];
      List<RecordType> recordID = [select Id from RecordType where name = 'RMA Case Fresh Start Provisioned' and sObjecttype = 'Case' limit 1];
      RMACase.RecordTypeID = recordId[0].Id ;
      update RMACase ;
      
      System.debug('**** Opportunity '+RMACase.Customer__c);
      
       if(RMACase.Customer__c!=NULL)
      {
        
        /*OpportunityLineItem OLIHWtoUpdate = [select Asset__c from OpportunityLineItem where OpportunityID =:RMACase.Customer__c ];
        OLIHWtoUpdate.Asset__c = NewAsset.Id ;
        update OLIHWtoUpdate ;
        */
        
        Opportunity UpgradeOpp = [select Id from Opportunity where Id=: RMACase.Customer__c];
        OpportunityLineItem OLINew = [select ID,OpportunityId,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__c,Asset_Type_Asset__c,Asset__r.Asset_Type_1__c from OpportunityLineItem where OpportunityId= :UpgradeOpp.Id    LIMIT 1  ] ;
        OLINew.Asset__c = assetUpdate.Id ;
        update OLINew;
        
         List<RecordType> recordID1 = [select Id from RecordType where name = 'Provisioned Opportunity' and sObjecttype = 'Opportunity' limit 1];
        Opportunity OpptoUpdate = [select Id from Opportunity where Id=: RMACase.Customer__c ] ;
        OpptoUpdate.RecordTypeID = recordID1[0].ID ; 
        update OpptoUpdate ;
      }
      
     // Asset NewAssetUpdate = [select Service_Id__c, Id, Service_Id__r.Name from Asset where Id=:NewAsset.Id];
      
      
      //RMCAPISync.GetServiceID(NewAssetUpdate.Service_Id__c,NewAssetUpdate.Id,NewAssetUpdate.Service_Id__r.Name);
      //RMCAPISync.GetServiceID(RMAAsset.Service_Id__c,RMAAsset.Id,RMAAsset.Service_ID__r.Name);
      
     

      Success = TRUE ;
        
               
        }
        
        if(Success == FALSE)
        {
        throw new IntegrationException('Service ID not created. Please check logs');
               
        }
      
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
            
    }
    
    
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
            
      }      
      
      public static HttpRequest buildWebServiceRequest(String endpoint, String body, String Type){
      
      HttpRequest request = new HttpRequest();
      request.setEndPoint(endpoint);
      
      
      request.setBody(body);
      if(Type=='Appliance')
      {
      request.setMethod('PUT');
      }
      else
      {
      request.setMethod('POST');
      }
      
      request.setHeader('X-API-KEY',KEY);
 //     request.setHeader('Content-length', String.valueOf(body.length()));
      
      return request ;
      
      
      
      }
      
      public static HttpResponse invokeWebService(Http h, HttpRequest req){
      HttpResponse res = h.send(req);
      System.debug(res +'Invoke Web Service');
      return res ;
      }

      public static void handleWebServiceResponse(HttpResponse res,String Type, String RMAServiceID){
      
      System.debug(res.getBody()+'********************INSERTION CHECK*****************************');
      
      if(Type=='ApplianceDeProv')
      {
      System.debug('Service ID = '+RMAServiceID)      ;
      
      Service_ID__c ServID = [select Id, Status__c from Service_ID__c where Name =: RMAServiceID ];
      
      ServID.Status__c = 'Inactive' ;
          
      update ServID ; 
      
      //Start
      String Status ;
      String message ;
      String Error ;
        JSONParser parser = JSON.createParser(res.getBody());
        System.debug('************** 1: '+Status);
        while (parser.nextToken()!= null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
        System.debug('************** 2: '+Status);
       String fieldName = parser.getText();
        parser.nextToken();
        System.debug('************** PARSER: '+parser.getText());
        if(fieldName == 'status') {
            Status = parser.getText();
            System.debug('************** STATUS: '+Status);
            
        }
        else if(fieldName == 'message'){
        message = parser.getText();
        System.debug('************** MESSAGE: '+message);
        }
        else if(fieldName == 'validation_errors'){
        
        parser.nextToken();
        parser.nextToken();
        error = parser.getText();
        System.debug('************** validation_errors: '+error);
        }
        
        
        } 
        
        }
        
        if(Status=='400')
        {
        
        throw new IntegrationException('Service ID not created.'+message+error);
        
        }
      
            
      }
      
      
      /*
      if(Type=='ApplianceCreate')
      {
      
      String Location = String.valueof(res.getHeader('Location'));  // http://rmc01.axcient.net/sfapi/appliance/35rf
      //Boolean Success =FALSE ;
      
      if(Location!=NULL)
      {
      String GetGenId = Location.Substring(Location.Length()-4,Location.Length());
      
      System.debug('SERVICE ID: '+ GetGenId);           
      Service_ID__c SID = new Service_ID__c(
      Name = GetGenId 
     
      );
      insert SID;
      */
      
      
      }
      
      
      
 /****  public static testMethod void TestAPICall() {
       
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

Asset Asset1 = new Asset(Name='AXCIENTTEST123456',Asset_Tag__c='12abe',AccountID = ResellerId, Service_ID__c = SID1.Id , RMC_End_Customer__c = ClientID , RMC_Model_Number__c = Model , RMC_Checkbox__c = TRUE, RMC_Offsite_Capacity__c = 2000, RMC_Package__c = 'Backup', End_Customer__c = ClientID,Data_Center__c = DC.Id );
insert Asset1; 

Asset Asset2 = new Asset(Name='AXCIENTTEST123457',Asset_Tag__c='12abf',AccountID = ResellerId, Service_ID__c = SID2.Id , RMC_End_Customer__c = ClientID , RMC_Model_Number__c = Model , RMC_Checkbox__c = TRUE, RMC_Offsite_Capacity__c = 2000, RMC_Package__c = 'Backup', End_Customer__c = ClientID,Data_Center__c = DC.Id );
insert Asset2; 

/*
Asset1.RMC_Model_Number__c = 'A20-TE-2000' ;
update Asset1 ;
Asset2.RMC_Offsite_Capacity__c = 4000 ;
update Asset2 ;
*/


/****Asset AssetTest = [select Name from Asset where Name!='' and HW_Type_1__c ='Appliance' and Asset_Tag__c !=''  LIMIT 1];

Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where isActive = true and isStandard = false limit 1];
Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];

Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
insert pbk1;

Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true,Offsite_Capacity__c=10,Package__c='Protect');
insert prd1;

Product2 prd2 = new Product2 (Name='Test Product Entry 2',Description='Test Product Entry 2',productCode = '1C4', isActive = true, Product_Type__c='HW', HW_Type__c ='D.A.S',Offsite_Capacity__c=10,Package__c='Protect');
insert prd2;

Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), Partner__c = ResellerAccount.Id,  End_Customer__c = EndCustomerAccount.Id);
insert opp1;


Opportunity opp2 = new Opportunity (Name='Opp2',StageName='Prospecting',CloseDate=Date.today(),Partner__c = ResellerAccount.Id,  Upgraded_From__c = opp1.Id, End_Customer__c = EndCustomerAccount.Id );
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

String endpointreseller = URL+'reseller/'+ResellerAccount.Id ;
String endpointclient = URL+'client/'+EndCustomerAccount.Id ;

String datumPartner = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
                
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
      
      HttpResponse responseapp = new HttpResponse();
HttpResponse responsepartner1 = new HttpResponse();
HttpResponse responseclient1 = new HttpResponse();
HttpResponse responseapp1 = new HttpResponse();
HttpResponse responseapp2 = new HttpResponse();
HttpResponse responsepartner2 = new HttpResponse();
HttpResponse responseclient2 = new HttpResponse();


RMCAPIFreshStart.ServiceIDFreshStart(asset1.Id,Asset2.Id, RMACase.Id );
HttpRequest requestpartner2 = RMCAPIFreshStart.buildWebServiceRequest(endpointreseller,datumPartner,'');
HttpRequest requestclient2 = RMCAPIFreshStart.buildWebServiceRequest(endpointclient,datumclient,'');RMCAPIRMA.handleWebServiceResponse(responseapp,Type2,asset1.Id,asset2.Id,RMACase.Id);
RMCAPIFreshStart.handleWebServiceResponse(responseapp,Type,'');
RMCAPIFreshStart.handleWebServiceResponse(responseapp,Type2,'');



       
       
       
       
}  */  
      
      
        
     
   }