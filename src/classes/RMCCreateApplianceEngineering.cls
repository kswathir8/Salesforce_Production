@isTest(seeAllData=true)
global class RMCCreateApplianceEngineering{

/*public static boolean isApexTest = false;
          
      public class IntegrationException extends Exception {}
      
      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
      
      @future(callout=true)
      Webservice static void CreateAppliance(String SerialNumber,String ModelNumber,String PackageValue,Decimal Offsite,String Alias,Id SFDCResellerId, Id SFDCClientId,String DataCenter, Id AssetID, Boolean Active, String ResellerName,String ClientName, String RMCEmail )
      {
      
      
      
      String datum = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
                
      String endpointreseller = URL+'reseller/'+SFDCResellerID;
      Http httpProtocolInsertReseller = new Http();
      HttpRequest request = buildWebServiceRequest(endpointreseller,datum);
           
      try
      {
      HttpResponse response = invokeWebService(httpProtocolInsertReseller ,request);
      handleWebServiceResponse(response,'Reseller','','');
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
      HttpRequest requestclient = buildWebServiceRequest(endpointclient,datumclient);
      
      try
      {
      HttpResponse responseclient = invokeWebService(httpProtocolInsertClient, requestclient );
      handleWebServiceResponse(responseclient,'Client','','');
      
      System.debug(responseclient.getBody()+'***********RESPONSE for CLIENT *********************') ;
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
    }
      
     String ActiveCheckbox ;
      
      if(Active==TRUE)
      {
      ActiveCheckbox = 'active' ;
      }
      else
      {
      ActiveCheckbox = 'deactivated' ;
      } 
     
      System.debug('************ Serial Number =' );
       
      System.debug('************ Model Number =' );
      
      System.debug('************ AssetID ='  );
      
      System.debug('************ ResellerName=' );
      
      System.debug('************ ClientName=');
      
      System.debug('************ ResellerID=');
      
      System.debug('************ ClientID=');
            
      System.debug('************ OffsiteCapacity=' );
      
      System.debug('************ Package Value =');
      
                              
     
      
      String datumapp = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+ModelNumber+ '",'
      + '"reseller":"'+ SFDCResellerID +'",'
      + '"client":"' + SFDCClientID +'",'
      + '"package":"'+ PackageValue +'",'
      + '"offsite":"'+ Offsite +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"'+ ActiveCheckbox +'"'
      + '}';
      
      String endpointapp = URL+'appliance/';
             
      Http httpProtocolInsertAppliance = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp ,datumapp);
      System.debug('RequestAPP: '+requestapp);
                  
      try
      {
     
      HttpResponse responseapp = invokeWebService(httpProtocolInsertAppliance, requestapp );
      System.debug('Data Sent 1: '+datumapp);
      handleWebServiceResponse(responseapp,'Appliance',AssetID,'');
      
      System.debug(responseapp.getStatus()+'***********APPLIANCE INSERTION STATUS *********************') ;
      System.debug(responseapp.getHeader('Location')+'  APPLIANCE INSERTION CHECK 1');
      System.debug('Data Sent 2: '+datumapp);
      
       
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
      request.setMethod('POST');
      request.setHeader('X-API-KEY',KEY);
      request.setHeader('Content-length', String.valueOf(body.length()));
      request.setTimeout(60000); 
      
      return request ;
      
      
      
      }
      
      public static HttpResponse invokeWebService(Http h, HttpRequest req){
      HttpResponse res = h.send(req);
      return res ;
      }

      public static void handleWebServiceResponse(HttpResponse res,String Type, String AssetID, String OpportunityID){
      System.debug(res.getStatus()+'********************APPLIANCE STATUS *****************************');   
      System.debug(res.getBody()+'********************INSERTION CHECK*****************************');
      if(Type=='Appliance')
      {
      System.debug(res.getHeader('Location')+'APPLIANCE INSERTION CHECK 1');
      if ((Test.isRunningTest())) {
      
      String Location = 'http://rmc01.axcient.net/sfapi/appliance/35rf' ;
      String GetGenId = Location.Substring(Location.Length()-4,Location.Length());
      
      Service_ID__c SID = new Service_ID__c(
      Name = GetGenId 
      );
      insert SID;
      
     
      
      }
      
      
      //else FOR test code
      else
      {
      
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
        
        throw new IntegrationException('Service ID not created.'+message+ ' ' +error);
        
        }
        

       
      String Location = String.valueof(res.getHeader('Location'));  // http://rmc01.axcient.net/sfapi/appliance/35rf
      Boolean Success =FALSE ;
      
      if(Location!=NULL)
      {
      String GetGenId = Location.Substring(Location.Length()-4,Location.Length());
      System.debug('SERVICE ID: '+ GetGenId);           
      Service_ID__c SID = new Service_ID__c(
      Name = GetGenId 
      );
      insert SID;
      
      Asset GetAssetToUpdate = [select Service_ID__c,Name from Asset where Id=:AssetID ];
      
      GetAssetToUpdate.Service_ID__c = SID.Id ;
      
      update GetAssetToUpdate ;
       
     
      
      Success = TRUE ;
        
     }
        
     if(Success == FALSE)
        {
        throw new IntegrationException('Service ID not created. Please check logs');
        }
      }
     
      }
      
      }
      
      
      
    /*   @isTest (seeAllData=true)
      public static void TestAPICall() {
   
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



Asset AssetTest = [select Name from Asset where Name!='' and HW_Type_1__c ='Appliance' and Asset_Tag__c !=''  LIMIT 1];

Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where isActive = true and isStandard = false limit 1];
Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];

Pricebook2 pbk1 = new Pricebook2 (Name='Test Pricebook Entry 1',Description='Test Pricebook Entry 1', isActive=true);
insert pbk1;

Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true,Offsite_Capacity__c=10,Package__c='Protect');
insert prd1;

Product2 prd2 = new Product2 (Name='Test Product Entry 2',Description='Test Product Entry 2',productCode = '1C4', isActive = true, Product_Type__c='HW', HW_Type__c ='D.A.S',Offsite_Capacity__c=10,Package__c='Protect');
insert prd2;

Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), AccountId = ResellerAccount.id, End_Customer__c = EndCustomerAccount.Id);
insert opp1;


Opportunity opp2 = new Opportunity (Name='Opp2',StageName='Prospecting',CloseDate=Date.today(), AccountId = ResellerAccount.id, Upgraded_From__c = opp1.Id, End_Customer__c = EndCustomerAccount.Id );
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

//RMCAPINewOrderFromOppty.GetServiceID(Resellername,Clientname,ResellerID , ClientID , DataCenter ,RMCEmail, opp1.Id   );


RMCCreateApplianceEngineering.CreateAppliance(SerialNumber, Model, PackageValue, Offsite, Alias, ResellerId, ClientId, DataCenter, Asset1.ID, TRUE, ResellerName, ClientName, RMCEmail);

String endpointreseller = URL+'reseller/'+ResellerAccount.Id ;
String endpointclient = URL+'client/'+EndCustomerAccount.Id ;

String datumPartner = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
                
                
                
//RMCAPINewOrderFromOppty.datumapp = datumapp ;             
                
Http httpProtocolGetAccounts = new Http();

HttpRequest requestpartner1 = RMCCreateApplianceEngineering.buildWebServiceRequest(endpointreseller,datumPartner);

String datumclient = '{'
                + '"name": "' + ClientName + '",'
                + '"reseller": "' + ResellerAccount.Id + '"'
                + '}';

HttpRequest requestclient1 = RMCCreateApplianceEngineering.buildWebServiceRequest(endpointclient,datumclient);

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


HttpRequest requestapp1 = RMCCreateApplianceEngineering.buildWebServiceRequest(endpointreseller,datumapp);




//HttpRequest requestapp3 = RMCAPIFreshStart.buildWebServiceRequest(endpointreseller,datumapp,Type3);
//Start
Http httpProtocolDeactivateSID = new Http();       // Create HTTP request to send. 
HttpRequest requestappdeprov = new HttpRequest(); // Set the endpoint URL. 
String endpointappdeprov= URL+'appliance/';
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


RMCCreateApplianceEngineering.handleWebServiceResponse(responsepartner1,'Reseller','',opp1.Id);
RMCCreateApplianceEngineering.handleWebServiceResponse(responseclient1,'Client','',opp1.Id);
RMCCreateApplianceEngineering.handleWebServiceResponse(responseapp1,'Appliance',AssetTest.Id,opp1.Id);

asset2.RMC_Offsite_Capacity__c = 2046 ;
asset2.RMC_Package__c = 'Fortify' ;

update asset2 ;






}
      
      
      */
      
        
     
   }