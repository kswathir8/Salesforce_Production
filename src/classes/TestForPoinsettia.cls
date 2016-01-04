@isTest
class TestForPoinsettia{

    static testMethod void testMethodForCodeCoverage(){
    
    
        List<RecordType> recordID = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
        Account acc = new Account(Name = 'Account Test43', RecordTypeId = recordID[0].Id, Partner_Agreement_Signed__c = 'yes',Partner_Membership_Level__c='Partner');
        insert acc;    
    
        Contact con = new Contact(
        FirstName ='Ja',
        LastName = 'Ta',
        AccountId = acc.Id
              
        );  
        insert con;
    
        List<RecordType> recordIDpb = [select Id from RecordType where name = 'Pre-Sales Demo' and sObjecttype = 'Playbook__c' limit 1];

        Playbook__c Playbook = new Playbook__c(
        RecordTypeId = recordIdpb[0].Id,
        Contact__c = con.id
        
        );
        insert Playbook ;
        
        
        
        
        }
        
        }