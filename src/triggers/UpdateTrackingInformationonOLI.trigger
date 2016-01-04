trigger UpdateTrackingInformationonOLI on OpportunityLineItem (after update) {

	try {
		if(Trigger.new[0].Asset__c != Trigger.old[0].Asset__c && Trigger.new[0].Asset_Link_Complete__c == FALSE){
		
			Asset AssetUpdate = [select Id,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c,
				Outbound_Shipment_Tracking_URL__c,Return_Shipment_Actual_Delivery_Date__c, Return_Shipment_Ship_Date__c,Return_Shipment_Tracking__c,
				HW_Type_1__c,End_Customer_Name__c,Return_Shipment_Tracking_URL__c,Will_Call__c,Asset_Tag__c 
				from Asset 
				where Id =:Trigger.new[0].Asset__c ];
			
			if(AssetUpdate.Outbound_Shipment_Tracking__c!=null){
				OpportunityLineItem OLI = [select Id,
					Outbound_Asset_Shipment_Tracking__c, Outbound_Asset_Ship_Date__c, Outbound_Asset_Actual_Delivery_Date__c,
					Outbound_Shipment_Tracking_URL__c, Return_Asset_Ship_Actual_Delivery_Date__c, Return_Asset_Shipment_Ship_Date__c, 
					Return_Asset_Shipment_Tracking__c, Return_Shipment_Tracking_URL__c,	OpportunityID, Part_Number__c, Ship_To_Name__c,
					Asset_Tag__c, Opportunity.Ship_To_Email__c,	Asset__r.Name, Product__r.ProductCode, Opportunity.StageName, Opportunity.Name,
					Asset_Link_Complete__c, PricebookEntry.Product2.ProductCode, Opportunity.Additional_Ship_To_Email_Notification_01__c,
					Opportunity.Additional_Ship_To_Email_Notification_02__c, Opportunity.Additional_Ship_To_Email_Notification_03__c,
					Opportunity.Owner.Name
					from OpportunityLineItem 
					where Id =:Trigger.new[0].Id];
			
				OLI.Outbound_Asset_Shipment_Tracking__c = AssetUpdate.Outbound_Shipment_Tracking__c;
				OLI.Outbound_Asset_Ship_Date__c = AssetUpdate.Outbound_Asset_Ship_Date__c ;
				OLI.Outbound_Asset_Actual_Delivery_Date__c = AssetUpdate.Outbound_Asset_Actual_Delivery_Date__c ;
				OLI.Outbound_Shipment_Tracking_URL__c = AssetUpdate.Outbound_Shipment_Tracking_URL__c ;
				
				OLI.Return_Asset_Ship_Actual_Delivery_Date__c = AssetUpdate.Return_Shipment_Actual_Delivery_Date__c ;
				OLI.Return_Asset_Shipment_Ship_Date__c = AssetUpdate.Return_Shipment_Ship_Date__c ;
				OLI.Return_Asset_Shipment_Tracking__c = AssetUpdate.Return_Shipment_Tracking__c ;
				OLI.Return_Shipment_Tracking_URL__c = AssetUpdate.Return_Shipment_Tracking_URL__c ;
			
			
				if(OLI.Opportunity.StageName == 'Closed Won'){
					List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>(); 
					List<OpportunityTeamMember> oppMemberList= [SELECT Id,UserId FROM OpportunityTeamMember WHERE OpportunityId  =: OLI.OpportunityID ];  
					List<String> toAddresses=new List<String>();
					
					if(OLI.Opportunity.Ship_To_Email__c!=null){
						toAddresses.add(OLI.Opportunity.Ship_To_Email__c);
					}
					if(OLI.Opportunity.Additional_Ship_To_Email_Notification_01__c!=null){
						toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_01__c);
					}
					if(OLI.Opportunity.Additional_Ship_To_Email_Notification_02__c!=null){
						toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_02__c);
					}
					if(OLI.Opportunity.Additional_Ship_To_Email_Notification_03__c!=null){
						toAddresses.add(OLI.Opportunity.Additional_Ship_To_Email_Notification_03__c);
					}
				
					for(OpportunityTeamMember oppMember : oppMemberList){
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						
						if(oppMemberList.size() > 0 ){
							mail.setTargetObjectId(oppMember.UserId);
						}
						mail.setBCcAddresses(new String[] {'plal@axcient.com', 'elias@axcient.com'});
						
						if(assetUpdate.HW_Type_1__c == 'D.A.S'){
							mail.setSubject('DAS Shipped for '+OLI.Opportunity.Name+ ' ; '+AssetUpdate.End_Customer_Name__c );
							mail.saveAsActivity = false;
							mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode+'.</b><br><br> Your order for account <b>'+AssetUpdate.End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+ AssetUpdate.Asset_Tag__c +'</b><br><br>Thank you,<br>'+OLI.Opportunity.Owner.Name);
						}
						else if(assetUpdate.HW_Type_1__c == 'Appliance'){
							mail.setSubject('Appliance Shipped for '+OLI.Opportunity.Name+ ' ; '+AssetUpdate.End_Customer_Name__c );
							mail.saveAsActivity = false;
							mail.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode+'.</b><br><br> Your order for account <b>'+AssetUpdate.End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+ AssetUpdate.Asset_Tag__c +'</b><br><br>Thank you,<br>'+OLI.Opportunity.Owner.Name);
							OLI.Asset_Link_Complete__c = true;
						}
						
						mail.setReplyTo('ops@axcient.com');
						mail.setSenderDisplayName('Axcient Operations');
						mail.setUseSignature(false);
						mails.add(mail);
					}
					
					if(AssetUpdate.Will_Call__c == FALSE){
						Messaging.sendEmail(mails);
					}
				
					Messaging.SingleEmailMessage mailtoPartner = new Messaging.SingleEmailMessage();
					mailtoPartner.setToAddresses(toAddresses);
					mailtoPartner.setSubject(OLI.Opportunity.Name+ ' ; '+AssetUpdate.End_Customer_Name__c+' s Shipment Notice'  );
					mailtoPartner.setHTMLBody('Hello '+ OLI.Ship_To_Name__c + ',<br><br>Thank you for your recent order for a <b>'+OLI.PricebookEntry.Product2.ProductCode+'.</b><br><br> Your order for account <b>'+AssetUpdate.End_Customer_Name__c+ '</b> has shipped from our facility.<br><br>The tracking number is <b>'+ OLI.Outbound_Asset_Shipment_Tracking__c +'</b><br><br>To track your shipment, please click on the below URL<br>' + OLI.Outbound_Shipment_Tracking_URL__c +' <br><br>Below is more detailed information regarding your order:<br> Order Name:<b>'+OLI.Opportunity.Name+'</b><br><br>Axcient SN:<b>'+OLI.Asset__r.Name+'</b><br><br>Asset Tag:<b> '+AssetUpdate.Asset_Tag__c +'</b><br><br>Thank you,<br><br>'+OLI.Opportunity.Owner.Name);
					mailtoPartner.setBCcAddresses(new String[] {'plal@axcient.com', 'elias@axcient.com'});
					mailtoPartner.setReplyTo('ops@axcient.com');
					mailtoPartner.setSenderDisplayName('Axcient Operations');
					mailtoPartner.setUseSignature(false);
					if(AssetUpdate.Will_Call__c == FALSE){
						Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mailtoPartner });
					}
				}
				update OLI;
			}
		}
	}
	catch (Exception e) {
		System.debug('ERROR:' + e);
	}
}