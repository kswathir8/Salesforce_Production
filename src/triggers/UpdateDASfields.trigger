trigger UpdateDASfields on Asset (after update) {

List<Asset> AssetsToUpdate = new List<Asset>{};
/*Asset as1 = [select Id,DAS_Station__c,DAS_Status__c,Data_Center__c from Asset where Id =:Trigger.new[0].Id];

for(Integer i = 0 ; i< Trigger.new.size(); i++) {

if(Trigger.new[i].DAS_Station__c!=Trigger.old[i].DAS_Station__c && Trigger.new[i].DAS_Station__c == NULL)
{
    
as1.Data_Center__c = NULL;
AssetsToUpdate.add(as1);
        
}

}
update AssetsToUpdate ;
*/
/*
 * Edited by Alexandru Boghean - aboghean@sererra.com
*/
    for(Asset as1 : Trigger.new) {
        Asset oldAsset = Trigger.newMap.get(as1.Id);
        if(as1.DAS_Station__c != oldAsset.DAS_Station__c && as1.DAS_Station__c == NULL)
        {
            
            as1.Data_Center__c = NULL;
            AssetsToUpdate.add(as1);
                
        }
    
    }
    
    if(AssetsToUpdate.size() > 0)
    {
        update AssetsToUpdate ;
    }
}