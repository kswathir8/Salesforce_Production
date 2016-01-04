trigger UpdateCasesWithAccountName on Case (after update ) {

List<Case> CasesToUpdate = new List<Case>{};

try
{

List<RecordType> recordID = [select Id from RecordType where name = 'Disti' and sObjecttype = 'Case' limit 1];

if(Trigger.new[0].ContactId != Trigger.old[0].ContactId && Trigger.new[0].RecordTypeId!= recordID[0].Id )
{

List<Case> caseList = [select Id,ContactId from Case where ID =:Trigger.new[0].Id  ];
if(caseList.size() > 0)
{

for(Case c : caseList) {

List<Contact> contactList = [select AccountId,Name,Id from Contact where Id = :c.ContactId ];

for(Contact con: contactList)
{
c.AccountId = con.AccountId ;
CasesToUpdate.Add(c);
}
}

update CasesToUpdate ;
}
}
}
catch (Exception e) {
System.debug('ERROR:' + e);
}


}