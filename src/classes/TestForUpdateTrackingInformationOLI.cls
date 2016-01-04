@isTest(seeAllData=true)
class TestForUpdateTrackingInformationOLI{

/*static testMethod void testMethodForCodeCoverage(){

       
Account acc = [select Id, Name,HC_01__c,HC_02__c,HC_03__c, HC_04__c, HC_05__c,HC_06__c,HC_07A__c,HC_07B__c,HC_08__c,HC_09__c from Account where Name= 'Thrive Networks, a Staples Company' limit 1] ;


//get standard pricebook
Pricebook2  ResellerPb = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='Reseller Price Book' limit 1];
Pricebook2  R2012PriceBook = [select id, name, isActive from Pricebook2 where IsStandard = false and Name ='2012 Price Book' limit 1];

Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
insert prd1;

Product2 prd2 = new Product2 (Name='Test Product Entry 2',Description='Test Product Entry 2',productCode = '1C4', isActive = true, Product_Type__c='HW', HW_Type__c ='D.A.S');
insert prd2;

Product2 SW = [Select id,Name,ProductCode From Product2 Where Product_Type__c = 'SW' and isActive=TRUE and ProductCode = '10000-Fortify-10000' limit 1];

Product2 HW = [Select id,ProductCode From Product2 Where Product_Type__c = 'HW' AND isActive = true and ProductCode ='A20-R-1000' limit 1];

PriceBookEntry PBESW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: SW.Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE  LIMIT 1];

PriceBookEntry PBEHW = [select Id,PriceBook2Id, Product2Id, UnitPrice from PriceBookEntry where Product2Id =: HW.Id and PriceBook2Id=:R2012PriceBook.Id and IsActive=TRUE LIMIT 1];



List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
Account acc1 = new Account(Name = 'Account Test43', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
insert acc1;    
    
List<RecordType> recordID2 = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
Account acc2 = new Account(Name = 'Account Test4311', RecordTypeId = recordID2[0].Id );
insert acc2;    
    

Contact con = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc.Id, Email ='pl@axcient.com');  
insert con;

Contact con2 = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc.Id,Email ='pl2@axcient.com');  
insert con2;


Contact con3 = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc.Id,Email ='pl3@axcient.com');  
insert con3;


Contact con4 = new Contact(FirstName ='Ja',LastName = 'Ta',AccountId = acc1.Id,Email ='pl4@axcient.com');  
insert con4;

Opportunity opp1 = new Opportunity (Name='Opp1',StageName='Prospecting',CloseDate=Date.today(),Pricebook2Id = R2012PriceBook.Id , AccountId = acc.id,
Additional_Ship_To_Contact_1__c=con2.id,
Additional_Ship_To_Contact_2__c=con3.id,
Additional_Ship_To_Contact_3__c=con4.id,
Ship_To_Test1__c = 'End Customer'

);
insert opp1;



Opportunity opp2 = new Opportunity (Name='Opp2',StageName='Closed Won',CloseDate=Date.today(),Pricebook2Id = R2012PriceBook.Id , AccountId = acc.id, QuotePaymentMode__c='Credit Card',End_Customer__c=acc2.Id,
Ship_To_Contact__c = con.Id,
Additional_Ship_To_Contact_1__c=con2.id,
Additional_Ship_To_Contact_2__c=con3.id,
Additional_Ship_To_Contact_3__c=con4.id,
Ship_To_Test1__c = 'End Customer'
);
insert opp2;


User u1 = [select email,LastName from User where IsActive=TRUE and Department='300' LIMIT 1  ] ;

User u2 = [select email,LastName from User where IsActive=TRUE and Department='500' LIMIT 1  ] ;

User u3 = [select email,LastName from User where IsActive=TRUE and Department='100' LIMIT 1  ] ;



OpportunityTeamMember otm = New OpportunityTeamMember(
                                        TeamMemberRole = 'Sales Specialist',
                                        OpportunityId = opp1.id,
                                        UserId = u1.id
                                    );
                                        
insert otm;


OpportunityTeamMember otm2 = New OpportunityTeamMember(
                                        TeamMemberRole = 'Account Manager',
                                        OpportunityId = opp1.id,
                                        UserId = u2.id
                                    );
                                        
insert otm2;

/*
OpportunityTeamMember otm3 = New OpportunityTeamMember(
                                        TeamMemberRole = 'Account Manager',
                                        OpportunityId = opp1.id,
                                        UserId = u3.id
                                    );
                                        
insert otm3;
*/


/*   
Asset as1 = new Asset(Name = 'AA0211A0211200034',Asset_Tag__c ='2431',AccountId=acc.Id );
insert as1;


Asset as2 = new Asset(Name = 'Axcient DAS Unit', Asset_Tag__c ='1122', AccountId=acc.Id , Opportunity__c = opp2.Id, DAS_Phase__c ='1) Requested' );
insert as2;

Test.startTest();

Asset as3 = [select Name from Asset where AccountId=:acc.Id  and HW_Type_1__c ='D.A.S' LIMIT 1 ];

Asset as4 = [select Name from Asset where AccountId=:acc.Id  and HW_Type_1__c ='Appliance' LIMIT 1 ];

OpportunityLineItem oli = new OpportunityLineItem (
OpportunityId=opp1.Id,
UnitPrice = 22,
PriceBookEntryId= PBEHW.id,
Payable_to_Reseller__c = 5,
Quantity =1,
Asset__c = as3.Id,
Asset_Link_Complete__c = FALSE

);
insert oli;

as3.Outbound_Shipment_Tracking__c ='122111' ;
as3.Outbound_Asset_Ship_Date__c = Date.Today() ; 
as3.Outbound_Asset_Actual_Delivery_Date__c = Date.Today() ;
as3.Return_Shipment_Tracking__c ='1221111' ;
as3.Return_Shipment_Ship_Date__c = Date.Today() ;
as3.Will_Call__c = FALSE ;

update as3;



OpportunityLineItem oli11 = new OpportunityLineItem (
OpportunityId=opp1.Id,
UnitPrice = 22,
PriceBookEntryId= PBEHW.id,
Payable_to_Reseller__c = 5,
Quantity =1,
Asset__c = as4.Id,
Asset_Link_Complete__c = FALSE

);
insert oli11;

as4.Outbound_Shipment_Tracking__c ='122111' ;
as4.Outbound_Asset_Ship_Date__c = Date.Today() ; 
as4.Outbound_Asset_Actual_Delivery_Date__c = Date.Today() ;
as4.Return_Shipment_Tracking__c ='1221111' ;
as4.Return_Shipment_Ship_Date__c = Date.Today() ;
as4.Will_Call__c = FALSE ;
update as4;

as4.DAS_Phase__c ='4) Detached' ;
update as4;






/*
OpportunityLineItem oli2 = new OpportunityLineItem (
OpportunityId=opp1.Id,
UnitPrice = 22,
PriceBookEntryId= PBEHW.id,
Payable_to_Reseller__c = 5,
Quantity =1,

Asset_Link_Complete__c = FALSE,
Outbound_Asset_Shipment_Tracking__c ='122111',
Outbound_Asset_Ship_Date__c = Date.Today(),
Outbound_Asset_Actual_Delivery_Date__c = Date.Today(),
Return_Asset_Shipment_Tracking__c ='122111',
Return_Asset_Shipment_Ship_Date__c = Date.Today(),
Return_Asset_Ship_Actual_Delivery_Date__c = Date.Today(),
Asset__c =as3.Id
);
insert oli2;
*/

    


/*
List<String> toAddresses=new List<String>();

if(con.Email!=null)
{
toAddresses.add(con.Email);
}
if(con2.Email!=null)
{
toAddresses.add(con2.Email);
}
if(con3.Email!=null)
{
toAddresses.add(con3.Email);
}
if(con4.Email!=null)
{
toAddresses.add(con4.Email);
}

List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 

List<OpportunityTeamMember> oppMemberList= [SELECT Id,UserId FROM OpportunityTeamMember WHERE OpportunityId  =: opp2.Id ];  

for(OpportunityTeamMember oppMember : oppMemberList)
{

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(toAddresses);
mail.setTargetObjectId(oppMember.UserId);
mail.setSubject('My Subject');
mail.setUseSignature(false);
mail.saveAsActivity = false;
mail.setHtmlBody('TEST2');
mails.add(mail);
}
//Messaging.sendEmail(mails);
*/
/*
as3.DAS_Phase__c = '2) Returned' ;
update as3;
/*
for(OpportunityTeamMember oppMember : oppMemberList)
{

Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
//        String[] toAddresses2 = new String[] {'plal@axcient.com','elias@axcient.com'};
        mail2.setToAddresses(toAddresses);
        mail2.setSubject('My Subject');
        mail2.setUseSignature(false);
        mail2.setTargetObjectId(oppMember.UserId);
        mail2.setHtmlBody('TEST2');
        mail2.saveAsActivity = false;
        mails.add(mail2);

}
//Messaging.sendEmail(mails);
*/
/*
as3.DAS_Phase__c = '3) Ingesting' ;
update as3;
/*
Messaging.SingleEmailMessage mail3 = new Messaging.SingleEmailMessage();
//String[] toAddresses3 = new String[] {'plal@axcient.com','elias@axcient.com'};
mail3.setToAddresses(toAddresses);
mail3.setSubject('My Subject');
mail3.setUseSignature(false);
mail3.setHtmlBody('TEST2');
mail3.saveAsActivity = false;
//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail3 });

*/

//Test.stopTest();

//}
}