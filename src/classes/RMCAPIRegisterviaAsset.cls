global class RMCAPIRegisterviaAsset{

public static boolean isApexTest = false;

      public class IntegrationException extends Exception {}
      
      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
       
      @future(callout=true)
      Webservice static void GetServiceID(String AssetID,String SIDText,String DataCenter )
      {

      //Decimal OffsiteCapacity ;
      //String PackageValue ;
      //String NetEnrich ;
      
      Integer OLICountHW = [select count() from OpportunityLineItem where Asset__c = : AssetID and Asset_Tag_Asset__c !=NULL and PriceBookEntry.ProductCode!='DAS'];
      
      if(OLICountHW == 0)
		      {
		      
		       throw new IntegrationException('Select a HW Product in the underlying Opportunity ');
		      
		      }
      
      //OpportunityLineItem OLIHW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c,PriceBookEntry.ProductCode  from OpportunityLineItem where OpportunityID = : OpportunityID and Asset_Tag_Asset__c !=NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
      
      OpportunityLineItem OLIHW = [select ID,OpportunityID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c,PriceBookEntry.ProductCode  from OpportunityLineItem where Asset__c = : AssetID  LIMIT 1  ] ;
                  
      //String ServiceIDtoBeUpdated = SIDText ;
      
      //String OpportunityID = OLIHW.OpportunityID ;
      
      Opportunity GetOpp = [select  Partner__r.Name, End_Customer__r.Name, End_Customer__c,Partner__c,RMC_EmailA__c from Opportunity where ID=: OLIHW.OpportunityID ];
      
      //String ResellerName = GetOpp.Account.Name ;
      
      //String ClientName =  GetOpp.End_Customer__r.Name ;
      
      //String RMCEmail = GetOpp.RMC_EmailA__c ;
      
      String SFDCResellerLong = GetOpp.Partner__c ;
      
      String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      
      String SFDCClientLong = GetOpp.End_Customer__c ;
      
      String SFDCClientID= SFDCClientLong.substring(0, SFDCClientLong.Length()-3);
      
          
      Integer OLICountSW = [select count()from OpportunityLineItem where OpportunityID = : GetOpp.Id and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS' ] ;
      
      if(OLICountSW == 0)
      {
      throw new IntegrationException('Select a SW Product in the underlying opportunity');
      }
         
      OpportunityLineItem OLISW = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c,Asset__c  from OpportunityLineItem where OpportunityID = : GetOpp.Id and Asset_Tag_Asset__c =NULL and PriceBookEntry.ProductCode!='DAS'  LIMIT 1  ] ;
            
      System.debug('************* Product2ID ='+OLIHW.PriceBookEntry.Product2Id);
      
      Product2 Prod = [select ID,ProductCode,Offsite_Capacity__c, Package__c from Product2 where Id =: OLISW.PriceBookEntry.Product2Id ];
      
      //OffsiteCapacity = Prod.Offsite_Capacity__c ;  
      
      //PackageValue = Prod.Package__c ;
      
      String SerialNumber = OLIHW.Asset__r.Name ;
      
      //String Model = OLIHW.PriceBookEntry.ProductCode ;
      
      //String AssetID = OLIHW.Asset__c ;
      
      System.debug('************ Serial Number =' + OLIHW.Asset__r.Name);
       
     // System.debug('************ Model Number =' + Model);
      
      //System.debug('************ AssetID =' + AssetID );
      
     // System.debug('************ ResellerName=' + ResellerName);
      
     // System.debug('************ ClientName=' + ClientName);
      
      System.debug('************ ResellerID=' + SFDCResellerID);
      
      System.debug('************ ClientID=' + SFDCClientID);
            
     // System.debug('************ OffsiteCapacity=' + OffsiteCapacity);
      
      //System.debug('************ Package Value =' + PackageValue);
                              
      String datum = '{'
                + '"name": "' + GetOpp.Partner__r.Name + '",'
                + '"mail": "' + GetOpp.RMC_EmailA__c + '"'
                + '}';
                
      String endpointreseller = URL+'reseller/'+SFDCResellerID;
      Http httpProtocolInsertReseller = new Http();
      HttpRequest request = buildWebServiceRequest(endpointreseller,datum,'');
           
      try
      		{
	      HttpResponse response = invokeWebService(httpProtocolInsertReseller ,request);
	      //handleWebServiceResponse(response.getBody(),'Reseller','',OpportunityID,'');
			      }
		      catch(DmlException e){
		      System.debug('DML Exception : '+ e);
		      }
		      catch(System.CalloutException e)
		      {
		      System.debug('Call out error message : '+ e);
		      }
      
       String datumclient = '{'
                + '"name": "' + GetOpp.End_Customer__r.Name + '",'
                + '"reseller": "' +SFDCResellerID + '"'
                + '}';
                
      String endpointclient = URL+'client/'+SFDCClientID;
      Http httpProtocolInsertClient = new Http();       // Create HTTP request to send. 
      HttpRequest requestclient = buildWebServiceRequest(endpointclient,datumclient,'');
      
      try
      {
      HttpResponse responseclient = invokeWebService(httpProtocolInsertClient, requestclient );
      //handleWebServiceResponse(responseclient,'Client','',OpportunityID,'');
      
      System.debug(responseclient.getBody()+'***********RESPONSE for CLIENT *********************') ;
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
    }
    
     //rename old SID with Serial Number TOBEDELETED
     //body start
     String UpdatedSNO = SerialNumber.left(7)+'TBD'+SerialNumber.right(7);
     String datumappUpdate = '{'
      + '"serial_number":"'+UpdatedSNO + '",'
      + '"model":"'+OLIHW.Asset__r.Model_Number__c+ '",'
      + '"alias":"To be Deleted.Re registered from SFDC",'
      + '"reseller":"'+ SFDCResellerID +'",'
      + '"client":"' + SFDCClientID +'",'
      + '"package":"'+ Prod.Package__c +'",'
      + '"offsite":"'+ Prod.Offsite_Capacity__c +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"active'+'"'

      + '}';
      //body end
     String endpointappupdate = URL+'appliance/'+SIDText ;
     Http httpProtocolUpdateAppliance = new Http();
     HttpRequest requestappupdate = buildWebServiceRequest(endpointappupdate ,datumappupdate,'Appliance Update');
     
      try
      {
     
      HttpResponse responseappupdate = invokeWebService(httpProtocolUpdateAppliance, requestappupdate );
      System.debug('Data Sent 1: '+datumappupdate);
      handleWebServiceResponse(responseappupdate.getbody(),'Appliance Update',AssetID,OLIHW.OpportunityID,SIDText,responseappupdate.getHeader('Location'));
      
      System.debug(responseappupdate.getStatus()+'***********APPLIANCE INSERTION STATUS *********************') ;
      System.debug(responseappupdate.getHeader('Location')+'  APPLIANCE INSERTION CHECK 1');
      System.debug('Data Sent 2: '+datumappupdate);
      
       
     }
        
     catch(DmlException e){
      System.debug('DML Exception : '+ e);
      
    }
     
      
      String datumapp = '{'
      + '"serial_number":"'+SerialNumber + '",'
      + '"model":"'+OLIHW.Asset__r.Model_Number__c+ '",'
      + '"reseller":"'+ SFDCResellerID +'",'
      + '"client":"' + SFDCClientID +'",'
      + '"package":"'+ Prod.Package__c +'",'
      + '"offsite":"'+ Prod.Offsite_Capacity__c +'",'
      + '"data_center":"'+ DataCenter +'",'
      + '"status":"active'+'"'

      + '}';
      
      String endpointapp = URL+'appliance/';
             
      Http httpProtocolInsertAppliance = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp ,datumapp,'');
      System.debug('RequestAPP: '+requestapp);
                  
      try
      {
     
      HttpResponse responseapp = invokeWebService(httpProtocolInsertAppliance, requestapp );
      System.debug('Data Sent 1: '+datumapp);
      handleWebServiceResponse(responseapp.getBody(),'Appliance',AssetID,GetOpp.Id,SIDText,responseapp.getHeader('Location'));
      
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
      
      public static HttpRequest buildWebServiceRequest(String endpoint, String body, String Type){
      
      HttpRequest request = new HttpRequest();
      request.setEndPoint(endpoint);
      request.setBody(body);
      if(Type=='Appliance Update')
      {
      request.setMethod('PUT');
      }
      else
      {
      request.setMethod('POST');
      }
      request.setHeader('X-API-KEY',KEY);
      request.setHeader('Content-length', String.valueOf(body.length()));
      
      return request ;
      
      
      
      }
      
      public static HttpResponse invokeWebService(Http h, HttpRequest req){
      HttpResponse res = h.send(req);
      return res ;
      }

      public static void handleWebServiceResponse(String res,String Type, String AssetID, String OpportunityID,String ServiceIDToBeUpdated, String Header)
      {
     
      System.debug(res +'********************INSERTION CHECK*****************************');
      if(Type=='Appliance')
      {
      System.debug(Header+'APPLIANCE INSERTION CHECK 1');
      
      
      
      //else FOR test code
    
      
      String Status ;
      String message ;
      String Error ;
        JSONParser parser = JSON.createParser(res);
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
        
        throw new IntegrationException('Service ID not created. '+message+' '+error);
        
        }
        

       
      String Location = String.valueof(Header);  // http://rmc01.axcient.net/sfapi/appliance/35rf
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
      assetUpdate.ServiceID__c = GetGenId;
      assetUpdate.Service_ID__c = SID.Id ;
      assetUpdate.Re_registered__c = TRUE ;
      update assetUpdate;
      
           
      
      Service_ID__c ServID = [select Id, Status__c from Service_ID__c where Name =: ServiceIDtoBeUpdated ];
      ServID.Status__c = 'Inactive' ;
      update ServID ;
      
      Success = TRUE ;
        
     }
        
     if(Success == FALSE)
        {
        throw new IntegrationException('Service ID not created. Please check logs');
        }
      
     
      }
      
      
      
      }
      
      
      public static testMethod void testInvokeMethod(){
     	Account partner = new Account(name='Thrive Networks, a Staples Company');
     	Account endCustomer = new Account(name='Skinner, Inc');
     	Account[] accounts = new Account[]{partner,endCustomer};
     	insert accounts;
     	Service_ID__c SID = new Service_ID__c(name='bfyt');
     	insert SID;
     	Asset ass = new Asset(Name='AxcientTest6546y1',Accountid=partner.id,Asset_Tag__c='Aeg26');
     	insert ass;
     	Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), AccountId = partner.id, End_Customer__c = EndCustomer.Id);
		insert opp1;
     	
     	
     	String response = '{"service_id":"bfyt","alias":"null","serial_number":"AxcientTest6546y1","model":"A20-TE-4000","reseller":{"ext_id":"' + partner.id + '","name":"Thrive Networks, a Staples Company"},"client":{"ext_id":"'+endCustomer.id+'","name":"Skinner, Inc"},"package":"Backup","offsite":"4000","data_center":"Gen2_SJC","status":"active","servers":"","non_servers":"","support_tier":"AXCIENT"}';
     	String header = 'http://rmc01.axcient.net/sfapi/appliance/35rf' ;
     	Test.startTest();
     	
     	
     		handleWebServiceResponse(response,'Appliance',ass.Id,opp1.Id,'bfyt','erty');
     	
     	//handleWebServiceResponse(String res,String Type, String AssetID, String OpportunityID,String ServiceIDToBeUpdated, String Header)	
     	Test.stopTest();
     	
     }
    
    @isTest(seeAllData=true)
    public static void testHttpRequest(){
    	
     	HttpRequest req =    buildWebServiceRequest(URL+'appliance/','','');
    }
     
    public static testMethod void testValidationErrors(){
    	Account partner = new Account(name='Thrive Networks, a Staples Company');
     	Account endCustomer = new Account(name='Skinner, Inc');
     	Account[] accounts = new Account[]{partner,endCustomer};
     	insert accounts;
     	Service_ID__c SID = new Service_ID__c(name='bfyt');
     	insert SID;
     	Asset ass = new Asset(Name='AxcientTest6546y1',Accountid=partner.id,Asset_Tag__c='Aeg26');
     	insert ass;
     	Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), AccountId = partner.id, End_Customer__c = EndCustomer.Id);
		insert opp1;
		String header = 'http://rmc01.axcient.net/sfapi/appliance/35rf' ;
     	String errorMessage = '{"status":400,"message":"Validation errors occurred","validation_errors":{"data_center":"The Data Center field is required.","package":"The Package field is required."}}';
    	Test.startTest();
     		try{
     			handleWebServiceResponse(errorMessage,'Appliance',ass.id,'bfyt',opp1.Id,'erty');
     		}
     		catch(Exception e){
     			System.assert(e.getMessage().contains('Service ID not created'));
     		}
     	Test.stopTest();
    
    }
      
      
}      
      
  /*       public static testMethod void TestAPICall() {
   
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

RMCAPIRegisterViaAsset.GetServiceID(Asset1.ID, SID1.Name, DataCenter) ;

String endpointreseller = URL+'reseller/'+ResellerAccount.Id ;
String endpointclient = URL+'client/'+EndCustomerAccount.Id ;

String datumPartner = '{'
                + '"name": "' + ResellerName + '",'
                + '"mail": "' + RMCEmail + '"'
                + '}';
                
                
                
//RMCAPINewOrderFromOppty.datumapp = datumapp ;             
                
Http httpProtocolGetAccounts = new Http();

HttpRequest requestpartner1 = RMCAPIRegisterViaAsset.buildWebServiceRequest(endpointreseller,datumPartner,'');

String datumclient = '{'
                + '"name": "' + ClientName + '",'
                + '"reseller": "' + ResellerAccount.Id + '"'
                + '}';

HttpRequest requestclient1 = RMCAPIRegisterViaAsset.buildWebServiceRequest(endpointclient,datumclient,'');

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


HttpRequest requestapp1 = RMCAPIRegisterViaAsset.buildWebServiceRequest(endpointreseller,datumapp,'Appliance Update');




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




RMCAPIRegisterViaAsset.handleWebServiceResponse(responsepartner1,'Reseller',Asset1.Id,opp1.Id,SID1.Id);
RMCAPIRegisterViaAsset.handleWebServiceResponse(responseclient1,'Client',Asset1.Id,opp1.Id,'');
RMCAPIRegisterViaAsset.handleWebServiceResponse(responseapp1,'Appliance',AssetTest.Id,opp1.Id,SID1.Id);


}
    
      
      
*/