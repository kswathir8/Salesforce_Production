public class OpportunityController {

    public static Boolean isRunning;

    /********************
    *       Quotas      *
    ********************/
    
    public class dateInterval{
        public Date startDate {get;set;}
        public Date endDate {get;set;}
        
        public dateInterval(Date firstDate,Date secondDate){
            startDate = firstDate;
            endDate = secondDate;
        }
        
        public Boolean isInBetween(Date inbetweenDate){
            return ( inbetweenDate >= startDate && inbetweenDate <= endDate);
        }
        
        public Boolean greaterThan(Date compare){
            if(startDate > compare) return true;
            return false;
        }
    }
    
    public static List<Opportunity> adjustQuotaLookUp(List<Opportunity> OppList){
        
        if(OppList.size() == 0 ) return OppList; 
        
        Set<ID> ownerIDs = new Set<ID>();
        Date firstClosed;
        
        for(Opportunity itrOpp: oppList){
            ownerIds.add(itrOpp.ownerID);
            if(firstClosed == null) firstClosed = itrOpp.closeDate;
            else if(firstClosed > itrOpp.closeDate) firstClosed = itrOpp.closeDate;
        }
    
        System.debug(firstClosed);
    
        List<Quota__c> quotas = [Select id,OwnerID,startDate__c,endDate__c,Amount__c From Quota__c Where ownerID IN :ownerIDs AND (startDate__c <= :firstClosed.ToStartOfMonth() OR endDate__c > :firstClosed)];
        
        System.debug(quotas);
        
        Map<ID,Map<dateInterval,Quota__c>> ownerIDToDateIntervalToQuota = new Map<ID,Map<dateInterval,Quota__c>>();
        Map<ID,Map<Date,dateInterval>> ownerIDToStartDateToIntervalMap = new Map<ID,Map<Date,dateInterval>>();
        for(Quota__c quota: quotas){
            if(!ownerIDToDateIntervalToQuota.containsKey(quota.ownerID)) ownerIDToDateIntervalToQuota.put(quota.ownerID, new Map<dateInterval,Quota__c>());
            if(!ownerIDToStartDateToIntervalMap.containsKey(quota.ownerID)) ownerIDToStartDateToIntervalMap.put(quota.ownerID, new Map<Date,dateInterval>());
            
            //ownerIDToStartDateToQuota.get(quota.ownerID).put(quota.startDate__c,quota);
            DateInterval quotaInterval = new dateInterval(quota.startDate__c,quota.endDate__c);
            ownerIDToDateIntervalToQuota.get(quota.ownerID).put(quotaInterval,quota);
            ownerIDToStartDateToIntervalMap.get(quota.ownerID).put(quota.startDate__c, quotaInterval);
        }
    
        for(Opportunity itrOpp: oppList){
            if(!ownerIDToDateIntervalToQuota.containsKey(itrOpp.ownerID)) continue;
            Map<dateInterval,Quota__c> ownerMap = ownerIDToDateIntervalToQuota.get(itrOpp.ownerId);
            if(ownerMap == null) continue;
            
            List<dateInterval> sortedList = sortFromMap(ownerIDToStartDateToIntervalMap.get(itrOpp.ownerID));
            
            dateInterval interval = getDateFromSortedList(sortedList,itrOpp.CloseDate,0,sortedList.size());
            
            System.debug(sortedList);
            System.debug(interval);
            /*System.debug(ownerMap);
            System.debug(ownerMap.get(interval));
            System.debug(ownerIDToStartDateToIntervalMap.get(itrOpp.ownerID));*/
            
            if(interval != null) itrOpp.Quota__c = ownerMap.get(interval).id;
            
        }
        
        return OppList;
    
    }
    
    public static List<dateInterval> sortFromMap(Map<Date,DateInterval> dateTodateIntervalMap){
        List<dateInterval> dateIntervalList = new List<dateInterval>();
        List<Date> dateList = new List<Date>(dateTodateIntervalMap.keySet());
        dateList.sort();
        for(Date currentDate: dateList) dateIntervalList.add(dateTodateIntervalMap.get(currentDate));
        return dateIntervalList;
    }
    
    public static dateInterval getDateFromSortedList(List<dateInterval> sortedList, Date startDate, Integer startIndex, Integer endIndex){      
    
        System.debug('startIndex: ' + startIndex + ', EndIndex: ' + endIndex + ', index: ' + ((startIndex + endIndex) / 2));
    
        if(sortedList.get( (startIndex + endIndex) / 2 ).isInBetween(startDate)) return sortedList.get((startIndex + endIndex) / 2);
        if(startIndex == endIndex && !sortedList.get( (startIndex + endIndex) / 2 ).isInBetween(startDate)) return null;
        
        if( !sortedList.get( (startIndex + endIndex) / 2 ).greaterThan(startDate) ) return getDateFromSortedList(sortedList,startDate,( (startIndex + endIndex) / 2 ) + 1, endIndex);
        else return getDateFromSortedList(sortedList,startDate,startIndex, ( (startIndex + endIndex) / 2 ) - 1);
    }
    
    
    public static Map<ID,Opportunity> filterOpportunitiesThatHaveBeenSetToClosedWon(List<Opportunity> newOpps, Map<ID,Opportunity> oldMap){
        List<Opportunity> sortedOpps = new List<Opportunity>();
        for(Opportunity itrOpp: newOpps){
            if(itrOpp.stageName == 'Closed Won' && oldMap.get(itrOpp.id).stageName != 'Closed Won' ) sortedOpps.add(itrOpp);
        }
        return new Map<ID,Opportunity>(sortedOpps);
    }
    
    /************************************
    *   Contact Roles on Insertion      *
    ************************************/
    
    public static void addOpportunityContactRoles(List<Opportunity> newOpps){
        
        Set<ID> AccountIDs = new Set<ID>();
        for(Opportunity currentOp: newOpps) AccountIDs.add(currentOp.AccountID);
        Map<ID,Account> accountMapWithContacts = new Map<ID,Account>([Select id, (Select id From Contacts) From Account Where id IN:AccountIDs]);
        
        List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
        for(Opportunity currentOp: newOpps){
            if(currentOp.AccountID == null) continue;
    
            for(Contact c: accountMapWithContacts.get(currentOp.AccountID).contacts ){
                contactRoles.add(new OpportunityContactRole(OpportunityId=currentOp.id,contactID=c.id,Role='Unknown',isPrimary=false));
            }
        }
        
        if(contactRoles.size() > 0) insert contactRoles;
    }
    
    /********************
    *       SQL/PQL     *
    ********************/
    
    @future
    public static void rollUpToAccountsFromOpportunity(Set<ID> oppIds){
    
        // Pull Opportunities
        Map<ID,Opportunity> oppMap = new Map<Id,Opportunity>([Select id,Acknowledges_business_problem_pain__c,Purchase_timeframe__c,AccountId, 
                                                                employees__c,
                                                                Evaluating_BDR_BC_solutions__c,
                                                                Procure_BRD_BC_solution_or_obatin_budget__c,
                                                                MMR_Opps_expected_within_24_months__c,
                                                                How_many_managed_customers_do_you_have__c,
                                                                How_many_sales_people_do_you_have__c,
                                                                How_many_technical_resources_people__c,
                                                                How_many_identified_end_user_opps__c,
                                                                Experience_selling_BDR_and_backup_prods__c,
                                                                Experience_selling_cloud_services__c
                                                                
                                                                From Opportunity Where ID IN :oppIds]);
        
        if(oppMap.size() == 0) return;
        
        Set<Id> acctIDs = new Set<ID>();
        //Map<Id,List<Opportunity>> acctIdsToOppMap = new Map<ID,List<Opportunity>>();
        for(Opportunity opp: oppMap.values()){
            if(opp.AccountId != null) acctIds.add(opp.AccountId);
        /*  if(opp.AccountId == null) continue; 
            if(acctIdsToOppMap.containsKey(opp.AccountID)) acctIdsToOppMap.put(opp.AccountId,new List<Opportunity>());  
            acctIdsToOppMap.get(opp.AccountId).add(opp);*/
        }
        
        // Pull Accounts where one of the values is blank and in accountIds from Opps
        
        // SQL
        // Ackowledge - Acknowledges_business_problem_pain__c
        // Purchase timeframe- Purchase_timeframe__c
        // # employees - employees__c
        // Evaluation - Evaluating_BDR_BC_solutions__c
        // Procure - Procure_BRD_BC_solution_or_obatin_budget__c
        
        // PQL
        // MRR Opps - MMR_Opps_expected_within_24_months__c
        // How many managed - How_many_managed_customers_do_you_have__c
        // How many sales people - How_many_sales_people_do_you_have__c 
        // How many technical - How_many_technical_resources_people__c
        // How many identified - How_many_identified_end_user_opps__c
        // Experience - Experience_selling_BDR_and_backup_prods__c
        // Experience - Experience_selling_cloud_services__c
        
        Map<ID,Account> AccountsToUpdate = new Map<ID,Account>([Select id,Acknowledges_business_problem_pain__c, 
                                                                        Purchase_timeframe__c,employees__c,
                                                                        Evaluating_BDR_BC_solutions__c,
                                                                        Procure_BRD_BC_solution_or_obatin_budget__c,
                                                                        MRR_opps_expected_within_24_months__c,
                                                                        How_many_managed_customers_do_you_have__c,
                                                                        How_many_sales_people_do_you_have__c,
                                                                        How_many_technical_resources_people__c,
                                                                        How_many_identified_end_user_opps__c,
                                                                        Experience_selling_BDR_and_backup_prods__c,
                                                                        Experience_selling_cloud_services__c
        
                                                                    From Account Where id IN :acctIDs ]);

        if(AccountsToUpdate.size() == 0) return;
        
        for(Opportunity opp: oppMap.values()){
            if(!AccountsToUpdate.containsKey(opp.AccountID)) continue;
            if(AccountsToUpdate.get(opp.AccountId).MRR_opps_expected_within_24_months__c == null) AccountsToUpdate.get(opp.AccountId).MRR_opps_expected_within_24_months__c = opp.MMR_Opps_expected_within_24_months__c;
            if(AccountsToUpdate.get(opp.AccountId).How_many_managed_customers_do_you_have__c == null) AccountsToUpdate.get(opp.AccountId).How_many_managed_customers_do_you_have__c = opp.How_many_managed_customers_do_you_have__c;
            if(AccountsToUpdate.get(opp.AccountId).How_many_sales_people_do_you_have__c == null) AccountsToUpdate.get(opp.AccountId).How_many_sales_people_do_you_have__c = opp.How_many_sales_people_do_you_have__c;
            if(AccountsToUpdate.get(opp.AccountId).How_many_technical_resources_people__c == null) AccountsToUpdate.get(opp.AccountId).How_many_technical_resources_people__c = opp.How_many_technical_resources_people__c;
            if(AccountsToUpdate.get(opp.AccountId).How_many_identified_end_user_opps__c == null) AccountsToUpdate.get(opp.AccountId).How_many_identified_end_user_opps__c = opp.How_many_identified_end_user_opps__c;
            if(!AccountsToUpdate.get(opp.AccountId).Experience_selling_BDR_and_backup_prods__c && opp.Experience_selling_BDR_and_backup_prods__c) AccountsToUpdate.get(opp.AccountId).Experience_selling_BDR_and_backup_prods__c = opp.Experience_selling_BDR_and_backup_prods__c;
            if(!AccountsToUpdate.get(opp.AccountId).Experience_selling_cloud_services__c && opp.Experience_selling_cloud_services__c) AccountsToUpdate.get(opp.AccountId).Experience_selling_cloud_services__c = opp.Experience_selling_cloud_services__c;
            if(AccountsToUpdate.get(opp.AccountId).Acknowledges_business_problem_pain__c  == null) AccountsToUpdate.get(opp.AccountId).Acknowledges_business_problem_pain__c = opp.Acknowledges_business_problem_pain__c;
            if(AccountsToUpdate.get(opp.AccountId).Purchase_timeframe__c == null) AccountsToUpdate.get(opp.AccountId).Purchase_timeframe__c = opp.Purchase_timeframe__c;
            if(AccountsToUpdate.get(opp.AccountId).employees__c  == null) AccountsToUpdate.get(opp.AccountId).employees__c = opp.employees__c;
            if(!AccountsToUpdate.get(opp.AccountId).Evaluating_BDR_BC_solutions__c && opp.Evaluating_BDR_BC_solutions__c) AccountsToUpdate.get(opp.AccountId).Evaluating_BDR_BC_solutions__c = opp.Evaluating_BDR_BC_solutions__c;
            if(!AccountsToUpdate.get(opp.AccountId).Procure_BRD_BC_solution_or_obatin_budget__c && opp.Procure_BRD_BC_solution_or_obatin_budget__c) AccountsToUpdate.get(opp.AccountId).Procure_BRD_BC_solution_or_obatin_budget__c = opp.Procure_BRD_BC_solution_or_obatin_budget__c;
            
        }
        
        update AccountsToUpdate.values();

    }
    
    public static Map<ID,Opportunity> filterOpportunitiesThatUpdatedPQLFields(List<Opportunity> newOpps, Map<ID,Opportunity> oldMap){
            Map<ID,Opportunity> updateOps = new Map<ID,Opportunity>();
            for(Opportunity opp: newOpps){
                if( (opp.MMR_opps_expected_within_24_months__c != null && opp.MMR_opps_expected_within_24_months__c != oldMap.get(opp.id).MMR_opps_expected_within_24_months__c )
                    || ( opp.How_many_managed_customers_do_you_have__c != null && opp.How_many_managed_customers_do_you_have__c != oldMap.get(opp.id).How_many_managed_customers_do_you_have__c )
                    || ( opp.How_many_sales_people_do_you_have__c != null && opp.How_many_sales_people_do_you_have__c != oldMap.get(opp.id).How_many_sales_people_do_you_have__c )
                    || ( opp.How_many_technical_resources_people__c != null && opp.How_many_technical_resources_people__c != oldMap.get(opp.id).How_many_technical_resources_people__c )
                    || ( opp.How_many_identified_end_user_opps__c != null && opp.How_many_identified_end_user_opps__c != oldMap.get(opp.id).How_many_identified_end_user_opps__c )
                    || ( opp.Experience_selling_BDR_and_backup_prods__c != null && opp.Experience_selling_BDR_and_backup_prods__c != oldMap.get(opp.id).Experience_selling_BDR_and_backup_prods__c )
                    || ( opp.Experience_selling_cloud_services__c != null && opp.Experience_selling_cloud_services__c != oldMap.get(opp.id).Experience_selling_cloud_services__c ) 
                    || ( opp.Acknowledges_business_problem_pain__c != null && opp.Acknowledges_business_problem_pain__c != oldMap.get(opp.id).Acknowledges_business_problem_pain__c )   
                    || ( opp.Purchase_timeframe__c != null && opp.Purchase_timeframe__c != oldMap.get(opp.id).Purchase_timeframe__c )   
                    || ( opp.employees__c != null && opp.employees__c != oldMap.get(opp.id).employees__c )  
                    || ( opp.Evaluating_BDR_BC_solutions__c != null && opp.Evaluating_BDR_BC_solutions__c != oldMap.get(opp.id).Evaluating_BDR_BC_solutions__c )    
                    || ( opp.Procure_BRD_BC_solution_or_obatin_budget__c != null && opp.Procure_BRD_BC_solution_or_obatin_budget__c != oldMap.get(opp.id).Procure_BRD_BC_solution_or_obatin_budget__c ) )       
                        updateOps.put(opp.id,opp);
            }
            return updateOps;
    }
    
    public static Map<ID,Opportunity> filterOpportunitiesThatUpdatedPQLFields(List<Opportunity> newOpps){
            Map<ID,Opportunity> updateOps = new Map<ID,Opportunity>();
            for(Opportunity opp: newOpps){
                if( (opp.MMR_opps_expected_within_24_months__c != null )
                    || ( opp.How_many_managed_customers_do_you_have__c != null )
                    || ( opp.How_many_sales_people_do_you_have__c != null )
                    || ( opp.How_many_technical_resources_people__c != null )
                    || ( opp.How_many_identified_end_user_opps__c != null )
                    || ( opp.Experience_selling_BDR_and_backup_prods__c != null  )
                    || ( opp.Experience_selling_cloud_services__c != null ) 
                    || ( opp.Acknowledges_business_problem_pain__c != null )    
                    || ( opp.Purchase_timeframe__c != null )    
                    || ( opp.employees__c != null )     
                    || ( opp.Evaluating_BDR_BC_solutions__c != null )   
                    || ( opp.Procure_BRD_BC_solution_or_obatin_budget__c != null ) )        
                        updateOps.put(opp.id,opp);
            }
            return updateOps;
    }
    
    /****************************
    *       Test Methods        *
    ****************************/
    
    // Contact Role Insertion testing
    
    /*public static testMethod void testAddContactRoleWhenInsertingOpp(){
        
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        Contact testContact = new Contact(firstName='Test',lastName='Guy',email='test@email.com',AccountID=testAccount.id);
        insert testContact;
        
        Opportunity testOpp = new Opportunity(Name='Test Opp',closedate=Date.Today(),stageName='Closed Won',AccountID=testAccount.id);
        
        Test.startTest();
            insert testOpp;
        Test.stopTest();
        
        List<OpportunityContactRole> roles = [Select id,OpportunityID,ContactID,Role From OpportunityContactRole];
        System.assertEquals(1,roles.size());
        System.assertEquals(testContact.id,roles.get(0).contactID);
    }*/
    
    // Unit Test - getDateFromSortedList
    public static testMethod void testGetDateFromSortedList(){
        List<dateInterval> sortedList = new List<dateInterval>();
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-15),Date.today().toStartOfMonth().addMonths(-12).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-12),Date.today().toStartOfMonth().addMonths(-9).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-6),Date.today().toStartOfMonth().addMonths(-3).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-1),Date.today().toStartOfMonth().addMonths(2).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(3),Date.today().toStartOfMonth().addMonths(1).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(6),Date.today().toStartOfMonth().addMonths(3).addDays(-1)));
        
        DateInterval returnedDate;
        
        Test.startTest();
             returnedDate = OpportunityController.getDateFromSortedList(sortedList,Date.today() , 0, sortedList.size() -1);
        Test.stopTest();
        
        System.assertNotEquals(null,returnedDate);
        System.assertEquals(sortedList.get(3).startDate,returnedDate.startDate);
        System.assertEquals(sortedList.get(3).endDate,returnedDate.endDate);
        
    }
    
    // Unit Test - getDateFromSortedList
    public static testMethod void testGetDateFromSortedListDescending(){
        List<dateInterval> sortedList = new List<dateInterval>();
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-6),Date.today().toStartOfMonth().addMonths(-3).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-3),Date.today().toStartOfMonth().addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(-1),Date.today().toStartOfMonth().addMonths(2).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(4),Date.today().toStartOfMonth().addMonths(7).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(7),Date.today().toStartOfMonth().addMonths(12).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(12),Date.today().toStartOfMonth().addMonths(15).addDays(-1)));
        sortedList.add(new dateInterval(Date.today().toStartOfMonth().addMonths(15),Date.today().toStartOfMonth().addMonths(18).addDays(-1)));
        
        DateInterval returnedDate;
        
        Test.startTest();
             returnedDate = OpportunityController.getDateFromSortedList(sortedList,Date.today() , 0, sortedList.size() -1);
        Test.stopTest();
        
        System.assertNotEquals(null,returnedDate);
        System.assertEquals(sortedList.get(2).startDate,returnedDate.startDate);
        System.assertEquals(sortedList.get(2).endDate,returnedDate.endDate);
        
    }
    
    // Unit Test - sortFromMap(Map<Date,dateInterval> )
    public static testMethod void testSortFromMap(){
        Map<Date,dateInterval> nonSortedMap = new Map<Date,dateInterval>();
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(-15) , new dateInterval(Date.today().toStartOfMonth().addMonths(-15),Date.today().toStartOfMonth().addMonths(-12).addDays(-1)));
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(-1) , new dateInterval(Date.today().toStartOfMonth().addMonths(-1),Date.today().toStartOfMonth().addMonths(2).addDays(-1)));
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(-3) , new dateInterval(Date.today().toStartOfMonth().addMonths(3),Date.today().toStartOfMonth().addMonths(1).addDays(-1)));
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(6) , new dateInterval(Date.today().toStartOfMonth().addMonths(6),Date.today().toStartOfMonth().addMonths(3).addDays(-1)));
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(-12) , new dateInterval(Date.today().toStartOfMonth().addMonths(-12),Date.today().toStartOfMonth().addMonths(-9).addDays(-1)));
        nonSortedMap.put(Date.today().toStartOfMonth().addMonths(-6) , new dateInterval(Date.today().toStartOfMonth().addMonths(-6),Date.today().toStartOfMonth().addMonths(-3).addDays(-1)));
        
        List<dateInterval> sortedIntervals;
        
        Test.startTest();
            sortedIntervals = OpportunityController.sortFromMap(nonSortedMap);
        Test.stopTest();
        
        System.assertNotEquals(null,sortedIntervals);
        System.assertEquals(nonSortedMap.size(), sortedIntervals.size());
        System.assertEquals(nonSortedMap.get(Date.today().toStartOfMonth().addMonths(-15)), sortedIntervals.get(0));
        System.assertEquals(nonSortedMap.get(Date.today().toStartOfMonth().addMonths(-12)), sortedIntervals.get(1));
        System.assertEquals(nonSortedMap.get(Date.today().toStartOfMonth().addMonths(-6)), sortedIntervals.get(2));
        

    }
    
    // Quota Testing
    
    
    public static testMethod void testInsertionOfOpportunityWithAQuotaInRange(){
        // create Quota
        Quota__c inRange = new Quota__c(Amount__c=5000,startDate__c=Date.Today().toStartOfMonth(),endDate__c = Date.Today().toStartOfMonth().addMonths(3));
        insert inRange;
        
        // create Opportunity       
        Opportunity testOpp = new Opportunity(stageName='Prospect',closeDate= DAte.today(),Name='Test Opp');
        insert testOpp;
        
        Test.startTest();
            testOpp.stageName = 'Closed Won';
            update testOpp;
        Test.stopTest();
        
        testOpp = [Select id,Quota__c From Opportunity Where id = :testOpp.id];
        system.assertEquals(inRange.id,testOpp.Quota__C);
    }
    
    public static testMethod void testInsertionOfOpportunityWithMultipleQuotaInRange(){
        // create Quota
        
        Quota__c inRange = new Quota__c(Amount__c=5000,startDate__c=Date.Today().toStartOfMonth(),endDate__c = Date.Today().toStartOfMonth().addMonths(3).addDays(-1));
        insert inRange;
        
        Quota__c q1 = new Quota__c(Amount__c=5000,startDate__c=Date.Today().toStartOfMonth().addMonths(-3),endDate__c = Date.Today().toStartOfMonth().addDays(-1));
        insert q1;
        
        Quota__c q2 = new Quota__c(Amount__c=5000,startDate__c=Date.Today().toStartOfMonth().addMonths(-6),endDate__c = Date.Today().toStartOfMonth().addMonths(-3).addDays(-1));
        insert q2;
        
        Quota__c q3 = new Quota__c(Amount__c=5000,startDate__c=Date.Today().toStartOfMonth().addMonths(3),endDate__c = Date.Today().toStartOfMonth().addMonths(6).addDays(-1));
        insert q3;
        
        // create Opportunity       
        Opportunity testOpp = new Opportunity(stageName='Prospect',closeDate= DAte.today(),Name='Test Opp');
        insert testOpp;
        
        Test.startTest();
            testOpp.stageName = 'Closed Won';
            update testOpp;
        Test.stopTest();
        
        testOpp = [Select id,Quota__c From Opportunity Where id = :testOpp.id];
        system.assertEquals(inRange.id,testOpp.Quota__C);
    }
    
    // SQL/PQL Testing
    
    public static testMethod void testUpdateOfOpportunitiesWithAccountsWithBlankValues(){
        
        
        // create empty accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer num = 0; num < 1; num++){
            testAccounts.add(new Account(Name='Test Account' + num));
        }
        insert testAccounts;
        
        Map<ID,Account> mappedTestAccounts = new Map<ID,Account>(testAccounts);
        
        // create Opportunities
        List<Opportunity> testOppties = new List<Opportunity>();
        for(ID nextAccountID: mappedTestAccounts.keySet()){
            testOppties.add(new Opportunity(AccountID=nextAccountID,Name='Test Opp' + nextAccountID,stageName='Prospect',closeDate=Date.today()));
        }
        insert testOppties; 
        
        Test.startTest();
            for(Opportunity currentOpp: testOppties){
                currentOpp.MMR_opps_expected_within_24_months__c = '1';
                currentOpp.How_many_managed_customers_do_you_have__c  = 1;
                currentOpp.How_many_sales_people_do_you_have__c  = 1;
                currentOpp.How_many_technical_resources_people__c  = 1;
                currentOpp.How_many_identified_end_user_opps__c  = 1;
                currentOpp.Experience_selling_BDR_and_backup_prods__c = true;
                currentOpp.Experience_selling_cloud_services__c = true;

            }
            update testOppties;
        Test.stopTest();
        
        testAccounts = [Select id,/*Acknowledges_business_problem_pain__c, 
                                                                        Purchase_timeframe__c,employees__c,
                                                                        Evaluating_BDR_BC_solutions__c,
                                                                        Procure_BRD_BC_solution_or_obatin_budget__c,
                                                                        */
                                                                        MRR_opps_expected_within_24_months__c,
                                                                        How_many_managed_customers_do_you_have__c,
                                                                        How_many_sales_people_do_you_have__c,
                                                                        How_many_technical_resources_people__c,
                                                                        How_many_identified_end_user_opps__c,
                                                                        Experience_selling_BDR_and_backup_prods__c,
                                                                        Experience_selling_cloud_services__c
        
                                                                    From Account Where id IN :testAccounts ];
        System.assertNotEquals(0,testAccounts.size());
        for(Account currentAccount: testAccounts){
            System.assertEquals(currentAccount.MRR_opps_expected_within_24_months__c,'1');
            System.assertEquals(currentAccount.How_many_managed_customers_do_you_have__c,1);
            System.assertEquals(currentAccount.How_many_sales_people_do_you_have__c,1);
            System.assertEquals(currentAccount.How_many_technical_resources_people__c,1);
            System.assertEquals(currentAccount.How_many_identified_end_user_opps__c,1);
            System.assertEquals(currentAccount.Experience_selling_BDR_and_backup_prods__c,true);
            System.assertEquals(currentAccount.Experience_selling_cloud_services__c,true);
        }                                               
        
    }
    
    public static testMethod void testUpdateOfOpportunitiesWithAccountsWithSomeFilledValues(){
        
        
        // create empty accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer num = 0; num < 1; num++){
            testAccounts.add(new Account(Name='Test Account' + num,MRR_opps_expected_within_24_months__c='2',How_many_managed_customers_do_you_have__c=14));
        }
        insert testAccounts;
        
        Map<ID,Account> mappedTestAccounts = new Map<ID,Account>(testAccounts);
        
        // create Opportunities
        List<Opportunity> testOppties = new List<Opportunity>();
        for(ID nextAccountID: mappedTestAccounts.keySet()){
            testOppties.add(new Opportunity(AccountID=nextAccountID,Name='Test Opp' + nextAccountID,stageName='Prospect',closeDate=Date.today()));
        }
        insert testOppties; 
        
        Test.startTest();
            for(Opportunity currentOpp: testOppties){
                currentOpp.MMR_opps_expected_within_24_months__c = '1';
                currentOpp.How_many_managed_customers_do_you_have__c  = 1;
                currentOpp.How_many_sales_people_do_you_have__c  = 1;
                currentOpp.How_many_technical_resources_people__c  = 1;
                currentOpp.How_many_identified_end_user_opps__c  = 1;
                currentOpp.Experience_selling_BDR_and_backup_prods__c = true;
                currentOpp.Experience_selling_cloud_services__c = true;

            }
            update testOppties;
        Test.stopTest();
        
        testAccounts = [Select id,/*Acknowledges_business_problem_pain__c, 
                                                                        Purchase_timeframe__c,employees__c,
                                                                        Evaluating_BDR_BC_solutions__c,
                                                                        Procure_BRD_BC_solution_or_obatin_budget__c,
                                                                        */
                                                                        MRR_opps_expected_within_24_months__c,
                                                                        How_many_managed_customers_do_you_have__c,
                                                                        How_many_sales_people_do_you_have__c,
                                                                        How_many_technical_resources_people__c,
                                                                        How_many_identified_end_user_opps__c,
                                                                        Experience_selling_BDR_and_backup_prods__c,
                                                                        Experience_selling_cloud_services__c
        
                                                                    From Account Where id IN :testAccounts ];
        System.assertNotEquals(0,testAccounts.size());
        for(Account currentAccount: testAccounts){
            System.assertEquals(currentAccount.MRR_opps_expected_within_24_months__c,'2');
            System.assertEquals(currentAccount.How_many_managed_customers_do_you_have__c,14);
            System.assertEquals(currentAccount.How_many_sales_people_do_you_have__c,1);
            System.assertEquals(currentAccount.How_many_technical_resources_people__c,1);
            System.assertEquals(currentAccount.How_many_identified_end_user_opps__c,1);
            System.assertEquals(currentAccount.Experience_selling_BDR_and_backup_prods__c,true);
            System.assertEquals(currentAccount.Experience_selling_cloud_services__c,true);
        }                                               
        
    }

}