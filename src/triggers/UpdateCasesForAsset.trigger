trigger UpdateCasesForAsset on Asset (after update) {

List<Case> CasesToUpdate = new List<Case>{};

try
{

for(Integer i = 0 ; i< Trigger.new.size(); i++) {

if(Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c || Trigger.new[i].Outbound_Shipment_Tracking__c != NULL || Trigger.new[i].Return_Shipment_Tracking__c != NULL )

{

List<Case> caseList = [select Id,
DAS_Phase__c,
Status,
Outbound_Asset_Shipment_Tracking__c,
Outbound_Asset_Ship_Date__c,
Outbound_Asset_Actual_Delivery_Date__c ,
Return_Shipment_Tracking__c,
Return_Shipment_Ship_Date__c,
Return_Shipment_Actual_Delivery_Date__c
from Case where AssetID =:Trigger.new[i].Id and Status != 'Closed' ];
if(caseList.size() > 0)
{
List<RecordType> recordID = [select Id from RecordType where name = 'DAS_Case' and sObjecttype = 'Case' limit 1];
Group dasGroup = [select Id from Group where Name ='D.A.S Requests' limit 1];  

for(Case c : caseList) {


c.Outbound_Asset_Shipment_Tracking__c =  Trigger.new[i].Outbound_Shipment_Tracking__c ;
c.Outbound_Asset_Ship_Date__c = Trigger.new[i].Outbound_Asset_Ship_Date__c ;
c.Outbound_Asset_Actual_Delivery_Date__c =  Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c ;

c.Return_Shipment_Actual_Delivery_Date__c = Trigger.new[i].Return_Shipment_Actual_Delivery_Date__c ;
c.Return_Shipment_Ship_Date__c = Trigger.new[i].Return_Shipment_Ship_Date__c ;
c.Return_Shipment_Tracking__c = Trigger.new[i].Return_Shipment_Tracking__c ;

if(Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c)
{
c.OwnerID = dasGroup.Id ;
c.DAS_Phase__c= Trigger.new[i].DAS_Phase__c ;
}

/*if(Trigger.new[i].DAS_Phase__c == '3) Ingesting')
{
c.Status = 'Closed';
}
*/
update c ;
   
}

//update CasesToUpdate ;
}
}
}
}
catch (Exception e) {
System.debug('ERROR:' + e);
}


}