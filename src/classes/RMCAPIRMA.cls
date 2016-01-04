@isTest(seeAllData=true)
global class RMCAPIRMA {

    /*  public static boolean isApexTest = false;

      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
      
      public class IntegrationException extends Exception {}
      
      @future(callout=true)
      Webservice static void GetRMAServiceID(String RMAAssetId, String AssetId,String CaseID)
      {
      
      
      
      
     Decimal OffsiteCapacity ;
     String PackageValue ;
     
          
      Asset RMAAsset = [select ID,Service_ID__r.Name,SerialNumber,Model_Number__c,DC1__c,Net_Enrich__c,Opportunity__c from Asset where Id =:RMAAssetId];
      
      String OppID = RMAAsset.Opportunity__c ;
      
      //OpportunityLineItem OLI = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where OpportunityID = :OppID and Asset_Tag_Asset__c=NULL  LIMIT 1  ] ;
      
      OpportunityLineItem OLI = [select ID,OpportunityId,PriceBookEntry.Product2Id,Asset_Tag_Asset__c from OpportunityLineItem where Asset__c= :RMAAssetId   LIMIT 1  ] ;
      
      String OpportunityID = OLI.OpportunityID ;
      
      //add check for upgraded / old opportunity for latest software package
      
      OpportunityLineItem OLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
      
      Opportunity GetOpp = [select  Partner__r.Name, End_Customer__r.Name, End_Customer__c,AccountID,RMC_EmailA__c,DataCenter__c from Opportunity where ID=: OpportunityID ];
      
      String ResellerName = GetOpp.Partner__r.Name ;
      
      String ClientName =  GetOpp.End_Customer__r.Name ;
      
      String RMCEmail = GetOpp.RMC_EmailA__c ;
      
      String SFDCResellerLong = GetOpp.Partner__c ;
      
      String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      
      String SFDCClientLong = GetOpp.End_Customer__c ;
      
      String SFDCClientID= SFDCClientLong.substring(0, SFDCClientLong.Length()-3);
      
      System.debug('************* Product2ID ='+OLI.PriceBookEntry.Product2Id);
      
      Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c from Product2 where Id =: OLISW.PriceBookEntry.Product2Id ];
      
      OffsiteCapacity = Prod.Offsite_Capacity__c ;  
      
      PackageValue = Prod.Package__c ;
            
      System.debug('************ OffsiteCapacity=' + OffsiteCapacity);
      
      System.debug('************ Package Value =' + PackageValue);
      
      System.debug('************* RMAAssetID ='+RMAAssetId);
      
      System.debug('************* SFDC ResellerID='+SFDCResellerId);
      
      System.debug('************* SFDC Client ID ='+SFDCClientID);
      
      String RMAServiceID = RMAAsset.Service_ID__r.Name ;
      
      String Model = RMAAsset.Model_Number__c ;
      String DataCenter = GetOpp.DataCenter__c ;
      String NetEnrich = RMAAsset.Net_Enrich__c ;
      
      System.debug('************ Model =' +RMAAsset.Model_Number__c );
      System.debug('************ DataCenter =' + GetOpp.DataCenter__c);
      System.debug('************ NetEnrich =' +RMAAsset.Net_Enrich__c);
      
      Asset NewAsset = [select Name,SerialNumber,Model_Number__c,DC1__c,Net_Enrich__c from Asset where Id =:AssetId];
      String SerialNumber = NewAsset.Name;
      System.debug('************ New Serial Number =' + NewAsset.SerialNumber);
            
                                     
      String datumapp = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+Model+ '",'
      + '"reseller":"'+SFDCResellerID +'",'
      + '"client":"' +SFDCClientID +'",'
      + '"package":"'+ PackageValue +'",'
      + '"offsite":"'+ OffsiteCapacity +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"active'+'"'
      + '}';
      
      String endpointapp = URL+'/appliance/'+RMAServiceID ;
             
      Http httpProtocolInsertAppliance = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp ,datumapp);
      System.debug('************ Data sent =' + datumapp );
                  
      try
      {
     
      HttpResponse responseapp = invokeWebService(httpProtocolInsertAppliance, requestapp );
      System.debug('************ Response =' + responseapp);
      handleWebServiceResponse(responseapp,'Appliance',AssetID,RMAAssetId,CaseID);
      System.debug(responseapp.getBody()+'APPLIANCE INSERTION CHECK 1');
      System.debug(responseapp.getHeader('Location')+'APPLIANCE INSERTION CHECK 1');
      System.debug(datumapp);
             
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

      public static void handleWebServiceResponse(HttpResponse res,String Type, String AssetID, String RMAAssetID,String CaseID){
      
      System.debug(res.getBody()+'********************INSERTION CHECK*****************************');
      
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
        throw new IntegrationException('Service ID not created.'+message+' '+error);
        }
      
      Asset RMAedAsset = [select Id,Name,Service_ID__c, Status from Asset where Id =:RMAAssetID] ;
      
      //OpportunityLineItem OLI = [select ID,OpportunityId,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__c from OpportunityLineItem where Asset__c= :RMAAssetId   LIMIT 1  ] ;
      
      Asset NewAsset = [select Id,Name,Service_Id__c, Status from Asset where Id =: AssetID];
      NewAsset.Service_ID__c = RMAedAsset.Service_Id__c ;
      update NewAsset ;
      
      RMAedAsset.Service_Id__c = NULL ;
      RMAedAsset.Status= 'Pending Return' ;
      update RMAedAsset ;
      
      //OLI.Asset__c = NewAsset.Id ;
      
      //update OLI ;
      
      Case RMACase = [select Customer__c,RecordTypeID from Case where Id=:CaseID ];
      List<RecordType> recordID = [select Id from RecordType where name = 'RMA Case Migration Provisioned' and sObjecttype = 'Case' limit 1];
      RMACase.RecordTypeID = recordId[0].Id ;
      update RMACase ;
      
      if(RMACase.Customer__c!=NULL)
      {
        Opportunity UpgradeOpp = [select Id from Opportunity where Id=: RMACase.Customer__c];
        OpportunityLineItem OLI = [select ID,OpportunityId,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__c,Asset_Type_Asset__c,Asset__r.Asset_Type_1__c from OpportunityLineItem where OpportunityId= :UpgradeOpp.Id    LIMIT 1  ] ;
        
        OLI.Asset__c = NewAsset.Id ;
        update OLI;
        
      }
      
      
      
      
      
      
      }
      
     /* 
       public static testMethod void TestAPICall() {
       
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

Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(),AccountId = ResellerAccount.id, End_Customer__c = EndCustomerAccount.Id, Partner__c = ResellerAccount.Id);
insert opp1;


Opportunity opp2 = new Opportunity (Name='Opp2',StageName='Prospecting',CloseDate=Date.today(), AccountId = ResellerAccount.id, Upgraded_From__c = opp1.Id, End_Customer__c = EndCustomerAccount.Id, Partner__c = ResellerAccount.Id );
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


RMCAPIRMA.GetRMAServiceID(asset1.Id,Asset2.Id, RMACase.Id );
HttpRequest requestpartner3 = RMCAPIRMA.buildWebServiceRequest(endpointreseller,datumPartner);
HttpRequest requestclient3 = RMCAPIRMA.buildWebServiceRequest(endpointclient,datumclient);
RMCAPIRMA.handleWebServiceResponse(responseapp,Type2,asset1.Id,asset2.Id,RMACase.Id);


       
       
       
       
}
      
*/      
      
        
     
}