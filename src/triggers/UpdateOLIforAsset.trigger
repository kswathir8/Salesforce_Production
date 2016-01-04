trigger UpdateOLIforAsset on Asset (after update) {
//Email notifications and field updates on OLI needs to happen after information is inserted in to the asset.

    List<Asset> AssetsToUpdate = new List<Asset>{};
    List<OpportunityLineItem > OLIToUpdate = new List<OpportunityLineItem>{};
    try {
        for(Integer i=0 ; i<Trigger.new.size(); i++) {
            if(Trigger.new[i].Outbound_Shipment_Tracking__c!= NULL && (Trigger.new[i].Outbound_Shipment_Tracking__c!= Trigger.old[i].Outbound_Shipment_Tracking__c  || 
                                                                        Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c || 
                                                                        Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c != Trigger.old[i].Outbound_Asset_Actual_Delivery_Date__c ) )
                    {
                    System.debug('@@@SFDC: Inside 1');
                    List<OpportunityLineItem > OLIList = [select Id,
                                                                Is_Updated__c,
                                                                DAS_Phase__c,
                                                                Asset_Link_Complete__c,
                                                                OpportunityID,
                                                                Outbound_Asset_Shipment_Tracking__c,
                                                                Outbound_Asset_Ship_Date__c,
                                                                Outbound_Asset_Actual_Delivery_Date__c,
                                                                Outbound_Shipment_Tracking_URL__c,
                                                                Return_Asset_Shipment_Tracking__c,
                                                                Return_Asset_Shipment_Ship_Date__c,
                                                                Return_Asset_Ship_Actual_Delivery_Date__c,
                                                                Return_Shipment_Tracking_URL__c,
                                                                Ship_To_Name__c,                                                             
                                                                Asset__r.Name,Asset_Tag_Asset__c,
                                                                Opportunity.Ship_To_Email__c,
                                                                Opportunity.Name,
                                                                Part_Number__c,
                                                                PricebookEntry.Product2.ProductCode,
                                                                PricebookEntry.product2.Family,
                                                                PricebookEntry.Product2.HW_Type__c,
                                                                Opportunity.Additional_Ship_To_Email_Notification_01__c,
                                                                Opportunity.Additional_Ship_To_Email_Notification_02__c,
                                                                Opportunity.Additional_Ship_To_Email_Notification_03__c,
                                                                Opportunity.Additional_Ship_To_Email_Text__c,
                                                                Opportunity.Owner.Name from OpportunityLineItem where opportunityid =:Trigger.new[i].opportunity__c and Asset_Link_Complete__c = FALSE ];
                //Asset__c =:Trigger.new[i].Id
                    if(OLIList.size() > 0)
                        {
                            System.debug('@@@SFDC: Inside 2 OLI not 0');
                            for(OpportunityLineItem OLI : OLIList)
                                {
                                    String Shipname ; 
                                    //OLI.Outbound_Asset_Shipment_Tracking__c = Trigger.new[i].Outbound_Shipment_Tracking__c ;
                                    //OLI.Outbound_Asset_Ship_Date__c = Trigger.new[i].Outbound_Asset_Ship_Date__c ;
                                    OLI.Outbound_Asset_Actual_Delivery_Date__c = Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c ;
                                    OLI.Outbound_Shipment_Tracking_URL__c = Trigger.new[i].Outbound_Shipment_Tracking_URL__c ;
                                    
                                    OLI.Return_Asset_Ship_Actual_Delivery_Date__c = Trigger.new[i].Return_Shipment_Actual_Delivery_Date__c ;
                                    OLI.Return_Asset_Shipment_Ship_Date__c = Trigger.new[i].Return_Shipment_Ship_Date__c ;
                                    OLI.Return_Asset_Shipment_Tracking__c = Trigger.new[i].Return_Shipment_Tracking__c ;
                                    OLI.Return_Shipment_Tracking_URL__c = Trigger.new[i].Return_Shipment_Tracking_URL__c ;
                                    
                                    
                                    Shipname = OLI.Ship_To_Name__c ;
                                    
                                    List<String> toAddresses=new List<String>();
                                    if(OLI.Opportunity.Ship_To_Email__c!=null)
                                        toAddresses.add(OLI.Opportunity.Ship_To_Email__c);
                                    if(OLI.Opportunity.Additional_Ship_To_Email_Notification_01__c!=null)
                                        toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_01__c);
                                    if(OLI.Opportunity.Additional_Ship_To_Email_Notification_02__c!=null)
                                        toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_02__c);
                                    if(OLI.Opportunity.Additional_Ship_To_Email_Notification_03__c!=null)
                                        toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_03__c);
                                    if(OLI.Opportunity.Additional_Ship_To_Email_Text__c!=null)
                                        toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Text__c);
                                    
                                    
                                    if(oli.Outbound_Asset_Shipment_Tracking__c != null && Trigger.new[i].HW_Type_1__c =='Appliance' && oli.PricebookEntry.Product2.HW_Type__c == 'Appliance'&& (oli.PricebookEntry.Product2.Family == 'Hardware' || oli.PricebookEntry.Product2.Family == 'A20 Appliances' || oli.PricebookEntry.Product2.Family == 'Rental') && oli.Outbound_Asset_Actual_Delivery_Date__c == null) {
                                        System.debug('@@@SFDC: Inside 3 Appliance');
                                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
                                        List<Opportunity> oppMemberList= [SELECT Id,OwnerId FROM Opportunity  WHERE Id  =: OLI.OpportunityID ];  //changing from opportunity team to opportunity owner
                                        
                                        for(Opportunity oppMember : oppMemberList) {
                                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                            mail.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mail.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mail.setTargetObjectId(oppMember.OwnerId);
                                            mail.setSubject('Appliance Shipped for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c );
                                            mail.saveAsActivity = false;
                                            mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode +'.</b><br><br> Your order for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+Trigger.new[i].Asset_Tag__c +'</b><br><br>Thank you,<br><br>'+'Axcient Support Team');
                                            mail.setReplyTo('support@axcient.com');
                                            mail.setSenderDisplayName('Axcient Support');
                                            mail.setUseSignature(false);
                                            mails.add(mail);
                                        }
                                            
                                        if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                                Messaging.sendEmail(mails);
                                                System.debug('@@@SFDC: Inside 4 Mails being sent ');
                                        }
                                           
                                        Messaging.SingleEmailMessage mailtoPartner = new Messaging.SingleEmailMessage();
                                        //mailtoPartner.setToAddresses(toAddresses);
                                        mailtoPartner.setSubject('Appliance Shipped for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c );
                                        mailtoPartner.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode +'.</b><br><br> Your order for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+Trigger.new[i].Asset_Tag__c +'</b><br><br>Thank you,<br>'+'Axcient Support Team');
                                        mailtoPartner.setToAddresses(toAddresses);
                                        mailtoPartner.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                        mailtoPartner.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                        mailtoPartner.setReplyTo('support@axcient.com');
                                        mailtoPartner.setSenderDisplayName('Axcient Support');
                                        mailtoPartner.setUseSignature(false);
                                            
                                        if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailtoPartner });
                                            System.debug('@@@SFDC: Inside 5 Mails being sent to partner');
                                        }
                                            
            
                                        OLI.Asset_Link_Complete__c = true;
                                    }
                                            
                                    if(oli.Outbound_Asset_Shipment_Tracking__c != null && Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c && Trigger.new[i].DAS_Phase__c == '1) Requested' && oli.PricebookEntry.Product2.HW_Type__c == 'D.A.S' && (oli.PricebookEntry.Product2.Family == 'Hardware' || oli.PricebookEntry.Product2.Family == 'A20 Appliances' || oli.PricebookEntry.Product2.Family == 'Rental')&& oli.Outbound_Asset_Actual_Delivery_Date__c == null) {
                                        
                                        System.debug('@@@SFDC: Inside 6 Das phase 1');
                                        
                                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
                                        List<Opportunity> oppMemberList= [SELECT Id,OwnerId FROM Opportunity  WHERE Id  =: OLI.OpportunityID ];  //changing from opportunity team to opportunity owner
                                            
                                        for(Opportunity oppMember : oppMemberList){
                                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                            mail.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mail.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mail.setTargetObjectId(oppMember.OwnerId);
                                            mail.setSubject('DAS Shipped for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c );
                                            mail.saveAsActivity = false;
                                            mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode +'.</b><br><br> Your order for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+Trigger.new[i].Asset_Tag__c +'</b><br><br>Thank you,<br><br>'+'Axcient Support Team');
                                            mail.setReplyTo('support@axcient.com');
                                            mail.setSenderDisplayName('Axcient Support');
                                            mail.setUseSignature(false);
                                            mails.add(mail);
                                        }
                                            
                                        if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                            Messaging.sendEmail(mails);
                                             System.debug('@@@SFDC: Inside 7 Mails sent from Das phase 1');
                                        }
            
                                        Messaging.SingleEmailMessage mailtoPartner = new Messaging.SingleEmailMessage();
                                            
                                        mailtoPartner.setSubject('DAS Shipped for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c );
                                        mailtoPartner.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode +'.</b><br><br> Your order for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+Trigger.new[i].Asset_Tag__c  +'</b><br><br>Thank you,<br><br>'+'Axcient Support Team');
                                        mailtoPartner.setToAddresses(toAddresses);
                                        //mailtoPartner.setToAddresses(ToAddresses);
                                        mailtoPartner.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                        mailtoPartner.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                        mailtoPartner.setReplyTo('support@axcient.com');
                                        mailtoPartner.setSenderDisplayName('Axcient Support');
                                        mailtoPartner.setUseSignature(false);
                                        
                                        if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailtoPartner });
                                            System.debug('@@@SFDC: Inside 8 Partner Mails sent from Das phase 1');
                                        }
                                            
                                    }
                                            
                                    if(oli.Outbound_Asset_Shipment_Tracking__c != null && Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c && Trigger.new[i].DAS_Phase__c == '2) Returned' && oli.PricebookEntry.Product2.HW_Type__c == 'D.A.S'&& (oli.PricebookEntry.Product2.Family == 'Hardware' || oli.PricebookEntry.Product2.Family == 'A20 Appliances' || oli.PricebookEntry.Product2.Family == 'Rental')&& oli.Outbound_Asset_Actual_Delivery_Date__c == null ) {
                                        
                                        System.debug('@@@SFDC: Inside 9 Das phase 2');
                                        
                                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
                                        List<Opportunity> oppMemberList= [SELECT Id,OwnerId FROM Opportunity  WHERE Id  =: OLI.OpportunityID ];  //changing from opportunity team to opportunity owner
                                                
                                        for(Opportunity oppMember : oppMemberList) {
                                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                            mail.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mail.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mail.setTargetObjectId(oppMember.OwnerId);
                                            mail.setSubject('DAS Received for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c);
                                            mail.saveAsActivity = false;
                                            mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>The DAS you requested for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> and shipped back to us has made it. You will be notified once the data has been delivered to the data center and your initial offsite sync has been started. <br><br>Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+OLI.Asset_Tag_Asset__c +'</b><br><br>The tracking # for your DAS was <b>'+OLI.Return_Asset_Shipment_Tracking__c+'</b><br><br>If any questions come up, please don’t hesitate to contact support@axcient.com.<br><br>Thank you,<br>'+'Axcient Support Team');
                                            mail.setReplyTo('support@axcient.com');
                                            mail.setSenderDisplayName('Axcient Support');
                                            mail.setUseSignature(false);
                                            mails.add(mail);
                                        }
                                        system.debug('will call-------'+Trigger.new[i].Will_Call__c);
                                        system.debug('Asset link -------'+OLI.Asset_Link_Complete__c);
                                        system.debug('Asset link -------'+OLI.id);
                                        if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                             
                                            System.debug('@@@SFDC: Inside 10 Das phase 2 - Mails sent ');
                                            system.debug('TO ADDRESS***'+toAddresses);
                                            Messaging.sendEmail(mails);
                                        }
                                             
                                            Messaging.SingleEmailMessage mailtoPartner = new Messaging.SingleEmailMessage();
                                            mailtoPartner.setToAddresses(ToAddresses);
                                            mailtoPartner.setSubject('DAS Received for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c);
                                            mailtoPartner.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>The DAS you requested for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> and shipped back to us has made it. You will be notified once the data has been delivered to the data center and your initial offsite sync has been started. <br><br>Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+OLI.Asset_Tag_Asset__c +'</b><br><br>The tracking # for your DAS was <b>'+OLI.Return_Asset_Shipment_Tracking__c+'</b><br><br>If any questions come up, please don’t hesitate to contact support@axcient.com.<br><br>Thank you,<br>'+'Axcient Support Team');
                                            //mailtoPartner.setToAddresses(toAddresses);
                                            mailtoPartner.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mailtoPartner.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mailtoPartner.setReplyTo('support@axcient.com');
                                            mailtoPartner.setSenderDisplayName('Axcient Support');
                                            mailtoPartner.setUseSignature(false);
                                            
                                            if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailtoPartner });
                                                System.debug('@@@SFDC: Inside 11 Das phase 2 - Partner Mails sent ');
                                            }
                                            
                                    }
                                            
                                    if(oli.Outbound_Asset_Shipment_Tracking__c != null && Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c && Trigger.new[i].DAS_Phase__c == '3) Ingesting' && oli.PricebookEntry.Product2.HW_Type__c == 'D.A.S' && (oli.PricebookEntry.Product2.Family == 'Hardware' || oli.PricebookEntry.Product2.Family == 'A20 Appliances' || oli.PricebookEntry.Product2.Family == 'Rental')&& oli.Outbound_Asset_Actual_Delivery_Date__c == null){
                                        
                                        System.debug('@@@SFDC: Inside 12 Das phase 3');
                                        
                                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
                                        List<Opportunity> oppMemberList= [SELECT Id,OwnerId FROM Opportunity  WHERE Id  =: OLI.OpportunityID ];  //changing from opportunity team to opportunity owner
                                        
                                        for(Opportunity oppMember : oppMemberList) {
                                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                            mail.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mail.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mail.setTargetObjectId(oppMember.OwnerId);
                                            mail.setSubject('DAS Delivered to Data Center for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c);
                                            
                                            mail.saveAsActivity = false;
                                            mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>The DAS you requested for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has been delivered to the data center and your initial offsite sync has started. Your data is now PROTECTED with Axcient.<br><br>Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+OLI.Asset_Tag_Asset__c +'</b><br><br>If any questions come up, please don’t hesitate to contact support@axcient.com.<br><br>Thank you,<br>'+'Axcient Support Team');
                                            mail.setReplyTo('support@axcient.com');
                                            mail.setSenderDisplayName('Axcient Support');
                                            mail.setUseSignature(false);
                                            
                                            mails.add(mail);
                                        }
                                            
                                            if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                                Messaging.sendEmail(mails);
                                                System.debug('@@@SFDC: Inside 13 Das phase 3 - Mails sent ');
                                            }
                                            
                                            Messaging.SingleEmailMessage mailtoPartner = new Messaging.SingleEmailMessage();
                                            //mailtoPartner.setToAddresses(ToAddresses);
                                            mailtoPartner.setSubject('DAS Delivered to Data Center for '+OLI.Opportunity.Name+ ' ; '+Trigger.new[i].End_Customer_Name__c);
                                            mailtoPartner.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>The DAS you requested for account <b>'+Trigger.new[i].End_Customer_Name__c+ '</b> has been delivered to the data center and your initial offsite sync has started. Your data is now PROTECTED with Axcient.<br><br>Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+OLI.Asset_Tag_Asset__c +'</b><br><br>If any questions come up, please don’t hesitate to contact support@axcient.com.<br><br>Thank you,<br>'+'Axcient Support Team');
                                          
                                            mailtoPartner.setToAddresses(toAddresses);
                                            mailtoPartner.setBCcAddresses(new String[] {'salesops@axcient.com'});
                                            mailtoPartner.setBCcAddresses(new String[] {'imckee@axcient.com'});
                                            mailtoPartner.setReplyTo('support@axcient.com');
                                            mailtoPartner.setSenderDisplayName('Axceint Support');
                                            mailtoPartner.setUseSignature(false);
                                            
                                            if(Trigger.new[i].Will_Call__c == FALSE && OLI.Asset_Link_Complete__c == FALSE && !test.isrunningtest()){
                                                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailtoPartner });
                                                System.debug('@@@SFDC: Inside 14 Das phase 3 - Partner Mails sent ');
                                            }
                                            
                                            OLI.Asset_Link_Complete__c = true;
                                    }
                                            
                                    if(Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c && Trigger.new[i].HW_Type_1__c =='D.A.S' && (Trigger.new[i].DAS_Phase__c =='4) Detached' || Trigger.new[i].DAS_Phase__c == '5) Quarantine' ||Trigger.new[i].DAS_Phase__c == '6) Complete' )&& oli.PricebookEntry.Product2.Family == 'Hardware'){
                                        OLI.Asset_Link_Complete__c = true;
                                        System.debug('@@@SFDC: Inside 15 other');
                                    }
                                    
                                    OLIToUpdate.add(OLI);
                                    System.debug('@@@SFDC: Inside 16 OLI update ');
                                }
                        }
            }
        }
        update OLIToUpdate ;
    }
    catch (Exception e) {
            System.debug('ERROR:' + e);
    }
    
}