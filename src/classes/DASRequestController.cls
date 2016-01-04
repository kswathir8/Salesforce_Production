public with sharing class DASRequestController {

        public String chosenContactID {get;set;}
        public String shippingMethod {get;set;}
        public Boolean needsCustomer {get;set;}
        public Boolean updatedCustomer {get;set;}
        public ApexPages.StandardController controller;
        public Case thisCase {get;set;}
        public String inputSID {get;set;}
        
        private Boolean isPartner;

        public DASRequestController(ApexPages.StandardController stdController){
                chosenContactID = 'N/A';
                needsCustomer = false;
                controller = stdController;
        thisCase = new Case(RecordTypeID=ApexPages.currentPage().getParameters().get('RecordType'));
        isPartner = isPartner();
        updatedCustomer = false;
        }
        
        public Boolean getIsPartner(){
                return isPartner;
        }
        
        @RemoteAction
        public static String getContactJSON(String contactIDString){
                        ID contactID = ID.valueOf(contactIDString);
                        return JSON.serialize([Select id,Name,email,Account.Name,Account.ShippingCity,Account.ShippingStreet,Account.ShippingState,Account.ShippingPostalCode From Contact Where id = :contactID]).replaceAll('\'','\\\'');             
        } 
        
        public void output(){
                
                updatedCustomer = true;
                
                chosenContactID = thisCase.ContactID;
                thisCase.DAS_Request_Fee_Notice__c = 'PLEASE NOTE: EFFECTIVE 5/23/11, A FEE OF $40 WILL BE CHARGED FOR THE DELIVERY AND RETURN SHIPPING OF THE DAS UNIT. THIS EXPEDITED DELIVERY TO AND FROM YOUR LOCATION ALLOWS US TO BEGIN PROTECTING YOUR DATA AS QUICKLY AS POSSIBLE';
        }
        
        public PageReference save(){
                
                updatedCustomer = false;
                
                if(thisCase.id == null){ 
                
                
                        if(thisCase.Estimated_Data_Size__c == null)     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Estimate Data Size is a required field. Please choose one of the options.'));              
                        if(!isPartner && thisCase.End_Customer__c == null)      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End Customer is required for processing. Please pick the appropriate customer.'));                 
                        if(thisCase.Customer__c == null)        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Customer is required for processing. Please pick the appropriate customer.'));             
                        if(thisCase.ContactID == null)  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the contact you choose. Please fill out the Contact feild.'));               
                        if(thisCase.Ship_To_Company__c == null) ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the shipping address below. Please fill out the "Ship To Company" feild.'));                 
                        if(thisCase.Ship_To_Street__c == null)  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the shipping address below. Please fill out the "Ship To Street" feild.'));                  
                        if(thisCase.Ship_To_City__c == null)    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the shipping address below. Please fill out the "Ship To City" feild.'));            
                        if(thisCase.Ship_To_State__c == null)   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the shipping address below. Please fill out the "Ship To State" feild.'));                   
                        if(thisCase.Ship_To_Zip__c == null)     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Packages will be addressed to the shipping address below. Please fill out the "Ship To Zip" feild.'));             
                        if(thisCase.Service_ID__c == null && !isPartner)        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Servie IDs are requred for these requests. Please fill in the appropriate ID.'));                  
                        
                        if( (inputSID == null || inputSID == '') && isPartner){ 
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Service ID is required for this type of request. Please retry entering the value or contact axcient for the requested Service ID.'));
                        }
                        else if(isPartner){
                                List<Service_ID__c> caseSIDs = [Select id,NAme from Service_ID__c Where Name = :inputSID];
                                if(caseSIDs.size() > 0){
                                        thisCase.Service_ID__c = caseSIDs.get(0).id;
                                }
                                else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Service ID couldn\'t not be found that mathces your entry into the SID field. Please retry entering the value or contact axcient for the requested Service ID.'));
                        }
                        
                        /*if(!hasAsset() && !ApexPages.hasMessages() ){
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An Appliance hasn\'t yet been associated with the Service ID provided. Please fill out the customer field.'));             
                                needsCustomer = true;
                        }*/
                        if(ApexPages.hasMessages() ) return null;
                        thisCase.Subject = 'DAS Request';
                        if(isPartner){ 
                                thisCase.DAS_Request_By__c = 'Partner';
                                //Opportunity customer = [Select id, End_customer__c From Opportunity Where id =:thisCase.Customer__c];
                                //thisCase.End_Customer__c = customer.End_customer__c;
                        }
                        
                        thisCase.Description = 'Preferred Shipping Method: ' + shippingMethod;
                        thisCase.OwnerId = ID.valueOf(RecordIDs__c.getValues('DAS Queue').Record_ID__c);
                        thisCase.Type = 'DAS Device Tracker';
                        insert thisCase;
                        
                }
                // else update thisCase; -- not possible
                if( isPartner ) return new PageReference('/apex/SupportCenter');
                return new PageReference('/' + thisCase.id);
        }

        private Boolean isPartner(){
                List<UserRole> roles = [Select id,Name From UserRole Where id = :UserInfo.getUserRoleId()];
                if(roles.size() == 1 && roles.get(0).Name.toLowerCase().contains('partner')) return true;
                return false;
        }
        
        private Boolean hasAsset(){
                if(thisCase.Customer__c != null) return true;
                if(thisCase.Service_ID__c == null) return false;
                Service_ID__c service = [Select id,Name,Axcient_SN__c From Service_ID__c Where id = :thisCase.Service_Id__c];
                if(service.Axcient_SN__c != null) return true;
                return false;
        }
        
        
        /************************
        *                                               *
        *       Test Methods            *
        *                                               *
        ************************/
        
        public static testMethod void testgetContactJSON(){
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                Contact c = new Contact(firstName='Gram',lastname='Test',email='gram@test.com',AccountId=a.id);
                insert c;
                DASRequestController.getContactJSON(c.id);
        }
        
        @isTest(seeAllData=true)
        public static void testConstructorAndOutput(){
                DASRequestController controller = new DASRequestController(new ApexPages.Standardcontroller(new Case()));
                System.assertEquals(controller.chosenContactID,'N/A');
                
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                Contact c = new Contact(firstName='Gram',lastname='Test',email='gram@test.com',AccountId=a.id);
                insert c;
                
                controller.thisCase.ContactId = c.id;
                controller.output();
                System.assertEquals(controller.chosenContactID,c.id);
        }
        
        @isTest(seeAllData=true)
        public static void testSaveContact(){
                
                RecordType DasCaseType = [Select id From RecordType Where SobjectType='Case' AND name = 'DAS Case'];
                Test.setCurrentPage(new PageReference('/apex/DASRequestForm?RecordType=' + DasCaseType.id));
                
                DASRequestController controller = new DASRequestController(new ApexPages.Standardcontroller(new Case()));
                System.assertEquals(controller.chosenContactID,'N/A');
                System.assertEquals(DasCaseType.id,controller.thisCase.RecordTypeID);
                
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                Contact c = new Contact(firstName='Gram',lastname='Test',email='gram@test.com',AccountId=a.id);
                insert c;
                Opportunity opp = new Opportunity(AccountId=a.id,stageName='Closed Lost',closeDate=Date.today(),name='Test-Opp');
                insert opp;
                Asset ass = new Asset(AccountId=a.id,Name='Test-Asset',Quantity=1,Asset_Tag__c='12345678');
                insert ass;
                Service_ID__c service = new Service_ID__c(Axcient_SN__c=ass.id,name='Test-ServiceID');
                insert service;
                ass.Service_ID__c = service.id;
                update ass; 
                
                controller.thisCase.ContactId = c.id;
                controller.thisCase.Customer__c = opp.id;
                controller.output();
                System.assertEquals(controller.chosenContactID,c.id);
                
                
                Test.startTest();
                
                        controller.thisCase.Service_ID__c = service.id;
                        controller.thisCase.Estimated_Data_Size__c = 'Greater than 3 Terabytes';
                        controller.thisCase.End_Customer__c = a.id;
                        controller.thisCase.Ship_To_Company__c = a.name;
                        controller.thisCase.Ship_To_Street__c = '111 Fake St.';
                        controller.thisCase.Ship_To_City__c = 'Mountain View';
                        controller.thisCase.Ship_To_State__c = 'CA';
                        controller.thisCase.Ship_To_Zip__c = '94043';
                        controller.save();
                
                Test.stopTest();
                
                System.debug(ApexPages.getMessages());
                System.assertEquals(0,ApexPages.getMessages().size());
                
                List<Case> cases = [Select id,RecordTypeId,ownerId,Ship_To_Company__c,Ship_To_Street__c,Ship_To_City__c,Ship_To_State__c,Ship_To_Zip__c From Case Where id = :controller.thisCase.id];
                System.assertEquals(1,cases.size());
                Case thisCase = cases.get(0);
                System.assertEquals(RecordIDs__c.getValues('DAS Queue').Record_ID__c,thisCase.ownerId);
                System.assertEquals(a.name,thisCase.Ship_To_Company__c);
                System.assertEquals('111 Fake St.',thisCase.Ship_To_Street__c);
                System.assertEquals('Mountain View',thisCase.Ship_To_City__c);
                System.assertEquals('CA',thisCase.Ship_To_State__c);
                System.assertEquals('94043',thisCase.Ship_To_Zip__c);
                System.assertEquals(DasCaseType.id,thisCase.RecordTypeID);
                
        }
        
        @isTest(seeAllData=true)
        public static void testSaveContactAsPartner(){
                
                RecordType DasCaseType = [Select id From RecordType Where SobjectType='Case' AND name = 'DAS Case'];
                Test.setCurrentPage(new PageReference('/apex/DASRequestForm?RecordType=' + DasCaseType.id));
                
                DASRequestController controller = new DASRequestController(new ApexPages.Standardcontroller(new Case()));
                System.assertEquals(controller.chosenContactID,'N/A');
                System.assertEquals(DasCaseType.id,controller.thisCase.RecordTypeID);
                
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                Contact c = new Contact(firstName='Gram',lastname='Test',email='gram@test.com',AccountId=a.id);
                insert c;
                Opportunity opp = new Opportunity(AccountId=a.id,stageName='Closed Lost',closeDate=Date.today(),name='Test-Opp');
                insert opp;
                Asset ass = new Asset(AccountId=a.id,Name='Test-Asset',Quantity=1,Asset_Tag__c='12345678');
                insert ass;
                Service_ID__c service = new Service_ID__c(Axcient_SN__c=ass.id,name='Test-ServiceID');
                insert service;
                ass.Service_ID__c = service.id;
                update ass; 
                
                controller.thisCase.ContactId = c.id;
                controller.thisCase.Customer__c = opp.id;
                controller.isPartner = true;
                controller.output();
                System.assertEquals(controller.chosenContactID,c.id);
                
                
                Test.startTest();
                
                        controller.inputSID = 'Test-ServiceID';
                        controller.thisCase.Estimated_Data_Size__c = 'Greater than 3 Terabytes';
                        controller.thisCase.End_Customer__c = a.id;
                        controller.thisCase.Ship_To_Company__c = a.name;
                        controller.thisCase.Ship_To_Street__c = '111 Fake St.';
                        controller.thisCase.Ship_To_City__c = 'Mountain View';
                        controller.thisCase.Ship_To_State__c = 'CA';
                        controller.thisCase.Ship_To_Zip__c = '94043';
                        controller.thisCase.Customer__c = opp.id;
                        controller.save();
                
                Test.stopTest();
                
                System.debug(ApexPages.getMessages());
                System.assertEquals(0,ApexPages.getMessages().size());
                
                List<Case> cases = [Select id,RecordTypeId,OwnerID,Ship_To_Company__c,Ship_To_Street__c,Ship_To_City__c,Ship_To_State__c,Ship_To_Zip__c From Case Where id = :controller.thisCase.id];
                System.assertEquals(1,cases.size());
                Case thisCase = cases.get(0);
                System.assertEquals(RecordIDs__c.getValues('DAS Queue').Record_ID__c,thisCase.ownerId);
                System.assertEquals(a.name,thisCase.Ship_To_Company__c);
                System.assertEquals('111 Fake St.',thisCase.Ship_To_Street__c);
                System.assertEquals('Mountain View',thisCase.Ship_To_City__c);
                System.assertEquals('CA',thisCase.Ship_To_State__c);
                System.assertEquals('94043',thisCase.Ship_To_Zip__c);
                System.assertEquals(DasCaseType.id,thisCase.RecordTypeID);
                
        }

        @isTest(seeAllData=true)
        public static void testSaveContactNoAsset(){
                
                RecordType DasCaseType = [Select id From RecordType Where SobjectType='Case' AND name = 'DAS Case'];
                Test.setCurrentPage(new PageReference('/apex/DASRequestForm?RecordType=' + DasCaseType.id));
                
                DASRequestController controller = new DASRequestController(new ApexPages.Standardcontroller(new Case()));
                System.assertEquals(controller.chosenContactID,'N/A');
                System.assertEquals(DasCaseType.id,controller.thisCase.RecordTypeID);
                
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                Contact c = new Contact(firstName='Gram',lastname='Test',email='gram@test.com',AccountId=a.id);
                insert c;
                Opportunity opp = new Opportunity(AccountId=a.id,stageName='Closed Lost',closeDate=Date.today(),name='Test-Opp');
                insert opp;
                Service_ID__c service = new Service_ID__c(name='Test-ServiceID');
                insert service;
                
                Test.startTest();
                
                controller.thisCase.ContactId = c.id;
                controller.output();
                System.assertEquals(controller.chosenContactID,c.id);
                
                controller.thisCase.Service_ID__c = service.id;
                controller.thisCase.Estimated_Data_Size__c = 'Greater than 3 Terabytes';
                controller.thisCase.End_Customer__c = a.id;
                controller.thisCase.Ship_To_Company__c = a.name;
                controller.thisCase.Ship_To_Street__c = '111 Fake St.';
                controller.thisCase.Ship_To_City__c = 'Mountain View';
                controller.thisCase.Ship_To_State__c = 'CA';
                controller.thisCase.Ship_To_Zip__c = '94043';
                controller.save();
                
                Test.stopTest();
                
                System.assert(ApexPages.hasMessages());
                
        }
        
        @isTest(seeAllData=true)
        public static void testSaveContactNoInfo(){
                
                RecordType DasCaseType = [Select id From RecordType Where SobjectType='Case' AND name = 'DAS Case'];
                Test.setCurrentPage(new PageReference('/apex/DASRequestForm?RecordType=' + DasCaseType.id));
                
                DASRequestController controller = new DASRequestController(new ApexPages.Standardcontroller(new Case()));
                System.assertEquals(controller.chosenContactID,'N/A');
                System.assertEquals(DasCaseType.id,controller.thisCase.RecordTypeID);
                
                Account a = new Account(name='Test',ShippingCity='Mountain View',ShippingStreet='111 Fake St',ShippingState='California',ShippingPostalCode='94043');
                insert a;
                
                Test.startTest();
                
                        controller.save();
                
                Test.stopTest();
                
                System.assert(ApexPages.getMessages().size() > 0);
                //System.assertEquals(8,ApexPages.getMessages().size());
                
        }
        

}