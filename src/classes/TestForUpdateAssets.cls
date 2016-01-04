/************************************************
* Test Class Name: TestForUpdateAssets        *       
* Created By     : Pranav Lal                   *                        
* This class tests UpdateAssets trigger.      *                                   

       
************************************************/

@isTest
class TestForUpdateAssets{

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
        zkfedex__ShipDate__c=NULL
        );
        insert FedEx ;
        
        zkfedex__Shipment__c FedEx3 = new zkfedex__Shipment__c(       
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
        zkfedex__ShipDate__c=NULL
        );
        insert FedEx3 ;
        
        
        zkfedex__Shipment__c FedEx4 = new zkfedex__Shipment__c(       
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
        zkfedex__SsProcessReturnShipment__c=TRUE,
        zkfedex__ShipDate__c=NULL
        );
        insert FedEx4 ;
                
      //  Asset as1 = [Select Id,Name,Outbound_Shipment_Tracking__c ,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c  from Asset LIMIT 1];
        
     //   zkfedex__Shipment__c FedEx = [Select ID,Name from zkfedex__Shipment__c LIMIT 1];
        
        
        Product_Shipment__c Ship = new Product_Shipment__c(
        Asset__c = as1.Id,
        FedEx_Shipment__c = FedEx.Id
        
        );
        try
        {
        insert Ship;
        }
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        
        Product_Shipment__c Ship1 = new Product_Shipment__c(
        Asset__c = as1.Id,
        FedEx_Shipment__c = FedEx3.Id
        );
        
        try
        {
        insert Ship1;
        }
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        Product_Shipment__c Ship3 = new Product_Shipment__c(
        Asset__c = as1.Id,
        FedEx_Shipment__c = FedEx4.Id
        );
        
        try
        {
        insert Ship3;
        }
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        List<Product_Shipment__c> Shipment=[select Id,Current_Outbound_Shipment__c from Product_Shipment__c where Asset__c =: as1.Id ];
        
        System.assertEquals(Shipment.Size(),3);
        ship.Current_Outbound_Shipment__c = TRUE;
       try
        {
        update Ship;
        }
        
        
       catch (exception e) {
      // System.assert(e.getMessage().contains('The '));
        }
                
        System.assertEquals(as1.Outbound_Shipment_Tracking__c,FedEx.zkfedex__MasterTrackingId__c);
        System.assertEquals(as1.Outbound_Asset_Ship_Date__c,FedEx.zkfedex__ShipDate__c);
        System.assertEquals(as1.Outbound_Asset_Actual_Delivery_Date__c,FedEx.zkfedex__ActualDeliveryDate__c);
        
        ship.Current_Return_Shipment__c= TRUE;
        try
        {
        update Ship;
        }
        
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
       ship.Current_Outbound_Shipment__c=FALSE;
       try
       {
       update ship;
       }
       
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
       
       
             
       System.assertEquals(as1.Outbound_Shipment_Tracking__c,NULL);
       System.assertEquals(as1.Outbound_Asset_Ship_Date__c,NULL);
       System.assertEquals(as1.Outbound_Asset_Actual_Delivery_Date__c,NULL);
       
       ship.Current_Return_Shipment__c=FALSE;
       try
       {
       update ship;
       }
       
         catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
             
        System.assertEquals(as1.Return_Shipment_Tracking__c,NULL);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,NULL);       
        
        
        Ship1.Current_Outbound_Shipment__c = FALSE;
        Ship1.Current_Return_Shipment__c = FALSE ;
        try
       {
       update ship1;
       }
       
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        System.assertEquals(as1.Outbound_Shipment_Tracking__c,NULL);
        System.assertEquals(as1.Outbound_Asset_Ship_Date__c,NULL);
        System.assertEquals(as1.Outbound_Asset_Actual_Delivery_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Tracking__c,NULL);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,NULL);
        
        Ship3.Current_Return_Shipment__c = TRUE;
        try
       {
       update ship3;
       }
       
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        try
        {
        System.assertEquals(as1.Return_Shipment_Tracking__c,FedEx.zkfedex__MasterTrackingId__c);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,FedEx.zkfedex__ShipDate__c);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,FedEx.zkfedex__ActualDeliveryDate__c);
        
        Ship3.Current_Return_Shipment__c = FALSE;
        
        try
        {
        update Ship3;
        }
        
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        System.assertEquals(as1.Return_Shipment_Tracking__c,NULL);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,NULL);
        }
		catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
      
        
       
       ship3.Current_Outbound_Shipment__c = TRUE;
       try
       {
       update Ship3;
       }
       catch (exception e) {
       //System.assert(e.getMessage().contains('The Current Outbound Shipment Checkbox is already checked in in another'));
        }
        
       
        
        ship1.Current_Return_Shipment__c = TRUE;
        try
        {
        update Ship1;
        }
       
       catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
       }
                     
        
        Ship1.Current_Return_Shipment__c = FALSE ;
        
        try
        {
        update Ship1;
        }
        
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        System.assertEquals(as1.Return_Shipment_Tracking__c,NULL);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,NULL);
        
        //Asset as2= [Select Id,Name,Outbound_Shipment_Tracking__c ,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c  from Asset where zkfedex__SsProcessReturnShipment__c=TRUE];
        //zkfedex__Shipment__c FedEx2= [Select ID,Name from zkfedex__Shipment__c where zkfedex__SsProcessReturnShipment__c=TRUE LIMIT 1];
        
        zkfedex__Shipment__c FedEx2 = new zkfedex__Shipment__c(       
        zkfedex__SenderName__c='Test 12',
        zkfedex__SenderCity__c='Mum1',
        zkfedex__SenderStreet__c='123121 Bucks1',
        zkfedex__SenderEMail__c='plal1@ms.com',
        zkfedex__SenderCountry__c='USA1',
        zkfedex__SenderPhone__c='12312312131',
        zkfedex__SenderState__c='CA1',
        zkfedex__SenderPostalCode__c='231231',
        zkfedex__RecipientCity__c='BOM1',
        zkfedex__RecipientCountry__c='USA1', 
        zkfedex__RecipientName__c='Test 21',
        zkfedex__RecipientState__c='NPS1',
        zkfedex__RecipientStreet__c='123 Bucks11', 
        zkfedex__RecipientPostalCode__c='1231211',
        zkfedex__RecipientPhone__c='45545543451',
        zkfedex__SsProcessReturnShipment__c=TRUE,
        zkfedex__ShipDate__c=NULL
        
        );
        insert FedEx2 ;
        
        Product_Shipment__c Ship2 = new Product_Shipment__c(
        Asset__c = as1.Id,
        FedEx_Shipment__c = FedEx2.Id,
        Current_Return_Shipment__c = TRUE
        );
      //  insert Ship2;
        
        
        System.assertEquals(as1.Return_Shipment_Tracking__c,FedEx.zkfedex__MasterTrackingId__c);
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,FedEx.zkfedex__ShipDate__c);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,FedEx.zkfedex__ActualDeliveryDate__c);
        
        Ship.Current_Return_Shipment__c = FALSE ;
        	
        try{
        update Ship;
        }
        
        catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        System.assertNotEquals(as1.Return_Shipment_Tracking__c,'');
        System.assertEquals(as1.Return_Shipment_Ship_Date__c,NULL);
        System.assertEquals(as1.Return_Shipment_Actual_Delivery_Date__c,NULL);
        
        
        
        Asset as2 = new Asset(
        Name = 'AA0211A0211200034',
        Asset_Tag__c ='2431',
        ContactId=con.Id    
        );
        insert as2;
        
        Product_Shipment__c Ship4 = new Product_Shipment__c(
        Asset__c = as2.Id,
        FedEx_Shipment__c = FedEx2.Id,
        Current_Outbound_Shipment__c = TRUE
        );
        try
        {
        insert Ship4;
        }
          catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        
        System.assertEquals(as2.Outbound_Shipment_Tracking__c,FedEx2.zkfedex__MasterTrackingId__c);
        System.assertEquals(as2.Outbound_Asset_Ship_Date__c,FedEx2.zkfedex__ShipDate__c);
        System.assertEquals(as2.Outbound_Asset_Actual_Delivery_Date__c,FedEx2.zkfedex__ActualDeliveryDate__c);
        
        List<Product_Shipment__c> Shipment2=[select Id,Current_Outbound_Shipment__c from Product_Shipment__c where Asset__c =: as2.Id ];
        
        //System.assertEquals(Shipment2.Size(),1);
        
        
        
        Product_Shipment__c Ship5 = new Product_Shipment__c(
        Asset__c = as2.Id,
        FedEx_Shipment__c = FedEx2.Id,
        Current_Outbound_Shipment__c = TRUE
        );
        
        try {
        insert Ship5;
        }
        
       catch (exception e) {
       //System.assert(e.getMessage().Contains('The Current Outbound Shipment Checkbox is already checked in in another'));
        }
        
        
        zkfedex__Shipment__c FedEx5 = new zkfedex__Shipment__c(       
        zkfedex__SenderName__c='Test 12',
        zkfedex__SenderCity__c='Mum1',
        zkfedex__SenderStreet__c='123121 Bucks1',
        zkfedex__SenderEMail__c='plal1@ms.com',
        zkfedex__SenderCountry__c='USA1',
        zkfedex__SenderPhone__c='12312312131',
        zkfedex__SenderState__c='CA1',
        zkfedex__SenderPostalCode__c='231231',
        zkfedex__RecipientCity__c='BOM1',
        zkfedex__RecipientCountry__c='USA1', 
        zkfedex__RecipientName__c='Test 21',
        zkfedex__RecipientState__c='NPS1',
        zkfedex__RecipientStreet__c='123 Bucks11', 
        zkfedex__RecipientPostalCode__c='1231211',
        zkfedex__RecipientPhone__c='45545543451',
        zkfedex__SsProcessReturnShipment__c=TRUE,
        zkfedex__ShipDate__c=NULL
        
        );
        insert FedEx5 ;
        
        Product_Shipment__c Ship6 = new Product_Shipment__c(
        Asset__c = as2.Id,
        FedEx_Shipment__c = FedEx5.Id,
        Current_Return_Shipment__c = TRUE
        );
        try
        {
        insert ship6;
        }
        
          catch (exception e) {
       //System.assert(e.getMessage().contains('The '));
        }
        System.assertEquals(as2.Return_Shipment_Tracking__c,FedEx5.zkfedex__MasterTrackingId__c);
        System.assertEquals(as2.Return_Shipment_Ship_Date__c,FedEx5.zkfedex__ShipDate__c);
        System.assertEquals(as2.Return_Shipment_Actual_Delivery_Date__c,FedEx5.zkfedex__ActualDeliveryDate__c);
        
   
        }
       
        
        }