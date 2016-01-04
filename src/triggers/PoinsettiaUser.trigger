trigger PoinsettiaUser on Playbook__c (after insert, after update) {

List<Playbook__c> PlaybookToUpdate = new List<Playbook__c>{};

try
{

for(Integer i=0 ; i<Trigger.new.size(); i++)
{

List<Playbook__c> Playbook = [select Id,Poinsettia__c from Playbook__c where Id =: Trigger.new[i].Id ];

for( Playbook__c pb : Playbook )
{

if(pb.Poinsettia__c == null)
        {
          pb.Poinsettia__c = UserInfo.getUserId();
          PlaybooktoUpdate.add(pb);
        }
 }
}

update PlaybookToUpdate ;

}

catch(Exception ex)
{
System.debug(ex);
}                   
   
}