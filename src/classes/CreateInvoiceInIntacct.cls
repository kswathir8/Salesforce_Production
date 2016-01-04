public with sharing class CreateInvoiceInIntacct{
   
    public static Boolean isApexTest = false;
    public CreateInvoiceInIntacct() {
        
    }
    
    //get the opportunity 
    public Opportunity getOpportunity(String Id) 
    {    
        Opportunity opportunity = [SELECT Id, Name, Amount, StageName, CloseDate, AccountId, Shipping_Date__c,
                                   Account.Name, Account.IntacctID__c,Account.Credit_Terms__c, End_Customer__c, End_Customer__r.Name,
                                   (SELECT ID, PriceBookEntry.Product2.ProductCode, Discount, PriceBookEntry.Product2.Name, Quantity, 
                                   UnitPrice,TotalPrice, PriceBookEntry.Product2.Item_GL_Group__c, PriceBookEntry.Product2.Product_Type__c                                                                     
                                   FROM OpportunityLineItems)                                  
                                   FROM Opportunity WHERE id =: Id];   
        return opportunity;
    }
    
    public Case getCase(String Id)
    {
        Case caseRecord = [select Id, CaseNumber, Type, Case_Reason__c, AssetId, Account.Id, Account.Name, Account.BillingCity, Account.BillingStreet, 
                           Account.BillingCountry, Account.BillingState, Account.BillingPostalCode, Account.ShippingCity, 
                           Account.ShippingStreet, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode,
                           Contact.Name, Contact.Id, CreatedDate, Subject, Account.IntacctId__c, Account.Credit_Terms__c,
                           Asset.Product2.ProductCode,  Asset.Product2.Standard_Unit__c, RecordType.Name
                           from Case 
                           where RecordType.Name like '%DAS Case%' and Id =: Id];
        return caseRecord;
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
    
    public zkfedex__Shipment__c getShipmentForOppty(String Id)
    {
        zkfedex__Shipment__c shipment = [SELECT ID, zkfedex__TotalNetCharge__c,zkfedex__ShipDate__c  
                                         FROM zkfedex__Shipment__c 
                                         WHERE Opportunity__c =: Id 
                                         order by CreatedDate DESC limit 1];
        return shipment;
    }
    
    public zkfedex__Shipment__c getShipmentForCase(String Id)
    {
        zkfedex__Shipment__c shipment = [SELECT ID, zkfedex__ShipDate__c, zkfedex__TotalNetCharge__c
                                         FROM zkfedex__Shipment__c 
                                         WHERE Case__c =: Id                                       
                                         order by CreatedDate DESC limit 1];
        return shipment;
    }
    public Boolean hasEndCustomer(Opportunity opportunity) 
    {
        Boolean isEndCustomer;
        
        if(opportunity.End_Customer__c != null && opportunity.End_Customer__c != opportunity.AccountID)
            isEndCustomer = true;
        else
            isEndCustomer = false;
        
        return isEndCustomer;
    }
    
    public DOM.xmlNode getContact(Account account, string field )
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
    
    public static Date addDaysToDate(Date startDate) 
    {
        Integer daysToAdd = 5;
        Date finalDate = startDate;
        Date auxDate = Date.newInstance(finalDate.year(), finalDate.month() + 1, 1);
        Integer numberOfDays = finalDate.daysBetween(auxDate);

        if(numberOfDays < daysToAdd)
        {
            if(!finalDate.isSameDay(finalDate.toStartOfMonth()))
            {
                finalDate = finalDate.addMonths(1);
                finalDate = finalDate.toStartOfMonth().addDays(daysToAdd - numberOfDays);
            }
            else
                finalDate = finalDate.addDays(daysToAdd);
        }
        else
            finalDate = finalDate.addDays(daysToAdd);
        
        return finalDate;
    }
    
    public String calculatePrice(Decimal unitPrice, Date startDate)
    {
        String price = '';
        Decimal pricePerDay = 0;
        Integer firstDay = startDate.day();
        Integer lastDay = Date.daysInMonth(startDate.year(),startDate.month());
        pricePerDay = unitPrice / lastDay;
        if(startDate.day() == startDate.toStartOfMonth().day())
            price = String.valueOf(unitPrice);
        else
            if(lastDay - firstDay + 1 <= 2)
                price = '0';
            else
                price = String.valueOf((pricePerDay * (lastDay - firstDay + 1)).setScale(2)); 
        return price;   
    }
    
    //Create body for the request
    public DOM.xmlNode buildInvoice(Opportunity opportunity, String controlID, String itemType, String shipToValue, String billToValue)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'create_' + controlID + '_oppty_' + opportunity.Id);
        
        DOM.xmlNode create_invoice = function.addChildElement('create_' + controlID,null,null);
       
        create_invoice = CreateNode(create_invoice, 'transactiontype', 'Sales Invoice');
        if(controlID == 'sotransaction')
        {
            DOM.xmlNode dateCreated = create_invoice.addChildElement('datecreated', null, null);
            dateCreated = CreateNode(dateCreated,'year',String.valueOf(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c.year()));
            dateCreated = CreateNode(dateCreated,'month',String.valueOf(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c.month()));
            dateCreated = CreateNode(dateCreated,'day',String.valueOf(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c.day()));
        } 
        
        create_invoice = CreateNode(create_invoice,'customerid', opportunity.Account.IntacctID__c);
        create_invoice = CreateNode(create_invoice,'referenceno', opportunity.Name);
        create_invoice = CreateNode(create_invoice,'termname', opportunity.Account.Credit_Terms__c);
        
        if(shipToValue != '')
        {
        	DOM.xmlNode shipto = create_invoice.addChildElement('shipto', null, null);
        	shipto = CreateNode(shipto, 'contactname', shipToValue);
        }
        if(billToValue != '')
        {        
        	DOM.xmlNode billto = create_invoice.addChildElement('billto', null, null);
       	    billto = CreateNode(billto, 'contactname', billToValue);
        } 
        
        create_invoice = CreateNode(create_invoice,'currency','USD');
        create_invoice = CreateNode(create_invoice,'exchratetype', 'Intacct Daily Rate');
        
        DOM.xmlNode customFields = create_invoice.addChildElement('customfields', null, null);
        DOM.xmlNode customField;
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'OPPORTUNITY_ID');
        customField = CreateNode(customField, 'customfieldvalue', opportunity.Id);
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'ACCOUNT_SFDC_ID');
        customField = CreateNode(customField, 'customfieldvalue', opportunity.Account.Id);

        DOM.xmlNode items = create_invoice.addChildElement(itemType+'s', null, null);
        for(OpportunityLineItem oppProducts : opportunity.OpportunityLineItems) {
            if(itemType == 'sotransitem') 
            {
                DOM.xmlNode item = items.addChildElement(itemType, null, null);
                item = CreateNode(item, 'itemid', oppProducts.PriceBookEntry.Product2.ProductCode);
                if(oppProducts.PriceBookEntry.Product2.Product_Type__c  == 'HW')
                {
                	item = CreateNode(item, 'warehouseid', 'WH1');
                }
                item = CreateNode(item, 'quantity', String.valueOf(oppProducts.Quantity));
                item = CreateNode(item, 'unit', 'Each'); 
                item = CreateNode(item, 'discountpercent', String.valueOf(oppProducts.Discount));
                if(oppProducts.PriceBookEntry.Product2.Product_Type__c  != 'HW')
                    item = CreateNode(item, 'price', calculatePrice(oppProducts.UnitPrice, addDaysToDate(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c)));
                else
                    item = CreateNode(item, 'price','0'); 
                item = CreateNode(item, 'discsurchargememo', 'Price Changed');
                item = CreateNode(item, 'customerid', opportunity.Account.IntacctID__c);   
                
            }
            else 
                if(oppProducts.PriceBookEntry.Product2.Product_Type__c  != 'HW')
                {
                    DOM.xmlNode item = items.addChildElement(itemType, null, null);
                    item = CreateNode(item, 'itemid', oppProducts.PriceBookEntry.Product2.ProductCode);
                    //item = CreateNode(item, 'warehouseid', 'WH1');
                    item = CreateNode(item, 'quantity', String.valueOf(oppProducts.Quantity));
                    item = CreateNode(item, 'unit', 'Each'); 
                    item = CreateNode(item, 'discountpercent', String.valueOf(oppProducts.Discount));
                    item = CreateNode(item, 'price', String.valueOf(oppProducts.UnitPrice));
                    item = CreateNode(item, 'discsurchargememo', 'Price Changed');
                    item = CreateNode(item, 'customerid', opportunity.Account.IntacctID__c);
                }
        }
        if(itemType == 'sotransitem')
        {
            DOM.xmlNode item = items.addChildElement(itemType, null, null);
            item = CreateNode(item, 'itemid',  'Freight');
            item = CreateNode(item, 'warehouseid', 'WH1');
            item = CreateNode(item, 'quantity', '1');
            item = CreateNode(item, 'unit', 'Each');
            item = CreateNode(item, 'price', String.valueOf(getShipmentForOppty(opportunity.Id).zkfedex__TotalNetCharge__c));
            item = CreateNode(item, 'discsurchargememo', 'Price Changed');
            item = CreateNode(item, 'customerid', opportunity.Account.IntacctID__c); 
        }
        
        if(controlID == 'recursotransaction')
        {
            DOM.xmlNode startDate = create_invoice.addChildElement('startdate', null, null);
            startDate = CreateNode(startDate,'year',String.valueOf(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c.year()));
            startDate = CreateNode(startDate,'month',String.valueOf(addDaysToDate(getShipmentForOppty(opportunity.Id).zkfedex__ShipDate__c).month()+1));//toStartOfMonth();
            startDate = CreateNode(startDate,'day','1'); 
            
            create_invoice = CreateNode(create_invoice,'modenew','Months');
            create_invoice = CreateNode(create_invoice,'interval','1');
            create_invoice = CreateNode(create_invoice,'status','active');
            create_invoice = CreateNode(create_invoice,'docstatus','');     
        }
        return function;
    }
    
    public DOM.xmlNode buildInvoice(Case caseRecord, String shipToValue, String billToValue)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'create_sotransaction_case_' + caseRecord.Id);
        
        DOM.xmlNode create_invoice = function.addChildElement('create_sotransaction', null, null);
       
        create_invoice = CreateNode(create_invoice, 'transactiontype', 'Sales Invoice');
        DOM.xmlNode dateCreated = create_invoice.addChildElement('datecreated', null, null);
        dateCreated = CreateNode(dateCreated,'year',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.year()));
        dateCreated = CreateNode(dateCreated,'month',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.month()));
        dateCreated = CreateNode(dateCreated,'day',String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__ShipDate__c.day()));

        create_invoice = CreateNode(create_invoice,'customerid', caseRecord.Account.IntacctID__c);
        create_invoice = CreateNode(create_invoice,'referenceno', caseRecord.CaseNumber);
        create_invoice = CreateNode(create_invoice,'termname', caseRecord.Account.Credit_Terms__c);
       
        if(shipToValue != '')
        {
        	DOM.xmlNode shipto = create_invoice.addChildElement('shipto', null, null);
        	shipto = CreateNode(shipto, 'contactname', shipToValue);
        }
        if(billToValue != '')
        {        
        	DOM.xmlNode billto = create_invoice.addChildElement('billto', null, null);
       	    billto = CreateNode(billto, 'contactname', billToValue); 
        } 
        
        create_invoice = CreateNode(create_invoice,'currency','USD');
        create_invoice = CreateNode(create_invoice,'exchratetype', 'Intacct Daily Rate');
        
        DOM.xmlNode customFields = create_invoice.addChildElement('customfields', null, null);
        DOM.xmlNode customField;
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'CASE_ID');
        customField = CreateNode(customField, 'customfieldvalue', caseRecord.Id);
        
        customField = customFields.addChildElement('customfield', null, null);
        customField = CreateNode(customField, 'customfieldname', 'ACCOUNT_SFDC_ID');
        customField = CreateNode(customField, 'customfieldvalue', caseRecord.Account.Id);

        DOM.xmlNode items = create_invoice.addChildElement('sotransitems', null, null);
       
        DOM.xmlNode item = items.addChildElement('sotransitem', null, null);
        item = CreateNode(item, 'itemid',  'Freight');
        item = CreateNode(item, 'warehouseid', 'WH1');
        item = CreateNode(item, 'quantity', '1');
        item = CreateNode(item, 'unit', 'Each');
        item = CreateNode(item, 'price', String.valueOf(getShipmentForCase(caseRecord.Id).zkfedex__TotalNetCharge__c));
        item = CreateNode(item, 'discsurchargememo', 'Price Changed');
        item = CreateNode(item, 'customerid', caseRecord.Account.IntacctID__c); 
        
        return function;
    }
    
     
    public String getContactName(string nodeName,DOM.Document responseDom)
    {
        String contactName='';
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
        return contactName;
    }
    
    public String sendContactsRequest(List<DOM.xmlNode> getContacts)
    {
        String result = '';
        DOM.Document docContacts = IntacctGateWay.BuildRequestDocument(getContacts);
        HttpRequest request = IntacctGateWay.BuildHttpRequest(docContacts);
        Http httpForContacts = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!isApextest)
        {
            response = httpForContacts.send(request);
            result = response.getBody();
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
    //create sotransaction in Intacct
      public Boolean createInvoice(String Id) 
      {
        Boolean hasErrors = true; 

        List<DOM.xmlNode> functions = new List<DOM.xmlNode>();
        List<DOM.xmlNode> getContacts = new List<DOM.xmlNode>();
        DOM.Document doc = new DOM.Document();
        System.debug('Object Type: ' + getSObjectType(Id)); 
        if(getSObjectType(Id) == 'Opportunity')
        {
            Opportunity opportunity = getOpportunity(Id);
            getContacts.add(getContact(opportunity.Account,'billto'));
            getContacts.add(getContact(opportunity.Account,'shipto'));
            doc.load(sendContactsRequest(getContacts));
            functions.add(BuildInvoice(opportunity,'sotransaction','sotransitem', getContactName('shipto',doc), getContactName('billto',doc)));
            if(!hasEndCustomer(opportunity))
                functions.add(BuildInvoice(opportunity,'recursotransaction','recursotransitem', getContactName('shipto',doc), getContactName('billto',doc)));
        
        }
        else
        if(getSObjectType(Id) == 'Case')
        {
            Case caseRecord = getCase(Id);
            getContacts.add(getContact(caseRecord.Account,'billto'));
            getContacts.add(getContact(caseRecord.Account,'shipto'));
            //String response = sendContactsRequest(getContacts);
            doc.load(sendContactsRequest(getContacts));
            functions.add(BuildInvoice(caseRecord,getContactName('shipto',doc), getContactName('billto',doc)));
        }

        DOM.Document docSoTransaction = IntacctGateWay.BuildRequestDocument(functions);      
        HttpRequest req = IntacctGateWay.BuildHttpRequest(docSoTransaction);
        System.debug('request: ' + req.getBodyDocument().toXmlString()); 
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        DOM.Document responseDoc = new DOM.Document(); 
        String result = '';
        if(!isApexTest)
        {
            res = http.send(req);
            result = res.getBodyDocument().toXmlString();
            System.debug('res: ' + res.getBody()); 
        }
        else
            result = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><response></response>'; 
        responseDoc.load(result);
        //checks for errors in the response from Intacct
        hasErrors = IntacctAPI.ParseErrors(responseDoc); 
        
        return hasErrors;
         
    }
    @future (callout=true)
    public static void syncToIntacct(String Id)
    {
        CreateInvoiceInIntacct sync = new CreateInvoiceInIntacct(); 
        sync.createInvoice(Id);
    }
    
    public Boolean createInvoiceForTest(String Id)
    {
        isApexTest = true;
        return createInvoice(Id);
    }
}