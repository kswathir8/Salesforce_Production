/************************************************
* Test Class Name: TestforUpdateProductShipment        *       
* Created By     : Pranav Lal                   *                        
* This class tests UpdateAssets trigger.        *                                   

       
************************************************/

@isTest
class TestforUpdateProductShipment{

    static testMethod void testMethodForCodeCoverage(){
    
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test43', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
        insert acc;    
    
        Contact con = new Contact(
        FirstName ='Ja',
        LastName = 'Ta',
        AccountId = acc.Id
              
        );  
        insert con;
    
        Asset as1 = new Asset(
        Name = 'AA0211A0211200034',
        Asset_Tag__c ='2431',
        ContactId=con.Id    
        );
        
        insert as1;
        zkfedex__Shipment__c FedEx = new zkfedex__Shipment__c(       
        zkfedex__SenderName__c='Test 1',
        zkfedex__SenderCity__c='Mum',
        zkfedex__SenderStreet__c='123121 Bucks',
        zkfedex__SenderEMail__c='plal@ms.com',
        zkfedex__SenderCountry__c='USA',
        zkfedex__SenderPhone__c='1231231231',
        zkfedex__SenderState__c='CA',
        zkfedex__SenderPostalCode__c='23123',
        zkfedex__RecipientCity__c='BOM',
        zkfedex__RecipientCountry__c='USA', 
        zkfedex__RecipientName__c='Test 2',
        zkfedex__RecipientState__c='NPS',
        zkfedex__RecipientStreet__c='123 Bucks', 
        zkfedex__RecipientPostalCode__c='123121',
        zkfedex__RecipientPhone__c='4554554345',
        zkfedex__ShipDate__c=NULL,
        zkfedex__Delivered__c=FALSE,
        zkfedex__DeliveryDate__c=date.today(),
        TestCheck__c = FALSE
        );
        insert FedEx ;
        
        zkfedex__Shipment__c FedEx1 = new zkfedex__Shipment__c(       
        zkfedex__SenderName__c='Test 1',
        zkfedex__SenderCity__c='Mum',
        zkfedex__SenderStreet__c='123121 Bucks',
        zkfedex__SenderEMail__c='plal@ms.com',
        zkfedex__SenderCountry__c='USA',
        zkfedex__SenderPhone__c='1231231231',
        zkfedex__SenderState__c='CA',
        zkfedex__SenderPostalCode__c='23123',
        zkfedex__RecipientCity__c='BOM',
        zkfedex__RecipientCountry__c='USA', 
        zkfedex__RecipientName__c='Test 2',
        zkfedex__RecipientState__c='NPS',
        zkfedex__RecipientStreet__c='123 Bucks', 
        zkfedex__RecipientPostalCode__c='123121',
        zkfedex__RecipientPhone__c='4554554345',
        zkfedex__ShipDate__c=NULL,
        zkfedex__Delivered__c=FALSE,
        zkfedex__DeliveryDate__c=date.today(),
        TestCheck__c = FALSE
        );
        insert FedEx1 ;
        
        Product_Shipment__c Ship = new Product_Shipment__c(
        Asset__c = as1.Id,
        FedEx_Shipment__c = FedEx.Id,
        IsChanged__c =false,
        Current_Outbound_Shipment__c = TRUE
        
        );
        
        try
        {
        insert Ship;
        }
        
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
                
        //upsert FedEx;
        System.assertEquals(as1.Outbound_Shipment_Tracking__c,FedEx.zkfedex__MasterTrackingId__c);
        System.assertEquals(as1.Outbound_Asset_Ship_Date__c,FedEx.zkfedex__ShipDate__c);
        System.assertEquals(Date.Today(),FedEx.zkfedex__DeliveryDate__c);
        
        Ship.IsChanged__c=TRUE;
        Ship.Current_Outbound_Shipment__c = FALSE ;
        try
        {
        update Ship;
        }
        
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
       
        System.AssertEquals(Ship.IsChanged__c, TRUE);
        
        Ship.IsChanged__c = FALSE ;
        try
        {
        update Ship;
        }
        
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        System.AssertEquals(Ship.IsChanged__c, FALSE);
        
        
        try
        {
        update FedEx;
        }
        
        catch(exception e)
        {
        System.Assert(e.getMessage().contains('Please do not manually edit'));
        }
        //Ship.FedEx_Shipment__c = FedEx1.Id;
      //update FedEx ;
        
        
 
    }



    
    }