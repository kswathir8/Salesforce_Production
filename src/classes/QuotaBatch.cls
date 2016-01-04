public class QuotaBatch implements Database.Batchable<sObject>,Schedulable,Database.stateful {

	public String query;
	public Map<ID,Quota__c> quotas;

	public QuotaBatch(){
		query = 'Select id,MRR_Value_Formula__c,Contract_Terms__c,Quota__c, (Select id,Asset_HW_Type__c From OpportunityLineItems Where Asset_HW_Type__c = \'Appliance\') From Opportunity Where Quota__c != \'\'';
		quotas = new Map<ID,Quota__c>([Select id,HW_bonus__c,Partner_bonus__c,Prepay_bonus__c,endDate__c From Quota__c Where endDate__c >= :Date.Today()]);
		// zero out quotas
		for(Quota__c currentQuota: quotas.values()){
			quotas.get(currentQuota.id).Hw_Bonus__c = 0;
 			quotas.get(currentQuota.id).Prepay_bonus__c = 0;
		}
	}
	
	public QuotaBatch(String queryString){
		query = queryString;
		quotas = new Map<ID,Quota__c>([Select id,HW_bonus__c,Partner_bonus__c,Prepay_bonus__c,endDate__c From Quota__c Where endDate__c >= :Date.Today()]);
	}

	public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    public void execute(SchedulableContext SC ){
    	database.executeBatch(this);
    }
   
   	public void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
    		
    	for(Opportunity currentOp: (List<Opportunity>)scope){
    		if(!quotas.containsKey(currentOp.Quota__c)) continue;
 			
 			// check for null values in quota
 			//if(quotas.get(currentOp.Quota__c).Hw_Bonus__c == null) quotas.get(currentOp.Quota__c).Hw_Bonus__c = 0;
 			//if(quotas.get(currentOp.Quota__c).Prepay_bonus__c == null) quotas.get(currentOp.Quota__c).Prepay_bonus__c = 0;
 
 			// Hardware Bonus
    		quotas.get(currentOp.Quota__c).Hw_Bonus__c += currentOp.OpportunityLineItems.size() * 150;
    		System.debug(currentOp);
    		System.debug(currentOp.OpportunityLineItems);
    		
    		// Pre-Pay Bonus
    		if(currentOp.Contract_Terms__c == '1-Year Pre-paid') quotas.get(currentOp.Quota__c).Prepay_bonus__c += currentOp.MRR_Value_Formula__c * 12 * 0.03;
    		else if(currentOp.Contract_Terms__c == '2-Year Pre-paid') quotas.get(currentOp.Quota__c).Prepay_bonus__c += currentOp.MRR_Value_Formula__c * 24 * 0.03;
    		else if(currentOp.Contract_Terms__c == '3-Year Pre-paid') quotas.get(currentOp.Quota__c).Prepay_bonus__c += currentOp.MRR_Value_Formula__c * 36 * 0.03;
    	}	
    	
    	System.debug(quotas);                   
	}
	
	public void finish(Database.BatchableContext BC){
		system.debug(quotas);
		update quotas.values();
	}
	
	/*********************************
   *		Test Methods			*
   *********************************/
   
   public static testMethod void testSingleQuotaWith200Opportunities1YrPrePay(){
   		
   		Quota__c testQuota = new Quota__c(Name='Test Quota',Amount__c=5000,startDAte__C=Date.Today().addMonths(-1),endDate__c=Date.Today().addMonths(1));
   		insert testQuota;
   		
   		List<Opportunity> testOps = new List<Opportunity>();
   		Integer numOps = 0;
   		for(; numOps < 200; numOps++){
   			testOps.add(new Opportunity(Name='Test Opp: '+numOps,closeDate=Date.Today(),stageName='Closed Won',Contract_Terms__c='1-Year Pre-paid',MRR_Value__c=100,Quota__c=testQuota.id));
   		}
   		insert testOps;
   		
   		//List<OpportunityLineItem> testItems = new List<OpportunityLineItem>();	
   		
   		
   		System.debug(testQuota);
   		System.debug(testOps);
   		
   		Test.startTest();
   			QuotaBatch batch = new QuotaBatch();
   			Database.executeBatch(batch, 200);
   		Test.stopTest();
   		
   		testQuota = [Select id,HW_bonus__c,Partner_bonus__c,Prepay_bonus__c,StartDate__c From Quota__c Where id=:testQuota.id];
   		System.assertEquals(numOps * 100 * 12 * 0.03,testQuota.Prepay_bonus__c);
   }
   
    public static testMethod void testSingleQuotaWith200Opportunities3YrPrePay(){
   		
   		Quota__c testQuota = new Quota__c(Name='Test Quota',Amount__c=5000,startDAte__C=Date.Today().addMonths(-1),endDate__c=Date.Today().addMonths(1));
   		insert testQuota;
   		
   		List<Opportunity> testOps = new List<Opportunity>();
   		Integer numOps = 0;
   		for(; numOps < 200; numOps++){
   			testOps.add(new Opportunity(Name='Test Opp: '+numOps,closeDate=Date.Today(),stageName='Closed Won',Contract_Terms__c='3-Year Pre-paid',MRR_Value__c=100,Quota__c=testQuota.id));
   		}
   		insert testOps;
   		
   		//List<OpportunityLineItem> testItems = new List<OpportunityLineItem>();	
   		
   		
   		System.debug(testQuota);
   		System.debug(testOps);
   		
   		Test.startTest();
   			QuotaBatch batch = new QuotaBatch();
   			Database.executeBatch(batch, 200);
   		Test.stopTest();
   		
   		testQuota = [Select id,HW_bonus__c,Partner_bonus__c,Prepay_bonus__c,StartDate__c From Quota__c Where id=:testQuota.id];
   		System.assertEquals(numOps * 100 * 36 * 0.03,testQuota.Prepay_bonus__c);
   }
   
}