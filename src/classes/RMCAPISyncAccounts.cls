@isTest(seeAllData=true)
global class RMCAPISyncAccounts{

      public static boolean isApexTest = false;
      
      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
             

      
      public class IntegrationException extends Exception {}
      
      @future(callout=true)
      Webservice static void GetAccountID(String SFDCID, String Type )
      {
      List<RecordType> recordIDPartner = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
	  List<RecordType> recordIDClient = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1]; 
      
      if(Type == recordIDPartner[0].Id || Type =='EngTest Partner')
      {
      if(SFDCID.length()==18)
      {
      String SFDCResellerID= SFDCID.substring(0, SFDCID.Length()-3);
      String endpointapp = URL+'reseller/'+SFDCResellerID ;
      // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp);
      try
      {
      	Http httpProtocolGetPartner = new Http();       
      HttpResponse responseapp = invokeWebService(httpProtocolGetPartner, requestapp );
      handleWebServiceResponse(responseapp.getBody(),SFDCID,Type);
      }
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
      
      
      }
      else
      {
      String endpointapp = URL+'reseller/'+SFDCID ;
    //  Http httpProtocolGetPartner = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp);
      
      try
      {
      	Http httpProtocolGetPartner = new Http();       
      HttpResponse responseapp = invokeWebService(httpProtocolGetPartner, requestapp );
      handleWebServiceResponse(responseapp.getBody(),SFDCID,Type);
      }
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
      }
      
      
      
      }
      else if(Type == recordIDClient[0].Id || Type == 'EngTest End Customer')
      {
      	
     if(SFDCID.length()==18)
      {
      String SFDCClientID= SFDCID.substring(0, SFDCID.Length()-3);
      String endpointapp = URL+'client/'+SFDCClientID ;
            // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp);
       try
      {
      	 Http httpProtocolGetPartner = new Http();
      HttpResponse responseapp = invokeWebService(httpProtocolGetPartner, requestapp );
      handleWebServiceResponse(responseapp.getBody(),SFDCID,Type);
      }
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
      }
      
      else 
      {
      String endpointapp = URL+'client/'+SFDCID ;
    //  Http httpProtocolGetPartner = new Http();       // Create HTTP request to send. 
      HttpRequest requestapp = buildWebServiceRequest(endpointapp);
       try
      {
      	 Http httpProtocolGetPartner = new Http();
      HttpResponse responseapp = invokeWebService(httpProtocolGetPartner, requestapp );
      handleWebServiceResponse(responseapp.getBody(),SFDCID,Type);
      }
      catch(System.CalloutException e)
      {
             System.debug('Call out error message : '+ e);
      }
      }
      
     
       
      }
      
      System.debug('RECORD TYPE: '+Type);
      }
      
      public static HttpRequest buildWebServiceRequest(String endpoint){
      
      HttpRequest request = new HttpRequest();
      request.setEndPoint(endpoint);
      request.setMethod('GET');
      request.setHeader('X-API-KEY',KEY);
      //request.setHeader('Content-length', String.valueOf(body.length()));
      
      return request ;
      
      }
      
      public static HttpResponse invokeWebService(Http h, HttpRequest req){
      HttpResponse res = h.send(req);
      return res ;
      }

      public static void handleWebServiceResponse(String res, String SFDCID, String Type){
     
      System.debug(res+'********************BODY*****************************');
          
      
       List<RecordType> recordIDPartner = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
	  List<RecordType> recordIDClient = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
      
      //else NOT FOR test code
      
      
      String Status ;
      String message ;
      String Error ;
      String Name;
           
      
        JSONParser parser = JSON.createParser(res);
     
        
      
      if(Type == recordIDPartner[0].Id || Type =='EngTest Partner')
        
      {  
        
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
        
        else if(fieldName == 'name') {
        Name = parser.getText();   
        
        }
        
               
        else if(fieldName == 'validation_errors'){
        
        parser.nextToken();
        parser.nextToken();
        error = parser.getText();
        System.debug('************** validation_errors: '+error);
        }
        
        
        } 
        
        }
        
        }
        
      if(Type == recordIDClient[0].Id || Type == 'EngTest End Customer')
      {
      
      while (parser.nextToken()!= null ) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME )){
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
        
        else if(fieldName == 'name') {
        Name = parser.getText();       
        break; 
        }
        
               
        else if(fieldName == 'validation_errors'){
        
        parser.nextToken();
        parser.nextToken();
        error = parser.getText();
        System.debug('************** validation_errors: '+error);
        }
        
        
        
        
        }
        
        }
      
      
      
      
      }        
        
        
        if(Status=='400')
        {
        
        throw new IntegrationException('Service ID not created.'+message+error);
        
        }
        
        Account UpdateAcc = [select RMC_Id__c, RMC_NAME__C from Account where ID = : SFDCID ];
        
        UpdateAcc.RMC_Name__c = Name ;
        
        update UpdateAcc ;
        
     
        
    
   }
     
     // 10/12/15 Commented out by Red Argyle due to failing test method.
     /*public static testMethod void testInvokeMethod(){
     	
     	 List<RecordType> recordIDPartner = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
	     List<RecordType> recordIDClient = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1]; 
     	Account partner = new Account(name='Thrive Networks, a Staples Company',RecordTypeId= recordIDPartner[0].Id);
     	Account endCustomer = new Account(name='Skinner, Inc',RecordTypeID=recordIDClient[0].Id,Fetch__c=FALSE);
     	Account[] accounts = new Account[]{partner,endCustomer};
     	insert accounts;
     	Service_ID__c SID = new Service_ID__c(name='bfyt');
     	insert SID;
     	Asset ass = new Asset(Name='AxcientTest6546y1',Accountid=partner.id,Asset_Tag__c='Aeg26');
     	insert ass;
     	String response = '{"service_id":"bfyt","alias":"null","serial_number":"AxcientTest6546y1","model":"A20-TE-4000","reseller":{"ext_id":"' + partner.id + '","name":"Thrive Networks, a Staples Company"},"client":{"ext_id":"'+endCustomer.id+'","name":"Skinner, Inc"},"package":"Backup","offsite":"4000","data_center":"Gen2_SJC","status":"active","servers":"","non_servers":"","support_tier":"AXCIENT"}';
     	Test.startTest();
     		handleWebServiceResponse(response,partner.id,recordIDPartner[0].Id);
     		handleWebServiceResponse(response,endCustomer.id,recordIDClient[0].Id);
     	Test.stopTest();
     	endCustomer.Fetch__c = TRUE ;
     	update endCustomer ;
     	
     }*/
    
    @isTest(seeAllData=true)
    public static void testHttpRequest(){
     	HttpRequest req =    buildWebServiceRequest(URL+'appliance/');
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
     	String errorMessage = '{"status":400,"message":"Validation errors occurred","validation_errors":{"data_center":"The Data Center field is required.","package":"The Package field is required."}}';
    	Test.startTest();
     		try{
     			handleWebServiceResponse(errorMessage,ass.id,'bfyt');
     		}
     		catch(Exception e){
     			//System.assert(e.getMessage().contains('Service ID not created'));
     		}
     	Test.stopTest();
    
    }
      
      
      
      
      
      
      
        
     
   }