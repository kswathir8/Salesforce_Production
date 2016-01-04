public class createLinearityRecord implements schedulable {

	public Forecast_Schedule__c FS;
	private boolean runBatch;

	public createLinearityRecord(String recordTypeName, Date startDate){
		runBatch = true;
		RecordType forecastScheduleRecordType = [Select id From RecordType Where Name = :recordTypeName AND sObjectType='Forecast_Schedule__c'];
		FS = new Forecast_Schedule__c(RecordTypeID=forecastScheduleRecordType.id,Forecast_Date__c=startDate,Name=recordTypeName + ' Forecast: ' + startDate);
	}
	
	public createLinearityRecord(String recordTypeName, Date startDate, Boolean runTheBatch){
		runBatch = runTheBatch;
		RecordType forecastScheduleRecordType = [Select id From RecordType Where Name = :recordTypeName AND sObjectType='Forecast_Schedule__c'];
		FS = new Forecast_Schedule__c(RecordTypeID=forecastScheduleRecordType.id,Forecast_Date__c=startDate,Name=recordTypeName + ' Forecast: ' + startDate);
	}
	
	public void execute(SchedulableContext ctx){
		insert FS; 
		if(runBatch) runtheBatch();
	}
	
	private void runTheBatch(){
		DateTime scheduleTime = System.now().addMinutes(1);
		String stringTime = scheduleTime.second() + ' ' + scheduleTime.Minute() + ' '  + scheduleTime.Hour() + ' '  + scheduleTime.Day() + ' '  + scheduleTime.Month() + ' ? '  + scheduleTime.Year();
		System.schedule('RunBatch for Forecast Schedule: ' + FS.id,stringTime, new OpportunityForecastBatch(FS.id));
	}
	
	/************************
	*	Test Methods		*
	************************/


	public static testMethod void testProperInsertion(){
		
		DateTime scheduleTime = System.now().addMinutes(1);
		String stringTime = scheduleTime.second() + ' ' + scheduleTime.Minute() + ' '  + scheduleTime.Hour() + ' '  + scheduleTime.Day() + ' '  + scheduleTime.Month() + ' ? '  + scheduleTime.Year();
		
		Test.startTest();
		
		try{
			System.schedule('testBasicScheduledApex',stringTime, new createLinearityRecord('Weekly',Date.today()));
		}
		catch(Exception e){
			System.assert(false);
		}
		
		Test.stopTest();
		
		List<Forecast_Schedule__c> forecasts = [Select id,Forecast_Date__c,RecordType.Name From Forecast_Schedule__c Where Forecast_Date__c = :Date.today()];
		System.assertEquals(1,forecasts.size());
		System.assertEquals(Date.today(),forecasts.get(0).Forecast_Date__c);
		System.assertEquals('Weekly',forecasts.get(0).RecordType.Name);
		
	}

}