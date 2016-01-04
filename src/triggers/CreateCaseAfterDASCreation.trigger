trigger CreateCaseAfterDASCreation on D_A_S__c (after insert) {
    
//Comment: you'll be creating records, as part of the process you'll put them in the 'map' created here


        List <Case> CaseToInsert = new List <Case>() ;
        List <HW_Request_Case__c> HWRequestToInsert = new List<HW_Request_Case__c>();
                
        for(D_A_S__c DAS : Trigger.new)
        
        {
            if(DAS.Status__c == 'NEW REQUEST')
            {
                
                D_A_S__c DS = [select Opportunity__r.Name , Opportunity__r.Account.Name, Contact_del__r.FirstName, Contact_del__r.LastName , Contact_del__r.Email,CreatedBy.Name,Contact_del__c from D_A_S__c where Id=:DAS.Id ] ;
                
                Case c = new Case();
                
                c.Subject ='D.A.S -'+ DS.Opportunity__r.Name + ', ' + DS.Opportunity__r.Account.Name  ;
                c.Description ='Opportunity Name: '+ DS.Opportunity__r.Name +'\n'
                +'Account: '+ DS.Opportunity__r.Account.Name +'\n'
                +'Contact Name: '+DS.Contact_del__r.FirstName +' '+DS.Contact_del__r.LastName+ '\n'
                +'Contact Email: '+ DS.Contact_del__r.Email 
                +'\n\n\n'
                +' Created By: ' + DS.CreatedBy.Name   ;
                
                c.Origin ='Web';
                c.Type = 'DAS Device Tracker';
                c.ContactID = DS.Contact_del__c;
                c.AccountID = DS.Opportunity__r.AccountID ;
                c.OwnerID = '00G800000022jgR';
                
                //CaseToInsert.add(c);
                insert c;
             

                HW_Request_Case__c HW = new HW_Request_Case__c();
                HW.HW_Request_Form__c = DAS.Id ;
                HW.Case__c = c.Id ;
                //HWRequestToInsert.add(HW);
                insert HW;
                
                
            }
            
        }
        
        try
        {
            //insert CaseToInsert;
            //insert HWRequestToInsert ;
            
        }
        
        catch (system.DmlException e)
        {
            System.debug(e);
        }
        
        }