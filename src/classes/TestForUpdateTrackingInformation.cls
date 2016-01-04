@isTest(seeAllData=true)
class TestForUpdateTrackingInformation{

    static testMethod void testMethodForCodeCoverage(){
    
        //Test.starttest();
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test43', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
        insert acc;    
    
        Contact con = new Contact(
        FirstName ='Ja',
        LastName = 'Ta',
        AccountId = acc.Id
              
        );  
        insert con;
        
        Account acc1 = [select Id, Name from Account where Name='Marco, Inc.'limit 1] ;
        
        Account acc2  = [select Id,Name from Account where Name='Marco, Inc.' limit 1];
        
        Asset as3 = [select Name,AccountID from Asset where AccountId=:acc1.Id  and HW_Type_1__c ='D.A.S' LIMIT 1 ];

        Asset as4 = [select Name,AccountID from Asset where AccountId=:acc1.Id  and HW_Type_1__c ='Appliance' LIMIT 1 ];
        
        Asset as5 = [select Name,AccountID from Asset where AccountId=:acc2.Id  and HW_Type_1__c ='Appliance' LIMIT 1 ];
        
        Contact con1 = [select Id,Name from Contact where AccountID=:acc1.Id LIMIT 1];
        
        Contact con2 = [select Id,Name from Contact where AccountID=:acc2.Id LIMIT 1 ];
        
        
       Asset_Tracking__c att1 = new Asset_Tracking__c(
       Asset__c= as3.Id ,
       Account__c=acc1.Id
       ); 
       insert att1 ;
       
       Asset_Tracking__c att2 = new Asset_Tracking__c(
       Asset__c= as5.Id ,
       Account__c=acc2.Id
       ); 
       insert att2 ;
       
       as3.DAS_Phase__c ='1) Requested';
       update as3 ;
        
       as3.DAS_Phase__c = '2) Returned';
       update as3;
       
         
      
        
       as3.DAS_Phase__c ='3) Ingesting';
       update as3 ;
       
      
       
        
        as3.DAS_Phase__c = '4) Detached';
        update as3;
        
        as3.DAS_Phase__c = '5) Quarantine';
        update as3;
        
        as3.DAS_Phase__c = '1) Requested';
        update as3;
        
        as3.AccountID = acc2.Id ;
        update as3 ;
        
        
        //Test.stoptest();
       
       
        
         
        
    
       
        
   
       
       
       
     
             
       //System.assertEquals(at1.DAS_Phase_1_Completion_Date__c,Datetime.now());
       ////System.assertEquals(at1.DAS_Phase_2_Completion_Date__c,Datetime.now());
      // System.assertEquals(at1.DAS_Phase_3_Completion_Date__c,Datetime.now());
       //System.assertEquals(at1.DAS_Phase_4_Completion_Date__c,Datetime.now());

        
      //from here
       //System.assertEquals(as4.DAS_Phase_1_Completion_Date__c,at4.DAS_Phase_1_Completion_Date__c);
      // System.assertEquals(as3.DAS_Phase_2_Completion_Date__c,Datetime.now());
     //  System.assertEquals(at2.DAS_Phase_2_Completion_Date__c,Datetime.now());
     //  System.assertEquals(as3.DAS_Phase_2_Completion_Date__c,at2.DAS_Phase_2_Completion_Date__c);
       
       //System.assertEquals(as4.Asset_Tracking_Counter__c,1);
        
      
       

     //   System.assertEquals(at3.DAS_Phase_1_Completion_Date__c,at1.DAS_Phase_1_Completion_Date__c);
        

     //   System.assertEquals(at3.DAS_Phase_2_Completion_Date__c,at2.DAS_Phase_2_Completion_Date__c);

        
        //System.assertEquals(as4.DAS_Phase_3_Completion_Date__c,Datetime.now());
        //System.assertEquals(at3.DAS_Phase_3_Completion_Date__c,Datetime.now());
       // System.assertEquals(as4.DAS_Phase_3_Completion_Date__c,at3.DAS_Phase_3_Completion_Date__c);
        
        
       
       //System.assertEquals(at4.DAS_Phase_1_Completion_Date__c,at1.DAS_Phase_1_Completion_Date__c);
        
        
       // System.assertEquals(at4.DAS_Phase_2_Completion_Date__c,at2.DAS_Phase_2_Completion_Date__c);
       
        
        
       // System.assertEquals(at4.DAS_Phase_3_Completion_Date__c,at3.DAS_Phase_3_Completion_Date__c);
        
        
       // System.assertEquals(as5.DAS_Phase_4_Completion_Date__c,Datetime.now());
       // System.assertEquals(at4.DAS_Phase_4_Completion_Date__c,Datetime.now());
       //System.assertEquals(as5.DAS_Phase_4_Completion_Date__c,at4.DAS_Phase_4_Completion_Date__c);
        
        
       
       
       //System.assertEquals(at5.DAS_Phase_1_Completion_Date__c,at1.DAS_Phase_1_Completion_Date__c);
       // System.assertEquals(at5.DAS_Phase_2_Completion_Date__c,at2.DAS_Phase_2_Completion_Date__c);
       // System.assertEquals(at5.DAS_Phase_3_Completion_Date__c,at3.DAS_Phase_3_Completion_Date__c);
        // System.assertEquals(at5.DAS_Phase_4_Completion_Date__c,at4.DAS_Phase_3_Completion_Date__c);
      
     //    System.assertEquals(as6.DAS_Phase_5_Completion_Date__c,Datetime.now());
      //  System.assertEquals(at5.DAS_Phase_5_Completion_Date__c,Datetime.now());
       // System.assertEquals(as6.DAS_Phase_5_Completion_Date__c,at5.DAS_Phase_5_Completion_Date__c);
        
        
       
       
        
       // System.assertEquals(at6.DAS_Phase_1_Completion_Date__c,Datetime.now());
       // System.assertEquals(at6.DAS_Phase_2_Completion_Date__c,Datetime.now());
       // System.assertEquals(at6.DAS_Phase_3_Completion_Date__c,Datetime.now());
        
     
        
       // System.assertEquals(at7.DAS_Phase_1_Completion_Date__c,Datetime.now());
       // System.assertEquals(at7.DAS_Phase_2_Completion_Date__c,Datetime.now());
       
      
       
        //System.assertEquals(at8.DAS_Phase_1_Completion_Date__c,Datetime.now());
        //System.assertEquals(at8.DAS_Phase_2_Completion_Date__c,Datetime.now());
        //System.assertEquals(at8.DAS_Phase_3_Completion_Date__c,Datetime.now());
        //System.assertEquals(at8.DAS_Phase_4_Completion_Date__c,Datetime.now());

      
        
        
       
        //System.assertEquals(at9.DAS_Phase_1_Completion_Date__c,Datetime.now());
        //System.assertEquals(at9.DAS_Phase_2_Completion_Date__c,Datetime.now());
        //System.assertEquals(at9.DAS_Phase_3_Completion_Date__c,Datetime.now());
        //System.assertEquals(at9.DAS_Phase_4_Completion_Date__c,Datetime.now());
        //System.assertEquals(at9.DAS_Phase_5_Completion_Date__c,Datetime.now());

      
        
        
        
        
}

        
}