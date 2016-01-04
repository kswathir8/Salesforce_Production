public class RMAWizard {
public String shippingMethod {get;set;}
    public PageReference Cancel() {
        return null;
    }


    public RMAWizard() {

    }

        private ApexPages.standardController controller {get;set;}
        public Questionnaire_Wizard__c QW { get; set; }     
        Case RMACase;
        
        public RMAWizard(ApexPages.StandardController stdController) { // constructor
                controller = stdController;
                this.QW = (Questionnaire_Wizard__c)stdController.getRecord();
        }
         
        public Service_Id__c SID {
        get{
            if (SID == null) SID = new Service_Id__c();
            return SID; 
        }
        set;
    }
    
    public PageReference step2() {return Page.RMAStep1;}
    public PageReference step3() {return Page.RMAStep1_1;}
    public PageReference step1() {return Page.RMAStep2;}
    public PageReference step1_1() {
            try{
                Asset as1 = [Select Name,Id,Service_ID__c from Asset where Service_ID__c =:QW.Service_Id__c limit 1];
                QW.RMAAsset__c = as1.Id ;
            }
                catch (System.Exception e) {
                ApexPages.addMessages(e);
                return null;
                }       
                return Page.RMAStep3;
    }
        public PageReference step4() {return Page.RMAStep4;}
        public PageReference step6() {return Page.RMAStep6;}
        public PageReference step7() {return Page.RMAStep7;} 

    public PageReference step5() {
    //insert QW;
            try {
                    if(QW.Ship_To__c == 'Partner'){
                            System.debug('***********************' + QW.Contact__r.AccountID) ;
                            Contact con1 = [select Id,Account.ShippingStreet, Account.ShippingState, Account.ShippingPostalCode, Account.ShippingCity,Account.ShippingCountry from Contact where Id = :QW.Contact__c];
                            QW.ShippingStreet__c = con1.Account.ShippingStreet;
                            QW.ShippingCity__c = con1.Account.ShippingCity ;
                            QW.ShippingState__c = con1.Account.ShippingState ;
                            QW.ShippingPostalCode__c = con1.Account.ShippingPostalCode ; 
                            QW.ShippingCountry__c = con1.Account.ShippingCountry ;
                    }
                    
                    if(QW.Ship_To__c == 'End Customer')
                    {       
                        Asset as1 = [Select Name,Id,Service_ID__c from Asset where Service_ID__c =:QW.Service_Id__c limit 1];
                        OpportunityLineItem OLI = [select OpportunityID from OpportunityLineItem where Asset__c=:as1.Id LIMIT 1 ];
                        Opportunity opp = [select End_Customer__c from Opportunity where Id =: OLI.OpportunityId];
                        Account EndCus = [select ShippingStreet, ShippingState, ShippingPostalCode, ShippingCity,ShippingCountry from Account where Id = :opp.End_Customer__c ];
                    
                            QW.Account__c = EndCus.Id ;
                            QW.ShippingStreet__c = EndCus.ShippingStreet;
                            QW.ShippingCity__c = EndCus.ShippingCity ;
                            QW.ShippingState__c = EndCus.ShippingState ;
                            QW.ShippingPostalCode__c = EndCus.ShippingPostalCode ;
                            QW.ShippingCountry__c = EndCus.ShippingCountry ;
                    }
                    
                    if(QW.Ship_To__c == 'Other'){
                            QW.ShippingStreet__c = '';
                            QW.ShippingCity__c = '' ;
                            QW.ShippingState__c = '' ;
                            QW.ShippingPostalCode__c = '' ;
                            QW.ShippingCountry__c = '' ;
                    }
            }
            catch (System.Exception e) {
                        ApexPages.addMessages(e);
                        return null;
            }
        return Page.RMAStep5;
    }

     public PageReference save(){
            Case RMACase= new Case();
            List<RecordType> recordID = [select Id from RecordType where name = 'RMA Case' and sObjecttype = 'Case' limit 1];
            List<RecordType> recordID1 = [select Id from RecordType where name = 'RMA Case Fresh Start Not Provisioned' and sObjecttype = 'Case' limit 1];
            List<RecordType> recordID2= [select Id from RecordType where name = 'RMA Case Migration Not Provisioned' and sObjecttype = 'Case' limit 1];
            
            if(QW.RMA_Type__c=='Appliance Migration (No RMC Entry)'){
                RMACase.RecordTypeId = recordID2[0].Id ;
            }
            if(QW.RMA_Type__c=='Fresh Start (Enter in RMC)'){
                RMACase.RecordTypeId = recordID1[0].Id ;
            }
     
                RMACase.ContactId = QW.Contact__c ;
                RMACase.ParentId = QW.Related_Case__c ;
                RMACase.End_Customer__c = QW.Account__c ;
                     
                RMACase.RMA_Feedback__c = 'Can Appliance Boot:'+QW.Can_Appliance_Boot__c +'\n'+ 
                'Lights:'+ QW.Lights_On_Device__c +'\n'+ 
                'Drive or RAID:'+QW.Drive_Or_Raid__c+'\n'+ 
                'Loud Noise:'+QW.Loud_Noise__c +'\n'+ 
                'Was it Fan:'+ QW.Fan__c +'\n'+ 
                'Beeps:' + QW.Beeps__c +'\n' +
                'Other Notes:'+ QW.Notes__c ;
              
            String Return1 ='Return Shipping Label' ;

            Asset AssetToupdate = [Select Id,Status,Name from Asset where Id =: QW.RMAAsset__c];
            AssetToupdate.Status = 'Pending Return';
            update AssetToUpdate ;
              
                RMACase.Service_ID__c = QW.Service_ID__c ;
                RMACase.RMAed_Asset__c = QW.RMAAsset__c ;
                
                if(QW.Return_Shipping_Label__c=='Yes'){
                RMACase.Subject= 'RMA Request'+' '+Return1 ;
                } 
        else{
                RMACase.Subject= 'RMA Request'+' '+QW.RMA_Type__c ;
        }
                RMACase.Priority = QW.Priority__c;
                RMACase.Attention__c = QW.ATTN__c;
                RMACase.Ship_to_Company__c = QW.Ship_to_Company__c;
                RMACase.Ship_To__c = QW.Ship_To__c ;
                RMACase.Ship_To_City__c = QW.ShippingCity__c ;
                RMACase.Ship_To_Street__c = QW.ShippingStreet__c ;
                RMACase.Ship_To_State__c = QW.ShippingState__c ;
                RMACase.Ship_To_Zip__c = QW.ShippingPostalCode__c ;
                RMACase.Type = 'Hardware' ;
                RMACase.Escalated_for_RMA__c = TRUE ;
                RMACase.Priority = 'Normal' ;
                RMACase.Reason = QW.Reason__c ;
                RMACase.firmware_version__c = QW.Firmware_Version__c;
                RMACase.Model__c = QW.Model__c ;
                RMACase.Additional_Email_Recipient_1__c = QW.Additional_Email_1__c ;
                RMACase.Additional_Email_Recipient_2__c = QW.Additional_Email_2__c ;
                RMACase.Additional_Email_Recipient_3__c = QW.Additional_Email_3__c ;
                RMACase.End_Customer__c = QW.Account__c ;
                RMACase.Data_Retention__c = QW.RMA_Type__c ;
                RMACase.Origin = 'RMA Wizard' ;
                RMACase.Description = RMACase.RMA_Feedback__c ;
                RMACase.OwnerId = '00G800000023L19' ;
                RMACase.Type_of_Return__c = QW.Type_of_return__c; 
                RMACase.Delay_60_Days__c = QW.Delay_60_Days__c;
 
                try {
            insert RMACase;   
            System.debug('case=' + RMACase);  
        } 
        catch (System.DmlException e) {
                ApexPages.addMessages(e);
            return null;
        }
                
        controller = new ApexPages.standardController(RMACase);
        return controller.view();          
     }                      
}