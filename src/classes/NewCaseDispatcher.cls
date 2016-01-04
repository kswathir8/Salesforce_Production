public class NewCaseDispatcher {

    public NewCaseDispatcher(ApexPages.StandardController controller) {

    }

    Id profileId = UserInfo.getProfileId();
    
    public PageReference redirectToPage() {
    
        ID caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Case').getRecordTypeId();
        system.debug('caseRecordTypeID***'+caseRecordTypeId);
        ID dasCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DAS Case').getRecordTypeId();
        system.debug('caseRecordTypeID###'+dasCaseRecordTypeId);
        ID distiCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Disti Case').getRecordTypeId();
        system.debug('caseRecordTypeID***'+distiCaseRecordTypeId);
        ID rmaCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA Case').getRecordTypeId();
        system.debug('caseRecordTypeID###'+rmaCaseRecordTypeId);
        ID custSupCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Support Case').getRecordTypeId();
        system.debug('caseRecordTypeID###'+rmaCaseRecordTypeId);
        
        String selectedRecordType = ApexPages.currentPage().getParameters().get('RecordType');
        
        
        if(selectedRecordType == dasCaseRecordTypeId){                  
            return new PageReference('/apex/DASRequestForm?RecordType='+dasCaseRecordTypeId);
        }
        else if(selectedRecordType == rmaCaseRecordTypeId){
           // if( profileId  != '00e80000001OMYU' && profileId != '00e80000001OMYV' && profileId  != '00e80000001OMYW')
           if(userInfo.getuserType() == 'CspLitePortal')
                return Page.RMAStep2.setRedirect(true);
            else{
                PageReference p = new PageReference('/500/e?retURL=%2F500%2Fo&RecordType='+rmaCaseRecordTypeId+'&ent=Case');
                p.getParameters().put('nooverride','1');
                return p;
            }
        }
        else if(selectedRecordType == distiCaseRecordTypeId){
            PageReference p = new PageReference('/500/e?retURL=%2F500%2Fo&RecordType='+distiCaseRecordTypeId+'&ent=Case');
            p.getParameters().put('nooverride','1');
            return p;
        }
        //Added by : Anusha Surpaneni
        else if(userInfo.getuserType() == 'CspLitePortal'){
            PageReference p = new PageReference('/Support/500/e?retURL=%2FSupport%2F500%2Fo');
           // PageReference p = new PageReference('/support/500/e?retURL=%2Fsupport%2F500%2Fo');
            p.getParameters().put('nooverride','1');
            return p;
        }
        else{
            PageReference p = new PageReference('/500/e?retURL=%2F500%2Fo&RecordType='+CaseRecordTypeId+'&ent=Case');
            p.getParameters().put('nooverride','1');
            return p;
        }
    }  
}