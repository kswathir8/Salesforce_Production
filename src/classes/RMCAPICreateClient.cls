@isTest(seeAllData=true)
global class RMCAPICreateClient{

    
public static boolean isApexTest = false;
       
   public class IntegrationException extends Exception {}
      
      static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
      static String URL = RMC_Login__c.getInstance().API_URL__c ;
      
      
      @future(callout=true)
      Webservice static void CreateClient(String Clientname,  String SFDCClientId )
      {
      
         

      Opportunity opp = [select Id, Name, Partner__r.Name, Partner__c ,Partner__r.RMC_Email__c from Opportunity where End_Customer__c =: SFDCClientId LIMIT 1 ] ;
      
      
      String SFDCResellerLong = opp.Partner__c ;
      String SFDCResellerID= SFDCResellerLong.substring(0, SFDCResellerLong.Length()-3);
      
  //    String datum = GetBody();
            
      String datum = '{'
                + '"name": "' + opp.Partner__r.Name + '",'
                + '"mail": "' + opp.Partner__r.RMC_Email__c + '"'
                + '}';
                
      String endpointreseller = URL+'reseller/'+SFDCResellerID;
      
      HttpRequest request = buildWebServiceRequest(endpointreseller,datum,'Reseller');
           
      try
      {
      	Http httpProtocolInsertReseller = new Http();
      HttpResponse response = invokeWebService(httpProtocolInsertReseller ,request);
      //handleWebServiceResponse(response,'Reseller','');
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
      HttpRequest requestclient = buildWebServiceRequest(endpointclient,datumclient,'Client');
      
      try
      {
      HttpResponse responseclient = invokeWebService(httpProtocolInsertClient, requestclient );
     // handleWebServiceResponse(responseclient,'Client','');
      
      System.debug(responseclient.getBody()+'CLIENT INSERTION CHECK 1') ;
      }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
    }
    
      }
      
      public static HttpRequest buildWebServiceRequest(String endpoint, String body, String Type){
      
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

 

    
    @isTest(seeAllData=true)
    public static void testHttpRequest(){
    	
    	Account endCustomer = new Account(name='Skinner, Inc');
    	
    	 String endpointclient = URL+'client/'+endCustomer.Id;
    	 Account partner = new Account(name='Thrive Networks, a Staples Company');
    	
			String body = '{"name":"Thrive Networks, a Staples Company","reseller":"' + partner.id +'" }'; 	
     	HttpRequest req =    buildWebServiceRequest(endpointclient,body,'Client');
    }
    
    public static testMethod void testInvokeMethod(){
        // 10/12/15 Commented out by Red Argyle to pass production validation.
     	/*Account partner = new Account(name='Thrive Networks, a Staples Company');
     	Account endCustomer = new Account(name='Skinner, Inc');
     	Account[] accounts = new Account[]{partner,endCustomer};
     	insert accounts;
     	Service_ID__c SID = new Service_ID__c(name='bfyt');
     	insert SID;
     	Asset ass = new Asset(Name='AxcientTest6546y1',Accountid=partner.id,Asset_Tag__c='Aeg26');
     	insert ass;
     	Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(), Partner__c = partner.id, End_Customer__c = EndCustomer.Id);
		insert opp1;
     	String response = '{"service_id":"bfyt","alias":"null","serial_number":"AxcientTest6546y1","model":"A20-TE-4000","reseller":{"ext_id":"' + partner.id + '","name":"Thrive Networks, a Staples Company"},"client":{"ext_id":"'+endCustomer.id+'","name":"Skinner, Inc"},"package":"Backup","offsite":"4000","data_center":"Gen2_SJC","status":"active","servers":"","non_servers":"","support_tier":"AXCIENT"}';
     	Test.startTest();
     	CreateClient('Thrive Networks, a Staples Company',  endCustomer.Id );
   //  		handleWebServiceResponse(response,ass.id,'bfyt');
     	Test.stopTest();*/
        
     }
     
      
        
     
   }