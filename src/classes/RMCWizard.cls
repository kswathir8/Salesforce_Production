public class RMCWizard {
    
    private ApexPages.standardController controller {get;set;}
    public Opportunity opp { get; set; }
    List<SelectOption> value= new List<SelectOption>();
    List<SelectOption> option = new List<SelectOption>();        
    //public ID OpptyId = ApexPages.currentPage().getParameters().get('Id') ;
    
    public final Account Partner;
    public final Account EndCustomer;
    public String PartnerType ;
    
    
    public RMCWizard(ApexPages.StandardController stdController) {
            // constructor
            controller = stdController;
            this.opp= (Opportunity)stdController.getRecord();
            this.opp.Hardware_Product__c = '01t80000002SFHB' ;
            this.opp.StageName = 'Propose' ;
            
            //Opportunity CurrOpp = [SELECT AccountId, End_Customer__c,StageName,CloseDate  FROM Opportunity WHERE Id =:opp.id];      
    }
         
    
    public PageReference saveSF()
    {
        List<RecordType> recordID = [select Id from RecordType where name = 'Upgrade/Downgrade Opportunity Not Provisioned' and sObjecttype = 'Opportunity' limit 1];
        
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
		Partner__r.Name
		FROM Opportunity WHERE Id =:opp.id];
        
        Opportunity UpgradedOpportunity = CurrOpp.clone(false);
        
        /*Opportunity UpgradedOpportunity = new Opportunity(Name=opp.Upgrade_Downgrade__c+ ': ' +CurrOpp.Name,StageName=opp.StageName,Upgraded_From__c = opp.Id,
                                                            Displaced_Backup_Solutions__c = CurrOpp.Displaced_Backup_Solutions__c , 
                                                            Ship_To_Email__c=CurrOpp.Ship_To_Email__c, 
                                                            Monthly_Serivce_Price__c = CurrOpp.Monthly_Serivce_Price__c ,
                                                            QuotePaymentMode__c = CurrOpp.QuotePaymentMode__c,
                                                            Ship_To_Test1__c=CurrOpp.Ship_To_Test1__c,
                                                            Ship_To_Contact__c = CurrOpp.Ship_To_Contact__c ,
                                                            Shipping_Service_Level__c = CurrOpp.Shipping_Service_Level__c ,
                                                            End_Customer__c = CurrOpp.End_Customer__c,
                                                            AccountID = CurrOpp.AccountID, 
                                                            Partner__c = CurrOpp.Partner__c,
                                                            CloseDate = opp.CloseDate,
                                                            Software_Product__c = opp.Software_Product__c,
                                                            Hardware_Product__c = opp.Hardware_Product__c,
                                                            Ship_To_Phone__c = CurrOpp.Ship_To_Phone__c , 
                                                            Ship_To_State__c = CurrOpp.Ship_To_State__c , 
                                                            Ship_To_Street__c = CurrOpp.Ship_To_Street__c, 
                                                            Ship_To_Zip__c = CurrOpp.Ship_To_Zip__c,
                                                            Ship_To_Country__c = CurrOpp.Ship_To_Country__c ,
                                                            Ship_Appliance_To__c = CurrOpp.Ship_Appliance_To__c,
                                                            Additional_Ship_To_Contact_1__c = CurrOpp.Additional_Ship_To_Contact_1__c,
                                                            Additional_Ship_To_Contact_2__c = CurrOpp.Additional_Ship_To_Contact_2__c,
                                                            Additional_Ship_To_Contact_3__c = CurrOpp.Additional_Ship_To_Contact_3__c,
                                                            RecordTypeID = recordID[0].Id ,
                                                            DC__c = opp.DC__c, 
                                                            Upgrade_SID_Status__c = opp.Upgrade_SID_Status__c,
                                                            Upgrade_Downgrade__c = opp.Upgrade_Downgrade__c,
                                                                                                                      
                                                            Type_of_Upgrade__c = opp.Type_of_Upgrade__c );
   */
    
    UpgradedOpportunity.Name=opp.Upgrade_Downgrade__c+ ': ' +CurrOpp.Name;
    UpgradedOpportunity.StageName=opp.StageName ;
    UpgradedOpportunity.Upgraded_From__c = opp.Id ;
    UpgradedOpportunity.CloseDate = opp.CloseDate ;
    UpgradedOpportunity.Software_Product__c = opp.Software_Product__c ;
    UpgradedOpportunity.Hardware_Product__c = opp.Hardware_Product__c ;
    UpgradedOpportunity.Upgrade_SID_Status__c = opp.Upgrade_SID_Status__c ;
    UpgradedOpportunity.Upgrade_Downgrade__c = opp.Upgrade_Downgrade__c ;
    UpgradedOpportunity.Type_of_Upgrade__c = opp.Type_of_Upgrade__c ;
    UpgradedOpportunity.RecordTypeID = recordID[0].Id ;
    
    
                                                                
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
                                     
                                     RecordTypeID = recordIDCase[0].Id );
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
        
        
        
        /********************************************
        *           Test Methods                    *
        ********************************************/
        
        @isTest (seeAllData=true)
        public static void testSaveSFWithSoftware(){
            
            RecordType endCustomer = [Select id From RecordType Where sObjectType='Account' AND Name = 'End Customer'];
            
            Account a = new Account(name='Test Account', RecordTypeID=endCustomer.id);
            insert a;
            Contact c = new Contact(firstName='Fake',lastName='Guy',email='fake@guy.com',AccountID=a.id);
            insert c;
            
            //Data_Center__c DC = [select Name from Data_Center__c where Name = 'GEN2_Canada' LIMIT 1];
	        // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
	        Data_Center__c DC = new Data_Center__c(RMC_Name__c = 'Gen2_Canada') ;
	        insert DC ;
            
            Opportunity opp = new Opportunity(Name='Initial Opp',StageName='Closed Won',
                                                            Displaced_Backup_Solutions__c = 'blank' , 
                                                            Ship_To_Email__c='gram@test.com', 
                                                            Monthly_Serivce_Price__c = 150 ,
                                                            QuotePaymentMode__c = 'blank',
                                                            Ship_To_Test1__c= '111 Fake St',
                                                            Ship_To_Contact__c = c.id ,
                                                            Shipping_Service_Level__c = 'blank' ,
                                                            End_Customer__c = a.id,
                                                            AccountID = a.id, 
                                                            Partner__c = a.Id ,
                                                            CloseDate = Date.today(),
                                                            Ship_To_Phone__c = '(123) 456-7890' , 
                                                            Ship_To_State__c = 'CA' , 
                                                            Ship_To_Street__c = 'blank', 
                                                            Ship_To_Zip__c = 'blank',
                                                            Ship_To_Country__c = 'blank' ,
                                                            DC__c = DC.Id,
                                                            Ship_Appliance_To__c = 'blank' );
                                                            
            insert opp;
            
            Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];
            
            //Asset ass1 = [select Name from Asset where Asset_Tag__c != '' and Name !='Axcient DAS Unit' LIMIT 1 ];
            // MMA - 06/10/15 - Creating a new asset instead of querying one. Name and Asset_Tag__c are required fields
            Asset ass1 = new Asset(Name = 'Axcient Test', Asset_Tag__c = 'fred', AccountId = a.Id, ContactId = c.Id) ;
            insert ass1 ;
            
            Product2 HW = [Select id,ProductCode From Product2 Where Product_Type__c = 'HW' AND isActive = true and ProductCode ='A20-R-1000' limit 1];
            
            PriceBookEntry PBEHWOrig = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: HW.Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            
            OpportunityLineItem OLItoIns = new OpportunityLineItem(
            OpportunityID = opp.Id ,
            Asset__c = ass1.Id,
            PricebookEntryId = PBEHWOrig.Id          
            );
            insert OLItoIns ;
            
            opp = [SELECT Name,AccountId,Partner__c, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name ,
                                        Additional_Ship_To_Contact_1__c,
                                        Additional_Ship_To_Contact_2__c,
                                        Additional_Ship_To_Contact_3__c FROM Opportunity WHERE Id =:opp.id];
            
            /* System Asserts */
            System.Assert(opp.Name.contains('Initial Opp'));
            System.Assert(opp.StageName=='Closed Won');
            System.AssertEquals(opp.Displaced_Backup_Solutions__c , 'blank' );  
            System.Assert(opp.Monthly_Serivce_Price__c == 150 );
            System.Assert(opp.QuotePaymentMode__c == 'blank');
            System.Assert(opp.Ship_To_Test1__c== '111 Fake St');
            System.Assert(opp.Ship_To_Contact__c == c.id );
            System.Assert(opp.Shipping_Service_Level__c == 'blank' );
            System.Assert(opp.End_Customer__c == a.id);
            System.Assert(opp.AccountID == a.id); 
            System.Assert(opp.CloseDate == Date.today());
            
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
            RMCWizard wizard = new RMCWizard(stdController);
            Product2 SW = [Select id,Name,ProductCode From Product2 Where Product_Type__c = 'SW' and isActive=TRUE and ProductCode = '10000-Fortify-10000' limit 1];
            
            
            
            
            
            // Data_Center__c dc1 = [Select id From Data_Center__c limit 1];
	        // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
	        Data_Center__c dc1 = new Data_Center__c() ;
	        insert dc1 ;
            Test.setCurrentPage(new PageReference('apex/TemporaryUpgrade?scontrolCaching=1&id=' + opp.id));
            
            
            Test.startTest();
            
                wizard.opp.Upgrade_Downgrade__c = 'upgrade';
                wizard.opp.CloseDate = Date.today();
                wizard.opp.StageName = 'Closed Lost';
                wizard.opp.Type_of_Upgrade__c = 'Software (Entitlements)';
                wizard.opp.Software_Product__c = SW.id;
                wizard.opp.Hardware_Product__c = HW.id;
                wizard.opp.DC__c = DC.id;
                wizard.opp.Upgrade_SID_Status__c = 'Create New SID';
                wizard.opp.AccountID = a.id;
                wizard.opp.Partner__c = a.id ;
                wizard.opp.End_Customer__c = a.id;
                wizard.saveSF();
                opp = wizard.opp;
            
            Test.stopTest();
            
            opp = [SELECT Name,AccountId, Partner__c, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name ,
                                        Additional_Ship_To_Contact_1__c,
                                        Additional_Ship_To_Contact_2__c,
                                        Additional_Ship_To_Contact_3__c FROM Opportunity WHERE Id =:opp.id];
            
            /* System Asserts */
            System.Assert(opp.Name.contains('Initial Opp'));
            System.Assert(opp.StageName=='Closed Won');
            System.AssertEquals(opp.Displaced_Backup_Solutions__c , 'blank' );  
            System.Assert(opp.Monthly_Serivce_Price__c == 150 );
            System.Assert(opp.QuotePaymentMode__c == 'blank');
            System.Assert(opp.Ship_To_Test1__c== '111 Fake St');
            System.Assert(opp.Ship_To_Contact__c == c.id );
            System.Assert(opp.Shipping_Service_Level__c == 'blank' );
            System.Assert(opp.End_Customer__c == a.id);
            System.Assert(opp.AccountID == a.id); 
            System.Assert(opp.CloseDate == Date.today());
            
            
        } 
        
        @isTest (seeAllData=true)
        public static void testSaveSFWithHardware(){
            
            RecordType endCustomer = [Select id From RecordType Where sObjectType='Account' AND Name = 'End Customer'];
            
            Account a = new Account(name='Test Account', RecordTypeID=endCustomer.id);
            insert a;
            Contact c = new Contact(firstName='Fake',lastName='Guy',email='fake@guy.com',AccountID=a.id);
            insert c;
            
            //Data_Center__c DC = [select Name from Data_Center__c where Name = 'GEN2_Canada' LIMIT 1];
	        // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
	        Data_Center__c DC = new Data_Center__c(RMC_Name__c = 'Gen2_Canada') ;
	        insert DC ;
            
            Opportunity opp = new Opportunity(Name='Initial Opp',StageName='Closed Won',
                                                            Displaced_Backup_Solutions__c = 'blank' , 
                                                            Ship_To_Email__c='gram@test.com', 
                                                            Monthly_Serivce_Price__c = 150 ,
                                                            QuotePaymentMode__c = 'blank',
                                                            Ship_To_Test1__c= '111 Fake St',
                                                            Ship_To_Contact__c = c.id ,
                                                            Shipping_Service_Level__c = 'blank' ,
                                                            End_Customer__c = a.id,
                                                            AccountID = a.id, 
                                                            Partner__c = a.id,
                                                            CloseDate = Date.today(),
                                                            DC__c = DC.Id,
                                                            Ship_To_Phone__c = '(123) 456-7890' , 
                                                            Ship_To_State__c = 'CA' , 
                                                            Ship_To_Street__c = 'blank', 
                                                            Ship_To_Zip__c = 'blank',
                                                            Ship_To_Country__c = 'blank' ,
                                                            Ship_Appliance_To__c = 'blank' );
                                                            
            insert opp;
            
            
            
            opp = [SELECT Name,AccountId, Partner__c, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name ,
                                        Additional_Ship_To_Contact_1__c,
                                        Additional_Ship_To_Contact_2__c,
                                        Additional_Ship_To_Contact_3__c FROM Opportunity WHERE Id =:opp.id];
            
            /* System Asserts */
            System.Assert(opp.Name.contains('Initial Opp'));
            System.Assert(opp.StageName=='Closed Won');
            System.AssertEquals(opp.Displaced_Backup_Solutions__c , 'blank' );  
            System.Assert(opp.Monthly_Serivce_Price__c == 150 );
            System.Assert(opp.QuotePaymentMode__c == 'blank');
            System.Assert(opp.Ship_To_Test1__c== '111 Fake St');
            System.Assert(opp.Ship_To_Contact__c == c.id );
            System.Assert(opp.Shipping_Service_Level__c == 'blank' );
            System.Assert(opp.End_Customer__c == a.id);
            System.Assert(opp.AccountID == a.id); 
            System.Assert(opp.CloseDate == Date.today());
            
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
            RMCWizard wizard = new RMCWizard(stdController);
            Product2 HW = [Select id,ProductCode From Product2 Where Product_Type__c = 'HW' AND isActive = true and ProductCode ='A20-R-1000' limit 1];
            Data_Center__c dc2 = [Select id From Data_Center__c limit 1];
            Test.setCurrentPage(new PageReference('apex/TemporaryUpgrade?scontrolCaching=1&id=' + opp.id));
            
            
            Test.startTest();
            
                wizard.opp.Upgrade_Downgrade__c = 'upgrade';
                wizard.opp.CloseDate = Date.today();
                wizard.opp.StageName = 'Closed Lost';
                wizard.opp.Type_of_Upgrade__c = 'Hardware (Appliance)';
                wizard.opp.Hardware_Product__c = HW.id;
                wizard.opp.DC__c = DC.id;
                wizard.opp.Upgrade_SID_Status__c = 'Create New SID';
                wizard.opp.AccountID = a.id;
                wizard.opp.Partner__c = a.id ;
                wizard.opp.End_Customer__c = a.id;
                wizard.saveSF();
                opp = wizard.opp;
            
            Test.stopTest();
            
            opp = [SELECT Name,AccountId,Partner__c, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name ,
                                        Additional_Ship_To_Contact_1__c,
                                        Additional_Ship_To_Contact_2__c,
                                        Additional_Ship_To_Contact_3__c FROM Opportunity WHERE Id =:opp.id];
            
            /* System Asserts */
            System.Assert(opp.Name.contains('Initial Opp'));
            System.Assert(opp.StageName=='Closed Won');
            System.AssertEquals(opp.Displaced_Backup_Solutions__c , 'blank' );  
            System.Assert(opp.Monthly_Serivce_Price__c == 150 );
            System.Assert(opp.QuotePaymentMode__c == 'blank');
            System.Assert(opp.Ship_To_Test1__c== '111 Fake St');
            System.Assert(opp.Ship_To_Contact__c == c.id );
            System.Assert(opp.Shipping_Service_Level__c == 'blank' );
            System.Assert(opp.End_Customer__c == a.id);
            System.Assert(opp.AccountID == a.id); 
            System.Assert(opp.CloseDate == Date.today());
            
            
        } 
        
}