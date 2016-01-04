public class OpportunityStageChanges {

	public static void revertRecordType(Map<ID,Opportunity> oldOpps, List<Opportunity> newOpps){
		for(Opportunity op: newOpps){
			
			if(op.Commited__c && !oldOpps.get(op.id).Commited__c) op.ForecastCategoryName = 'Commit';
			
			if(op.StageName != oldOpps.get(op.id).stageName ){
				if(op.StageName.contains('Closed') && op.Original_RecordType__c != null){
					op.RecordTypeId = ID.valueOf(op.Original_recordType__c);
					op.Commited__c = false;
				}
			}
			else if(op.Approved__c && op.Original_RecordType__c == null)  op.Original_RecordType__c = String.valueOf(oldOpps.get(op.id).RecordTypeId).substring(0,15);
		}
	}
	
	/****************************
	*		Test Methods 		*
	****************************/

	public static testMethod void testRecordTypeIntoRecordTypeOriginal(){
		RecordType standardOpp = [Select id,Name From RecordType Where Name = 'Standard Opportunity' AND sObjectType = 'Opportunity'];
		Opportunity op = new Opportunity(Name='Test Opp',closeDate=Date.Today(),stageName='Prospect',recordTypeId=standardOpp.id);
		insert op;
		
		op.stageName = 'Close';
		update op;
		
		Test.startTest();
			op.Approved__c = true;
			update op;
		Test.StopTest();
		
		op = [Select id,Name,stageName,RecordTypeID From Opportunity Where id = :op.id];
		System.assertNotEquals(standardOpp.id,op.recordTypeID);
	}
	
	public static testMethod void testRecordTypeIntoRecordTypeOriginalFailsForClosedWonStage(){
		RecordType standardOpp = [Select id,Name From RecordType Where Name = 'Standard Opportunity' AND sObjectType = 'Opportunity'];
		Opportunity op = new Opportunity(Name='Test Opp',closeDate=Date.Today(),stageName='Prospect',recordTypeId=standardOpp.id);
		insert op;
		
		op.stageName = 'Close';
		op.Approved__c = true;
		update op;
		
		op = [Select id,Name,stageName,RecordTypeID From Opportunity Where id = :op.id];
		System.assertNotEquals(standardOpp.id,op.recordTypeID);
		
		Test.startTest();
			op.stageName = 'Closed Won';
			update op;
		Test.StopTest();
		
		op = [Select id,Name,stageName,RecordTypeID From Opportunity Where id = :op.id];
		System.assertNotEquals(standardOpp.id,op.recordTypeID);
	}
	
	public static testMethod void testRevertRecordTypeToOriginal(){
		
		RecordType standardOpp = [Select id,Name From RecordType Where Name = 'Standard Opportunity' AND sObjectType = 'Opportunity'];
		RecordType salesOps = [Select id,Name From RecordType Where Name = 'Sales Ops' AND sObjectType = 'Opportunity'];
		Opportunity op = new Opportunity(Name='Test Opp',closeDate=Date.Today(),stageName='Prospect',recordTypeId=salesOps.id,Approved__c = true,Original_RecordType__c=String.valueOf(standardOpp.id).substring(0,15));
		insert op;
		
		Test.startTest();
			op.StageName = 'Closed Lost';
			update op;
		Test.StopTest();
		
		op = [Select id,Name,stageName,RecordTypeID,Original_RecordType__c From Opportunity Where id = :op.id];
		System.assertEquals(standardOpp.id,op.recordTypeID);
		
	}

}