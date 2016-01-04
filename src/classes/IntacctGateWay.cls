global class IntacctGateWay
{
    //upgrade
    private static string gatewayURL;
    private static string senderID;
    private static string senderPassword;
    private static string userID;
    private static string companyID;
    private static string companyPassword;
    private static string locationID;
    
    private static void GetSettings()
    {
        Intacct_Integration_Settings__c gw = Intacct_Integration_Settings__c.getValues('Intacct Gateway');
        gatewayURL = gw.Intacct_Gateway_URL__c;
        senderID = gw.Intacct_Sender_ID__c;
        senderPassword = gw.Intacct_Sender_Password__c;
        userID = gw.Intacct_User_ID__c;
        companyID = gw.Intacct_Company_ID__c;
        companyPassword = gw.Intacct_Company_Password__c;
        locationID = gw.Intacct_Entity_ID__c;
    }   
    
    global static HttpRequest BuildHttpRequest(DOM.Document request)
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(gatewayURL);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'x-intacct-xml-request');
        req.setBodyDocument(request);
        req.setTimeout(120000);
        
        return req; 
    }
    
    global static DOM.Document BuildRequestDocument(DOM.xmlNode function)
    {
        GetSettings();
    
        DOM.Document requestDoc = new DOM.Document();
        requestDoc.load('<request></request>');
        DOM.xmlNode request = requestDoc.getRootElement();
        
        TG_XmlUtils.appendChild(request, BuildControl('test', false));
        TG_XmlUtils.appendChild(request, BuildOperation(function));
        
        return requestDoc;
    }

    global static DOM.Document BuildRequestDocument(DOM.xmlNode function, string controlID, boolean uniqueID)
    {
        GetSettings();
        
        DOM.Document requestDoc = new DOM.Document();
        requestDoc.load('<request></request>');
        DOM.xmlNode request = requestDoc.getRootElement();
        
        TG_XmlUtils.appendChild(request, BuildControl(controlID, uniqueID));
        TG_XmlUtils.appendChild(request, BuildOperation(function));
        
        return requestDoc;
    }

    global static DOM.Document BuildRequestDocument(DOM.xmlNode[] functions)
    {
        GetSettings();
        
        DOM.Document requestDoc = new DOM.Document();
        requestDoc.load('<request></request>');
        DOM.xmlNode request = requestDoc.getRootElement();
        
        String controlId = 'intacct_operation_' + String.valueOf(System.now()); 
        TG_XmlUtils.appendChild(request, BuildControl(controlId, false));
        TG_XmlUtils.appendChild(request, BuildOperation(functions));
                    
        return requestDoc;
    }

    global static DOM.Document BuildRequestDocument(DOM.xmlNode[] functions, string controlID, boolean uniqueID)
    {
        GetSettings();
        
        DOM.Document requestDoc = new DOM.Document();
        requestDoc.load('<request></request>');
        DOM.xmlNode request = requestDoc.getRootElement();
        
        TG_XmlUtils.appendChild(request, BuildControl(controlID, uniqueID));
        TG_XmlUtils.appendChild(request, BuildOperation(functions));
                    
        return requestDoc;
    }

    private static DOM.xmlNode BuildControl(string controlID, boolean uniqueID)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<control></control>');
        DOM.xmlNode control = XML.getRootElement();
        control.addChildElement('senderid', null, null).addTextNode(senderID);
        control.addChildElement('password', null, null).addTextNode(senderPassword);
        control.addChildElement('controlid', null, null).addTextNode(controlID);
        if(uniqueID)
            control.addChildElement('uniqueid',null,null).addTextNode('true');
        else
            control.addChildElement('uniqueid',null,null).addTextNode('false');
        control.addChildElement('dtdversion', null, null).addTextNode('2.1');        
        return control;
    }
    
    private static DOM.xmlNode BuildAuthentication()
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<authentication></authentication>');
        DOM.xmlNode authentication = XML.getRootElement();
        DOM.xmlNode login = authentication.addChildElement('login', null, null);
        login.addChildElement('userid', null, null).addTextNode(userID);
        login.addChildElement('companyid', null, null).addTextNode(companyID);
        login.addChildElement('password', null, null).addTextNode(companyPassword);
        if(locationID != null && locationID != '')
            login.addChildElement('locationid', null, null).addTextNode(locationID);
        
        return authentication;
    }
    
    private static DOM.xmlNode BuildOperation(DOM.xmlNode function)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<operation></operation>');
        DOM.xmlNode operation = XML.getRootElement();
        TG_XmlUtils.appendChild(operation, BuildAuthentication());
        DOM.xmlNode content = operation.addChildElement('content', null, null);
        TG_XmlUtils.appendChild(content, function);

        return operation;
    }
    
    private static DOM.xmlNode BuildOperation(DOM.xmlNode[] functions)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<operation></operation>');
        DOM.xmlNode operation = XML.getRootElement();
        operation.setAttribute('transaction','true');
        TG_XmlUtils.appendChild(operation, BuildAuthentication());
        DOM.xmlNode content = operation.addChildElement('content', null, null);
        for(DOM.xmlNode function : functions)
            TG_XmlUtils.appendChild(content, function);

        return operation;
    }
    
    global static DOM.Document BuildList(string objectName)
    {
        DOM.Document XML = new DOM.Document();
        XML.load('<function></function>');
        DOM.xmlNode function = XML.getRootElement();
        function.setAttribute('controlid', 'test');
        function.addChildElement('get_list', null, null).setAttribute('object', objectName);
        
        return IntacctGateWay.BuildRequestDocument(function);
    }
}