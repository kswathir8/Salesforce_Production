global class IntacctAPI {
    global static Boolean ParseErrors(Dom.Document responseDOM)
    {
        String requestControlID;
        String currentFunctionControlID;
        String currentFunction;
        
        Boolean errorFound = false;
        Integer ID = 0;
        
        List<IntacctErrorMessage__c> sfErrorMessageList = new List<IntacctErrorMessage__c>();
        List<IntacctError__c> sfErrorList = new List<IntacctError__c>();
       
        for(dom.XmlNode responseLevelNode : responseDOM.getRootElement().getChildElements())
        {
            if(responseLevelNode.getName() == 'control')
            {
                for(dom.XmlNode controlLevelNode : responseLevelNode.getChildElements())
                {
                    if(controlLevelNode.getName() == 'controlid')
                    {
                        requestControlID = controlLevelNode.getText();  
                    }                   
                }
            }
            if(responseLevelNode.getName() == 'errormessage')
            {
                errorFound = true;
                ID++;
                sfErrorMessageList.Add(IntacctAPI.GetErrorMessage('Error at control level, controlid: ' + requestControlID, ID));
                sfErrorList.AddAll(IntacctAPI.GetErrors(responseLevelNode, ID));
            }
            if(responseLevelNode.getName() == 'operation')
            {
                for(dom.XmlNode operationLevelNode : responseLevelNode.getChildElements())
                {
                    if(operationLevelNode.getName() == 'errormessage')
                    {
                        errorFound = true;
                        ID++;
                        sfErrorMessageList.Add(IntacctAPI.GetErrorMessage('Error at operation level, controlid: ' + requestControlID, ID));
                        sfErrorList.AddAll(IntacctAPI.GetErrors(operationLevelNode, ID));
                    }
                    if(operationLevelNode.getName() == 'result')
                    {
                        for(dom.XmlNode functionLevelNode : operationLevelNode.getChildElements())
                        {
                            if(functionLevelNode.getName() == 'function')
                            { 
                                currentFunction = functionLevelNode.getText();
                            }
                            if(functionLevelNode.getName() == 'controlid')
                            {
                                currentFunctionControlID = functionLevelNode.getText();
                            }
                            if(functionLevelNode.getName() == 'errormessage')
                            {
                                errorFound = true;
                                ID++;
                                sfErrorMessageList.Add(IntacctAPI.GetErrorMessage('Error at function level:\nControl ID: ' + requestControlID + ',\nFunction: ' + currentFunction + ',\nFunction Control ID: ' + currentFunctionControlID, ID));
                                sfErrorList.AddAll(IntacctAPI.GetErrors(functionLevelNode, ID));
                            }
                        }
                    }
                }
            }
        }
        
        if(sfErrorMessageList.size() > 0)
        {
            Insert sfErrorMessageList;
            for(Integer i = 0; i < sfErrorMessageList.size(); i++)
                for(Integer j = 0; j < sfErrorList.size(); j++)
                    if(sfErrorList[j].Error_Message_Index__c == sfErrorMessageList[i].Error_Message_Index__c)
                        sfErrorList[j].IntacctErrorMessage__c = sfErrorMessageList[i].Id;
            Insert sfErrorList;
            
        }       
        
        return (errorFound);
    }
    
    global static IntacctErrorMessage__c GetErrorMessage(String context, Integer id)
    {
        IntacctErrorMessage__c sfErrorMessage;
        sfErrorMessage = new IntacctErrorMessage__c();
        sfErrorMessage.Context_Text_Area__c = context;
        sfErrorMessage.Opportunity__c = IntacctAPI.getObjectIdByName(context, '_sotransaction_oppty_');
        sfErrorMessage.Case__c = IntacctAPI.getObjectIdByName(context, '_sotransaction_case_');
        sfErrorMessage.Error_Message_Index__c = id;
        
        return sfErrorMessage;
    } 
    
    global static List<IntacctError__c> GetErrors(DOM.Xmlnode errorMessage, Integer id)
    {
        IntacctError__c sfError;
        
        List<IntacctError__c> sfErrorList = new List<IntacctError__c>();
        
        for(dom.XmlNode error : errorMessage.getChildElements())
        {
            if(error.getName() == 'error')
            {
                sfError = new IntacctError__c();
                sfError.Error_Message_Index__c = id;
                for(dom.Xmlnode node : error.getChildElements())
                {
                    if(node.getName() == 'errorno')
                    {
                        if(node.getText().length() > 100)
                            sfError.errorno__c = node.getText().substring(0, 100);
                        else
                            sfError.errorno__c = node.getText();
                    }
                    if(node.getName() == 'description')
                    {
                        if(node.getText().length() > 255)
                            sfError.description__c = node.getText().substring(0, 255);
                        else
                            sfError.description__c = node.getText();
                    }
                    if(node.getName() == 'description2')
                    {
                        if(node.getText().length() > 255)
                            sfError.description2__c = node.getText().substring(0, 255);
                        else
                            sfError.description2__c = node.getText();
                    }
                    if(node.getName() == 'correction')
                    {
                        if(node.getText().length() > 255)
                            sfError.correction__c = node.getText().substring(0, 255);
                        else
                            sfError.correction__c = node.getText();
                    }
                }
                sfErrorList.add(sfError);
            }
        }       
        return sfErrorList;
    }
    
   
    global static String getObjectIdByName(String context, String objectName) {
        String sfId = null;
        Integer sfIdLength = 18;
        
        Integer objectNameLength = objectName.length();
        Integer objectNameStartPosition = context.indexOf(objectName);
        Integer sfIdStrart = objectNameLength + objectNameStartPosition;
        
        if(objectNameStartPosition > 0)
            sfId = context.substring(sfIdStrart, sfIdStrart + sfIdLength);
        
        return sfId;
    }
}