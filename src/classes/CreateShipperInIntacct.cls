public with sharing class CreateShipperInIntacct {
    
    public static Boolean isApexTest = false;
    public CreateShipperInIntacct() {
        
    }
    
    //get the opportunity 
    public Sales_Order__c getSalesOrder(String Id) 
    {    
        List<Sales_Order__c> salesOrder = [SELECT id, name,Reference_Number__c,Ship_Date__c, Account__c, Date__c, Terms__c, Bill_to_Address_1__c, Bill_to_Address_2__c,
                                     Bill_to_City__c, Bill_to_Country__c, Bill_to_Name__c, Ship_to_Name__c, Opportunity__r.Name, Ship_to_city__c, Opportunity__r.Status__c,
                                     Ship_to_Country__c, Ship_to_State__c, Ship_to_zip_Code__c, Bill_to_zip_Code__c, Bill_to_State__c, Ship_to_Address_1__c,
                                     Account__r.Id, Account__r.Name, Account__r.IntacctID__c, Account__r.Credit_Terms__c,Opportunity__r.id,
                                     (SELECT id, Quantity__c, price__c, Item__c, Sales_Order__c, Axcient_Asset_Tag__c, Axcient_Serial_Number__c,Product_Serial_Number__c
                                     FROM R00N40000001bdlLEAQ__r ) 
                                     FROM Sales_Order__c 
                                     WHERE Opportunity__c =: Id AND Account__c != null
                                     ORDER BY Date__c DESC Limit 1 ]; 
		if(salesOrder.size() > 0)
		{                                    
        	return salesOrder[0];
		}
		
		return null; 
    }
    
    public Case getCase(String Id)
    {
    	try{
        	Case caseRecord = [select Id, CaseNumber, Type, Case_Reason__c, AssetId, Account.Id, Account.Name, Account.BillingCity, Account.BillingStreet, 
                           Account.BillingCountry, Account.BillingState, Account.BillingPostalCode, Account.ShippingCity, 
                           Account.ShippingStreet, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode,
                           Contact.Name, Contact.Id, CreatedDate, Subject, Account.IntacctId__c, Account.Credit_Terms__c,
                           Asset.Product2.ProductCode,  Asset.Product2.Standard_Unit__c, RecordType.Name
                           from Case 
                           where Id =: Id
						   AND AssetId != null 
						   AND RecordType.Name Like '%DAS Case%'];
			return caseRecord;
    	}
    	catch(Exception ex)
    	{
    		return null;
    	}
    }
    public zkfedex__Shipment__c getShipmentForOppty(String Id)
    {
        zkfedex__Shipment__c shipment = [SELECT ID, zkfedex__ShipDate__c
                                         FROM zkfedex__Shipment__c 
                                         WHERE Opportunity__c =: Id                                    
                                         order by CreatedDate DESC limit 1];
        return shipment;
    }
    
    public zkfedex__Shipment__c getShipmentForCase(String Id)
    {
        zkfedex__Shipment__c shipment = [SELECT ID, zkfedex__ShipDate__c
                                         FROM zkfedex__Shipment__c 
                                         WHERE Case__c =: Id                                       
                                         order by CreatedDate DESC limit 1];
        return shipment;
    }
    
    public String getSObjectType(String Id)
    {
        String objectType;
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String,String> keyPrefixMap = new Map<String,String>{};
        Set<String> keyPrefixSet = gd.keySet();
        for(String sObj : keyPrefixSet){
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            String sObjName = r.getName();
            String sObjPrefix = r.getKeyPrefix();
            keyPrefixMap.put(sObjPrefix,sObjName);
        }
        
        objectType = keyPrefixMap.get(Id.substring(0,3));
        
        return objectType;
    }
    //create a XML node
    public DOM.xmlNode CreateNode(DOM.xmlNode node, String NodeName, String NodeValue)
    {
        if(NodeValue!=null)
            node.addChildElement(NodeName, null, null).addTextNode(NodeValue);
        return node;
    }
    
    //create child nodes for a XML node named 'customfield'
    public DOM.xmlNode createCustomField(DOM.xmlNode node, String fieldName, String fieldValue)
    {       
        node = CreateNode(node, 'customfieldname', fieldName);
        if(fieldValue !=null )
            node = CreateNode(node, 'customfieldvalue', fieldValue);
        else
            node = CreateNode(node, 'customfieldvalue', '');
        return node;
    }
    
    //Create body for the request
    public DOM.xmlNode buildShipper(Sales_Order__c salesOrder, string billToValue, string shipTOValue)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'create_sotransaction_oppty_' + salesOrder.Opportunity__r.id);
        
        DOM.xmlNode create_shipper = function.addChildElement('create_sotransaction',null,null);
       
        create_shipper = CreateNode(create_shipper, 'transactiontype', 'Shipper');
        DOM.xmlNode dateCreated = create_shipper.addChildElement('datecreated', null, null);
        dateCreated = CreateNode(dateCreated,'year',String.valueOf(System.today().year()));
        dateCreated = CreateNode(dateCreated,'month',String.valueOf(System.today().month()));
        dateCreated = CreateNode(dateCreated,'day',String.valueOf(System.today().day())); 
 
        create_shipper = CreateNode(create_shipper,'customerid', salesOrder.Account__r.IntacctID__c);
        create_shipper = CreateNode(create_shipper,'referenceno',salesOrder.Opportunity__r.Name);
        create_shipper = CreateNode(create_shipper,'termname', salesOrder.Account__r.Credit_Terms__c);

        DOM.xmlNode datedue = create_shipper.addChildElement('datedue', null, null);
        datedue = CreateNode(datedue,'year',String.valueOf(getShipmentForOppty(salesOrder.Opportunity__r.Id).zkfedex__ShipDate__c.year()));
        datedue = CreateNode(datedue,'month',String.valueOf(getShipmentForOppty(salesOrder.Opportunity__r.Id).zkfedex__ShipDate__c.month()));
        datedue = CreateNode(datedue,'day',String.valueOf(getShipmentForOppty(salesOrder.Opportunity__r.Id).zkfedex__ShipDate__c.day())); 
        
        if(shipToValue != '')
        {
        	DOM.xmlNode shipto = create_shipper.addChildElement('shipto', null, null);
        	shipto = CreateNode(shipto, 'contactname', shipToValue);
        }
        if(billToValue != '')
        {        
        	DOM.xmlNode billto = create_shipper.addChildElement('billto', null, null);
       	    billto = CreateNode(billto, 'contactname', billToValue);
        } 
        
        create_shipper = CreateNode(create_shipper,'currency','USD');
        create_shipper = CreateNode(create_shipper,'exchratetype', 'Intacct Daily Rate');
        
        DOM.xmlNode customFields = create_shipper.addChildElement('customfields', null, null);
        DOM.xmlNode customField;
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'OPPORTUNITY_ID');
        customField = CreateNode(customField, 'customfieldvalue', salesOrder.Opportunity__c);
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'ACCOUNT_SFDC_ID');
        customField = CreateNode(customField, 'customfieldvalue', salesOrder.Account__c);       
        DOM.xmlNode items = create_shipper.addChildElement('sotransitems', null, null);
        
        for(Sales_Order_Item__c soItem : salesOrder.R00N40000001bdlLEAQ__r) {
            DOM.xmlNode item = items.addChildElement('sotransitem', null, null);
            item = CreateNode(item, 'itemid', soItem.Item__c);
            item = CreateNode(item, 'warehouseid', 'WH1'); 
            item = CreateNode(item, 'quantity', String.valueOf(soItem.Quantity__c));
            item = CreateNode(item, 'unit', 'Each'); 
            item = CreateNode(item, 'price', String.valueOf(soItem.price__c));
            item = CreateNode(item, 'discsurchargememo', 'Price Changed');
            DOM.xmlNode customFieldsLineItem = item.addChildElement('customfields', null, null);
            DOM.xmlNode customFieldLineItem = customFieldsLineItem.addChildElement('customfield', null, null); 
            createCustomField(customFieldLineItem,'ASSET_TAG_NUMBER', soItem.Axcient_Asset_Tag__c);
           
            customFieldLineItem = customFieldsLineItem.addChildElement('customfield', null, null); 
            createCustomField(customFieldLineItem,'AXCIENT_SERIAL_NUMBER2', soItem.Axcient_Serial_Number__c);
            
            customFieldLineItem = customFieldsLineItem.addChildElement('customfield', null, null); 
            createCustomField(customFieldLineItem,'MFG_SERIAL_NUMBER', soItem.Product_Serial_Number__c);

        }

        return function;
    }
    
    public DOM.xmlNode buildShipper(Case caseRecord, string billToValue, string shipTOValue)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'create_sotransaction_case_' + caseRecord.id);
        
        DOM.xmlNode create_shipper = function.addChildElement('create_sotransaction',null,null);
       
        create_shipper = CreateNode(create_shipper, 'transactiontype', 'Shipper');
        DOM.xmlNode dateCreated = create_shipper.addChildElement('datecreated', null, null);
        dateCreated = CreateNode(dateCreated,'year',String.valueOf(System.today().year()));
        dateCreated = CreateNode(dateCreated,'month',String.valueOf(System.today().month()));
        dateCreated = CreateNode(dateCreated,'day',String.valueOf(System.today().day())); 
 
        create_shipper = CreateNode(create_shipper,'customerid',caseRecord.Account.IntacctID__c);
        //create_shipper = CreateNode(create_shipper,'referenceno',salesOrder.Opportunity__r.Name);
        create_shipper = CreateNode(create_shipper,'termname', caseRecord.Account.Credit_Terms__c);

        DOM.xmlNode datedue = create_shipper.addChildElement('datedue', null, null);
        datedue = CreateNode(datedue,'year',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.year()));
        datedue = CreateNode(datedue,'month',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.month()));
        datedue = CreateNode(datedue,'day',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.day())); 
        
        if(shipToValue != '')
        {
        	DOM.xmlNode shipto = create_shipper.addChildElement('shipto', null, null);
        	shipto = CreateNode(shipto, 'contactname', shipToValue);
        }
        if(billToValue != '')
        {        
        	DOM.xmlNode billto = create_shipper.addChildElement('billto', null, null);
       	    billto = CreateNode(billto, 'contactname', billToValue);
        } 
        
        create_shipper = CreateNode(create_shipper,'currency','USD');
        create_shipper = CreateNode(create_shipper,'exchratetype', 'Intacct Daily Rate');
        
        DOM.xmlNode customFields = create_shipper.addChildElement('customfields', null, null);
        DOM.xmlNode customField;
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'CASE_ID');
        customField = CreateNode(customField, 'customfieldvalue', caseRecord.Id);
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'ACCOUNT_SFDC_ID');
        customField = CreateNode(customField, 'customfieldvalue', caseRecord.Account.Id);       
        DOM.xmlNode items = create_shipper.addChildElement('sotransitems', null, null);

        DOM.xmlNode item = items.addChildElement('sotransitem', null, null);
        item = CreateNode(item, 'itemid', caseRecord.Asset.Product2.ProductCode);
        item = CreateNode(item, 'warehouseid', 'WH1');
        item = CreateNode(item, 'quantity', '1');
        item = CreateNode(item, 'unit', caseRecord.Asset.Product2.Standard_Unit__c); 
        item = CreateNode(item, 'price', '0');
        item = CreateNode(item, 'discsurchargememo', 'Price Changed');
        return function;
    }
    public DOM.xmlNode getContact(Account account, string field)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'get_billto_contact_' + account.Id);
        
        DOM.xmlNode get_billingContact = function.addChildElement('get_list',null,null);
        get_billingContact.setAttribute('object', 'customer');
        get_billingContact.setAttribute('maxitems', '1');
        
        DOM.xmlNode filter = get_billingContact.addChildElement('filter', null, null);
        DOM.xmlNode expression = filter.addChildElement('expression', null, null);
        expression = CreateNode(expression, 'field', 'customerid');
        expression = CreateNode(expression, 'operator', '=');
        expression = CreateNode(expression, 'value', account.IntacctID__c);
        
        DOM.xmlNode fields = get_billingContact.addChildElement('fields', null, null);
        fields = CreateNode(fields, 'field', field);
        
        return function;
    }
    
    public String getContactName(string nodeName,DOM.Document responseDom)
    {
        String contactName='';
        System.debug('root:' + responseDom.getRootElement());
        for(dom.XmlNode responseLevelNode : responseDom.getRootElement().getChildElements())
        {
            if(responseLevelNode.getName() == 'operation')
            {
                for(dom.XmlNode resultLevelNode : responseLevelNode.getChildElements())
                {
                    if(resultLevelNode.getName() == 'result')
                    {
                        for(dom.XmlNode dataLevelNode : resultLevelNode.getChildElements())
                        {
                            if(dataLevelNode.getName() == 'data')
                            {
                                for(dom.XmlNode customerLevelNode : dataLevelNode.getChildElements())
                                {
                                    if(customerLevelNode.getName() == 'customer')
                                    {
                                        for(dom.XmlNode contactLevelNode : customerLevelNode.getChildElements())
                                        {
                                            if(contactLevelNode.getName() == nodeName)
                                            {
                                                for(dom.XmlNode contactNameLevelNode : contactLevelNode.getChildElements())
                                                {
                                                    if(contactNameLevelNode.getName() == 'contactname')
                                                        contactName = contactNameLevelNode.getText();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }                       
                    } 
                }
                                 
            }
        }
        system.debug('contactName: ' + contactname);
        return contactName;
    }
    public String sendContactsRequest(List<DOM.xmlNode> getContacts)
    {
        String result = '';
        DOM.Document docContacts = IntacctGateWay.BuildRequestDocument(getContacts);
        HttpRequest request = IntacctGateWay.BuildHttpRequest(docContacts);
        Http httpForContacts = new Http();
         System.debug('req:' + request.getBodyDocument().toXmlString());
        HTTPResponse response = new HTTPResponse();
        if(!isApextest)
        {
            response = httpForContacts.send(request);
            result = response.getBody();
            SYstem.debug('res: ' + result ); 
            System.debug('res1:' + response.getBody());
        }
        else
            result = '<response>'+
                          +'<control>'+
                             + '<status>success</status>'+
                               +'<senderid>Axcient</senderid>'+
                               +'<controlid>ControlIdHere</controlid>'+
                               +'<uniqueid>false</uniqueid>'+
                               +'<dtdversion>2.1</dtdversion>'+
                         +'</control>'+
                         +'<operation>'+
                               +'<authentication>'+
                                    +'<status>success</status>'+
                                    +'<userid>ps_config</userid>'+
                                    +'<companyid>Axcient-copy</companyid>'+
                               +'</authentication>'+
                               +'<result>'+
                                   +'<status>success</status>'+
                                   +'<function>get_list</function>'+
                                   +'<controlid>testControlId</controlid>'+
                                   +'<listtype start="0" end="0" total="1">customer</listtype>'+
                                   +'<data>'+
                                      +'<customer>'+
                                          +'<billto>'+
                                             +'<contactname>B_C-3000000062</contactname>'+
                                          +'</billto>'+
                                          +'<shipto>'+
                                             +'<contactname>S_C-3000000062</contactname>'+
                                          +'</shipto>'+
                                      +'</customer>'+
                                   +'</data>'+
                                +'</result>'+
                          +'</operation>'+
                    +'</response>';

        return result;
    }
    public Boolean createShipper(String Id) 
    {
        Boolean hasErrors = true; 
        List<DOM.xmlNode> getContacts = new List<DOM.xmlNode>();
        List<DOM.xmlNode> functions = new List<DOM.xmlNode>();
        DOM.Document doc = new DOM.Document();
        if(getSObjectType(Id) == 'Opportunity' && getSalesOrder(Id) != null)
        {
            Sales_Order__c salesOrder = getSalesOrder(Id);
            if(salesOrder.Opportunity__r.Status__c != 'Converted')  
            {     
	            getContacts.add(getContact(salesOrder.Account__r,'billto')); 
	            getContacts.add(getContact(salesOrder.Account__r,'shipto')); 
	            doc.load(sendContactsRequest(getContacts));
	            functions.add(buildShipper(salesOrder,getContactName('billto', doc), getContactName('shipto', doc)));
            }
            else
            {
            	return hasErrors;
            }
        }
        else
            if(getSObjectType(Id) == 'Case')
            {
                Case caseRecord = getCase(Id); 
                if(caseRecord != null)    
                {   
                	getContacts.add(getContact(caseRecord.Account,'billto')); 
                	getContacts.add(getContact(caseRecord.Account,'shipto'));
                	doc.load(sendContactsRequest(getContacts));
                	functions.add(buildShipper(caseRecord,getContactName('billto', doc), getContactName('shipto', doc)));
                }
            }
        

        //create shipper call
        if(functions.size() > 0)
        {
	        DOM.Document docShipper = IntacctGateWay.BuildRequestDocument(functions);
	        
	        HttpRequest req = IntacctGateWay.BuildHttpRequest(docShipper);
	        System.debug('req:' + req.getBodyDocument().toXmlString());
	        Http http = new Http();
	        HTTPResponse res = new HTTPResponse();
	        DOM.Document responseDoc = new DOM.Document(); 
	        String result = '';
	        if(!isApexTest)
	        {
	            res = http.send(req);
	            result = res.getBodyDocument().toXmlString();
	            SYstem.debug('res: ' + res.getBody()); 
	        }
	        else
	            result = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><response></response>';
	        responseDoc.load(result);
	        hasErrors = IntacctAPI.ParseErrors(responseDoc);
        }       
        return hasErrors;
        
    }
    
    @future (callout=true)
    public static void syncToIntacct(String Id)
    {
        CreateShipperInIntacct sync = new CreateShipperInIntacct();
        sync.createShipper(Id);
    }
    
    public Boolean createShipperForTest(String Id)
    {
        isApexTest = true;
        return createShipper(Id);
    }
}