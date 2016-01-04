trigger UpdateTrackingShipmentDASDates on Asset (after update) {

List<Asset> AssetsToUpdate = new List<Asset>{};
List<Asset_Tracking__c> TrackingsToUpdate = new List<Asset_Tracking__c >{};

try
{

Asset as1 = [select Id,DAS_Phase_1_Completion_Date__c,DAS_Phase_2_Completion_Date__c,DAS_Phase_3_Completion_Date__c,
DAS_Phase_4_Completion_Date__c, DAS_Phase_5_Completion_Date__c,DAS_Phase_6_Completion_Date__c,Outbound_Shipment_Tracking__c,Outbound_Asset_Ship_Date__c,Outbound_Asset_Actual_Delivery_Date__c from Asset where Id =:Trigger.new[0].Id LIMIT 1];

Account acc = [select Id,Name from Account where Id =:Trigger.new[0].AccountID];

for(Integer i = 0 ; i< Trigger.new.size(); i++) {

if(Trigger.new[i].DAS_Phase__c != Trigger.old[i].DAS_Phase__c && Trigger.new[i].Account == Trigger.old[i].Account )
{
//add condtion if exists or not one

if(Trigger.new[i].Asset_Tracking_Counter__c > 0 )
{
Asset_Tracking__c at = [select Id, DAS_Phase_4_Completion_Date__c,DAS_Phase_3_Completion_Date__c, DAS_Phase_5_Completion_Date__c,
                        DAS_Phase_1_Completion_Date__c, DAS_Phase_2_Completion_Date__c from Asset_Tracking__c where Asset__c =: as1.Id AND Account__c =:acc.Id LIMIT 1 ];

if(Trigger.old[i].DAS_Phase__c == '1) Requested'){
as1.DAS_Phase_1_Completion_Date__c = Datetime.now();
at.DAS_Phase_1_Completion_Date__c = Datetime.now();

}

else if(Trigger.old[i].DAS_Phase__c == '2) Returned'){
as1.DAS_Phase_2_Completion_Date__c = Datetime.now();
at.DAS_Phase_2_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '3) Ingesting'){
as1.DAS_Phase_3_Completion_Date__c = Datetime.now();
at.DAS_Phase_3_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '4) Detached'){
as1.DAS_Phase_4_Completion_Date__c = Datetime.now();
at.DAS_Phase_4_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '5) Quarantine'){
as1.DAS_Phase_5_Completion_Date__c = Datetime.now();
at.DAS_Phase_5_Completion_Date__c = Datetime.now();
}
/*
//PL: New changes for case tracking START

if(Trigger.new[i].Outbound_Shipment_Tracking__c != NULL)
{
at.Outbound_Shipment_Tracking__c = Trigger.new[i].Outbound_Shipment_Tracking__c;

at.Outbound_Asset_Ship_Date__c = Trigger.new[i].Outbound_Asset_Ship_Date__c ;

at.Outbound_Asset_Actual_Delivery_Date__c = Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c;

at.Case_Associated__c = Trigger.new[i].Current_Case__c ;

at.DAS_Phase__c = Trigger.new[i].DAS_Phase__c ;

}


//END
*/

if(Trigger.new[i].DAS_Phase__c == '2) Returned' && Trigger.old[i].DAS_Phase__c != '1) Requested'){

if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){ as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
}

else if(Trigger.new[i].DAS_Phase__c == '3) Ingesting' && Trigger.old[i].DAS_Phase__c != '2) Returned'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now();at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now();at.DAS_Phase_2_Completion_Date__c = Datetime.now();}

}

else if(Trigger.new[i].DAS_Phase__c == '4) Detached' && Trigger.old[i].DAS_Phase__c != '3) Ingesting'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now(); }

}

else if(Trigger.new[i].DAS_Phase__c == '5) Quarantine' && Trigger.old[i].DAS_Phase__c != '4) Detached'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_4_Completion_Date__c == null){as1.DAS_Phase_4_Completion_Date__c = Datetime.now(); at.DAS_Phase_4_Completion_Date__c = Datetime.now(); }

}

else if(Trigger.new[i].DAS_Phase__c == '6) Complete' && Trigger.old[i].DAS_Phase__c != '5) Quarantine'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_4_Completion_Date__c == null){as1.DAS_Phase_4_Completion_Date__c = Datetime.now(); at.DAS_Phase_4_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_5_Completion_Date__c == null){as1.DAS_Phase_5_Completion_Date__c = Datetime.now(); at.DAS_Phase_5_Completion_Date__c = Datetime.now(); }
}

AssetsToUpdate.add(as1);
TrackingsToUpdate.add(at);
}                        
                  
else if(Trigger.new[i].Asset_Tracking_Counter__c == 0 )
{
Asset_Tracking__c at = new Asset_Tracking__c(Asset__c = Trigger.new[i].Id, Account__c = acc.Id );
if(Trigger.old[i].DAS_Phase__c == '1) Requested'){
as1.DAS_Phase_1_Completion_Date__c = Datetime.now();
at.DAS_Phase_1_Completion_Date__c = Datetime.now();

}

else if(Trigger.old[i].DAS_Phase__c == '2) Returned'){
as1.DAS_Phase_2_Completion_Date__c = Datetime.now();
at.DAS_Phase_2_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '3) Ingesting'){
as1.DAS_Phase_3_Completion_Date__c = Datetime.now();
at.DAS_Phase_3_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '4) Detached'){
as1.DAS_Phase_4_Completion_Date__c = Datetime.now();
at.DAS_Phase_4_Completion_Date__c = Datetime.now();
}

else if(Trigger.old[i].DAS_Phase__c == '5) Quarantine'){
as1.DAS_Phase_5_Completion_Date__c = Datetime.now();
at.DAS_Phase_5_Completion_Date__c = Datetime.now();
}

//PL: New changes for case tracking START
/*
if(Trigger.new[i].Outbound_Shipment_Tracking__c != NULL)
{
at.Outbound_Shipment_Tracking__c = Trigger.new[i].Outbound_Shipment_Tracking__c;

at.Outbound_Asset_Ship_Date__c = Trigger.new[i].Outbound_Asset_Ship_Date__c ;

at.Outbound_Asset_Actual_Delivery_Date__c = Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c;

at.Case_Associated__c = Trigger.new[i].Current_Case__c ;

at.DAS_Phase__c = Trigger.new[i].DAS_Phase__c ;

}

*/
//END



if(Trigger.new[i].DAS_Phase__c == '2) Returned' && Trigger.old[i].DAS_Phase__c != '1) Requested'){

if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){ as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
}

else if(Trigger.new[i].DAS_Phase__c == '3) Ingesting' && Trigger.old[i].DAS_Phase__c != '2) Returned'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now();at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now();at.DAS_Phase_2_Completion_Date__c = Datetime.now();}

}

else if(Trigger.new[i].DAS_Phase__c == '4) Detached' && Trigger.old[i].DAS_Phase__c != '3) Ingesting'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now(); }

}

else if(Trigger.new[i].DAS_Phase__c == '5) Quarantine' && Trigger.old[i].DAS_Phase__c != '4) Detached'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_4_Completion_Date__c == null){as1.DAS_Phase_4_Completion_Date__c = Datetime.now(); at.DAS_Phase_4_Completion_Date__c = Datetime.now(); }

}

else if(Trigger.new[i].DAS_Phase__c == '6) Complete' && Trigger.old[i].DAS_Phase__c != '5) Quarantine'){
if(Trigger.new[i].DAS_Phase_1_Completion_Date__c == null){as1.DAS_Phase_1_Completion_Date__c = Datetime.now(); at.DAS_Phase_1_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_2_Completion_Date__c == null){as1.DAS_Phase_2_Completion_Date__c = Datetime.now(); at.DAS_Phase_2_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_3_Completion_Date__c == null){as1.DAS_Phase_3_Completion_Date__c = Datetime.now(); at.DAS_Phase_3_Completion_Date__c = Datetime.now(); }
if(Trigger.new[i].DAS_Phase_4_Completion_Date__c == null){as1.DAS_Phase_4_Completion_Date__c = Datetime.now(); at.DAS_Phase_4_Completion_Date__c = Datetime.now();}
if(Trigger.new[i].DAS_Phase_5_Completion_Date__c == null){as1.DAS_Phase_5_Completion_Date__c = Datetime.now(); at.DAS_Phase_5_Completion_Date__c = Datetime.now(); }
}

AssetsToUpdate.add(as1);
//TrackingsToUpdate.add(at);

Id AxcientId ;
Account GetAccount = [select Id from Account where Name = 'Axcient Inc' LIMIT 1 ] ;
AxcientId = GetAccount.Id;
if(Trigger.new[i].AccountId != AxcientId)
{
insert at;
}

}

}

if(Trigger.new[i].AccountId != Trigger.old[i].AccountId )
{

Asset_Tracking__c at = new Asset_Tracking__c(Asset__c = Trigger.new[i].Id, Account__c = acc.Id );
as1.DAS_Phase_1_Completion_Date__c = NULL ;
as1.DAS_Phase_2_Completion_Date__c = NULL ;
as1.DAS_Phase_3_Completion_Date__c = NULL ;
as1.DAS_Phase_4_Completion_Date__c = NULL ;
as1.DAS_Phase_5_Completion_Date__c = NULL ;
as1.DAS_Phase__c = '' ;

AssetsToUpdate.add(as1);
/*
//PL: New changes for case tracking START
if(Trigger.new[i].Outbound_Shipment_Tracking__c != NULL)
{
at.Outbound_Shipment_Tracking__c = Trigger.new[i].Outbound_Shipment_Tracking__c;
at.Outbound_Asset_Ship_Date__c = Trigger.new[i].Outbound_Asset_Ship_Date__c ;
at.Outbound_Asset_Actual_Delivery_Date__c = Trigger.new[i].Outbound_Asset_Actual_Delivery_Date__c;
at.Case_Associated__c = Trigger.new[i].Current_Case__c ;
at.DAS_Phase__c = Trigger.new[i].DAS_Phase__c ;
}
//END
*/

Id AxcientId ;
Account GetAccount = [select Id from Account where Name = 'Axcient Inc' LIMIT 1 ] ;
AxcientId = GetAccount.Id;
if(Trigger.new[i].AccountId != AxcientId)
{
insert at;
}


}


}

update AssetsToUpdate;
update TrackingsToUpdate;

}

catch(Exception e)
{
   e.getMessage();
   System.debug('######## Message ####' + e.getMessage());      

}

}