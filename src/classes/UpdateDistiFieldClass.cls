public class UpdateDistiFieldClass
{

	public static void UpdateDistiFields(Opportunity opp,Account acc) 
	{
		try
		{
		
			Opportunity opptoUpdate = [select Disti__c, Disti_Account_Number__c,DistiFetched__c from Opportunity where Id =: opp.Id];
			
			Account acctoUpdate = [select Primary_Disti__c, Disti_Account_Number__c from Account where Id =: acc.Id];
			
			opptoUpdate.Disti__c = acctoUpdate.Primary_Disti__c ;
			opptoUpdate.Disti_Account_Number__c = acctoUpdate.Disti_Account_Number__c;
			opptoUpdate.DistiFetched__c = TRUE ;
			
			update opptoUpdate ;
		}
		catch(Exception e)
		{
			System.debug(e);
		}
		
		       
	
	}

/*
	public static void SendEmailToDisti(Opportunity opp,Account acc, OpportunityLineItem OppLineItem, Id DistiID) 
	{
	
		try
		{
			Opportunity oppty = [select Account.Owner.Name,Account.Owner.Email,Account.Owner.Phone,Account.Name,End_Customer__r.Name,Disti__c, Disti_Account_Number__c,DistiFetched__c from Opportunity where Id =: opp.Id];
			Account acct = [select Name,Primary_Disti__c, Disti_Account_Number__c from Account where Id =: acc.Id];
			OpportunityLineItem oli = [select PriceBookEntry.ProductCode, PriceBookEntry.Product2.Description from OpportunityLineItem where Id = : OppLineItem.Id ];
			List<Contact> ContactList = [select Name,FirstName,Email,Hardware_Fulfillment_Contact__c from Contact where AccountID =:DistiID and Hardware_Fulfillment_Contact__c =TRUE ];
			//List<Asset> AssetsToUpdate = new List<Asset>{};
			if (ContactList.size() != 0) 
			{
			                 
				List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
				List <String> emailAddresses = new List<String>{};
				
				for(Contact con :ContactList)
				{
					if(con.Hardware_Fulfillment_Contact__c == TRUE)
					{
						//emailAddresses = new String[] {con.email };
						emailAddresses.add(con.email); 
					}
				}
				
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setSubject('A NEW HP APPLIANCE ORDER FOR YOU FROM AXCIENT');
				mail.saveAsActivity = false;
				String HTMLBody = 'Hello, <br/><br/> A new hardware order is being placed by an Axcient partner. Here are the details:<br/><br/>';
				//HTMLBody +='Axcient Partner: '+oppty.Account.Name+'<br/><br/>'+'<br/><br/>'Partner’s Ingram Account #: '+oppty.Disti_Account_Number__c+End Customer Account: '+oppty.End_Customer__c.Name+'+'<br/><br/>'+Axcient Contact Name: '+oppty.Account.OwnerFullName'+Axcient Contact Email: '+oppty.Account.OwnerEmail' +;
				HTMLBody += 'Axcient Partner:  <b>' +oppty.Account.Name+ '</b><br/>'
				                     + 'Partner’s Distributor Account #: <b>' +oppty.Disti_Account_Number__c + '</b><br/><br/>' +
				                      + 'End Customer Account:<b>' +oppty.End_Customer__r.Name + '</b><br/><br/>' +
				                      + 'Axcient Contact Name:<b> ' +oppty.Account.Owner.Name + '</b><br/>' +
				                      + 'Axcient Contact Email:<b> ' +oppty.Account.Owner.Email + '</b><br/>' +
				                      + 'Axcient Contact Phone:<b> ' +oppty.Account.Owner.Phone + '</b><br/><br/>' +  
				                      + 'HP SKU: PRODUCT:<b> '+oli.PriceBookEntry.Product2.Description + '</b><br/><br/>' +                     
				                      + 'Please contact <b>DistiShipments@axcient.com </b> with confirmation of receipt of this order ASAP.<br/><br/>' +                      
				                      + 'Let us know if there are any issues that need to be addressed.<br/><br/>' +                      
				                      + 'Thanks!<br/><br/>' +                      
				                      + 'The Axcient Team <br/><br/>'                      
				      ;
				                    
				mail.setHTMLBody(HTMLBody);
				//String[] emailAddresses = new String[] {con.email };
				mail.setToAddresses(emailAddresses);  
				mail.setBCcAddresses(new String[] {'plal@axcient.com', 'elias@axcient.com','aalegria@axcient.com','jteddleton@axcient.com'});
				mail.setCcAddresses(new String[] {'aneir@axcient.com','aalegria@axcient.com'});
				mail.setReplyTo('DistiShipments@axcient.com');
				mail.setSenderDisplayName('Axcient Disti Shipment');
				mail.setUseSignature(false);
				mails.add(mail);
		
			 
			 	if (mails.size() > 0) {
			 	
				 	try{
				    	Messaging.sendEmail(mails, true);
		               // set the message for the user
			            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,mails.size() + ' emails sent'));
				   	}
					catch (Exception e){
		               // show the messages to the user		                
		                //ApexPages.addMessages(e);
			    	}
				}
			        
			}
		        
		}
		        
		catch(Exception e)
		{
			System.debug(e);
		}
		        
	}
*/
	public static void SendEmailToDisti(Opportunity opp,Account acc, List<OpportunityLineItem> OppLineItem, Id DistiID) 
	{
	
		try
		{
			Opportunity oppty = [select Account.Owner.Name,Account.Owner.Email,Account.Owner.Phone,Account.Name,End_Customer__r.Name,Disti__c, Disti_Account_Number__c,DistiFetched__c from Opportunity where Id =: opp.Id];
			Account acct = [select Name,Primary_Disti__c, Disti_Account_Number__c from Account where Id =: acc.Id];
			//OpportunityLineItem oli = [select PriceBookEntry.ProductCode, PriceBookEntry.Product2.Description from OpportunityLineItem where Id = : OppLineItem.Id ];
			List<Contact> ContactList = [select Name,FirstName,Email,Hardware_Fulfillment_Contact__c from Contact where AccountID =:DistiID and Hardware_Fulfillment_Contact__c =TRUE ];
			//List<Asset> AssetsToUpdate = new List<Asset>{};
			if (ContactList.size() != 0) 
			{
			                 
				List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
				List <String> emailAddresses = new List<String>{};
				
				for(Contact con :ContactList)
				{
					if(con.Hardware_Fulfillment_Contact__c == TRUE)
					{
						//emailAddresses = new String[] {con.email };
						emailAddresses.add(con.email); 
					}
				}
				
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setSubject('A NEW HP APPLIANCE ORDER FOR YOU FROM AXCIENT');
				mail.saveAsActivity = false;
				String HPSKUs = '';
				for(OpportunityLineItem oli: OppLineItem){
					HPSKUs += 'HP SKU: PRODUCT:<b> '+oli.PriceBookEntry.Product2.Description + '</b><br/>';                     
				}
				
				String HTMLBody = 'Hello, <br/><br/> A new hardware order is being placed by an Axcient partner. Here are the details:<br/><br/>';
				//HTMLBody +='Axcient Partner: '+oppty.Account.Name+'<br/><br/>'+'<br/><br/>'Partner’s Ingram Account #: '+oppty.Disti_Account_Number__c+End Customer Account: '+oppty.End_Customer__c.Name+'+'<br/><br/>'+Axcient Contact Name: '+oppty.Account.OwnerFullName'+Axcient Contact Email: '+oppty.Account.OwnerEmail' +;
				HTMLBody += 'Axcient Partner:  <b>' +oppty.Account.Name+ '</b><br/>'
				                     + 'Partner’s Distributor Account #: <b>' +oppty.Disti_Account_Number__c + '</b><br/><br/>' +
				                      + 'End Customer Account:<b>' +oppty.End_Customer__r.Name + '</b><br/><br/>' +
				                      + 'Axcient Contact Name:<b> ' +oppty.Account.Owner.Name + '</b><br/>' +
				                      + 'Axcient Contact Email:<b> ' +oppty.Account.Owner.Email + '</b><br/>' +
				                      + 'Axcient Contact Phone:<b> ' +oppty.Account.Owner.Phone + '</b><br/><br/>' +  
				                      + HPSKUs + '<br/>' +
				                      + 'Please contact <b>DistiShipments@axcient.com </b> with confirmation of receipt of this order ASAP.<br/><br/>' +                      
				                      + 'Let us know if there are any issues that need to be addressed.<br/><br/>' +                      
				                      + 'Thanks!<br/><br/>' +                      
				                      + 'The Axcient Team <br/><br/>'                      
				      ;
				                    
				mail.setHTMLBody(HTMLBody);
				//String[] emailAddresses = new String[] {con.email };
				mail.setToAddresses(emailAddresses);  
				mail.setBCcAddresses(new String[] {'plal@axcient.com', 'elias@axcient.com','aalegria@axcient.com','jteddleton@axcient.com'});
				mail.setCcAddresses(new String[] {'aneir@axcient.com','aalegria@axcient.com'});
				mail.setReplyTo('DistiShipments@axcient.com');
				mail.setSenderDisplayName('Axcient Disti Shipment');
				mail.setUseSignature(false);
				mails.add(mail);
		
			 
			 	if (mails.size() > 0) {
			 	
				 	try{
				    	Messaging.sendEmail(mails, true);
		               // set the message for the user
			            // ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,mails.size() + ' emails sent'));
				   	}
					catch (Exception e){
		               // show the messages to the user		                
		                //ApexPages.addMessages(e);
			    	}
				}
			        
			}
		        
		}
		        
		catch(Exception e)
		{
			System.debug(e);
		}
		        
	}



}