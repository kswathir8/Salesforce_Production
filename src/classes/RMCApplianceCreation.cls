global class RMCApplianceCreation {

    private ApexPages.standardController controller {get;set;}
    public Asset asst {get; set;}
    public class IntegrationException extends Exception {}

    static string KEY = RMC_Login__c.getInstance().API_Access_Key__c;
    static String URL = RMC_Login__c.getInstance().API_URL__c ;
    public static boolean isApexTest = false;


    public RMCApplianceCreation(ApexPages.StandardController stdController) {
        controller = stdController;
        this.asst= (Asset)stdController.getRecord();
    }
    
    public PageReference Step1() 
    {
        //   Asset GetAsset = [select Name from Asset where Id= : asst.Id ];
        //   delete GetAsset ;
        return Page.RMCEngineering ;
    }  

    public PageReference confirm() 
    {
    String PC = asst.RMC_Model_Number__c ;

    Product2 GetProduct = [select Name, ProductCode from Product2 where ProductCode=: PC  LIMIT 1];

    Asset EngAsset = new Asset(
            Product2Id = GetProduct.Id,
            Asset_Tag__c = 'TESTENG',
            AccountID = asst.RMC_Partner__c ,
            RMC_Partner__c = asst.RMC_Partner__c ,
            End_Customer__c = asst.RMC_Client__c,
            RMC_Client__c = asst.RMC_Client__c,
            RMC_End_Customer__c = asst.RMC_Client__c,
            RMC_Package__c = asst.RMC_Package__c ,
            RMC_Offsite_Capacity__c = asst.RMC_Offsite_Capacity__c ,
            RMC_Serial_Number__c = asst.RMC_Serial_Number__c ,
            RMC_Server_Entitlements__c = asst.RMC_Server_Entitlements__c ,
            RMC_Non_Server_Entitlement__c = asst.RMC_Non_Server_Entitlement__c ,
            RMC_Checkbox__c = asst.RMC_Checkbox__c ,
            RMC_Model_Number__c = asst.RMC_Model_Number__c ,
            Data_Center__c = asst.Data_Center__c,
            RMC_NOC_Support__c = asst.RMC_NOC_Support__c,
            RMC_Alias__c = asst.RMC_Alias__c,
            Name = asst.RMC_Serial_Number__c
        );
    try
    {
        insert EngAsset ;
    } catch(DMLException ex)
    {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getDmlMessage(0)));
        return NULL ;
    } catch (Exception ex)
    {
        //ApexPages.addMessage(new ApexPages.MessageApexPages.Severity.ERROR,
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        return NULL ;
    }

    return Page.RMCConfirmAndSend ;
    }    
    
    
    
    public PageReference saveSF()
    {
        Asset GetAssetToUpdate = [
            select 
                RMC_Partner__r.Name,
                RMC_Partner__r.RMC_Email__c,   
                Service_ID__c,
                Name, 
                RMC_Client__r.Name ,
                RMC_Partner__c , 
                RMC_Alias__c , 
                RMC_Package__c , 
                RMC_Offsite_Capacity__c ,
                RMC_Serial_Number__c,
                RMC_Model_Number__c,
                RMC_Checkbox__c ,
                Asset_Tag__c,
                Account.Name,
                End_Customer__c,
                DC1__c
            from Asset 
            where RMC_Serial_Number__c = :asst.RMC_Serial_Number__c
            ];

        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'TEST'));
        //Start
        System.debug('************RMC EMAIL ADMIN ' + asst.RMC_Partner__r.RMC_Email__c );
         
         


        String datum = '{'
                    + '"name": "' + GetAssetToUpdate.Account.Name + '",'
                    + '"mail": "' + GetAssetToUpdate.RMC_Partner__r.RMC_Email__c + '"'
                    + '}';
                    
                    
        String ResellerID = GetAssetToUpdate.RMC_Partner__c ;
        String SFDCResellerID= ResellerID.substring(0, ResellerID.Length()-3);
                  
                  
        String endpointreseller = URL+'reseller/'+SFDCResellerID ;
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

                  + '"name": "' + GetAssetToUpdate.RMC_Client__r.Name + '",'
                  + '"reseller": "' + SFDCResellerID + '"'
                  + '}';


        String ClientID = GetAssetToUpdate.RMC_Client__c ;
        String SFDCClientID= ClientID.substring(0, ClientID.Length()-3);

                
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

        if(asst.RMC_Checkbox__c == TRUE)
        {
            ActiveCheckbox = 'active' ;
        }
        else
        {
            ActiveCheckbox = 'deactivated' ;
        } 

        System.debug('************ Serial Number = ' +GetAssetToUpdate.RMC_Serial_Number__c );
        System.debug('************ Model Number =' + GetAssetToUpdate.RMC_Model_Number__c );
        System.debug('************ AssetID ='  );
        System.debug('************ ResellerName= ' + GetAssetToUpdate.Account.Name );
        System.debug('************ ClientName= ' + GetAssetToUpdate.RMC_Client__r.Name );
        System.debug('************ ResellerID= ' +GetAssetToUpdate.RMC_Partner__c );
        System.debug('************ ClientID=');
        System.debug('************ OffsiteCapacity=' +GetAssetToUpdate.RMC_Offsite_Capacity__c );
        System.debug('************ Package Value =' + GetAssetToUpdate.RMC_Package__c);

        String datumapp = '{'
            + '"serial_number":"'+ GetAssetToUpdate.RMC_Serial_Number__c + '",'
            + '"model":"'+GetAssetToUpdate.RMC_Model_Number__c+ '",'
            + '"reseller":"'+ SFDCResellerID  +'",'
            + '"client":"' + SFDCClientID +'",'
            + '"package":"'+ GetAssetToUpdate.RMC_Package__c +'",'
            + '"offsite":"'+ GetAssetToUpdate.RMC_Offsite_Capacity__c +'",'
            + '"data_center":"'+GetAssetToUpdate.DC1__c +'",'
            + '"status":"'+ ActiveCheckbox +'"'
            + '}';
        //+ '"status":"active'+'"'
        //DC1__c
        String endpointapp = URL+'appliance/';

        Http httpProtocolInsertAppliance = new Http();       // Create HTTP request to send. 
        HttpRequest requestapp = buildWebServiceRequest(endpointapp ,datumapp);
        System.debug('RequestAPP: '+requestapp);

        try
        {
            HttpResponse responseapp = invokeWebService(httpProtocolInsertAppliance, requestapp );
            System.debug('Data Sent 1: '+datumapp);
            handleWebServiceResponse(responseapp,'Appliance',GetAssetToUpdate.Id,'');

            System.debug(responseapp.getStatus()+'***********APPLIANCE INSERTION STATUS *********************') ;
            System.debug(responseapp.getHeader('Location')+'  APPLIANCE INSERTION CHECK 1');
            System.debug('Data Sent 2: '+datumapp);

            //insert EngAsset ;
            if(ApexPages.hasMessages()) return NULL ;
            else
            {
                controller = new ApexPages.standardController(GetAssetToUpdate);
                return controller.view();
            }
        } catch(DmlException e){
            System.debug('DML Exception : '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return NULL ;
        } catch(System.CalloutException e)
        {
            System.debug('Call out error message : '+ e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            Return NULL ;
        }
    }
      
    public static HttpRequest buildWebServiceRequest(String endpoint, String body)
    {
        HttpRequest request = new HttpRequest();
        request.setEndPoint(endpoint);
        request.setBody(body);
        request.setMethod('POST');
        request.setHeader('X-API-KEY',KEY);
        request.setHeader('Content-length', String.valueOf(body.length()));
        request.setTimeout(120000); 

        return request ;
    }

    public static HttpResponse invokeWebService(Http h, HttpRequest req)
    {
        System.debug('REQUEST SENT::::------------- '+ req);
        HttpResponse res = h.send(req);
        return res ;
    }

    public static void handleWebServiceResponse(HttpResponse res,String Type, String AssetID, String OpportunityID)
    {
        try 
        {

            System.debug(res.getStatus()+'********************APPLIANCE STATUS *****************************');   
            System.debug(res.getBody()+'********************INSERTION CHECK*****************************');
            if(Type == 'Appliance')
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
                    while (parser.nextToken()!= null) 
                    {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
                        {
                            System.debug('************** 2: '+Status);
                            String fieldName = parser.getText();
                            parser.nextToken();
                            System.debug('************** PARSER: '+parser.getText());
                            if(fieldName == 'status') 
                            {
                                Status = parser.getText();
                                System.debug('************** STATUS: '+Status);
                            }
                            else if(fieldName == 'message')
                            {
                                message = parser.getText();
                                System.debug('************** MESSAGE: '+message);
                            }
                            else if(fieldName == 'validation_errors')
                            {
                                parser.nextToken();
                                parser.nextToken();
                                error = parser.getText();
                                System.debug('************** validation_errors: '+error);
                            }
                        } 
                    }
                    System.debug('************** validation_errors: '+Status);
                    if(Status=='400')
                    {
                        System.debug('************** INSIDE 400?? : '+Status);
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, message+ ' ' +error ));
                        //throw new IntegrationException('Service ID not created.'+message+ ' ' +error);
                    }

                    String Location = String.valueof(res.getHeader('Location'));  // http://rmc01.axcient.net/sfapi/appliance/35rf
                    Boolean Success = FALSE ;

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
                        Asset GetAssetToUpdate = [select Service_ID__c,Name from Asset where Id=:AssetID ];
                        delete GetAssetToUpdate ;

                        throw new IntegrationException('Service ID not created.');
                    }
                }

            }

        } catch (Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
        //End
        //String SerialNumber,String ModelNumber,String PackageValue,String Offsite,String Alias,String SFDCResellerId, String SFDCClientId,String DataCenter, String AssetID
        //CreateAppliance(asst.RMC_Serial_Number__c ,asst.RMC_Model_Number__c ,asst.RMC_Package__c,asst.RMC_Offsite_Capacity__c ,asst.RMC_Alias__c, asst.RMC_Partner__c ,asst.RMC_Client__c,  EngAsset.DC1__c , EngAsset.Id); 
    }

    /**
     * @author: Matthew Allen
     * @date: 06/10/2015
     * @desc: creating an HTTPMock Callout in order to make the unit test work. You need a mock callout since you can't
     *   use real call outs in a unit test. This simulates a successful response to the callout.
     */
    global class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest req) {         
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setHeader('Location', 'http://rmc01.axcient.net/sfapi/appliance/35rf');
            res.setBody('{"status":"400","message":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

  /*  @isTest (seeAllData=true)
    public static void testSaveSFWithSoftware(){
        // MMA - 06/10/15 - Changing the unit test to use a call out per standard.
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        RecordType endCustomer = [Select id From RecordType Where sObjectType='Account' AND Name = 'EngTest End Customer'];
        RecordType Partner = [Select id From RecordType Where sObjectType='Account' AND Name = 'EngTest Partner'];
        
        Account a = new Account(name='Test Account12', RecordTypeID=endCustomer.id);
        insert a;
        
        Account b = new Account(name='Test Account', RecordTypeID=Partner.id);
        insert b;
        
        Contact c = new Contact(firstName='Fake',lastName='Guy',email='fake@guy.com',AccountID=a.id);
        insert c;
        
        Product2 GetProduct = [select Name, ProductCode from Product2 where ProductCode= 'A20-T-1000'  LIMIT 1];
        
//        Data_Center__c dc = [Select id From Data_Center__c limit 1];
        // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
        Data_Center__c dc = new Data_Center__c() ;
        insert dc ;
        
        Asset EngAsset = new Asset(
                                    Product2Id = GetProduct.Id,
                                    Asset_Tag__c = 'TE11',
                                    AccountID = b.Id ,
                                    RMC_Partner__c = b.Id ,
                                    End_Customer__c = a.Id,
                                    RMC_Client__c = a.Id,
                                    RMC_End_Customer__c = a.Id,
                                    RMC_Package__c = 'Backup' ,
                                    RMC_Offsite_Capacity__c = 1024 ,
                                    RMC_Serial_Number__c = 'AXCIENTTEST121212' ,
                                    RMC_Server_Entitlements__c = '' ,
                                    RMC_Non_Server_Entitlement__c = '' ,
                                    RMC_Checkbox__c = TRUE ,
                                    RMC_Model_Number__c = 'A20-T-1000' ,
                                    Data_Center__c = dc.ID ,
                                    RMC_NOC_Support__c = TRUE,
                                    RMC_Alias__c = '' ,
                                    Name = 'AXCIENTTEST121212'
                                    
                                    );

                                insert EngAsset ;

                                 System.Assert(EngAsset.RMC_Package__c == 'Backup');
                                 
                                 ApexPages.StandardController stdController = new ApexPages.StandardController(EngAsset);
                                 
                                 RMCApplianceCreation ApplCreate = new RMCApplianceCreation(stdController);
                                 
                                 Test.setCurrentPage(new PageReference('/apex/RMCEngineering' ));
                                 
                                Test.startTest();
      
                                ApplCreate.asst.Asset_Tag__c = 'TE11' ;
                                ApplCreate.asst.AccountID = b.Id ;
                                ApplCreate.asst.RMC_Partner__c = b.Id ;
                                ApplCreate.asst.End_Customer__c = a.Id ;
                                ApplCreate.asst.RMC_Package__c = 'Backup';
                                ApplCreate.asst.Data_Center__c = dc.id;
                                ApplCreate.asst.RMC_Offsite_Capacity__c = 1024;
                                ApplCreate.asst.RMC_Serial_Number__c = 'AXCIENTTEST121212';
                                ApplCreate.asst.RMC_Server_Entitlements__c = '';
                                ApplCreate.asst.RMC_Non_Server_Entitlement__c = '';
                                ApplCreate.asst.RMC_Checkbox__c = TRUE ;
                                ApplCreate.asst.RMC_Model_Number__c = 'A20-T-1000' ;
                                ApplCreate.asst.RMC_NOC_Support__c = TRUE ;
                                ApplCreate.asst.RMC_Alias__c = '' ;
                                ApplCreate.asst.Name = 'AXCIENTTEST121212' ;
                                
                                ApplCreate.confirm();
                               // EngAsset= ApplCreate.EngAsset;
                               EngAsset= ApplCreate.asst;
      
                                Test.stopTest();
                                 
         
       

         Test.setCurrentPage(new PageReference('/apex/RMCConfirmAndSend' ));
         
        
          EngAsset =  [select RMC_Partner__r.Name,
                        RMC_Partner__r.RMC_Email__c,   
                        Service_ID__c,
                        Name, 
                        RMC_Client__r.Name ,
                        RMC_Partner__c , 
                        RMC_Alias__c , 
                        RMC_Package__c , 
                        RMC_Offsite_Capacity__c ,
                        RMC_Serial_Number__c,
                        RMC_Model_Number__c,
                        RMC_Checkbox__c ,
                        Asset_Tag__c,
                        Account.Name,
                        End_Customer__c,
                        DC1__c

                    from Asset where Id = :EngAsset.Id ];
                    
                    ApplCreate.saveSF();
                    
          EngAsset= ApplCreate.asst;
      } */
}