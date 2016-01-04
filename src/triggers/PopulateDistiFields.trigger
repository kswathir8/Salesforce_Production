trigger PopulateDistiFields on Opportunity (after update) {

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
}

}