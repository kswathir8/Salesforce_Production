global class OpportunityForecastBatch implements schedulable,Database.Batchable<sObject> {

	private String query;
	private ID forcastID;

	global OpportunityForecastBatch(ID ForecastScheduleID){
		query = 'Select id,Forecast_Amount__c From Opportunity Where stageName IN (\'Prospect\',\'Qualify\',\'Propose\',\'Agree\',\'Close\')';
		forcastID = ForecastScheduleID;
	}

	global OpportunityForecastBatch(String querySTring,ID ForecastScheduleID){
		query = queryString;
		forcastID = ForecastScheduleID;
	}

	// Batch Implementation
	
	global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope){
		     List<Opportunity_Forcecast__c> forecasts = new List<Opportunity_Forcecast__c>();
		     for(Opportunity currentOp: (List<Opportunity>)scope){
		     	Decimal forecastAmount = 0;
		     	if(currentOp.Forecast_Amount__c != null) forecastAmount = currentOp.Forecast_Amount__c;
		     	forecasts.add(new Opportunity_Forcecast__c(Opportunity__c=currentOp.id,Forecast_Schedule__c=forcastID,Forecast_Amount__c=forecastAmount));
		     }
		     if(forecasts.size() > 0) insert forecasts;
   	}

   	global void finish(Database.BatchableContext BC){
   	
   	}
   	
   	// Schedule Implementation
   	
   	public void execute(SchedulableContext ctx){
		Database.executeBatch(this,200);
	}


	/************************
	*	Test Methods		*
	************************/

	@isTest(seeAllData=true)
	public static void testRunningBatch(){

		// create Opportunities
		String[] stages = new String[]{'Prospect','Qualify','Propose','Agree','Close'}; 
		List<Opportunity> testOps = new List<Opportunity>();
		for(Integer num = 0; num < 100; num++){
			Integer stageIndex = Math.round(Math.random() * 4);
			testOps.add(new Opportunity(Name='testOp' + num,stageName=stages[stageIndex],closeDate=Date.today().addDays(stageIndex)));
		}
		insert testOps;
		
		// Create Forecast Schedule
		RecordType forecastScheduleRecordType = [Select id From RecordType Where Name = 'Weekly' AND sObjectType='Forecast_Schedule__c'];
		Forecast_Schedule__c fs = new Forecast_Schedule__c(Name='Weekly Forecast',RecordTypeID=forecastScheduleRecordType.id,Forecast_Date__c=Date.Today());
		insert fs;
		
		Test.startTest();
		
			String query = 'Select id,Forecast_Amount__c From Opportunity Where stageName IN (\'Prospect\',\'Qualify\',\'Propose\',\'Agree\',\'Close\') AND Name like \'testOp%\'';
			Database.executeBatch(new OpportunityForecastBatch(query,fs.id),100);
		
		Test.stopTest();
	
	
		 List<Opportunity_Forcecast__c> forecasts = [Select id,Forecast_Schedule__c From Opportunity_Forcecast__c Where Opportunity__c IN :testOps];
		 System.assertEquals(100,forecasts.size());
		 for(Opportunity_Forcecast__c currentForecast: forecasts){
		 	System.assertEquals(fs.id,currentForecast.Forecast_Schedule__c);
		 }
	}

}