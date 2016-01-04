public class LeadSourceController {

	@future
	public static void rollUpToAccounts(Set<ID> leadSourceIds){
		
		// Pull Lead Source
		
		List<Lead_Source__c> lsList = [Select id,Account__c,Acknowledges_business_problem_pain__c, 
												Purchase_timeframe__c,employees__c,
												Evaluating_BDR_BC_solutions__c,
												Procure_BRD_BC_solution_or_obatin_budget__c,
												Experience_selling_BDR_and_backup_prods__c,
												Experience_selling_cloud_services__c,
												How_many_identified_end_user_opps__c,
												How_many_managed_customers_do_you_have__c,
												How_many_sales_people_do_you_have__c,
												MRR_opps_expected_within_24_months__c,
												How_many_technical_resource_people__c From Lead_Source__c Where id IN: leadSourceIds];
		
		Map<ID, List<Lead_Source__c>> AccountIDToLeadSourceList = new Map<ID, List<Lead_Source__c>>();
		Set<ID> acctIds = new Set<ID>();
		for(Lead_Source__c currentSource: lsList){ 
			if(currentSource.Account__c == null) continue;	
			acctIds.add(currentSource.Account__c);
			if(!AccountIDToLeadSourceList.containsKey(currentSource.Account__c)) AccountIDToLeadSourceList.put(currentSource.Account__c, new List<Lead_Source__c>());
			AccountIDToLeadSourceList.get(currentSource.Account__c).add(currentSource);
		}
		 
		// Pull Accounts
		List<Account> leadSourceAccts = [Select id,Acknowledges_business_problem_pain__c, 
												Purchase_timeframe__c,employees__c,
												Evaluating_BDR_BC_solutions__c,
												Procure_BRD_BC_solution_or_obatin_budget__c,
												Experience_selling_BDR_and_backup_prods__c,
												Experience_selling_cloud_services__c,
												How_many_identified_end_user_opps__c,
												How_many_managed_customers_do_you_have__c,
												How_many_sales_people_do_you_have__c,
												MRR_opps_expected_within_24_months__c,
												How_many_technical_resources_people__c From Account Where Id IN: acctIds];
		
		// update Accounts
		for(Account currentAccount: leadSourceAccts){
			for(Lead_Source__c currentSource: AccountIDToLeadSourceList.get(currentAccount.id)){
				
				// SQL
				if(currentAccount.Acknowledges_business_problem_pain__c == null) currentAccount.Acknowledges_business_problem_pain__c = currentSource.Acknowledges_business_problem_pain__c;
				if(currentAccount.Purchase_timeframe__c == null) currentAccount.Purchase_timeframe__c = currentSource.Purchase_timeframe__c;
				if(currentAccount.employees__c == null) currentAccount.employees__c = currentSource.employees__c;
				if(!currentAccount.Evaluating_BDR_BC_solutions__c) currentAccount.Evaluating_BDR_BC_solutions__c = currentSource.Evaluating_BDR_BC_solutions__c;
				if(!currentAccount.Procure_BRD_BC_solution_or_obatin_budget__c) currentAccount.Procure_BRD_BC_solution_or_obatin_budget__c = currentSource.Procure_BRD_BC_solution_or_obatin_budget__c;
				
				// PQL
				if(!currentAccount.Experience_selling_BDR_and_backup_prods__c) currentAccount.Experience_selling_BDR_and_backup_prods__c = currentSource.Experience_selling_BDR_and_backup_prods__c;
				if(!currentAccount.Experience_selling_cloud_services__c) currentAccount.Experience_selling_cloud_services__c = currentSource.Experience_selling_cloud_services__c;
				if(currentAccount.How_many_identified_end_user_opps__c == null) currentAccount.How_many_identified_end_user_opps__c = currentSource.How_many_identified_end_user_opps__c;
				if(currentAccount.How_many_managed_customers_do_you_have__c == null) currentAccount.How_many_managed_customers_do_you_have__c = currentSource.How_many_managed_customers_do_you_have__c;
				if(currentAccount.How_many_sales_people_do_you_have__c == null) currentAccount.How_many_sales_people_do_you_have__c = currentSource.How_many_sales_people_do_you_have__c;
				if(currentAccount.MRR_opps_expected_within_24_months__c == null) currentAccount.MRR_opps_expected_within_24_months__c = currentSource.MRR_opps_expected_within_24_months__c;
				if(currentAccount.How_many_technical_resources_people__c == null) currentAccount.How_many_technical_resources_people__c = currentSource.How_many_technical_resource_people__c;
			
			}
		}
		
		update LeadSourceAccts;
		
	}
	
	/*********************************
    *		Test Methods			 *
    *********************************/
    
    public static testMethod void testOneLeadSourceToOneAccount(){
    	
    	Account singleAccount = new Account(Name='the Account');
    	insert singleAccount;
    	
    	Lead_Source__c firstLeadSource = new Lead_Source__c();
    	firstLeadSource.Experience_selling_BDR_and_backup_prods__c = true;
    	firstLeadSource.Experience_selling_cloud_services__c = false;
    	firstLeadSource.How_many_identified_end_user_opps__c = 1;
    	firstLeadSource.How_many_managed_customers_do_you_have__c = 0;
    	firstLeadSource.How_many_sales_people_do_you_have__c = 0;
    	firstLeadSource.MRR_opps_expected_within_24_months__c = '50-100';
    	firstLeadSource.How_many_technical_resource_people__c = 0;
    	firstLeadSource.Account__c = singleAccount.id;
    	
    	Test.startTest();
    	
    	insert firstLeadSource;
    	
    	Test.StopTest();
    	
    	singleAccount = [Select id,is_PQL__c,Experience_selling_BDR_and_backup_prods__c,
    								Experience_selling_cloud_services__c,
    								How_many_identified_end_user_opps__c,
    								How_many_managed_customers_do_you_have__c,
    								How_many_sales_people_do_you_have__c,
    								MRR_opps_expected_within_24_months__c,
    								How_many_technical_resources_people__c From Account Where id = :singleAccount.id];
    	
    	 System.assertEquals(firstLeadSource.Experience_selling_BDR_and_backup_prods__c,singleAccount.Experience_selling_BDR_and_backup_prods__c);
    	 System.assertEquals(firstLeadSource.Experience_selling_cloud_services__c,singleAccount.Experience_selling_cloud_services__c);
    	 System.assertEquals(firstLeadSource.How_many_identified_end_user_opps__c,singleAccount.How_many_identified_end_user_opps__c);
    	 System.assertEquals(firstLeadSource.How_many_managed_customers_do_you_have__c,singleAccount.How_many_managed_customers_do_you_have__c);
    	 System.assertEquals(firstLeadSource.How_many_sales_people_do_you_have__c,singleAccount.How_many_sales_people_do_you_have__c);
    	 System.assertEquals(firstLeadSource.MRR_opps_expected_within_24_months__c,singleAccount.MRR_opps_expected_within_24_months__c);
    	 System.assertEquals(firstLeadSource.How_many_technical_resource_people__c,singleAccount.How_many_technical_resources_people__c);
    	 //System.assertEquals('NO',singleAccount.is_PQL__c);
    	 
    	
    }
    
    
    public static testMethod void testOneLeadSourceToOneAccountWithSomePopulatedValues(){
    	
    	Account singleAccount = new Account(Name='the Account');
    	singleAccount.Experience_selling_BDR_and_backup_prods__c = false;
    	singleAccount.How_many_identified_end_user_opps__c = 2;
    	singleAccount.How_many_sales_people_do_you_have__c = 1;
    	insert singleAccount;
    	
    	Lead_Source__c firstLeadSource = new Lead_Source__c();
    	firstLeadSource.Experience_selling_BDR_and_backup_prods__c = true;
    	firstLeadSource.Experience_selling_cloud_services__c = false;
    	firstLeadSource.How_many_identified_end_user_opps__c = 1;
    	firstLeadSource.How_many_managed_customers_do_you_have__c = 0;
    	firstLeadSource.How_many_sales_people_do_you_have__c = 0;
    	firstLeadSource.MRR_opps_expected_within_24_months__c = '50-100';
    	firstLeadSource.How_many_technical_resource_people__c = 0;
    	firstLeadSource.Account__c = singleAccount.id;
    	
    	Test.startTest();
    	
    	insert firstLeadSource;
    	
    	Test.StopTest();
    	
    	singleAccount = [Select id,is_PQL__c,Experience_selling_BDR_and_backup_prods__c,
    								Experience_selling_cloud_services__c,
    								How_many_identified_end_user_opps__c,
    								How_many_managed_customers_do_you_have__c,
    								How_many_sales_people_do_you_have__c,
    								MRR_opps_expected_within_24_months__c,
    								How_many_technical_resources_people__c From Account Where id = :singleAccount.id];
    	
    	 System.assertEquals(firstLeadSource.Experience_selling_BDR_and_backup_prods__c,singleAccount.Experience_selling_BDR_and_backup_prods__c);
    	 System.assertEquals(firstLeadSource.Experience_selling_cloud_services__c,singleAccount.Experience_selling_cloud_services__c);
    	 System.assertNotEquals(firstLeadSource.How_many_identified_end_user_opps__c,singleAccount.How_many_identified_end_user_opps__c);
    	 System.assertEquals(firstLeadSource.How_many_managed_customers_do_you_have__c,singleAccount.How_many_managed_customers_do_you_have__c);
    	 System.assertNotEquals(firstLeadSource.How_many_sales_people_do_you_have__c,singleAccount.How_many_sales_people_do_you_have__c);
    	 System.assertEquals(firstLeadSource.MRR_opps_expected_within_24_months__c,singleAccount.MRR_opps_expected_within_24_months__c);
    	 System.assertEquals(firstLeadSource.How_many_technical_resource_people__c,singleAccount.How_many_technical_resources_people__c);
    	 //System.assertEquals('NO',singleAccount.is_PQL__c);
    	 
    	
    }

	public static testMethod void testSeveralLeadSourceToSeveralAccount(){
    	
    	List<Account> acctList = new List<Account>();
    	Account firstAccount = new Account(Name='the Account 1');
    	acctList.add(firstAccount);
    	Account secondAccount = new Account(Name='the Account 2');
    	acctList.add(secondAccount);
    	Account thirdAccount = new Account(Name='the Account 3');
    	acctList.add(thirdAccount);
    	Account fourthAccount = new Account(Name='the Account 4');
    	acctList.add(fourthAccount);
    	Account fifthAccount = new Account(Name='the Account 5');
    	acctList.add(fifthAccount);
    	
    	insert acctList;
    	
    	List<Lead_Source__c> lsList = new List<Lead_Source__c>();
    	
    	lsList.add( new Lead_Source__c(Account__c=firstAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=secondAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=thirdAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=fourthAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=fifthAccount.id) );
    	
    	for(Lead_Source__c currentls: lsList){
    	
	    	currentls.Experience_selling_BDR_and_backup_prods__c = true;
	    	currentls.Experience_selling_cloud_services__c = false;
	    	currentls.How_many_identified_end_user_opps__c = 1;
	    	currentls.How_many_managed_customers_do_you_have__c = 0;
	    	currentls.How_many_sales_people_do_you_have__c = 0;
	    	currentls.MRR_opps_expected_within_24_months__c = '50-100';
	    	currentls.How_many_technical_resource_people__c = 0;
    	
    	}
    	
    	
    	
    	Test.startTest();
    	
    		insert lsList;
    	
    	Test.StopTest();
    	
    	acctList = [Select id,is_PQL__c,Experience_selling_BDR_and_backup_prods__c,
    								Experience_selling_cloud_services__c,
    								How_many_identified_end_user_opps__c,
    								How_many_managed_customers_do_you_have__c,
    								How_many_sales_people_do_you_have__c,
    								MRR_opps_expected_within_24_months__c,
    								How_many_technical_resources_people__c From Account Where id IN :acctList];
    	
		for(Account a: acctList){

	    	 System.assertEquals(lsList.get(0).Experience_selling_BDR_and_backup_prods__c,a.Experience_selling_BDR_and_backup_prods__c);
	    	 System.assertEquals(lsList.get(0).Experience_selling_cloud_services__c,a.Experience_selling_cloud_services__c);
	    	 System.assertEquals(lsList.get(0).How_many_identified_end_user_opps__c,a.How_many_identified_end_user_opps__c);
	    	 System.assertEquals(lsList.get(0).How_many_managed_customers_do_you_have__c,a.How_many_managed_customers_do_you_have__c);
	    	 System.assertEquals(lsList.get(0).How_many_sales_people_do_you_have__c,a.How_many_sales_people_do_you_have__c);
	    	 System.assertEquals(lsList.get(0).MRR_opps_expected_within_24_months__c,a.MRR_opps_expected_within_24_months__c);
	    	 System.assertEquals(lsList.get(0).How_many_technical_resource_people__c,a.How_many_technical_resources_people__c);
	    	 //System.assertEquals('NO',a.is_PQL__c); formula field that may change criteria
	    	 
		}
    	 
    	
    }
    
    // SQL
    
    public static testMethod void testOneLeadSourceToOneAccountSQL(){
    	
    	Account singleAccount = new Account(Name='the Account');
    	insert singleAccount;
    	
    	Lead_Source__c firstLeadSource = new Lead_Source__c();
    	firstLeadSource.Evaluating_BDR_BC_solutions__c = true;
    	firstLeadSource.Procure_BRD_BC_solution_or_obatin_budget__c = true;
    	firstLeadSource.Acknowledges_business_problem_pain__c = 'Compliance';
    	firstLeadSource.Purchase_timeframe__c = '2 weeks';
    	firstLeadSource.employees__c = '20';
    	firstLeadSource.Account__c = singleAccount.id;
    	
    	Test.startTest();
    	
    	insert firstLeadSource;
    	
    	Test.StopTest();
    	
    	singleAccount = [Select id,is_PQL__c,Acknowledges_business_problem_pain__c, 
												Purchase_timeframe__c,employees__c,
												Evaluating_BDR_BC_solutions__c,
												Procure_BRD_BC_solution_or_obatin_budget__c From Account Where id = :singleAccount.id];
    	
    	 System.assertEquals(firstLeadSource.Evaluating_BDR_BC_solutions__c,singleAccount.Evaluating_BDR_BC_solutions__c);
    	 System.assertEquals(firstLeadSource.Procure_BRD_BC_solution_or_obatin_budget__c,singleAccount.Procure_BRD_BC_solution_or_obatin_budget__c);
    	 System.assertEquals(firstLeadSource.Acknowledges_business_problem_pain__c,singleAccount.Acknowledges_business_problem_pain__c);
    	 System.assertEquals(firstLeadSource.Purchase_timeframe__c,singleAccount.Purchase_timeframe__c);
    	 System.assertEquals(firstLeadSource.employees__c,singleAccount.employees__c);
    	
    }
    
    public static testMethod void testOneLeadSourceToOneAccountWithSomePopulatedValuesSQL(){
    	
    	Account singleAccount = new Account(Name='the Account');
    	singleAccount.Evaluating_BDR_BC_solutions__c = false;
    	singleAccount.Acknowledges_business_problem_pain__c = 'Other';
    	singleAccount.Purchase_timeframe__c = '8 weeks';
    	insert singleAccount;
    	
    	Lead_Source__c firstLeadSource = new Lead_Source__c();
    	firstLeadSource.Evaluating_BDR_BC_solutions__c = true;
    	firstLeadSource.Procure_BRD_BC_solution_or_obatin_budget__c = true;
    	firstLeadSource.Acknowledges_business_problem_pain__c = 'Compliance';
    	firstLeadSource.Purchase_timeframe__c = '2 weeks';
    	firstLeadSource.employees__c = '20';
    	firstLeadSource.Account__c = singleAccount.id;
    	
    	Test.startTest();
    	
    	insert firstLeadSource;
    	
    	Test.StopTest();
    	
    	singleAccount = [Select id,is_PQL__c,Acknowledges_business_problem_pain__c, 
												Purchase_timeframe__c,employees__c,
												Evaluating_BDR_BC_solutions__c,
												Procure_BRD_BC_solution_or_obatin_budget__c From Account Where id = :singleAccount.id];
    	
    	System.assertEquals(firstLeadSource.Evaluating_BDR_BC_solutions__c,singleAccount.Evaluating_BDR_BC_solutions__c);
    	System.assertEquals(firstLeadSource.Procure_BRD_BC_solution_or_obatin_budget__c,singleAccount.Procure_BRD_BC_solution_or_obatin_budget__c);
    	System.assertNotEquals(firstLeadSource.Acknowledges_business_problem_pain__c,singleAccount.Acknowledges_business_problem_pain__c);
    	System.assertNotEquals(firstLeadSource.Purchase_timeframe__c,singleAccount.Purchase_timeframe__c);
    	System.assertEquals(firstLeadSource.employees__c,singleAccount.employees__c);
    	 
    	
    }

	public static testMethod void testSeveralLeadSourceToSeveralAccountSQL(){
    	
    	List<Account> acctList = new List<Account>();
    	Account firstAccount = new Account(Name='the Account 1');
    	acctList.add(firstAccount);
    	Account secondAccount = new Account(Name='the Account 2');
    	acctList.add(secondAccount);
    	Account thirdAccount = new Account(Name='the Account 3');
    	acctList.add(thirdAccount);
    	Account fourthAccount = new Account(Name='the Account 4');
    	acctList.add(fourthAccount);
    	Account fifthAccount = new Account(Name='the Account 5');
    	acctList.add(fifthAccount);
    	
    	insert acctList;
    	
    	List<Lead_Source__c> lsList = new List<Lead_Source__c>();
    	
    	lsList.add( new Lead_Source__c(Account__c=firstAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=secondAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=thirdAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=fourthAccount.id) );
    	lsList.add( new Lead_Source__c(Account__c=fifthAccount.id) );
    	
    	for(Lead_Source__c currentls: lsList){
    	
	    	currentls.Evaluating_BDR_BC_solutions__c = true;
	    	currentls.Procure_BRD_BC_solution_or_obatin_budget__c = true;
	    	currentls.Acknowledges_business_problem_pain__c = 'Compliance';
	    	currentls.Purchase_timeframe__c = '2 weeks';
	    	currentls.employees__c = '20';
	    	
    	}
    	
    	
    	
    	Test.startTest();
    	
    		insert lsList;
    	
    	Test.StopTest();
    	
    	acctList = [Select id,is_PQL__c,Acknowledges_business_problem_pain__c, 
												Purchase_timeframe__c,employees__c,
												Evaluating_BDR_BC_solutions__c,
												Procure_BRD_BC_solution_or_obatin_budget__c From Account Where id IN :acctList];
    	
		for(Account a: acctList){

		    System.assertEquals(lsList.get(0).Evaluating_BDR_BC_solutions__c,a.Evaluating_BDR_BC_solutions__c);
	    	System.assertEquals(lsList.get(0).Procure_BRD_BC_solution_or_obatin_budget__c,a.Procure_BRD_BC_solution_or_obatin_budget__c);
	    	System.assertEquals(lsList.get(0).Acknowledges_business_problem_pain__c,a.Acknowledges_business_problem_pain__c);
	    	System.assertEquals(lsList.get(0).Purchase_timeframe__c,a.Purchase_timeframe__c);
	    	System.assertEquals(lsList.get(0).employees__c,a.employees__c);
	    	 
		}
    	 
    	
    }

}