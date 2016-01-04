public class RenewalWizardClass{
    
    private ApexPages.standardController controller {get;set;}
    public Opportunity opp { get; set; }
    List<SelectOption> value= new List<SelectOption>();
    List<SelectOption> option = new List<SelectOption>();        
    //public ID OpptyId = ApexPages.currentPage().getParameters().get('Id') ;
    
    public final Account Partner;
    public final Account EndCustomer;
    public String PartnerType ;
    
    
    public RenewalWizardClass(ApexPages.StandardController stdController) {
            // constructor
            controller = stdController;
            this.opp= (Opportunity)stdController.getRecord();
            this.opp.Hardware_Product__c = '01t80000002SFHB' ;
            this.opp.StageName = 'Propose' ;
            
       }
            
         
    
    public PageReference saveSF()
    {
        List<RecordType> recordID = [select Id from RecordType where name = 'Renewal' and sObjecttype = 'Opportunity' limit 1];
        
        Opportunity CurrOpp = [SELECT Name,
        AccountId,
        ForecastCategoryName,
        Type, 
        StageName,
        CloseDate,
        employees__c,
                X1st_Full_Month__c,
                X1st_Month_Billing__c,
                Account_Number__c,
                Acknowledges_business_problem_pain__c,
                jsImpacts__Added_from_Data_com__c,
                Additional_Ship_To_Contact_1__c,
                Additional_Ship_To_Contact_2__c,
                Additional_Ship_To_Contact_3__c,
                Additional_Ship_To_Email_Notification_01__c,
                Additional_Ship_To_Email_Notification_02__c,
                Additional_Ship_To_Email_Notification_03__c,
                Customer_Address__c,
                Agree_Duration__c,
                rrpu__Alert_Message__c,
                On_site_Storage_GB__c,
                Approved__c,
                Asset__c,
                AssetID__c,
                Asset_Tag__c,
                Attended_a_live_demo__c,
                Attends_live_demo__c,
                Axcient_Appliance__c,
                Axcient_SN__c,
                QuoteBillingFrequency__c,
                Billing_Style__c,
                Bill_To__c,
                Return_Date__c,
                Cancellation_Reason__c,
                CC_Type__c,
                Reason_for_Lost__c,
                Closed_Lost_Record_Count__c,
                Close_Duration__c,
                Closed_Won_Duration__c,
                Close_Quarter__c,
                Commited__c,
                Company_Name__c,
                Competitor__c,
                Conditions__c,
                Customer_Contact_Name__c,
                Contact_Term_End_Date__c,
                Contract_Date__c,
                Contract_End_Date__c,
                Contract_Renewal_Date__c,
                Contract_Stats__c,
                Contract_Terms__c,
                Corp_Currency_Amount__c,
                Co_term_Start_Date__c,
                Credit_Card_Number__c,
                Credit_Card_Type__c,
                Credit_Terms__c,
                Customer_Account_Status__c,
                Customer_Contact_Title__c,
                Customer_Contract__c,
                DAS_Requested__c,
                DataCenter__c,
                Data_Center__c,
                DC__c,
                Deposit_on_file__c,
                Discount_on_Set_Act__c,
                Displaced_Backup_Solutions__c,
                Disti__c,
                Disti_Account_Number__c,
                DistiFetched__c,
                Disti_Deal__c,
                Disti_Required__c,
                Distributor__c,
                Drop_off_shipment__c,
                Drop_off_shipment_Receipt_Number__c,
                Customer_Email_Address__c,
                End_Customer__c,
                End_Customer_ID__c,
                QuoteEndDate__c,
                Evaluating_BDR_BC_solutions__c,
                Evaluation_Expiration__c,
                Exp_Date__c,
                Experience_selling_BDR_and_backup_prods__c,
                Experience_selling_cloud_services__c,
                First_Bill_Date__c,
                Forecast_Amount__c,
                Forecast_Type__c,
                Fulfillment__c,
                Hardware_Product__c,
                HW_Support_Level__c,
                How_many_identified_end_user_opps__c,
                How_many_managed_customers_do_you_have__c,
                How_many_sales_people_do_you_have__c,
                How_many_technical_resources_people__c,
                HP_Customer_Name__c,
                HP_End_Customer_Purchase_Order__c,
                HP_Legacy_Order_Number__c,
                HP_Order_Number__c,
                HP_Products__c,
                HP_SAP_Order_Number__c,
                HP_Ship_To_Addr__c,
                Includes_full_capacity_offsite_storage__c,
                Installed_Date__c,
                MQL__c,
                Lead_Source__c,
                Monthly_Serivce_Price__c,
                Montly_Service_Fee__c,
                MMR_Opps_expected_within_24_months__c,
                Name_On_The_CC__c,
                Net_Enrich__c,
                Number_of_Rejected__c,
                Number_of_SQL__c,
                Off_site_Storage__c,
                Off_Site_Stoarge_Included__c,
                Oppty_At_Risk_Reason_Code__c,
                Original_RecordType__c,
                Package__c,
                Partner__c,
                QuotePaymentMode__c,
                QuotePaymentTime__c,
                Perferred_Pricing_Monthly__c,
                Perferred_Pricing__c,
                PO_Date__c,
                Preferred_Amount_Due_at_Inception__c,
                Premium_Pricing_Monthly__c,
                Premium_Amount_Due_at_Inception__c,
                Premium_Set_up_and_Activation_Fee__c,
                Pre_paid_MRR_Delta__c,
                Procure_BRD_BC_solution_or_obatin_budget__c,
                Product__c,
                Purchase_timeframe__c,
                Comments__c,
                Total__c,
                Qualify_Duration__c,
                Quota__c,
                QuoteBeginDate__c,
                Quoted_Date__c,
                QuoteNumber__c,
                QuoteVersion__c,
                Renewal_Date_for_Service_Agreement__c,
                Reseller_Commission__c,
                Return_Tracking_Number__c,
                RMC_Alas__c,
                RMC_Alias__c,
                RMC_Email__c,
                RMC_EmailA__c,
                Sales_Duration__c,
                Serial_Number__c,
                Service_ID__c,
                Service_ID_2__c,
                Service_ID_new__c,
                Service_Level__c,
                Service_Start_Date__c,
                Service_Tag__c,
                Setup_and_Activation_Fee__c,
                Setup_and_Activation__c,
                Ship_Appliance_To__c,
                Shipping_Date__c,
                Shipped_To__c,
                Shipping_Approved__c,
                Shipping_Fee__c,
                Shipping_Priority__c,
                Ship_Request_Date__c,
                Shipping_Service_Level__c,
                Ship_To_Test1__c,
                Ship_To_City__c,
                Ship_To_Company__c,
                Ship_To_Country__c,
                Ship_To_Email__c,
                Ship_to_Name__c,
                Ship_To_Contact__c,
                Ship_To_Phone__c,
                Ship_To_State__c,
                Ship_To_Street__c,
                SHIP_TO_TEST__c,
                Ship_To_Zip__c,
                Software_Product__c,
                MQL_Closed_Lost_Reason__c,
                Status__c,
                Total_Discount__c,
                Total_Interim_Service_Fee__c,
                Total_Net_To_Axcient__c,
                Total_Payable_to_Reseller__c,
                Total_Product_Cost__c,
                Total_Renal_Cost__c,
                Shipping_Tracking_Number__c,
                Type_of_Upgrade__c,
                Typical_Data_Set__c,
                Unit_Received_By__c,
                Vertical__c,
                Account.Name,
                Partner__r.Name,
                MRR_Value_Formula__c
                FROM Opportunity WHERE Id =:opp.id];
        
        Opportunity UpgradedOpportunity = CurrOpp.clone(false);
        
        
   
   
    
    UpgradedOpportunity.Name= 'RENEWAL'+': ' +CurrOpp.Name;
    UpgradedOpportunity.StageName=opp.StageName ;
    UpgradedOpportunity.Upgraded_From__c = opp.Id ;
    UpgradedOpportunity.CloseDate = opp.CloseDate ;
    UpgradedOpportunity.Software_Product__c = opp.Software_Product__c ;
    UpgradedOpportunity.Hardware_Product__c = opp.Hardware_Product__c ;
    UpgradedOpportunity.Type_of_Upgrade__c = opp.Type_of_Upgrade__c ;
    UpgradedOpportunity.Upgrade__c = opp.Upgrade__c ;
    UpgradedOpportunity.Prepay__c = opp.Prepay__c ;
    UpgradedOpportunity.Renewal_Term__c = opp.Renewal_Term__c ;
    UpgradedOpportunity.RecordTypeID = recordID[0].Id ;
    UpgradedOpportunity.Status__c = 'Active' ;

    
    
    
                                                                
        try
        {                                                            
        insert UpgradedOpportunity ;
        }
      catch(DmlException e){
      System.debug('DML Exception : '+ e);
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+'Error during creating upgrade/downgrade opportunity'));
      Return NULL ;
      
    }
        
        CurrOpp.Status__c = 'Inactive - Upgraded / Downgraded';
        try
        {
        update CurrOpp ;
        }
        catch(DmlException e){
      System.debug('DML Exception : '+ e);
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+'Error during updating originial opportunity'));
      Return NULL ;
      
    }
        
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        Pricebook2  ResellerPb = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='Reseller Price Book' limit 1];
        Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];
        
        try
        {
        if(opp.Type_of_Upgrade__c == 'Software (Entitlements)')
        {
            PriceBookEntry PBESW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Software_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            OpportunityLineItem OLISW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBESW.Id);
            insert OLISW ;
            
             Integer OLIHWOrigCount = [select count() from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c!=NULL  LIMIT 1  ] ;
            
            if(OLIHWOrigCount > 0)
            {
            OpportunityLineItem OLIHWOrig = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c, Asset__c from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c!=NULL  LIMIT 1  ] ;
            PriceBookEntry PBEHWOrig = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: OLIHWOrig.PriceBookEntry.Product2Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            
            OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHWOrig.Id, Asset__c = OLIHWOrig.Asset__c );
            insert OLIHW ;
            }
            
        }
        else if(opp.Type_of_Upgrade__c == 'Hardware (Appliance)')
        {
             
        PriceBookEntry PBEHW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Hardware_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
        OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHW.Id);
        insert OLIHW ;
        }
        
        else if(opp.Type_of_Upgrade__c == 'Both')
        {
        PriceBookEntry PBEHW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Hardware_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
        OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHW.Id);
        insert OLIHW ;
        
        PriceBookEntry PBESW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Software_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
        OpportunityLineItem OLISW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBESW.Id);
        insert OLISW ;
        
        }
        
        if(opp.Upgrade__c == 'No')
        
        {
        
            Integer OLIHWOrigCount = [select count() from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c!=NULL  LIMIT 1  ] ;
            
            if(OLIHWOrigCount > 0)
            {
            OpportunityLineItem OLIHWOrig = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c, Asset__c from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c!=NULL  LIMIT 1  ] ;
            PriceBookEntry PBEHWOrig = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: OLIHWOrig.PriceBookEntry.Product2Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            
            OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHWOrig.Id, Asset__c = OLIHWOrig.Asset__c );
            insert OLIHW ;
            }
            
            
            Integer OLISWOrigCount = [select count() from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c=NULL  LIMIT 1  ] ;
            
            if(OLISWOrigCount > 0)
            {
            OpportunityLineItem OLISWOrig = [select ID,PriceBookEntry.Product2Id,Asset_Tag_Asset__c,Asset__r.Name,Asset__r.Service_ID__r.Name,Asset__r.Model_Number__c, Asset__c from OpportunityLineItem where OpportunityID = : CurrOpp.Id and Asset_Tag_Asset__c=NULL  LIMIT 1  ] ;
            PriceBookEntry PBESWOrig = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: OLISWOrig.PriceBookEntry.Product2Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            
            OpportunityLineItem OLISW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBESWOrig.Id, Asset__c = OLISWOrig.Asset__c );
            insert OLISW ;
            }
            
            
         }   
        
        
        
        
        }
        
        catch(DmlException e){
      System.debug('DML Exception : '+ e);
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()+'Please check the entitlements'));
      Return NULL ;
      
    }
    
    catch(Exception ec){
      System.debug('DML Exception : '+ ec);
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ec.getMessage()+' Please check the entitlements'));
      Return NULL ;
      
    }
        
       /* if(opp.Type_of_Upgrade__c == 'Both' || opp.Type_of_Upgrade__c == 'Hardware (Appliance)')
        {
            PriceBookEntry PBEHW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Hardware_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE LIMIT 1];
            OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHW.Id);
            insert OLIHW ;
            
            List<RecordType> recordIDCase = [select Id from RecordType where name = 'RMA Case' and sObjecttype = 'Case' limit 1];
            
            Case RMACase = new Case( Subject= 'RMA - Order Upgrade/Downgrade Request for ' + CurrOpp.Partner__r.Name ,
                                     Customer__c = UpgradedOpportunity.Id,
                                     End_Customer__c = CurrOpp.End_Customer__c,
                                     AccountID = CurrOpp.Partner__c ,
                                     
                                    
            insert RMACase ;
    
    
    
        }
        */
    
        

        
      if(ApexPages.hasMessages()) return NULL ;
      
      else
      {
      controller = new ApexPages.standardController(UpgradedOpportunity);
      return controller.view();
      }
      
        
        
    
    }
    
         
         
         
  
        Public string select1{get; set;}
        Public string select2{get; set;}
        Public string select3{get; set;}
        Public string select4{get; set;}
        
        
        
      
        
}