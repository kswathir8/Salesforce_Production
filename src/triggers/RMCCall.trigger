trigger RMCCall on Account (after update) {
List<RecordType> recordIDPartner = [select Id from RecordType where name = 'Partner' and sObjecttype = 'Account' limit 1];
List<RecordType> recordIDClient = [select Id from RecordType where name = 'End Customer' and sObjecttype = 'Account' limit 1];
for(Integer i=0 ; i<Trigger.new.size(); i++)
{

if(Trigger.new[i].Fetch__c!= Trigger.old[i].Fetch__c)
{

try
{
RMCAPISyncAccounts.GetAccountID(Trigger.new[i].Id, Trigger.new[i].RecordTypeId ) ;

}
catch(Exception ex)
{
System.debug(ex);
}
}
}

}