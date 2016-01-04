public class RMCTempUpgrade{
private ApexPages.standardController controller {get;set;}
public Opportunity opp { get; set; }
List<SelectOption> value= new List<SelectOption>();
List<SelectOption> option = new List<SelectOption>();        
public ID OpptyId = ApexPages.currentPage().getParameters().get('Id') ;

public final Account Partner;
public final Account EndCustomer;
public String PartnerType ;



public RMCTempUpgrade(ApexPages.StandardController stdController) {
        // constructor
        controller = stdController;
        this.opp= (Opportunity)stdController.getRecord();
        
//Opportunity CurrOpp = [SELECT AccountId,Partner__c, End_Customer__c,StageName,CloseDate  FROM Opportunity WHERE Id =:OpptyId];
                   
        
                
}
     

public PageReference saveSF()
{
Opportunity CurrOpp = [SELECT Name,AccountId,Partner__c, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
Upgrade_Downgrade__c,
Ship_To_Zip__c, 
Ship_To_Country__c ,
Ship_Appliance_To__c ,
Additional_Ship_To_Contact_1__c,
Additional_Ship_To_Contact_2__c,
Additional_Ship_To_Contact_3__c,
DC__c

FROM Opportunity WHERE Id =:opp.Id];

List<RecordType> recordID = [select Id from RecordType where name = 'Temporary Upgrade/Downgrade Non-Provisioned' and sObjecttype = 'Opportunity' limit 1];

Opportunity UpgradedOpportunity = new Opportunity(Name='TEMPORARY Upgrade:' +CurrOpp.Name,
                                                    StageName=CurrOpp.StageName,Upgraded_From__c = opp.Id,
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
                                                    CloseDate = CurrOpp.CloseDate,
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
                                                    DC__c = CurrOpp.DC__c,
                                                                                                
                                                    Upgrade_SID_Status__c = 'Update Existing SID',
                                                    Upgrade_Downgrade__c = opp.Upgrade_Downgrade__c




);

insert UpgradedOpportunity ;

Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
Pricebook2  ResellerPb = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='Reseller Price Book' limit 1];
Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];


Integer HWProd = [select count() from PriceBookEntry where Product2Id =: opp.Hardware_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE LIMIT 1];  
Integer SWProd  = [select count() from PriceBookEntry where Product2Id =: opp.Software_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];


if(HWProd==1)
{
PriceBookEntry PBEHW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Hardware_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE LIMIT 1];
OpportunityLineItem OLIHW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBEHW.Id);
insert OLIHW ;
if(UpgradedOpportunity.Upgrade_SID_Status__c=='Update Existing SID')
{
OpportunityLineItem OriginalOLIHW = [select Asset__c from OpportunityLineItem where OpportunityID =: OpptyId and Asset_Tag_Asset__c!=NULL  LIMIT 1 ];

if(OriginalOLIHW.Asset__c!=NULL)
{
OLIHW.Asset__c = OriginalOLIHW.Asset__c ;
update OLIHW ;
}
}
}

if(SWProd==1)
{
PriceBookEntry PBESW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: opp.Software_Product__c and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
OpportunityLineItem OLISW = new OpportunityLineItem(OpportunityId=UpgradedOpportunity.Id,PricebookEntryId = PBESW.Id);
insert OLISW ;
}


// looking to add the asset of the original OLI to the new OLI


controller = new ApexPages.standardController(UpgradedOpportunity);
return controller.view();

     

}




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
                                                            Partner__c = a.id ,
                                                            CloseDate = Date.today(),
                                                            Ship_To_Phone__c = '(123) 456-7890' , 
                                                            Ship_To_State__c = 'CA' , 
                                                            Ship_To_Street__c = 'blank', 
                                                            Ship_To_Zip__c = 'blank',
                                                            Ship_To_Country__c = 'blank' ,
                                                            Ship_Appliance_To__c = 'blank' );
                                                            
            insert opp;
            
            opp = [SELECT Name,AccountId, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name,
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
            RMCTempUpgrade wizard = new RMCTempUpgrade(stdController);
            
            Product2 SW = [Select id,Name,ProductCode From Product2 Where Product_Type__c = 'SW' and isActive=TRUE and ProductCode = '10000-Fortify-10000' limit 1];
            //Integer SWProd  = [select count() from PriceBookEntry where Product2Id =: SW.Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];
            
            // Data_Center__c dc = [Select id From Data_Center__c limit 1];
            // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
            Data_Center__c dc = new Data_Center__c() ;
            insert dc ;
            Test.setCurrentPage(new PageReference('apex/TemporaryUpgrade?scontrolCaching=1&id=' + opp.id));
            
            
            Test.startTest();
            
                wizard.opp.Upgrade_Downgrade__c = 'upgrade';
                wizard.opp.CloseDate = Date.today();
                wizard.opp.StageName = 'Closed Lost';
                wizard.opp.Type_of_Upgrade__c = 'Software (Entitlements)';
                wizard.opp.Software_Product__c = SW.id;
                wizard.opp.DC__c = dc.id;
                wizard.opp.Upgrade_SID_Status__c = 'Update Existing SID';
                wizard.opp.AccountID = a.id;
                wizard.opp.Partner__c = a.id ;
                wizard.opp.End_Customer__c = a.id;
                wizard.saveSF();
                opp = wizard.opp;
            
            Test.stopTest();
            
            opp = [SELECT Name,AccountId, Partner__c,StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
                                        Ship_To_Test1__c,Ship_To_Contact__c ,Shipping_Service_Level__c ,End_Customer__c, Ship_To_Phone__c, Ship_To_State__c, Ship_To_Street__c, 
                                        Upgrade_Downgrade__c,
                                        Ship_To_Zip__c, 
                                        Ship_To_Country__c ,
                                        Ship_Appliance_To__c ,
                                        Account.Name,
                                        Partner__r.Name,
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
                                                            CloseDate = Date.today(),
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
                                        Partner__r.Name,
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
            //Data_Center__c dc = [Select id From Data_Center__c limit 1];
            // MMA - 06/10/15 - Since dev doesn't have a data center. Simply create one.
            Data_Center__c dc = new Data_Center__c() ;
            insert dc ;

            Test.setCurrentPage(new PageReference('apex/TemporaryUpgrade?scontrolCaching=1&id=' + opp.id));
            
            Test.startTest();
            
                wizard.opp.Upgrade_Downgrade__c = 'upgrade';
                wizard.opp.CloseDate = Date.today();
                wizard.opp.StageName = 'Closed Lost';
                wizard.opp.Type_of_Upgrade__c = 'Hardware (Appliance)';
                wizard.opp.Hardware_Product__c = HW.id;
                wizard.opp.DC__c = dc.id;
                wizard.opp.Upgrade_SID_Status__c='Update Existing SID' ;
                wizard.opp.AccountID = a.id;
                wizard.opp.End_Customer__c = a.id;
                wizard.saveSF();
                opp = wizard.opp;
            
            Test.stopTest();
            
            opp = [SELECT Name,AccountId, StageName,CloseDate,Displaced_Backup_Solutions__c,Credit_Terms__c,Ship_To_Email__c,Monthly_Serivce_Price__c ,QuotePaymentMode__c,
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