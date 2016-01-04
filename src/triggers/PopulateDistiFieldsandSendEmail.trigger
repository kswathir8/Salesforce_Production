trigger PopulateDistiFieldsandSendEmail on Opportunity (after update) {

try

{

for(Integer i = 0 ; i< Trigger.new.size(); i++) {

if(Trigger.new[i].DistiFetched__c==FALSE && Trigger.new[i].Disti_Deal__c==TRUE)
{

Account GetUndAccount = [select Name,Primary_Disti__c from Account where Id =: Trigger.New[i].AccountId];

if(GetUndAccount.Primary_Disti__c==NULL)
{
Trigger.New[i].addError('You need to have a Disti selected at the account level');
}
else
{
UpdateDistiFieldClass.UpdateDistiFields(Trigger.new[i],GetUndAccount);
}

}

/*
Stage = Closed Won
Disti Deal? = checked
Disti  = <not blank>
Disti Account Number = <not blank>
Status = Active
Contact Roles section has a designated Partner Contact and Disti Contact*
Products section has at least one Product Code selected beginning with “HP” (all SKU’s beginning with “HP” need to populate the email template)
*/
if(
Trigger.new[i].StageName=='Closed Won' 
&& Trigger.new[i].Disti_Deal__c == TRUE 
&& Trigger.new[i].Disti__c != NULL 
&& Trigger.new[i].Status__c =='Active'
&& (Trigger.new[i].Disti_Account_Number__c != NULL || Trigger.new[i].Disti_Account_Number__c != '')
&& (Trigger.old[i].HP_Products__c != Trigger.new[i].HP_Products__c || Trigger.new[i].Status__c != Trigger.old[i].Status__c)
)
{
Account GetUndAccount = [select Name,Primary_Disti__c from Account where Id =: Trigger.New[i].AccountId];
List<OpportunityLineItem> GetOLIs = [select PriceBookEntry.ProductCode, PriceBookEntry.Product2.Name, PriceBookEntry.Product2.Description from OpportunityLineItem where OpportunityID =: Trigger.New[i].Id and PriceBookEntry.ProductCode like '%HP%'];
//System.debug('************************* PriceBookEntry.ProductCode:  ' + GetOLIs.PriceBookEntry.ProductCode);

List<Contact> ContactList = [select Email,Hardware_Fulfillment_Contact__c from Contact where AccountID =:Trigger.new[i].Disti__c and Hardware_Fulfillment_Contact__c = TRUE];
if (ContactList.size() == 0) 
{
Trigger.New[i].addError('Please select atleast one Hardware Fulfillment Contact at the Distributor account level to send the email notification.');
}
UpdateDistiFieldClass.SendEmailToDisti(Trigger.new[i],GetUndAccount,GetOLIs,Trigger.new[i].Disti__c);


}



}

}

  catch(Exception e)
{
System.debug(e);
}
        



}