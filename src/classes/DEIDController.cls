public with sharing class DEIDController {

	public static void updateOppFromDEID(List<DEID__c> deids){
		
		Map<ID,DEID__c> osreportIDToDEID = new Map<ID,DEID__c>();
		for(DEID__C deid: deids){
			if(deid.OS_Report__c != null)	osreportIDToDEID.put(deid.OS_Report__c,deid);
		}
		
		List<OSS_Report__c> reports = [Select id, Opportunity__c, HPOrderNo__c, CustomerName__c, ShipToAddr__c From OSS_Report__c Where id IN :osreportIDToDEID.keySet()];
		if(reports.size() == 0) return;
		
		Map<ID,OSS_Report__c> oppToOSReport = new Map<ID,OSS_Report__c>();
		for(OSS_Report__c report: reports){
			if(report.Opportunity__c != null) oppToOSReport.put(report.Opportunity__c,report);
		}
		
		List<Opportunity> opps = [Select id,AccountID From Opportunity Where id IN :oppToOSReport.keySet()];
		if(opps.size() == 0) return;
		
		for(Opportunity op: opps){
			op.HP_Order_Number__c = oppToOSReport.get(op.id).HPOrderNo__c ;
			op.HP_Customer_Name__c = oppToOSReport.get(op.id).CustomerName__c ;
			op.HP_Ship_To_Addr__c = oppToOSReport.get(op.id).ShipToAddr__c ;
			op.HP_SAP_Order_Number__c = osreportIDToDEID.get(oppToOSReport.get(op.id).id).Sap_order__c;
			op.HP_Legacy_Order_Number__c = osreportIDToDEID.get(oppToOSReport.get(op.id).id).Legacy_order__c;
			op.HP_End_Customer_Purchase_Order__c = osreportIDToDEID.get(oppToOSReport.get(op.id).id).End_customer_purchase_order__c;
		}
		
		update opps;
		
		createAssetsAndAttachToOLI(deids,new Map<ID,OSS_Report__c>(reports),new Map<ID,Opportunity>(opps));
		
	}
	
	public static void createAssetsAndAttachToOLI(List<DEID__c> deids, Map<ID,OSS_Report__c> osreportsMap, Map<ID,Opportunity> oppMap){
		
		if(deids == null || oppMap == null) return;
		if(deids != null && deids.size() == 0 ) return;
		if(oppMap != null && oppMap.size() == 0 ) return;
		
		Map<ID,Asset> OLIToNewAssets = new Map<ID,Asset>();
		
		List<Product2> appliances = [Select id From Product2 Where HW_Type__c = 'Appliance'];
		Map<Id,PricebookEntry> entries = new Map<ID,PricebookEntry>([Select id,Product2ID From PricebookEntry Where Product2ID IN :appliances]);
		List<OpportunityLineItem> hpItems = [Select id,OpportunityID,PricebookEntryId From OpportunityLineItem Where OpportunityID IN :oppMap.keySet() AND PricebookEntryID IN :entries.keySet()];
		if(hpItems.size() == 0) return;
		
		Map<ID,OpportunityLineItem> oppIDToOLIMap = new Map<ID,OpportunityLineItem>();
		for(OpportunityLineItem item: hpItems){
			oppIDToOLIMap.put(item.OpportunityID,item);
		}
		
		Map<Id,Asset> diedIdToAsset = new Map<Id,Asset>();
		
		for(DEID__c deid: deids){
			
			// Only create assets for DEIDs with OSReports and no Asset
			if(!osreportsMap.containsKey(deid.OS_Report__c) || deid.asset__c != null) continue;
			if(osreportsMap.get(deid.OS_Report__c).Opportunity__c == null || !oppMap.containsKey(osreportsMap.get(deid.OS_Report__c).Opportunity__c)) continue;
			ID acctID = oppMap.get(osreportsMap.get(deid.OS_Report__c).Opportunity__c).AccountID;
			
			Asset newAsset = new Asset(AccountID=acctId,asset_tag__c=deid.asset_tag__c,Name=deid.deviceName_label__c);
			newAsset.SerialNumber = deid.serialNumber__c;
			newAsset.Product2Id = entries.get(oppIDToOLIMap.get(oppMap.get(osreportsMap.get(deid.OS_Report__c).Opportunity__c).id).PricebookEntryID).Product2ID;
			
			// add asset
			OLIToNewAssets.put(oppIDToOLIMap.get(oppMap.get(osreportsMap.get(deid.OS_Report__c).Opportunity__c).id).id,newAsset);			
			diedIdToAsset.put(deid.id,newAsset);
		}
		
		System.debug(OLIToNewAssets.values());
		if(OLIToNewAssets.size() > 0)	insert OLIToNewAssets.values();
		
		List<OpportunityLineItem> updateItems = new List<OpportunityLineItem>();
		Map<ID,OpportunityLineItem> oliMap = new Map<ID,OpportunityLineItem>(hpItems);
		for(ID oliID: OLIToNewAssets.keySet()){
			oliMap.get(oliID).Asset__c = OLIToNewAssets.get(oliID).id;
			updateItems.add(oliMap.get(oliID));
		}
		
		if(updateItems.size() > 0) update updateItems;
		
		// add assets to deids
		for(DEID__c deid: deids){
			if(diedIdToAsset.containsKey(deid.id))	deid.Asset__c = diedIdToAsset.get(deid.id).id;
		}
		
	}
	
	/********************************************
	*				Test Methods				*
	********************************************/
	
	
	public static testMethod void testUpdatingOppFromDEID(){
		Account testAccount = new Account(name='Test Account');
		insert testAccount;
		Opportunity op = new Opportunity(name='Test Op',closeDate=Date.today(),stageName='Closed Won',HP_Order_Number__c='TestNumber1234',AccountID=testAccount.id);
		insert op;
		
		OSS_Report__c report = new OSS_Report__c();
		report.HPOrderNo__c = 'TestNumber1234';
		report.CustomerName__c = 'Test Customer';
		report.ShipToAddr__c = '111 Fake St., Mountain View, Ca';
		report.serialNumber__c = 'serialNumber123';
		report.Opportunity__c = op.Id ;
		insert report;

		DEID__c deid = new DEID__c();
		deid.serialNumber__c = 'serialNumber123';
		deid.OS_Report__c = report.Id ;
		deid.Sap_order__c = 'Fred' ;
		deid.Legacy_order__c = 'Tom' ;
		deid.End_customer_purchase_order__c = 'Sim' ;
		insert deid;
		
		deid = [Select id,OS_Report__c From DEID__C Where id = :deid.id];
		System.assertEquals(report.id,deid.OS_Report__c);
		
		Test.startTest();
//			update deid;
		Test.stopTest();
		
		op = [Select id,HP_Order_Number__c,HP_Customer_Name__c,HP_Ship_To_Addr__c,HP_SAP_Order_Number__c,HP_Legacy_Order_Number__c,HP_End_Customer_Purchase_Order__c From Opportunity Where id = :op.id];
		// OS Report field assertions
		System.assertEquals(report.HPOrderNo__c,op.HP_Order_Number__c);
		System.assertEquals(report.CustomerName__c,op.HP_Customer_Name__c);
		System.assertEquals(report.ShipToAddr__c,op.HP_Ship_To_Addr__c);
		
		
		deid = [Select id,sap_order__c,legacy_order__c,end_customer_purchase_order__c From DEID__C Where id = :deid.id];
		// DEID feild assertions
		System.assertEquals(deid.Sap_order__c,op.HP_SAP_Order_Number__c);
		System.assertEquals(deid.Legacy_order__c,op.HP_Legacy_Order_Number__c);
		System.assertEquals(deid.End_customer_purchase_order__c,op.HP_End_Customer_Purchase_Order__c);
	}
	
	@isTest(seeAllData=true)
	public static void testUpdatingOppWithOLIFromDEID(){
		Account testAccount = new Account(name='Test Account');
		insert testAccount;
		Opportunity op = new Opportunity(name='Test Op',closeDate=Date.today(),stageName='Closed Won',HP_Order_Number__c='TestNumber1234',AccountID=testAccount.id);
		insert op;
		Product2 product = [Select id From Product2 Where Name = 'Appliance (HP Distributor Fulfillment)' limit 1];
		Pricebook2 pricebook = [Select id From Pricebook2 Where Name = '2012 Price Book' limit 1];
		PricebookEntry entry = [Select id From PricebookEntry Where Product2ID = :product.id AND Pricebook2ID = :pricebook.id];
		OpportunityLineItem item = new OpportunityLineItem(OpportunityID=op.id,PricebookEntryID=entry.id,UnitPrice=4000,Quantity=1);
		insert item;

		OSS_Report__c report = new OSS_Report__c();
		report.HPOrderNo__c = 'TestNumber1234';
		report.CustomerName__c = 'Test Customer';
		report.ShipToAddr__c = '111 Fake St., Mountain View, Ca';
		report.serialNumber__c = 'serialNumber123';
		report.Opportunity__c = op.Id ;
		insert report;

		DEID__c deid = new DEID__c();
		deid.serialNumber__c = 'serialNumber123';
		deid.OS_Report__c = report.Id ;
		deid.Sap_order__c = 'Fred' ;
		deid.Legacy_order__c = 'Tom' ;
		deid.End_customer_purchase_order__c = 'Sim' ;
		deid.DeviceName_label__c = 'device';
		deid.Asset_tag__c = 'n/a';
		insert deid;
		
		deid = [Select id,OS_Report__c From DEID__C Where id = :deid.id];
		System.assertEquals(report.id,deid.OS_Report__c);
		
		Test.startTest();
//			update deid;
		Test.stopTest();
		
		op = [Select id,HP_Order_Number__c,HP_Customer_Name__c,HP_Ship_To_Addr__c,HP_SAP_Order_Number__c,HP_Legacy_Order_Number__c,HP_End_Customer_Purchase_Order__c From Opportunity Where id = :op.id];
		// OS Report field assertions
		System.assertEquals(report.HPOrderNo__c,op.HP_Order_Number__c);
		System.assertEquals(report.CustomerName__c,op.HP_Customer_Name__c);
		System.assertEquals(report.ShipToAddr__c,op.HP_Ship_To_Addr__c);
		
		
		deid = [Select id,sap_order__c,legacy_order__c,end_customer_purchase_order__c,asset__c,asset_tag__c,deviceName_label__c,serialNumber__c From DEID__C Where id = :deid.id];
		// DEID feild assertions
		System.assertEquals(deid.sap_order__c,op.HP_SAP_Order_Number__c);
		System.assertEquals(deid.legacy_order__c,op.HP_Legacy_Order_Number__c);
		System.assertEquals(deid.end_customer_purchase_order__c,op.HP_End_Customer_Purchase_Order__c);
		
		Asset newAsset = [Select id,asset_tag__c,name,SerialNumber,AccountId From Asset Where id = :deid.asset__c];
		System.assertEquals(testAccount.id,newAsset.AccountId);
		System.assertEquals(deid.asset_tag__c,newAsset.asset_tag__c);
		System.assertEquals(deid.deviceName_label__c,newAsset.name);
		System.assertEquals(deid.serialNumber__c,newAsset.SerialNumber);
		
		item = [Select id,Asset__c From OpportunityLineItem Where ID = :item.id];
		System.assertEquals(newAsset.id,item.Asset__c);
		
	} 
	
}