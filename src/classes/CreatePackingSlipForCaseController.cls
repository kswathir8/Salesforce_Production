public with sharing class CreatePackingSlipForCaseController {

    public Case caseRecord {get; set;}
    public Product2 product {get; set;}
    public Axcient_Addr__c add {get;set;}
    public static Boolean isApexTest = false;
    //constructor
    public CreatePackingSlipForCaseController(ApexPages.StandardController controller) 
    {  
        add = Axcient_Addr__c.getValues('Axcient Address');
        Id caseId= ApexPages.CurrentPage().getParameters().get('id');
        caseRecord = [select Id, CaseNumber, Type, Case_Reason__c, Account.Id, Account.Name, Account.BillingCity, Account.BillingStreet, 
                      Account.BillingCountry, Account.BillingState, Account.BillingPostalCode, Account.ShippingCity, 
                      Account.ShippingStreet, Account.ShippingState, Account.ShippingCountry, Account.ShippingPostalCode,
                      Contact.Name, Contact.Id, CreatedDate, Subject, Asset.Name, AssetId, Asset.SerialNumber,
                      Asset.Asset_Tag__c, Asset.Product2ID, Asset.Description, RecordType.Name
                      from Case 
                      where Id =: caseId];        
       
        getProduct();
    } 
    
    public void getProduct()
    {
        try{
            product = [select Id, Name, ProductCode, Standard_Unit__c, (select Id, SerialNumber, Asset_Tag__c, Name from Assets limit 1)
                      from Product2 where Name = 'Axcient DAS Unit' and ProductCode = 'DAS' limit 1];
        }
        catch(QueryException ex){System.debug('QueryException: ' + ex.getMessage());}
        
    } 
 
    public pageReference printPackingSlip()
    {
        if(caseRecord.RecordType.Name == 'DAS Case')
        {
            System.debug(caseRecord.AssetId);
            if(caseRecord.AssetId != null)
            { 
                if(product!=null)
                { 
                    Attachment attach=new Attachment(); 
                    PageReference pdf = new Pagereference('/apex/preparePackingSlipForCaseTemplate?id=' + caseRecord.id); 
                    pdf.setRedirect(true);
                    if(!isApexTest)
                        attach.Body = pdf.getContent();  
                    attach.Name = caseRecord.Subject + ' Packing Slip';  
                    attach.ContentType = 'pdf';  
                    attach.ParentID = caseRecord.id;  
                    try 
                    {  
                        insert(attach); 
                    } 
                    catch(System.DMLException ex) {  
                        System.debug('DMLException: ' +ex.getMessage());       
                    } 
                    return pdf;
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please check if you have a DAS Product created!'));
                    return null;
                }
            }
            else
            { 
                ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Please check if you have an Asset related to this Support Case!'));
                return null;
            }
        }
        else
        {
             ApexPages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Packing Slip is available only to cases of type "DAS"!'));
             return null;
        }
    }
    public pageReference printPackingSlipForTest()
    {
        isApexTest = true;
        return printPackingSlip();
    }
}