trigger UpdateUserContact on Account (after update) {

Map<Id,Account> AcctsWithMembershipChange = new Map<Id,Account>();

Map<Id,Contact> ContactsWithMembershipChange = new Map<Id,Contact>();

for(Integer i = 0 ; i< Trigger.new.size(); i++) {

if(Trigger.old[i].Partner_Membership_Level__c != Trigger.new[i].Partner_Membership_Level__c) 
{
if(AcctsWithMembershipChange.size()>0)
{
AcctsWithMembershipChange.put(Trigger.old[i].id,Trigger.new[i]);
Account acc = [select Id,Partner_Membership_Level__c from account where id in :AcctsWithMembershipChange.keySet() limit 1 ];
String membershiplevel = acc.Partner_Membership_Level__c;
String profilename ;
     if(membershiplevel =='Elite'){
     profilename ='Axcient Elite User';
        }
     else if(membershiplevel =='Partner'){
     profilename ='Axcient Partner User';
        }
     else if(membershiplevel =='Premier'){
     profilename ='Axcient Premier User';
        }
     else 
        { 
        profilename='Axcient Partner User';
        }
        
list<Profile> p = [select id from Profile where Name =:profilename];

List <User> updatedUsers = new List<User>();

for(Contact c : [SELECT id,accountId
                 FROM contact
                 WHERE accountId in : AcctsWithMembershipChange.keySet()]) {
                 ContactsWithMembershipChange.put(c.id,c);
                 }
                 
for(User u : [SELECT id,ProfileId,ContactId
              FROM user
              WHERE ContactId in : ContactsWithMembershipChange.keySet()]) {
              
              if(u.ContactId != NULL)
              {
              
              u.ProfileText__c= p[0].Id;
              updatedUsers.add(u);
              }
              
              }
              if(updatedUsers.size()>0)
              {
              update updatedUsers;
              }

}
}
}


                }