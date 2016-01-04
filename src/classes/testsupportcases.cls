@isTest

public class testsupportcases {

static testMethod void caseupdateconttest()

{

// Test Null Id
Case c0 = new Case();
 
PageReference pageTest0 = Page.supportcases;
//pageTest0.getParameters().put('Id',null);
Test.setCurrentPage(pageTest0);
 
ApexPages.Standardcontroller stdcon0 = new ApexPages.Standardcontroller(c0);
caseupdatecont con = new caseupdatecont(stdcon0);
//con.updatefield();
 

 

PageReference pageTest1 = Page.supportcases;
Account a = new Account(
Name = 'Testing Account #123'
        );
        insert a;
        
Contact c = new Contact(
            AccountId = a.Id,
            FirstName = 'Testy',
            LastName = 'Testerson'
        );
        insert c;

Case testcase = new Case(
Subject='Test',
ContactID = c.Id,
Description='Test123',
BusinessHoursID = '01m80000000CprN',
firmware_version__c = '2.10',
Origin = 'Phone',
Type ='Hardware',
Status='Open'
);

insert testcase;
   
Case c1 = [Select Id, Status From Case Where ID =: testcase.Id LIMIT 1];

ApexPages.Standardcontroller stdcon1 = new ApexPages.Standardcontroller(testcase);
caseupdatecont con1 = new caseupdatecont(stdcon1);

Test.setCurrentPage(pageTest1);
con1.updatecases();
 
// Test Non-Null Id with Record Type '012R00000004lEWIAY'      
testCase.Status='Closed';
update testCase ;        
Case c2 = [Select Id, Status From Case Where ID = :testcase.Id LIMIT 1];
 
ApexPages.Standardcontroller stdcon2 = new ApexPages.Standardcontroller(testcase);
caseupdatecont con2 = new caseupdatecont(stdcon2);
 
PageReference pageTest2 = Page.supportcases;
//pageTest2.getParameters().put('Id',t2.id);
Test.setCurrentPage(pageTest2);
con2.updatecases();
 

/*PageReference pageTest3 = Page.supportcases;
Test.setCurrentPage(pageTest3);

Id CaseID = ApexPages.CurrentPage().getparameters().get('caseid');

Case c3 = [Select Id, Status From Case Where ID =: CaseID LIMIT 1];

ApexPages.Standardcontroller stdcon3 = new ApexPages.Standardcontroller(c3);
caseupdatecont con3 = new caseupdatecont(stdcon3);
con3.updatefield();
*/

}


/*


Apexpages.StandardController stdController = new Apexpages.StandardController();
caseupdatecont myPageCon = new caseupdatecont (stdController);  

PageReference pageRef = Page.supportcases;



//caseupdatecont myPageCon = new caseupdatecont();



Case pCase = myPageCon.getCase();

myPageCon.updatefield();

pCase.Status = 'Open';

myPageCon.setCase(pCase);

myPageCon.updatefield();

pCase.Status = 'Escalated';

myPageCon.setCase(pCase);

myPageCon.updatefield();



}
*/
}