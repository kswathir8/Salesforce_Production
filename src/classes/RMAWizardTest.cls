@IsTest
public class RMAWizardTest {
    
    public static testMethod void testMyController() {
        // Testing the New Job Application Wizard
        ApexPages.standardController controller = new ApexPages.standardController(new  Questionnaire_Wizard__c());
        RMAWizard extension = new RMAWizard(controller);
        Questionnaire_Wizard__c Qwiz = extension.QW;
        
        
        
        // Verify that page fails without specifying a Position
//        System.assertEquals(extension.checkPosition().getURL(),Page.RMAStep2.getURL());
          
        // Instantiate a new controller extension with all parameters in the page
        extension = new RMAWizard(controller);
        // re-instantiate the jobApp to pick up the posId now
        QWiz = extension.QW ;
    
    List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test43', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
        insert acc;    
        
       List<RecordType> recordID1 = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
       Account acc1 = new Account(Name = 'Account Test43', RecordTypeId = recordID1[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
       insert acc1;    
    
    
        Contact con = new Contact(
        FirstName ='Ja',
        LastName = 'Ta',
        AccountId = acc.Id
              
        );  
        insert con;
        
        Contact con1 = new Contact(
        FirstName ='Ja1',
        LastName = 'Ta1',
        AccountId = acc1.Id
        );  
        insert con1;
        
    
        Asset as1 = new Asset(
        Name = 'AA0211A0211200034',
        Asset_Tag__c ='2431',
        ContactId=con.Id    
        );
        insert as1;

    
    
     Service_ID__c SID = new Service_ID__c (
        Name = 'abef',
        Axcient_SN__c = as1.Id,
        Status__c = 'Active'
        
        );
        insert SID ;
        
       
       String pageOne = extension.step1().getUrl();
       System.assertEquals(Page.RMAStep2.getURL(),pageOne);
    
       extension.SID =  SID ;
       
       
     // extension.Account__c = con1.Id;     
       /*Case c = new Case(
       Contact= con.Id ,
       End
       
       
       );
*/       
       
       
       
       try
       {
       String pageTwo = extension.step1_1().getUrl();
       }
       catch(Exception ex)
       {
       System.debug(ex);
       }
       
       
      
      // System.assertEquals(Page.RMAStep3.getURL(),pageTwo);
        
                
       
        
                
        String pageThree = extension.step2().getUrl();
        System.assertEquals(Page.RMAStep1.getURL(), pageThree);
        
        //Service_Id__c sid = [Select Axcient_SN__c from Service_Id__c where Id =:QW.Service_Id__c limit 1];
        
        
        
        
        String pageFour = extension.step3().getUrl();
        System.assertEquals(Page.RMAStep1_1.getURL(), pageFour);
        
        String pageFive = extension.step4().getUrl();
        System.assertEquals(Page.RMAStep4.getURL(), pageFive);
        
        String pageSix = extension.step5().getUrl();
        System.assertEquals(Page.RMAStep5.getURL(), pageSix);
        
        String pageSeven = extension.step6().getUrl();
        System.assertEquals(Page.RMAStep6.getURL(), pageSeven);
        
        String pageEight = extension.step7().getUrl();
        System.assertEquals(Page.RMAStep7.getURL(), pageEight);
        
        
               
        // now let's simulate the user filling out the new candidate form and move to page 3
     /*
        cand = new Candidate__c(first_name__c = 'Mike',
                                last_name__c = 'Reuben',
                                email__c = 'mike@reuben.com');
        extension.candidate = cand;
        pageThree = extension.step3().getUrl();
        System.assertEquals(Page.jobappstep3.getURL(), pageThree);
        
        // now let's run the save() and verify the new candidate and job_application creation
        System.debug('candidate=' + extension.candidate);
        jobApp = extension.jobApplication;
        // run the save()
        String saveUrl = extension.save().getUrl();
        // get the latest candidate and verify it
        cand = extension.candidate;
        System.assertNotEquals(cand.id,null);
        // get the latest jobApp and verify it
        jobApp = extension.jobApplication;
        System.assertEquals(jobApp.Candidate__c,cand.id);
        System.assertNotEquals(jobApp.id,null);
        // verify the Url after the save() method occurred
        System.assertEquals(saveUrl,extension.controller.view().getURL());
        */
    }
}